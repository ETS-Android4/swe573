class Event {
  final EventType type;
  final String category;
  final String location;
  final String title;
  final String details;
  final DateTime dateTime;
  final int durationInMinutes;

  Event(this.type, this.category, this.location, this.title, this.details,
      this.dateTime, this.durationInMinutes);

  static List<Event> example = [
    Event(
        EventType.meetup,
        "Golf",
        "İstanbul",
        "Golf Meetup",
        "We'll be playing Golf this weekend at Atasehir Golf Park. We're waiting for you!",
        DateTime.parse("2021-11-13 13:00:00"),
        4),
    Event(
        EventType.service,
        "Painting",
        "Ankara",
        "Painting lessons",
        "Hi everyone, I've decided to offer painting lessons here. We'll be studying the classics for the first lesson, and then work on technique a bit. I hope by the end of this everyone will be better painters.",
        DateTime.parse("2021-11-18 19:00:00"),
        2),
  ];
}

enum EventType {
  meetup,
  service,
}
