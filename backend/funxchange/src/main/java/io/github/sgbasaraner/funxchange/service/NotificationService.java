package io.github.sgbasaraner.funxchange.service;

import io.github.sgbasaraner.funxchange.entity.Follower;
import io.github.sgbasaraner.funxchange.entity.JoinRequest;
import io.github.sgbasaraner.funxchange.entity.Notification;
import io.github.sgbasaraner.funxchange.entity.User;
import io.github.sgbasaraner.funxchange.model.JoinRequestDTO;
import io.github.sgbasaraner.funxchange.model.NotificationDTO;
import io.github.sgbasaraner.funxchange.repository.NotificationRepository;
import io.github.sgbasaraner.funxchange.repository.UserRepository;
import io.github.sgbasaraner.funxchange.util.DeeplinkUtil;
import io.github.sgbasaraner.funxchange.util.Util;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.security.Principal;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class NotificationService {

    @Autowired
    private NotificationRepository repository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private DeeplinkUtil deeplinkUtil;

    @Autowired
    private Util util;

    public List<NotificationDTO> fetchNotifications(Principal principal, int offset, int limit) {
        final User requestor = userRepository.findUserByUserName(principal.getName()).get();
        final Pageable page = util.makePageable(offset, limit, Sort.by("created").descending());
        return repository
                .findByUser(requestor, page)
                .stream()
                .map(this::mapToDTO)
                .collect(Collectors.toUnmodifiableList());
    }

    @Transactional
    public void sendJoinRequestedNotification(JoinRequest request) {
        final String text = deeplinkUtil.generateJoinRequestText(request);
        final String deeplink = DeeplinkUtil.requestsDeeplink;
        Notification notification = new Notification();
        notification.setUser(request.getEvent().getUser());
        notification.setHtmlText(text);
        notification.setDeeplink(deeplink);
        repository.save(notification);
    }


    @Transactional
    public void sendJoinRequestApprovedNotification(JoinRequest request) {
        final String text = deeplinkUtil.generateJoinRequestApprovedText(request);
        final String deeplink = deeplinkUtil.generateEventDeeplink(request.getEvent().getId());
        Notification notification = new Notification();
        notification.setUser(request.getUser());
        notification.setHtmlText(text);
        notification.setDeeplink(deeplink);
        repository.save(notification);
    }

    @Transactional
    public void sendNewFollowerNotification(Follower follower) {
        Notification notification = new Notification();
        notification.setUser(follower.getFollowee());
        notification.setHtmlText(deeplinkUtil.generateFollowText(follower));
        notification.setDeeplink(deeplinkUtil.generateUserDeeplink(follower.getFollower().getId()));
        repository.save(notification);
    }

    private NotificationDTO mapToDTO(Notification notification) {
        return new NotificationDTO(notification.getHtmlText(), notification.getDeeplink());
    }
}
