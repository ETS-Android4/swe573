package io.github.sgbasaraner.funxchange;


import com.github.javafaker.Faker;
import io.github.sgbasaraner.funxchange.entity.*;
import io.github.sgbasaraner.funxchange.model.NewUserDTO;
import io.github.sgbasaraner.funxchange.repository.*;
import io.github.sgbasaraner.funxchange.service.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
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


	Logger logger = LoggerFactory.getLogger(FunxchangeApplication.class);

	public static void main(String[] args) {
		SpringApplication.run(FunxchangeApplication.class, args);
	}

	@EventListener(ApplicationReadyEvent.class)
	@Transactional
	public void runAfterStartup() {
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

		userDTOS.stream().limit(5).forEach(u -> System.out.println("Username: " + u.getUserName() + " pw: " + u.getPassword()));
	}

	private <T> Predicate<T> alwaysTruePredicate() {
		return x -> true;
	}

	private NewUserDTO mockUser(Faker faker) {
		return new NewUserDTO(faker.name().username() + faker.internet().domainSuffix(), faker.shakespeare().kingRichardIIIQuote(), randomElements(UserService.allowedInterests, alwaysTruePredicate(), faker.random().nextInt(UserService.allowedInterests.size())), faker.internet().password());
	}

	private Event mockEvent(Faker faker, User user, List<User> participants) {
		final Event event = new Event();
		event.setTitle(faker.job() + " for " + faker.rockBand().name());

		event.setStartDateTime(LocalDateTime.now().plus(faker.random().nextInt(432000), ChronoUnit.SECONDS));
		event.setEndDateTime(event.getStartDateTime().plus(faker.random().nextInt(1800, 432000), ChronoUnit.SECONDS));
		event.setDetails(faker.shakespeare().kingRichardIIIQuote());
		event.setCategory(randomElements(UserService.allowedInterests, alwaysTruePredicate(), 1).get(0));
		event.setType(faker.random().nextBoolean() ? "meetup" : "service");
		event.setLatitude(faker.random().nextDouble() * 42 + 36);
		event.setLongitude(faker.random().nextDouble() * 50 + 42);
		event.setCountryName(faker.country().name());
		event.setCityName(faker.address().cityName());
		event.setUser(user);
		event.setCreated(LocalDateTime.now().plus(faker.random().nextInt(20, 1000), ChronoUnit.MILLIS));
		participants.forEach(u -> {
			Set<Event> participatedEvents = Optional.ofNullable(u.getParticipatedEvents()).orElse(new HashSet<>());
			participatedEvents.add(event);
		});
		event.setParticipants(new HashSet<>(participants));
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
