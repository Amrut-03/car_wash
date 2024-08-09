import 'dart:convert';

import 'package:car_wash/common/utils/constants.dart';
import 'package:car_wash/provider/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Namelists extends ConsumerStatefulWidget {
  const Namelists({super.key});

  @override
  ConsumerState<Namelists> createState() => _NamelistsState();
}

class _NamelistsState extends ConsumerState<Namelists> {
  List<dynamic> body = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    customerList();
  }

  Future<void> customerList() async {
    final admin = ref.read(authProvider);
    var request = http.MultipartRequest('POST',
        Uri.parse('https://wash.sortbe.com/API/Admin/Client/Client-List'));
    request.fields.addAll({
      'enc_key': encKey,
      'emp_id': admin.admin!.id,
      'search_name': '',
    });

    http.StreamedResponse response = await request.send();
    String temp = await response.stream.bytesToString();
    var responseBody = jsonDecode(temp);

    if (response.statusCode == 200) {
      setState(() {
        body = responseBody['data'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: const Color.fromARGB(255, 0, 52, 182),
              ),
            )
          : ListView.builder(
              itemCount: body.length,
              itemBuilder: (context, index) {
                var employee = body[index];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Handle tap action if needed
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppTemplate.primaryClr,
                            boxShadow: [
                              BoxShadow(
                                color: AppTemplate.shadowClr,
                                blurRadius: 4.r,
                                spreadRadius: 0.r,
                                offset: Offset(0.w, 4.h),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(color: AppTemplate.shadowClr),
                          ),
                          child: SizedBox(
                            height: 56.h,
                            width: 310.w,
                            child: Padding(
                              padding: EdgeInsets.all(19.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    employee['client_name'],
                                    style: GoogleFonts.inter(
                                      color: AppTemplate.textClr,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                  Image.asset(
                                    'assets/images/forward.png',
                                    height: 40.h,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
