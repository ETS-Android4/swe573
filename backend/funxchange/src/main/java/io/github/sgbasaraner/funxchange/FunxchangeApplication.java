package io.github.sgbasaraner.funxchange;


import com.github.javafaker.Faker;
import io.github.sgbasaraner.funxchange.entity.*;
import io.github.sgbasaraner.funxchange.model.NewUserDTO;
import io.github.sgbasaraner.funxchange.repository.*;
import io.github.sgbasaraner.funxchange.service.UserService;
import io.github.sgbasaraner.funxchange.util.DeeplinkUtil;
import org.apache.commons.lang3.tuple.Pair;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.util.function.Function;
import java.util.function.Predicate;
import java.util.stream.Collectors;
import java.util.stream.IntStream;
import java.util.stream.Stream;

@SpringBootApplication
public class FunxchangeApplication {

	@Autowired
	private UserRepository userRepository;

	@Autowired
	private UserService userService;

	@Autowired
	private InterestRepository interestRepository;

	@Autowired
	private FollowerRepository followerRepository;

	@Autowired
	private MessageRepository messageRepository;

	@Autowired
	private EventRepository eventRepository;

	@Autowired
	private JoinRequestRepository joinRequestRepository;

	@Autowired
	private RatingRepository ratingRepository;

	@Autowired
	private DeeplinkUtil deeplinkUtil;

	@Autowired
	private NotificationRepository notificationRepository;

	public static void main(String[] args) {
		SpringApplication.run(FunxchangeApplication.class, args);
	}

	void generateMocks() {
		Faker faker = new Faker();
		Random rand = new Random();
		interestRepository.saveAllAndFlush(generateInterests());

		final List<NewUserDTO> userDTOS = generateList(i -> mockUser(faker), 300);
		userDTOS.forEach(u -> userService.signUp(u));

		final List<User> users = userRepository.findAll();

		final List<Follower> followerCandidates = users.stream().map(u -> {
			int followerCount = rand.nextInt(users.size() - 1);
			final List<User> followers = randomElements(users, c -> !u.getId().equals(c.getId()), followerCount);
			return followers.stream().map(f -> {
				Follower fol = new Follower();
				fol.setFollowee(u);
				fol.setFollower(f);
				return fol;
			}).collect(Collectors.toUnmodifiableList());
		}).flatMap(Collection::stream).collect(Collectors.toUnmodifiableList());

		followerRepository.saveAll(followerCandidates);

		List<Message> allMessages = new ArrayList<>();
		users.forEach(user -> {
			User randomOther = randomElements(users, user1 -> !user1.getId().equals(user.getId()), 1).get(0);
			List<Message> msgs = generateList(i -> {
				boolean randbool = faker.bool().bool();

				return mockMessage(faker, randbool ? user.getId() : randomOther.getId(), randbool ? randomOther.getId() : user.getId() );
			}, 45);

			allMessages.addAll(msgs);
		});

		Collections.shuffle(allMessages);
		allMessages.forEach(msg -> {
			messageRepository.save(msg);
		});

		final List<Event> mockEvents = users
				.stream()
				.map(u -> generateList(i -> mockEvent(faker, u, randomElements(users, usr -> !usr.getId().equals(u.getId()), faker.random().nextInt(10))), 40))
				.flatMap(List::stream)
				.collect(Collectors.toUnmodifiableList());

		eventRepository.saveAll(mockEvents);

		List<JoinRequest> joinRequests = mockEvents.stream().map(Event::getJoinRequests).flatMap(Set::stream).collect(Collectors.toUnmodifiableList());
		joinRequestRepository.saveAll(joinRequests);

		final List<Rating> allRatings = mockEvents.stream()
				.map(e -> Pair.of(Optional.of(e.getParticipants()).orElse(new HashSet<>()), e))
				.flatMap(pair -> pair.getLeft().stream().map(participant -> {
					final Rating participantRating = new Rating();
					participantRating.setRater(participant);
					participantRating.setService(pair.getRight());
					participantRating.setRated(pair.getRight().getUser());

					final Rating organizerRating = new Rating();
					organizerRating.setRater(pair.getRight().getUser());
					organizerRating.setService(pair.getRight());
					organizerRating.setRated(participant);
					if (!pair.getRight().isInFuture()) {
						participantRating.setRating(faker.random().nextInt(1, 5));
						organizerRating.setRating(faker.random().nextInt(1, 5));
					}
					return Stream.of(participantRating, organizerRating);
				}))
				.flatMap(s -> s)
				.collect(Collectors.toUnmodifiableList());

		ratingRepository.saveAll(allRatings);

		List<Notification> joinReqNotifs = joinRequests.stream().map(jr -> {
			final String text = deeplinkUtil.generateJoinRequestText(jr);
			final String deeplink = DeeplinkUtil.requestsDeeplink;
			Notification notification = new Notification();
			notification.setCreated(jr.getCreated());
			notification.setUser(jr.getEvent().getUser());
			notification.setHtmlText(text);
			notification.setDeeplink(deeplink);
			return notification;
		}).collect(Collectors.toList());

		List<Notification> followNotifs = followerCandidates.stream().map(f -> {
			Notification notification = new Notification();
			notification.setCreated(LocalDateTime.now().minusHours(faker.random().nextInt(5000)));
			notification.setUser(f.getFollowee());
			notification.setHtmlText(deeplinkUtil.generateFollowText(f));
			notification.setDeeplink(deeplinkUtil.generateUserDeeplink(f.getFollower().getId()));
			return notification;
		}).collect(Collectors.toUnmodifiableList());

		joinReqNotifs.addAll(followNotifs);

		notificationRepository.saveAll(joinReqNotifs);

		Timer t = new java.util.Timer();
		t.schedule(
				new java.util.TimerTask() {
					@Override
					public void run() {
						userDTOS.forEach(u -> System.out.println("Username: " + u.getUserName()));
						t.cancel();
					}
				},
				10000
		);
	}

	@EventListener(ApplicationReadyEvent.class)
	@Transactional
	public void runAfterStartup() {
		generateMocks();
	}

	private <T> Predicate<T> alwaysTruePredicate() {
		return x -> true;
	}

	private NewUserDTO mockUser(Faker faker) {
		return new NewUserDTO(faker.name().username() + faker.internet().domainSuffix(), faker.shakespeare().kingRichardIIIQuote(), randomElements(UserService.allowedInterests, alwaysTruePredicate(), faker.random().nextInt(UserService.allowedInterests.size())), "imamockuser");
	}

	private Event mockEvent(Faker faker, User user, List<User> participants) {
		final Event event = new Event();
		event.setTitle(faker.job().position()+ ", " + faker.job().seniority() + " for " + faker.rockBand().name());

		event.setStartDateTime(LocalDateTime.now().plus(1, ChronoUnit.DAYS).plus(faker.random().nextInt(-432000, 432000), ChronoUnit.SECONDS));
		event.setEndDateTime(event.getStartDateTime().plus(faker.random().nextInt(60, 60 * 6), ChronoUnit.MINUTES));
		event.setDetails(faker.shakespeare().kingRichardIIIQuote());
		event.setCategory(randomElements(UserService.allowedInterests, alwaysTruePredicate(), 1).get(0));
		event.setType(faker.random().nextBoolean() ? "meetup" : "service");
		event.setLatitude(faker.random().nextDouble() * 42 + 36);
		event.setLongitude(faker.random().nextDouble() * 50 + 42);
		event.setCountryName(faker.country().name());
		event.setCityName(faker.address().cityName());
		event.setUser(user);
		event.setCapacity(faker.random().nextInt(1, 12));
		event.setCreated(event.getStartDateTime().minusMinutes(faker.random().nextInt(60, 6000)));
		final List<User> limitedParticipants = participants.stream()
				.limit((faker.random().nextBoolean()) ? event.getCapacity() : event.getCapacity() - 1)
				.collect(Collectors.toUnmodifiableList());
		limitedParticipants.forEach(u -> {
			Set<Event> participatedEvents = Optional.ofNullable(u.getParticipatedEvents()).orElse(new HashSet<>());
			participatedEvents.add(event);
		});
		event.setParticipants(new HashSet<>(limitedParticipants));
		final List<JoinRequest> requests = participants.stream().filter(u -> !limitedParticipants
				.stream()
				.map(User::getId)
				.collect(Collectors.toUnmodifiableList())
				.contains(u.getId()))
				.map(u -> {
					final JoinRequest request = new JoinRequest();
					request.setEvent(event);
					request.setUser(u);
					request.setCreated(event.getStartDateTime().minusHours(faker.random().nextInt(500)));
					return request;
				})
				.collect(Collectors.toUnmodifiableList());


		requests.forEach(rq -> {
			Set<JoinRequest> requestedEvents = Optional.ofNullable(rq.getUser().getJoinRequests()).orElse(new HashSet<>());
			requestedEvents.add(rq);
		});
		event.setJoinRequests(new HashSet<>(requests));

		return event;
	}

	private <T> Stream<List<T>> batches(List<T> source, int length) {
		if (length <= 0)
			throw new IllegalArgumentException("length = " + length);
		int size = source.size();
		if (size <= 0)
			return Stream.empty();
		int fullChunks = (size - 1) / length;
		return IntStream.range(0, fullChunks + 1).mapToObj(
				n -> source.subList(n * length, n == fullChunks ? size : (n + 1) * length));
	}

	private Message mockMessage(Faker faker, UUID senderId, UUID receiverId) {
		Message message = new Message();
		message.setReceiverId(receiverId);
		message.setSenderId(senderId);
		message.setText(faker.backToTheFuture().quote());
		message.setCreated(LocalDateTime.now().minus(faker.random().nextInt(10000), ChronoUnit.SECONDS));
		return message;
	}

	private List<Interest> generateInterests() {
		return UserService.allowedInterests.stream().map(i -> {
			final Interest interest = new Interest();
			interest.setName(i);
			return interest;
		}).collect(Collectors.toUnmodifiableList());
	}

	private <T> List<T> generateList(Function<Integer, T> generator, int size) {
		List<T> returnList = new ArrayList<>();
		for (int i = 0; i < size; i++) {
			returnList.add(generator.apply(i));
		}
		return returnList;
	}

	private <T> List<T> randomElements(List<T> from, Predicate<T> predicate, int count) {
		List<T> copyList = new ArrayList<>(List.copyOf(from));
		Collections.shuffle(copyList);
		return copyList.stream().filter(predicate).limit(count).collect(Collectors.toUnmodifiableList());
	}
}
