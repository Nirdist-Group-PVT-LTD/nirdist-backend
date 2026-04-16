package com.nirdist.controller;

import com.nirdist.entity.Story;
import com.nirdist.service.StoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/stories")
@CrossOrigin(origins = "*")
public class StoryController {
    @Autowired
    private StoryService storyService;

    @PostMapping
    public ResponseEntity<Story> createStory(@RequestBody Story story) {
        Story createdStory = storyService.createStory(story);
        return ResponseEntity.status(HttpStatus.CREATED).body(createdStory);
    }

    @GetMapping("/{sId}")
    public ResponseEntity<Story> getStory(@PathVariable Integer sId) {
        Story story = storyService.getStoryById(sId);
        if (story != null) {
            return ResponseEntity.ok(story);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @GetMapping("/user/{vId}")
    public ResponseEntity<List<Story>> getUserStories(@PathVariable Integer vId) {
        List<Story> stories = storyService.getStoriesByUser(vId);
        return ResponseEntity.ok(stories);
    }

    @GetMapping
    public ResponseEntity<List<Story>> getActiveStories() {
        List<Story> stories = storyService.getActiveStories();
        return ResponseEntity.ok(stories);
    }

    @DeleteMapping("/{sId}")
    public ResponseEntity<Void> deleteStory(@PathVariable Integer sId) {
        storyService.deleteStory(sId);
        return ResponseEntity.noContent().build();
    }
}
