package io.github.sgbasaraner.funxchange;

import io.github.sgbasaraner.funxchange.entity.Test;
import io.github.sgbasaraner.funxchange.repository.TestRepository;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;

import java.util.List;

@SpringBootApplication
public class FunxchangeApplication {

	private final TestRepository testRepository;

	Logger logger = LoggerFactory.getLogger(FunxchangeApplication.class);

	@Autowired
	public FunxchangeApplication(TestRepository testRepository) {
		this.testRepository = testRepository;
	}

	public static void main(String[] args) {
		SpringApplication.run(FunxchangeApplication.class, args);
	}

	@EventListener(ApplicationReadyEvent.class)
	public void runAfterStartup() {
		List<Test> allEntities = testRepository.findAll();
		logger.info("Number of entities: " + allEntities.size());

		Test testEntity = new Test();
		testEntity.setTestValue("test value");
		logger.info("Saving test entity...");
		testRepository.save(testEntity);

		allEntities = testRepository.findAll();
		logger.info("Number of entities: " + allEntities.size());
	}

}
