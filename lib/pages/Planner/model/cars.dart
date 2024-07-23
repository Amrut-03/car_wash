class AllCar {
  final String clientName;
  final String clientId;
  final String vehicleNo;
  final String? alloted;

  AllCar({
    required this.clientName,
    required this.clientId,
    required this.vehicleNo,
    required this.alloted,
  });

  factory AllCar.fromJson(Map<String, dynamic> json) {
    return AllCar(
      clientName: json['client_name'],
      clientId: json['client_id'],
      vehicleNo: json['vehicle_no'],
      alloted: json['alloted'],
    );
  }
}

class AssignedCar {
  final String clientName;
  final String carId;
  final String vehicleNo;
  final String washName;

  AssignedCar({
    required this.clientName,
    required this.carId,
    required this.vehicleNo,
    required this.washName,
  });

  factory AssignedCar.fromJson(Map<String, dynamic> json) {
    return AssignedCar(
      clientName: json['client_name'],
      carId: json['car_id'],
      vehicleNo: json['vehicle_no'],
      washName: json['wash_name'],
    );
  }
}

class CarLists {
  final List<AllCar> allCars;
  final List<AssignedCar> assignedCars;

  CarLists({required this.allCars, required this.assignedCars});

  factory CarLists.fromJson(Map<String, dynamic> json) {
    var allCarsFromJson = json['data']['allCars'] as List;
    var assignedCarsFromJson = json['data']['assignedCars'] as List;
    print('*******');
    print(allCarsFromJson);
    print(assignedCarsFromJson);

    List<AllCar> allCarsList =
        allCarsFromJson.map((car) => AllCar.fromJson(car)).toList();
    List<AssignedCar> assignedCarsList =
        assignedCarsFromJson.map((car) => AssignedCar.fromJson(car)).toList();

    return CarLists(
      allCars: allCarsList,
      assignedCars: assignedCarsList,
    );
  }
}

class CarParams {
  final String empId;
  final String searchName;
  final String cleanerKey;

  CarParams({
    required this.empId,
    required this.searchName,
    required this.cleanerKey,
  });
}
