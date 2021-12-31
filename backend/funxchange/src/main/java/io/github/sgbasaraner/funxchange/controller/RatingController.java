package io.github.sgbasaraner.funxchange.controller;

import io.github.sgbasaraner.funxchange.model.RatingDTO;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.security.Principal;
import java.util.List;

@RestController
public class RatingController {
    @GetMapping("/ratings")
    List<RatingDTO> fetchRatings(Principal principal, @RequestParam int offset, @RequestParam int limit) {
        return null;
    }
}
