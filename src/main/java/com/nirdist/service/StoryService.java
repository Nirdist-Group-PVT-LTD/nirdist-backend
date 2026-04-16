package com.nirdist.service;

import com.nirdist.entity.Story;
import com.nirdist.repository.StoryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class StoryService {
    @Autowired
    private StoryRepository storyRepository;

    public Story createStory(Story story) {
        return storyRepository.save(story);
    }

    public Story getStoryById(Integer sId) {
        Optional<Story> story = storyRepository.findBySId(sId);
        return story.orElse(null);
    }

    public List<Story> getStoriesByUser(Integer vId) {
        return storyRepository.findByVId(vId);
    }

    public List<Story> getActiveStories() {
        return storyRepository.findActiveStories(LocalDateTime.now());
    }

    public void deleteStory(Integer sId) {
        storyRepository.deleteById(sId);
    }
}
