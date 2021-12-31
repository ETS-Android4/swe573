package io.github.sgbasaraner.funxchange.service;

import io.github.sgbasaraner.funxchange.entity.Rating;
import io.github.sgbasaraner.funxchange.entity.User;
import io.github.sgbasaraner.funxchange.model.RatingDTO;
import io.github.sgbasaraner.funxchange.repository.RatingRepository;
import io.github.sgbasaraner.funxchange.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.security.Principal;
import java.util.List;

@Service
public class RatingService {

    @Autowired
    private RatingRepository ratingRepository;

    @Autowired
    private UserService userService;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private EventService eventService;

    public List<RatingDTO> fetchRatings(Principal principal, int offset, int limit) {
        return null;
    }

    public RatingDTO updateRating(Principal principal, RatingDTO ratingDTO) {
        return null;
    }

    private RatingDTO mapToDTO(Rating entity, User requestor) {
        return new RatingDTO(
                entity.getId().toString(),
                userService.mapUserToDTO(entity.getRated(), requestor),
                entity.getRating(),
                eventService.mapToModel(entity.getService()));
    }
}
