package io.github.sgbasaraner.funxchange.service;

import io.github.sgbasaraner.funxchange.entity.Follower;
import io.github.sgbasaraner.funxchange.entity.JoinRequest;
import io.github.sgbasaraner.funxchange.entity.Notification;
import io.github.sgbasaraner.funxchange.repository.NotificationRepository;
import io.github.sgbasaraner.funxchange.util.DeeplinkUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Service
public class NotificationService {

    @Autowired
    private NotificationRepository repository;

    @Autowired
    private DeeplinkUtil deeplinkUtil;

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
}
