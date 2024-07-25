class AllCar {
  final String clientName;
  final String clientId;
  final String vehicleNo;
  final String alloted;

  AllCar({
    required this.clientName,
    required this.clientId,
    required this.vehicleNo,
    required this.alloted,
  });

  factory AllCar.fromJson(Map<String, dynamic> json) {
    return AllCar(
      clientName: json['client_name'] ?? '',
      clientId: json['client_id'] ?? '',
      vehicleNo: json['vehicle_no'] ?? '',
      alloted: json['alloted']?? '',
    );
  }
}