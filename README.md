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

Set up the device to run (Android):

1. Enable the [Developer options](https://developer.android.com/studio/debug/dev-options) for your Android device.

1. Enable USB debugging in developer options.

1. Plug in the phone to your computer with a USB cable. If you see any popup asking if you want to allow USB debugging in the computer, click "Yes".

Move to frontend directory:

`cd frontend/funxchange`

There are two options to run the project:

1. Running immediately with debug mode:

Run the project:

`flutter run`

2. Compiling a fat APK and running on-device:

Build the project:

`flutter build apk`

Take note of the command's output since it will show you where the compiled apk is located.

Copy the APK to your device.

Locate the APK in your Android file browser.

Tap the located APK file.

Android OS will ask you to grant permissions to install the APK. Allow it.

Find the installed app on your device and run it.
