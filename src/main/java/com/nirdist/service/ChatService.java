package com.nirdist.service;

import com.nirdist.dto.ChatMessageRequest;
import com.nirdist.dto.ChatMessageResponse;
import com.nirdist.dto.ChatRoomCreateRequest;
import com.nirdist.dto.ChatRoomResponse;
import com.nirdist.entity.ChatMember;
import com.nirdist.entity.ChatMessage;
import com.nirdist.entity.ChatRoom;
import com.nirdist.repository.ChatMemberRepository;
import com.nirdist.repository.ChatMessageRepository;
import com.nirdist.repository.ChatRoomRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

@Service
public class ChatService {
    @Autowired
    private ChatRoomRepository chatRoomRepository;

    @Autowired
    private ChatMemberRepository chatMemberRepository;

    @Autowired
    private ChatMessageRepository chatMessageRepository;

    public ChatRoomResponse createRoom(ChatRoomCreateRequest request) {
        if (request.getCreatedBy() == null) {
            throw new IllegalArgumentException("createdBy is required");
        }

        List<Integer> participants = new ArrayList<>();
        if (request.getParticipantIds() != null) {
            participants.addAll(request.getParticipantIds().stream()
                    .filter(Objects::nonNull)
                    .collect(Collectors.toList()));
        }
        if (!participants.contains(request.getCreatedBy())) {
            participants.add(request.getCreatedBy());
        }

        ChatRoom room = new ChatRoom();
        room.setName(request.getName());
        room.setIsGroup(request.getIsGroup() != null ? request.getIsGroup() : participants.size() > 2);
        room.setCreatedBy(request.getCreatedBy());
        ChatRoom savedRoom = chatRoomRepository.save(room);

        for (Integer userId : participants) {
            ChatMember member = new ChatMember();
            member.setRoomId(savedRoom.getRoomId());
            member.setUserId(userId);
            chatMemberRepository.save(member);
        }

        return buildRoomResponse(savedRoom, participants);
    }

    public List<ChatRoomResponse> listRoomsForUser(Integer userId) {
        List<ChatRoom> rooms = chatRoomRepository.findRoomsByUserId(userId);
        return rooms.stream()
                .map(room -> {
                    List<Integer> participants = chatMemberRepository.findByRoomId(room.getRoomId())
                            .stream()
                            .map(ChatMember::getUserId)
                            .collect(Collectors.toList());
                    return buildRoomResponse(room, participants);
                })
                .collect(Collectors.toList());
    }

    public List<ChatMessageResponse> listMessages(Integer roomId) {
        return chatMessageRepository.findByRoomIdOrderByCreatedAtAsc(roomId)
                .stream()
                .map(this::buildMessageResponse)
                .collect(Collectors.toList());
    }

    public ChatMessageResponse createMessage(Integer roomId, ChatMessageRequest request) {
        if (request.getSenderId() == null) {
            throw new IllegalArgumentException("senderId is required");
        }
        if (request.getContent() == null || request.getContent().isBlank()) {
            throw new IllegalArgumentException("content is required");
        }
        if (!chatMemberRepository.existsByRoomIdAndUserId(roomId, request.getSenderId())) {
            throw new IllegalStateException("sender is not a member of this room");
        }

        ChatMessage message = new ChatMessage();
        message.setRoomId(roomId);
        message.setSenderId(request.getSenderId());
        message.setContent(request.getContent());
        message.setMessageType(request.getMessageType() != null ? request.getMessageType() : "TEXT");

        ChatMessage savedMessage = chatMessageRepository.save(message);
        return buildMessageResponse(savedMessage);
    }

    private ChatRoomResponse buildRoomResponse(ChatRoom room, List<Integer> participants) {
        return new ChatRoomResponse(
                room.getRoomId(),
                room.getName(),
                room.getIsGroup(),
                room.getCreatedBy(),
                room.getCreatedAt(),
                participants
        );
    }

    private ChatMessageResponse buildMessageResponse(ChatMessage message) {
        return new ChatMessageResponse(
                message.getMessageId(),
                message.getRoomId(),
                message.getSenderId(),
                message.getContent(),
                message.getMessageType(),
                message.getCreatedAt()
        );
    }
}
