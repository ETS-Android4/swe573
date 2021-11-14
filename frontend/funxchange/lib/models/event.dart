class Event {
  final EventType type;
  final String category;
  final String location;
  final String title;
  final String details;
  final DateTime dateTime;
  final int durationInMinutes;
  final String imagePath;

  Event(this.type, this.category, this.location, this.title, this.details,
      this.dateTime, this.durationInMinutes, this.imagePath);

  static List<Event> example = [
    Event(
        EventType.meetup,
        "Golf",
        "İstanbul",
        "Golf Meetup",
        "We'll be playing Golf this weekend at Atasehir Golf Park. We're waiting for you!",
        DateTime.parse("2021-11-13 13:00:00"),
        4,
        "assets/golf.jpg"),
    Event(
        EventType.service,
        "Graphic Design",
        "Edirne",
        "Logo design",
        "Hi from Edirne! I'll design your brand's logo and deliver in a multi-format file.",
        DateTime.parse("2021-11-20 22:00:00"),
        1,
        "assets/graphics.jpg"),
    Event(
        EventType.service,
        "Painting",
        "Ankara",
        "Painting lessons",
        "Hi everyone, I've decided to offer painting lessons here. We'll be studying the classics for the first lesson, and then work on technique a bit. I hope by the end of this everyone will be better painters.",
        DateTime.parse("2021-11-18 19:00:00"),
        2,
        "assets/painting.jpg"),
    Event(
        EventType.service,
        "Sports",
        "Ankara",
        "Yoga class",
        "Hi everyone, I'm offering 1 on 1 yoga classes'. We'll follow flows specifically designed from me. I'll hopefully be able to test my new flows here.",
        DateTime.parse("2021-11-18 19:00:00"),
        2,
        "assets/yoga.jpg"),
  ];
}

enum EventType {
  meetup,
  service,
}
