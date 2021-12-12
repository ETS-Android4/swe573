package io.github.sgbasaraner.funxchange;


import com.github.javafaker.Faker;
import io.github.sgbasaraner.funxchange.entity.Follower;
import io.github.sgbasaraner.funxchange.entity.Interest;
import io.github.sgbasaraner.funxchange.entity.User;
import io.github.sgbasaraner.funxchange.model.NewUserDTO;
import io.github.sgbasaraner.funxchange.repository.FollowerRepository;
import io.github.sgbasaraner.funxchange.repository.InterestRepository;
import io.github.sgbasaraner.funxchange.repository.UserRepository;
import io.github.sgbasaraner.funxchange.service.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;

import java.util.*;
import java.util.function.Function;
import java.util.function.Predicate;
import java.util.stream.Collectors;

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

	Logger logger = LoggerFactory.getLogger(FunxchangeApplication.class);

	public static void main(String[] args) {
		SpringApplication.run(FunxchangeApplication.class, args);
	}

	@EventListener(ApplicationReadyEvent.class)
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

		users.stream().limit(5).forEach(u -> logger.info("Sample username: " + u.getUserName()));
	}

	private <T> Predicate<T> alwaysTruePredicate() {
		return x -> true;
	}

	private NewUserDTO mockUser(Faker faker) {
		return new NewUserDTO(faker.name().username(), faker.shakespeare().kingRichardIIIQuote(), randomElements(UserService.allowedInterests, alwaysTruePredicate(), faker.random().nextInt(UserService.allowedInterests.size())), faker.internet().password());
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
