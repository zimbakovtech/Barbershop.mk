class ServiceStat {
  final int serviceId;
  final String serviceName;
  final double percentage;
  final int appointmentCount;

  ServiceStat({
    required this.serviceId,
    required this.serviceName,
    required this.percentage,
    required this.appointmentCount,
  });

  factory ServiceStat.fromJson(Map<String, dynamic> json) {
    return ServiceStat(
      serviceId: json['service_id'],
      serviceName: json['service_name'],
      percentage: json['percentage'].toDouble(),
      appointmentCount: json['appointment_count'],
    );
  }
}

class CustomerStats {
  final int newCustomersCount;
  final int returningCustomersCount;
  final int totalCustomersCount;
  final double returnRate;

  CustomerStats({
    required this.newCustomersCount,
    required this.returningCustomersCount,
    required this.totalCustomersCount,
    required this.returnRate,
  });

  factory CustomerStats.fromJson(Map<String, dynamic> json) {
    return CustomerStats(
      newCustomersCount: json['new_customers_count'],
      returningCustomersCount: json['returning_customers_count'],
      totalCustomersCount: json['total_customers_count'],
      returnRate: json['return_rate'].toDouble(),
    );
  }
}
