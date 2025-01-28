class WorkingHours {
  final String day;
  final List<TimeSlot> timeSlots;

  WorkingHours({required this.day, required this.timeSlots});

  factory WorkingHours.fromJson(String day, List<dynamic> json) {
    return WorkingHours(
      day: day,
      timeSlots: json
          .map((slot) => TimeSlot.fromJson(slot as Map<String, dynamic>))
          .toList(),
    );
  }
}

class TimeSlot {
  final int id;
  final String startTime;
  final String endTime;

  TimeSlot({required this.id, required this.startTime, required this.endTime});

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      id: json['id'],
      startTime: json['start_time'],
      endTime: json['end_time'],
    );
  }
}
