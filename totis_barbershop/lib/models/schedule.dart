class Schedule extends Iterable<AvailableDate> {
  final String currentDate;
  final List<String> slots;
  final List<AvailableDate> availableDates;

  Schedule({
    required this.currentDate,
    required this.slots,
    required this.availableDates,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      currentDate: json['current_date'],
      slots: List<String>.from(json['slots']),
      availableDates: (json['available_dates'] as List<dynamic>)
          .map((date) => AvailableDate.fromJson(date))
          .toList(),
    );
  }
  @override
  Iterator<AvailableDate> get iterator => availableDates.iterator;
}

class AvailableDate {
  final String date;
  final bool isAvailable;
  final int totalSlots;

  AvailableDate({
    required this.date,
    required this.isAvailable,
    required this.totalSlots,
  });

  factory AvailableDate.fromJson(Map<String, dynamic> json) {
    return AvailableDate(
      date: json['date'],
      isAvailable: json['is_available'],
      totalSlots: json['total_slots'],
    );
  }
}
