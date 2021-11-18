enum Interest {
  golf,
  yoga,
  painting,
  graphicDesign,
  computers,
  makeup,
  cooking,
  gaming
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
      case Interest.computers:
        return "assets/computers.jpg";
      case Interest.makeup:
        return "assets/makeup.jpg";
      case Interest.cooking:
        return "assets/cooking.jpg";
      case Interest.gaming:
        return "assets/gaming.jpg";
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
      case Interest.computers:
        return "Computers";
      case Interest.makeup:
        return "Makeup";
      case Interest.cooking:
        return "Cooking";
      case Interest.gaming:
        return "Gaming";
    }
  }
}
    
    // "History",
    // "Foreign Languages",
    // "Cars",
    // "Dancing",
    // "Sewing",
    // "Politics",
    // "Partying"
