package io.github.sgbasaraner.funxchange.service;

import io.github.sgbasaraner.funxchange.entity.Rating;
import io.github.sgbasaraner.funxchange.entity.User;
import io.github.sgbasaraner.funxchange.model.RatingDTO;
import io.github.sgbasaraner.funxchange.repository.RatingRepository;
import io.github.sgbasaraner.funxchange.repository.UserRepository;
import io.github.sgbasaraner.funxchange.util.Util;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.security.Principal;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

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

    @Autowired
    private Util util;

    @Transactional
    public List<RatingDTO> fetchRatings(Principal principal, int offset, int limit) {
        final User requestor = userRepository.findUserByUserName(principal.getName()).get();
        final Pageable page = util.makePageable(offset, limit, Sort.by("created").descending());
        return ratingRepository.findByRater(requestor, page)
                .stream()
                .filter(r -> r.getService().isEnded())
                .map(r -> mapToDTO(r, requestor))
                .collect(Collectors.toUnmodifiableList());
    }

    @Transactional
    public RatingDTO updateRating(Principal principal, RatingDTO ratingDTO) {
        final User requestor = userRepository.findUserByUserName(principal.getName()).get();
        final Rating existingRating = ratingRepository.getById(UUID.fromString(ratingDTO.getId()));
        if (!existingRating.getRater().getId().equals(requestor.getId()))
            throw new IllegalArgumentException("Invalid rating");

        existingRating.setRating(ratingDTO.getRating());

        return mapToDTO(ratingRepository.save(existingRating), requestor);
    }

    private RatingDTO mapToDTO(Rating entity, User requestor) {
        return new RatingDTO(
                entity.getId().toString(),
                userService.mapUserToDTO(entity.getRated(), requestor),
                entity.getRating(),
                eventService.mapToModel(entity.getService(), requestor));
    }
}
