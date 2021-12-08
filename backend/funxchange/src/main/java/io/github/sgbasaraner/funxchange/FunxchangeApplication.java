package io.github.sgbasaraner.funxchange;


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

	Logger logger = LoggerFactory.getLogger(FunxchangeApplication.class);

	public static void main(String[] args) {
		SpringApplication.run(FunxchangeApplication.class, args);
	}

	@EventListener(ApplicationReadyEvent.class)
	public void runAfterStartup() {

	}

}
