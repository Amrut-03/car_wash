import 'dart:convert';
import 'package:car_wash/pages/Customer/createProfile.dart';
import 'package:car_wash/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class Namelists extends StatefulWidget {
  const Namelists({super.key});

  @override
  State<Namelists> createState() => _NamelistsState();
}

class _NamelistsState extends State<Namelists> {
  List<dynamic> body = [];

  @override
  void initState() {
    super.initState();
    customerList();
  }

  Future<void> customerList() async {
    var request = http.MultipartRequest('POST',
        Uri.parse('https://wash.sortbe.com/API/Admin/Client/Client-List'));
    request.fields.addAll({
      'enc_key': 'C0oRAe1QNtn3zYNvJ8rv',
      'emp_id': '123',
      'search_name': ''
    });

    http.StreamedResponse response = await request.send();
    String temp = await response.stream.bytesToString();
    var responseBody = jsonDecode(temp);

    if (response.statusCode == 200) {
      setState(() {
        body = responseBody['data'];
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return body.isEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 200.h,
              ),
              const CircularProgressIndicator(
                color: Color.fromARGB(255, 0, 52, 182),
              ),
            ],
          )
        : Expanded(
            child: ListView.builder(
              itemCount: body.length,
              itemBuilder: (context, index) {
                var employee = body[index];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      GestureDetector(
                        // onTap: () => Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => CustomerProfile(customerName: employee['client_name'], customerPhone: employee['mobile'],),
                        //   ),
                        // ),
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppTemplate.primaryClr,
                              boxShadow: [
                                BoxShadow(
                                    color: AppTemplate.shadowClr,
                                    blurRadius: 4.r,
                                    spreadRadius: 0.r,
                                    offset: Offset(0.w, 4.h))
                              ],
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(color: AppTemplate.shadowClr)),
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
                                        fontSize: 15.sp),
                                  ),
                                  Image(
                                    image: const AssetImage(
                                      'assets/images/forward.png',
                                    ),
                                    height: 40.h,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25.h,
                      )
                    ],
                  ),
                );
              },
            ),
          );
  }
}
