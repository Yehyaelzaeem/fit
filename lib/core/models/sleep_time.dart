class SleepTime {
  final String sleepTimeFrom;
  final String sleepTimeTo;
  final String date;

  SleepTime({
    required this.sleepTimeFrom,
    required this.sleepTimeTo,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'sleepTimeFrom': sleepTimeFrom,
      'sleepTimeTo': sleepTimeTo,
      'date': date,
    };
  }

  factory SleepTime.fromJson(Map<String, dynamic> json) {
    return SleepTime(
      sleepTimeFrom: json['sleepTimeFrom'],
      sleepTimeTo: json['sleepTimeTo'],
      date: json['date'],
    );
  }
}