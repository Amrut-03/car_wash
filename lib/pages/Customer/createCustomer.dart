import 'package:car_wash/Widgets/ButtonWidget.dart';
import 'package:car_wash/Widgets/CreateCustomerCard.dart';
import 'package:car_wash/Widgets/TextFieldWidget.dart';
import 'package:car_wash/Widgets/header.dart';
import 'package:car_wash/pages/Customer/customer.dart';
import 'package:car_wash/provider/provider.dart';
import 'package:car_wash/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class CreateCustomer extends ConsumerStatefulWidget {
  const CreateCustomer({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateCustomerState createState() => _CreateCustomerState();
}

class _CreateCustomerState extends ConsumerState<CreateCustomer> {
  TextEditingController customerController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  Future<void> creatCustomer() async {
    var request = http.MultipartRequest('POST',
        Uri.parse('https://wash.sortbe.com/API/Admin/Client/Client-Creation'));
    request.fields.addAll({
      'enc_key': 'C0oRAe1QNtn3zYNvJ8rv',
      'emp_id': '123',
      'client_name': customerController.text,
      'mobile': mobileController.text,
      'car_info':
          '[\n    {\n        "model_name" : "santro",\n        "vehicle_no" : "TN 45 AK 1723",\n        "lat" : "10.12345",\n        "long" : "24.658705"\n    },\n    {\n        "model_name" : "verna",\n        "vehicle_no" : "TN 45 AK 6520",\n        "lat" : "10.19345",\n        "long" : "25.658705"\n    }\n]'
    });
    request.files.add(
        await http.MultipartFile.fromPath('car_pic1', 'iIWDukDY2/ahmed.png'));
    request.files.add(await http.MultipartFile.fromPath(
        'car_pic2', '2Hi9BlZ7f/karunanidhi.png'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _scrollUp() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.pixels - 150.h,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final customerCards = ref.watch(customerCardProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppTemplate.primaryClr,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Header(txt: 'Create Customer'),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Text(
                'Customer Creation',
                style: GoogleFonts.inter(
                  color: AppTemplate.textClr,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Textfieldwidget(
                controller: customerController,
                labelTxt: 'Customer Name',
                labelTxtClr: Color(0xFF929292),
                enabledBorderClr: Color(0xFFD4D4D4),
                focusedBorderClr: Color(0xFFD4D4D4),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Textfieldwidget(
                controller: mobileController,
                labelTxt: 'Mobile Number',
                labelTxtClr: Color(0xFF929292),
                enabledBorderClr: Color(0xFFD4D4D4),
                focusedBorderClr: Color(0xFFD4D4D4),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Text(
                'Car Listing',
                style: GoogleFonts.inter(
                  color: AppTemplate.textClr,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: customerCards.isEmpty ? 1 : customerCards.length + 1,
                itemBuilder: (context, index) {
                  return CreateCustomerCard(index: index, onRemove: _scrollUp);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 69.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.r),
                      border: Border.all(
                        color: const Color(0xFf1E3763),
                        width: 1.5.w,
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.add,
                        color: const Color(0xFf1E3763),
                        size: 40.w,
                      ),
                      onPressed: () {
                        ref.read(customerCardProvider.notifier).addCard();
                        _scrollToBottom();
                      },
                    ),
                  ),
                  Buttonwidget(
                    width: 227.w,
                    height: 50.h,
                    buttonClr: const Color(0xFf1E3763),
                    txt: 'Create',
                    textClr: AppTemplate.primaryClr,
                    textSz: 18.sp,
                    onClick: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Customer(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
