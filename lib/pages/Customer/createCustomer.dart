import 'package:car_wash/Widgets/ButtonWidget.dart';
import 'package:car_wash/Widgets/CreateCustomerCard.dart';
import 'package:car_wash/Widgets/TextFieldWidget.dart';
import 'package:car_wash/Widgets/UpwardMenu.dart';
import 'package:car_wash/pages/Customer/customer.dart';
import 'package:car_wash/provider/provider.dart';
import 'package:car_wash/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateCustomer extends ConsumerStatefulWidget {
  const CreateCustomer({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateCustomerState createState() => _CreateCustomerState();
}

class _CreateCustomerState extends ConsumerState<CreateCustomer> {
  final ScrollController _scrollController = ScrollController();

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
            Container(
              height: 100.h,
              width: 360.w,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: const [
                    Color.fromARGB(255, 0, 52, 182),
                    AppTemplate.bgClr,
                    AppTemplate.bgClr,
                    AppTemplate.bgClr,
                    AppTemplate.bgClr,
                  ],
                  focal: Alignment(0.8.w, -0.1.h),
                  radius: 1.5.r,
                  tileMode: TileMode.clamp,
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 35.h,
                  ),
                  Stack(
                    children: [
                      ListTile(
                        leading: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Customer(),
                              ),
                            );
                          },
                          child: const Image(
                            image: AssetImage('assets/images/backward.png'),
                          ),
                        ),
                        title: Text(
                          'Create Customer',
                          style: GoogleFonts.inter(
                            color: AppTemplate.primaryClr,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 5.w,
                        bottom: -2.5.h,
                        child: GestureDetector(
                          onTap: () => Menu.showMenu(context),
                          child: SizedBox(
                            height: 50.h,
                            width: 60.w,
                            child: Padding(
                              padding: EdgeInsets.all(12.w),
                              child: Image(
                                image:
                                    const AssetImage('assets/images/menu1.png'),
                                height: 22.h,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                ],
              ),
            ),
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
              child: const Textfieldwidget(
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
              child: const Textfieldwidget(
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
