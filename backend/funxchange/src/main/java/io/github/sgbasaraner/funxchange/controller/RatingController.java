package io.github.sgbasaraner.funxchange.controller;

import io.github.sgbasaraner.funxchange.model.RatingDTO;
import io.github.sgbasaraner.funxchange.service.RatingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.List;

@RestController
public class RatingController {

    @Autowired
    private RatingService service;

    @GetMapping("/ratings")
    List<RatingDTO> fetchRatings(Principal principal, @RequestParam int offset, @RequestParam int limit) {
        return service.fetchRatings(principal, offset, limit);
    }

    @PostMapping("/ratings")
    RatingDTO updateRating(Principal principal, @RequestBody RatingDTO ratingDTO) {
        return service.updateRating(principal, ratingDTO);
    }
}
