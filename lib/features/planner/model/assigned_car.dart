class AssignedCar {
  final String clientName;
  final String carId;
  final String vehicleNo;
  final String washName;
  final String cleanId;
  final String remarks;

  AssignedCar({
    required this.clientName,
    required this.carId,
    required this.vehicleNo,
    required this.washName,
    required this.cleanId,
    required this.remarks,
  });

  factory AssignedCar.fromJson(Map<String, dynamic> json) {
    return AssignedCar(
      clientName: json['client_name'],
      carId: json['car_id'],
      vehicleNo: json['vehicle_no'],
      washName: json['wash_name'],
      cleanId: json['clean_id'],
      remarks: json['remarks'],
    );
  }
}
