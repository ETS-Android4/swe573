# BOUN SWE 573 - Software Development Practice (2021 Fall)

Funxchange is an application where people exchange services and meet with each other. More information is available on wiki page.

## Running backend services

Dependencies: Maven, Docker, Docker-Compose, Java 11 JDK

Move to backend directory:

`cd backend/funxchange`

Build the project:

`./mvnw clean package -DskipTests`

Copy the executable to docker directory:

`cp target/funxchange-0.0.1-SNAPSHOT.jar src/main/docker`

Move to docker directory:

`cd src/main/docker`

Run docker-compose:

`docker-compose up`

Note: For subsequent runs, you need to clear the previous image. To automate this process, there’s a bash script named “reup.sh” on the backend directory which clears the previous image and runs the aforementioned steps.

## Running frontend project

Dependencies (Android): Flutter SDK, Android SDK, an Android device or emulator
Dependencies (iOS): Flutter SDK, Xcode, an iOS device or iOS simulator

Move to frontend directory:

`cd frontend/funxchange`

Run the project:

`flutter run`

