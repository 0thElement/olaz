extension ExtendedList on List<dynamic> {
  List<String> toListString() {
    return map((e) => e.toString()).toList();
  }
}

extension ExtendedDateTime on DateTime {
  String format() {
    return "$year/$month/$day";
  }
}
