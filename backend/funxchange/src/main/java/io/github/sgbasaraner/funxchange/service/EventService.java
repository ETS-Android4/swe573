package io.github.sgbasaraner.funxchange.service;

import io.github.sgbasaraner.funxchange.entity.Event;
import io.github.sgbasaraner.funxchange.entity.JoinRequest;
import io.github.sgbasaraner.funxchange.entity.Rating;
import io.github.sgbasaraner.funxchange.entity.User;
import io.github.sgbasaraner.funxchange.model.EventDTO;
import io.github.sgbasaraner.funxchange.model.JoinRequestDTO;
import io.github.sgbasaraner.funxchange.model.NewEventDTO;
import io.github.sgbasaraner.funxchange.model.UserDTO;
import io.github.sgbasaraner.funxchange.repository.EventRepository;
import io.github.sgbasaraner.funxchange.repository.JoinRequestRepository;
import io.github.sgbasaraner.funxchange.repository.RatingRepository;
import io.github.sgbasaraner.funxchange.repository.UserRepository;
import io.github.sgbasaraner.funxchange.util.DeeplinkUtil;
import io.github.sgbasaraner.funxchange.util.Util;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;


import java.security.Principal;
import java.time.Duration;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class EventService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private EventRepository eventRepository;

    @Autowired
    private UserService userService;

    @Autowired
    private JoinRequestRepository joinRequestRepository;

    @Autowired
    private RatingRepository ratingRepository;

    @Autowired
    private Util util;

    @Autowired
    private DeeplinkUtil deeplinkUtil;

    public EventDTO fetchEvent(String eventId) {
        return mapToModel(eventRepository.getById(UUID.fromString(eventId)));
    }

    public List<EventDTO> fetchFeed(int offset, int limit) {
        final Pageable page = util.makePageable(offset, limit, Sort.by("created").descending());
        return eventRepository
                .findFeed(page)
                .stream()
                .map(this::mapToModel)
                .collect(Collectors.toUnmodifiableList());
    }

    public List<EventDTO> fetchEventsOfUser(int offset, int limit, String userId) {
        final Pageable page = util.makePageable(offset, limit, Sort.by("created").descending());
        final User user = userRepository.getById(UUID.fromString(userId));
        return eventRepository.findByUser(user, page)
                .stream()
                .map(this::mapToModel)
                .collect(Collectors.toUnmodifiableList());
    }

    public List<UserDTO> fetchParticipantsOfEvent(Principal principal, String eventId) {
        final User requestor = userRepository.findUserByUserName(principal.getName()).get();
        final Event event = eventRepository.getById(UUID.fromString(eventId));
        return event.getParticipants()
                .stream()
                .map(u -> userService.mapUserToDTO(u, requestor))
                .collect(Collectors.toUnmodifiableList());
    }

    public JoinRequestDTO joinEvent(Principal principal, String eventId) {
        // TODO: credit
        // TODO: notification
        final User requestor = userRepository.findUserByUserName(principal.getName()).get();
        final Event event = eventRepository.getById(UUID.fromString(eventId));
        if (!event.isInFuture()) throw new IllegalArgumentException("Can't join an event that's already started");
        final JoinRequest request = new JoinRequest();
        request.setEvent(event);
        request.setUser(requestor);
        return mapToJoinRequestDTO(joinRequestRepository.save(request));
    }

    @Transactional
    public JoinRequestDTO acceptJoinRequest(Principal principal, String eventId, String userId) {
        // TODO: credit
        // TODO: notification
        final User principalUser = userRepository.findUserByUserName(principal.getName()).get();
        final Event event = eventRepository.getById(UUID.fromString(eventId));
        if (!event.getUser().getId().equals(principalUser.getId()))
            throw new IllegalArgumentException("Invalid event id.");

        final User requestor = userRepository.getById(UUID.fromString(userId));

        final Rating participantRating = new Rating();
        participantRating.setRater(requestor);
        participantRating.setService(event);
        participantRating.setRated(principalUser);

        final Rating organizerRating = new Rating();
        organizerRating.setRater(principalUser);
        organizerRating.setService(event);
        organizerRating.setRated(requestor);

        ratingRepository.saveAll(List.of(participantRating, organizerRating));

        final JoinRequest request = joinRequestRepository.findFirstByEventAndUser(event, requestor);
        joinRequestRepository.delete(request);
        Set<Event> participatedEvents = Optional.ofNullable(requestor.getParticipatedEvents()).orElse(new HashSet<>());
        participatedEvents.add(event);
        event.getParticipants().add(requestor);
        return mapToJoinRequestDTO(request);
    }

    @Transactional
    public JoinRequestDTO rejectJoinRequest(Principal principal, String eventId, String userId) {
        final User principalUser = userRepository.findUserByUserName(principal.getName()).get();
        final Event event = eventRepository.getById(UUID.fromString(eventId));
        if (!event.getUser().getId().equals(principalUser.getId()))
            throw new IllegalArgumentException("Invalid event id.");

        final User requestor = userRepository.getById(UUID.fromString(userId));
        final JoinRequest request = joinRequestRepository.findFirstByEventAndUser(event, requestor);
        joinRequestRepository.delete(request);
        return mapToJoinRequestDTO(request);
    }

    @Transactional
    public EventDTO createEvent(Principal principal, NewEventDTO params) {
        validateNewEventParams(params);
        final User requestor = userRepository.findUserByUserName(principal.getName()).get();
        final Event entity = mapToEntity(params, requestor);
        return mapToModel(eventRepository.save(entity));
    }

    public List<JoinRequestDTO> fetchRequests(Principal principal, int offset, int limit) {
        final User requestor = userRepository.findUserByUserName(principal.getName()).get();
        final Pageable page = util.makePageable(offset, limit, Sort.by("created").descending());
        return joinRequestRepository
                .findRequestsToUsers(requestor.getId(), page)
                .stream()
                .map(this::mapToJoinRequestDTO)
                .collect(Collectors.toUnmodifiableList());
    }

    private Event mapToEntity(NewEventDTO params, User requestor) {
        final Event entity = new Event();
        entity.setParticipants(Collections.emptySet());
        entity.setType(params.getType());
        entity.setCityName(params.getCityName());
        entity.setCountryName(params.getCountryName());
        entity.setLongitude(params.getLongitude());
        entity.setLatitude(params.getLatitude());
        entity.setDetails(params.getDetails());
        entity.setTitle(params.getTitle());
        entity.setCategory(params.getCategory());
        entity.setEndDateTime(params.getEndDateTime());
        entity.setStartDateTime(params.getStartDateTime());
        entity.setJoinRequests(Collections.emptySet());
        entity.setUser(requestor);
        entity.setCapacity(params.getCapacity());
        return entity;
    }

    private EventDTO mapToModel(Event entity) {
        return new EventDTO(
                entity.getId().toString(),
                entity.getUser().getId().toString(),
                entity.getType(),
                entity.getCapacity(),
                entity.getParticipants().size(),
                entity.getCategory(),
                entity.getTitle(),
                entity.getDetails(),
                entity.getLatitude(),
                entity.getLongitude(),
                entity.getCityName(),
                entity.getCountryName(),
                Duration.between(entity.getStartDateTime(), entity.getEndDateTime()).toMinutes(),
                entity.getStartDateTime()
        );
    }

    private JoinRequestDTO mapToJoinRequestDTO(JoinRequest joinRequest) {
        return new JoinRequestDTO(joinRequest.getEvent().getId().toString(), joinRequest.getUser().getId().toString(), deeplinkUtil.generateJoinRequestText(joinRequest));
    }

    private void validateNewEventParams(NewEventDTO params) {
        Assert.isTrue(params.getEndDateTime().isAfter(params.getStartDateTime()), "End date time should be after the start.");
        Assert.isTrue(params.getStartDateTime().isAfter(LocalDateTime.now()), "Start date time should be after now.");
        Assert.hasLength(params.getTitle(), "Title shouldn't be empty.");
        Assert.hasLength(params.getDetails(), "Details shouldn't be empty.");
        Assert.isTrue(params.getTitle().length() < 256, "Title is too long.");
        Assert.isTrue(params.getCapacity() <= 12, "Too many participants.");
        Assert.isTrue(params.getDetails().length() < 8*256, "Details are too long.");
        Assert.isTrue(params.getType().equalsIgnoreCase("service") || params.getType().equalsIgnoreCase("meetup"), "Invalid event type.");
        Assert.isTrue(UserService.allowedInterests.contains(params.getCategory()), "Invalid category");
    }
}
