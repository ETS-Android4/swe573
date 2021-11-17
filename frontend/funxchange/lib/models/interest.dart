enum Interest {
  golf,
  yoga,
  painting,
  graphicDesign,
}

extension ImagePathExtension on Interest {
  String get imagePath {
    switch (this) {
      case Interest.golf:
        return "assets/golf.jpg";
      case Interest.yoga:
        return "assets/yoga.jpg";
      case Interest.painting:
        return "assets/painting.jpg";
      case Interest.graphicDesign:
        return "assets/graphics.jpg";
    }
  }
}

extension PrettyNameExtension on Interest {
  String get prettyName {
    switch (this) {
      case Interest.golf:
        return "Golf";
      case Interest.yoga:
        return "Yoga";
      case Interest.painting:
        return "Painting";
      case Interest.graphicDesign:
        return "Graphic Design";
    }
  }
}
    // "Computers",
    // "Makeup",
    // "History",
    // "Foreign Languages",
    // "Cars",
    // "Dancing",
    // "Sewing",
    // "Politics",
    // "Cooking",
    // "Video Games",
    // "Partying"
