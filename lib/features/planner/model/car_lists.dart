// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:car_wash/features/planner/model/all_car.dart';
import 'package:car_wash/features/planner/model/assigned_car.dart';

class CarLists {
  final List<AllCar> allCars;
  final List<AssignedCar> assignedCars;
  final String startKm;
  final String endKm;

  CarLists({
    required this.allCars,
    required this.assignedCars,
    required this.startKm,
    required this.endKm,
  });

  factory CarLists.fromJson(Map<String, dynamic> json) {
    var allCarsFromJson = json['data']['all_cars'] as List? ?? [];
    var assignedCarsFromJson = json['data']['assigned_cars'] as List? ?? [];
    var start = json['start_km'];
    var end = json['end_km'];

    List<AllCar> allCarsList =
        List<AllCar>.from(allCarsFromJson.map((car) => AllCar.fromJson(car)));
    List<AssignedCar> assignedCarsList = List<AssignedCar>.from(
        assignedCarsFromJson.map((car) => AssignedCar.fromJson(car)));
    print('All cars list = $allCarsList');
    print('Assigned cars list = $assignedCarsList');

    return CarLists(
      allCars: allCarsList,
      assignedCars: assignedCarsList,
      startKm: start,
      endKm: end,
    );
  }
}
