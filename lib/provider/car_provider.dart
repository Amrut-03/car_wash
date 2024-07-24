import 'dart:convert';

import 'package:car_wash/common/utils/constants.dart';
import 'package:car_wash/features/planner/model/all_car.dart';
import 'package:car_wash/features/planner/model/assigned_car.dart';
import 'package:car_wash/features/planner/model/car_lists.dart';
import 'package:car_wash/features/planner/model/car_params.dart';
import 'package:car_wash/provider/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final carProvider =
    FutureProvider.family<CarLists, CarParams>((ref, params) async {
  const url = 'https://wash.sortbe.com/API/Admin/Planner/Client-Planner';

  final admin = ref.read(adminProvider);

  if (admin == null) {
    throw Exception('Admin data is not available');
  }

  final response = await http.post(
    Uri.parse(url),
    body: {
      'enc_key': encKey,
      'emp_id': admin.id,
      'search_name': params.searchName,
      'planner_date': plannerDate,
      'cleaner_key': params.cleanerKey,
    },
  );
  final res = jsonDecode(response.body);
  if (res['status'] == 'Success') {
    List<AllCar> allCars = [];
    List<AssignedCar> assignedCars = [];
    String startKm = '';
    String endKm = '';

    try {
      List<dynamic> allCarsJson = res['data']['all_cars'] ?? [];
      List<dynamic> assignedCarsJson = res['data']['assigned_cars'] ?? [];
      allCars = List<AllCar>.from(allCarsJson.map((x) => AllCar.fromJson(x)));
      assignedCars = List<AssignedCar>.from(
          assignedCarsJson.map((x) => AssignedCar.fromJson(x)));
      startKm = res['start_km'];
      endKm = res['end_km'];
    } catch (e) {
      print('Error = $e');
    }
    return CarLists(
      allCars: allCars,
      assignedCars: assignedCars,
      startKm: startKm,
      endKm: endKm,
    );
  } else {
    throw Exception('Failed to load cars');
  }
});
