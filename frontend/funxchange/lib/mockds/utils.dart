import 'dart:async';

class MockUtils {
  static Future<T> delayed<T>([FutureOr<T> Function()? computation]) {
    return Future.delayed(const Duration(seconds: 1), computation);
  }
}
