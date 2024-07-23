import 'dart:convert';

import 'package:car_wash/pages/Planner/model/cars.dart';
import 'package:car_wash/provider/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

final carProvider =
    FutureProvider.family<CarLists, CarParams>((ref, params) async {
  String formattedDate = DateFormat('d MMMM yyyy').format(DateTime.now());
  const url = 'https://wash.sortbe.com/API/Admin/Planner/Client-Planner';
  const encKey = 'C0oRAe1QNtn3zYNvJ8rv';
  final plannerDate = formattedDate;
  final admin = ref.read(adminProvider);

  try {
    final response = await http.post(
      Uri.parse(url),
      body: {
        'enc_key': encKey,
        'emp_id': admin!.id,
        'search_name': params.searchName,
        'planner_date': plannerDate,
        'cleaner_key': params.cleanerKey,
      },
    );

    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);
      print('&&&&&&');
      print(res);
      return CarLists.fromJson(res);
    } else {
      throw Exception('Failed to load cars');
    }
  } catch (e) {
    print('Error = $e');
    return CarLists(
      allCars: [],
      assignedCars: [],
    );
  }
});
