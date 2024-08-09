import 'dart:convert';
import 'package:car_wash/features/customer/widgets/customerList.dart';
import 'package:car_wash/provider/admin_provider.dart';
import 'package:car_wash/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:car_wash/common/utils/constants.dart';
import 'package:car_wash/common/widgets/header.dart';
import 'package:car_wash/features/Customer/createCustomer.dart';

class CustomerState {
  final bool isLoading;
  final bool noRecordsFound;
  final List<dynamic> body;
  final TextEditingController searchController;

  CustomerState({
    required this.isLoading,
    required this.noRecordsFound,
    required this.body,
    required this.searchController,
  });

  CustomerState copyWith({
    bool? isLoading,
    bool? noRecordsFound,
    List<dynamic>? body,
    TextEditingController? searchController,
  }) {
    return CustomerState(
      isLoading: isLoading ?? this.isLoading,
      noRecordsFound: noRecordsFound ?? this.noRecordsFound,
      body: body ?? this.body,
      searchController: searchController ?? this.searchController,
    );
  }
}

class CustomerNotifier extends StateNotifier<CustomerState> {
  final Ref ref;

  CustomerNotifier(this.ref)
      : super(CustomerState(
          isLoading: true,
          noRecordsFound: false,
          body: [],
          searchController: TextEditingController(),
        )) {
    CustomerList();
    state.searchController.addListener(() {
      CustomerList();
    });
  }

  Future<void> CustomerList() async {
    final admin = ref.read(authProvider);
    state = state.copyWith(isLoading: true);

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://wash.sortbe.com/API/Admin/Client/Client-List'),
    );
    request.fields.addAll({
      'enc_key': encKey,
      'emp_id': admin.admin!.id,
      'search_name': state.searchController.text,
    });

    try {
      http.StreamedResponse response = await request.send();
      String temp = await response.stream.bytesToString();
      var responseBody = jsonDecode(temp);

      if (response.statusCode == 200 && responseBody['status'] == 'Success') {
        state = state.copyWith(
          body: responseBody['data'] ?? [],
          noRecordsFound: (responseBody['data'] ?? []).isEmpty,
        );
      } else {
        print('Error: ${responseBody['remarks']}');
        state = state.copyWith(
          body: [],
          noRecordsFound: true,
        );
      }
    } catch (e) {
      print('Failed to decode JSON: $e');
      state = state.copyWith(
        body: [],
        noRecordsFound: true,
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> removeCustomer(BuildContext context, String customerId) async {
    final admin = ref.read(authProvider);
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://wash.sortbe.com/API/Admin/Client/Client-Remove'),
    );
    request.fields.addAll({
      'enc_key': encKey,
      'emp_id': admin.admin!.id,
      'customer_id': customerId,
      'password': '12345665',
    });

    try {
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: AppTemplate.bgClr,
              content: Text(
                'Customer Removed Successfully',
                style: GoogleFonts.inter(color: AppTemplate.primaryClr),
              )),
        );
        state = state.copyWith(
          body: state.body
              .where((customer) => customer['customer_id'] != customerId)
              .toList(),
          noRecordsFound: state.body.isEmpty,
        );
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print('Failed to remove customer: $e');
    }
  }

  Future<void> confirmRemoveCustomer(
      BuildContext context, String customerId) async {
    bool? shouldRemove = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTemplate.primaryClr,
          title: Text('Confirm Removal'),
          content: Text('Are you sure you want to remove this customer?'),
          actions: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppTemplate.bgClr,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    'No',
                    style: GoogleFonts.inter(color: AppTemplate.primaryClr),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppTemplate.bgClr,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(
                    'Yes',
                    style: GoogleFonts.inter(color: AppTemplate.primaryClr),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    if (shouldRemove == true) {
      await removeCustomer(context, customerId);
      await CustomerList();
    }
  }
}

class Customer extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customerController = ref.watch(customerProvider);

    return Scaffold(
      backgroundColor: AppTemplate.primaryClr,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Header(txt: 'Customer'),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Available Customers',
                    style: GoogleFonts.inter(
                        color: AppTemplate.textClr,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateCustomer(),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: Stack(
                          children: [
                            SvgPicture.asset(
                              'assets/svg/person.svg',
                              height: 18,
                            ),
                            Positioned(
                              right: 1.w,
                              bottom: 0.h,
                              child: SvgPicture.asset(
                                'assets/svg/add.svg',
                                height: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: TextField(
                controller: customerController.searchController,
                cursorColor: AppTemplate.textClr,
                cursorHeight: 20.h,
                decoration: InputDecoration(
                  hintText: 'Search by Name or Vehicle Number',
                  hintStyle: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: const Color(0xFF929292),
                      fontWeight: FontWeight.w400),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.r),
                    borderSide: BorderSide(
                        color: const Color(0xFFD4D4D4), width: 1.5.w),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.r),
                    borderSide: BorderSide(
                        color: const Color(0xFFD4D4D4), width: 1.5.w),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Search Result',
                    style: GoogleFonts.inter(
                        color: AppTemplate.textClr,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400),
                  ),
                  customerController.isLoading
                      ? Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 10.h,
                                width: 10.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.w,
                                  color: const Color.fromARGB(255, 0, 52, 182),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Text(
                          customerController.noRecordsFound
                              ? 'Showing 0 of 250'
                              : 'Showing ${customerController.body.length} of 250',
                          style: GoogleFonts.inter(
                              color: AppTemplate.textClr,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400),
                        ),
                ],
              ),
            ),
            customerController.isLoading
                ? Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 100.h,
                        ),
                        const CircularProgressIndicator(
                          color: Color.fromARGB(255, 0, 52, 182),
                        ),
                      ],
                    ),
                  )
                : customerController.body.isEmpty
                    ? Column(
                        children: [
                          SizedBox(height: 100.h),
                          Center(
                            child: Text(
                              'No records found',
                              style: GoogleFonts.inter(
                                  color: AppTemplate.textClr,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      )
                    : Flexible(
                        child: CustomerList(),
                      ),
          ],
        ),
      ),
    );
  }
}
