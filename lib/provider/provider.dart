import 'dart:io';
import 'package:car_wash/features/customer/pages/customer.dart';
import 'package:car_wash/features/dashboard.dart';
import 'package:car_wash/features/employee/pages/employee.dart';
import 'package:car_wash/features/planner/pages/planner_employee.dart';
import 'package:car_wash/provider/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

class CustomerCard {
  File? image;

  CustomerCard({this.image});
}

class CustomerCardNotifier extends StateNotifier<List<CustomerCard>> {
  CustomerCardNotifier() : super([]);

  void updateImage(int index, File imageFile) {
    print('updateImage called');
    if (index < state.length) {
      print('Updating image at index $index with file path: ${imageFile.path}');
      final updatedCards = List<CustomerCard>.from(state);
      updatedCards[index] = CustomerCard(image: imageFile);
      state = updatedCards;
    }
  }

  void resetCards() {
    state = [CustomerCard()];
  }

  void addCard() {
    state = [...state, CustomerCard()];
  }

  void removeCard(int index) {
    if (index < state.length) {
      state.removeAt(index);
      state = List.from(state);
    }
  }

  void clearCards() {
    state = [];
  }
}

final customerCardProvider =
    StateNotifierProvider<CustomerCardNotifier, List<CustomerCard>>((ref) {
  return CustomerCardNotifier();
});

final locationProvider =
    StateNotifierProvider<LocationNotifier, Position?>((ref) {
  return LocationNotifier();
});

class LocationNotifier extends StateNotifier<Position?> {
  LocationNotifier() : super(null);

  void updateLocation(Position position) {
    state = position;
  }
}

final dropdownProvider = StateNotifierProvider<DropdownNotifier, String>((ref) {
  return DropdownNotifier();
});

class DropdownNotifier extends StateNotifier<String> {
  DropdownNotifier() : super('Employee');

  void setDropdownValue(String value) {
    state = value;
  }
}

// Text field controllers
final employeeNameProvider = Provider((ref) => TextEditingController());
final dobControllerProvider = Provider((ref) => TextEditingController());
final addressControllerProvider = Provider((ref) => TextEditingController());
final phone1ControllerProvider = Provider((ref) => TextEditingController());
final phone2ControllerProvider = Provider((ref) => TextEditingController());
final passwordControllerProvider = Provider((ref) => TextEditingController());
// Image files
final aadharFrontProvider = StateProvider<File?>((ref) => null);
final aadharBackProvider = StateProvider<File?>((ref) => null);
final driveFrontProvider = StateProvider<File?>((ref) => null);
final driveBackProvider = StateProvider<File?>((ref) => null);
final employeePhotoProvider = StateProvider<File?>((ref) => null);

final aadharFrontUrlProvider = StateProvider<String?>((ref) => null);
final aadharBackUrlProvider = StateProvider<String?>((ref) => null);
final driveFrontUrlProvider = StateProvider<String?>((ref) => null);
final driveBackUrlProvider = StateProvider<String?>((ref) => null);
final employeePhotoUrlProvider = StateProvider<String?>((ref) => null);

final customerProvider = StateNotifierProvider<CustomerNotifier, CustomerState>(
  (ref) => CustomerNotifier(ref),
);

// final employeeProvider = StateNotifierProvider<EmployeeNotifier, EmployeeState>(
//   (ref) {
//     final adminId = ref.read(authProvider).admin!.id;
//     final searchController =
//         TextEditingController(); // Create the searchController here
//     return EmployeeNotifier(ref, adminId, searchController);
//   },
// );

final dashboardProvider =
    StateNotifierProvider<DashboardNotifier, AsyncValue<DashboardData>>(
  (ref) => DashboardNotifier(),
);

final empIdProvider = StateProvider<String>((ref) => '');
