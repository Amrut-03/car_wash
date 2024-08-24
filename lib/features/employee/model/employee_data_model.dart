class Wash {
  final String washTime;
  final String washStatus;
  final String washId;
  final String clientName;

  Wash({
    required this.washTime,
    required this.washStatus,
    required this.washId,
    required this.clientName,
  });

  factory Wash.fromJson(Map<String, dynamic> json) {
    return Wash(
      washTime: json['wash_time'],
      washStatus: json['wash_status'],
      washId: json['wash_id'],
      clientName: json['client_name'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': washId,
      'wash_date': washTime,
      'wash_status': washStatus,
      'client_name': clientName,
    };
  }
}

class EmployeeData {
  final String id;
  final String name;
  final String employeePic;
  final String address;
  final String phone1;
  final List<Wash> washes;

  EmployeeData({
    required this.id,
    required this.name,
    required this.employeePic,
    required this.address,
    required this.phone1,
    required this.washes,
  });

  factory EmployeeData.fromJson(Map<String, dynamic> json) {
    var list = json['washes'] as List;
    List<Wash> washList = list.map((i) => Wash.fromJson(i)).toList();

    return EmployeeData(
      id: json['id'],
      name: json['name'],
      employeePic: json['employee_pic'],
      address: json['address'],
      phone1: json['phone_1'],
      washes: washList,
    );
  }
}
