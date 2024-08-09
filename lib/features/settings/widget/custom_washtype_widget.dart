import 'package:car_wash/common/utils/constants.dart';
import 'package:car_wash/common/widgets/buttonWidget.dart';
import 'package:car_wash/common/widgets/textFieldWidget.dart';
import 'package:car_wash/features/settings/model/price_model.dart';
import 'package:car_wash/provider/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class CustomWashtypeWidget extends ConsumerStatefulWidget {
  final String washType;
  final List<PriceModel> prices;

  const CustomWashtypeWidget({
    Key? key,
    required this.washType,
    required this.prices,
  }) : super(key: key);

  @override
  ConsumerState<CustomWashtypeWidget> createState() =>
      _CustomWashtypeWidgetState();
}

class _CustomWashtypeWidgetState extends ConsumerState<CustomWashtypeWidget> {
  late List<TextEditingController> _priceControllers;
  final Duration _animationDuration = const Duration(milliseconds: 300);
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _initializeControllers() {
    _priceControllers = widget.prices
        .map((price) => TextEditingController(text: "${price.incentive}"))
        .toList();
  }

  void _disposeControllers() {
    for (var controller in _priceControllers) {
      controller.dispose();
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: AppTemplate.bgClr,
      content: Text(
        message,
        style: GoogleFonts.inter(
            color: AppTemplate.primaryClr, fontWeight: FontWeight.w400),
      ),
    ));
  }

  Future<void> updatePrices(
      String priceId, TextEditingController incentives) async {
    final admin = ref.read(authProvider);
    if (incentives.text.isEmpty) {
      _showErrorSnackBar('Incentive cannot be empty');
      return;
    }
    var request = http.MultipartRequest('POST',
        Uri.parse('https://wash.sortbe.com/API/Admin/Settings/Update-Pricing'));
    request.fields.addAll({
      'enc_key': encKey,
      'emp_id': admin.admin!.id,
      'price_data':
          '[\n    {\n        "price_id" : "$priceId",\n        "incentive" : "${incentives.text}"\n    }\n]'
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print("Price updated successfully");
    } else {
      print(response.reasonPhrase);
      _showErrorSnackBar("Failed to update incentives");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: AppTemplate.shadowClr,
              blurRadius: 4.r,
              spreadRadius: 0.r,
              offset: Offset(0.w, 4.h)),
        ],
        border: Border.all(color: AppTemplate.shadowClr),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                widget.washType,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF447B00),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                icon: Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up_outlined
                      : Icons.keyboard_arrow_down_outlined,
                  size: 28,
                ),
              ),
            ],
          ),
          AnimatedSize(
            duration: _animationDuration,
            curve: Curves.easeInOut,
            child: SizedBox(
              height: _isExpanded ? null : 0,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      children: widget.prices.asMap().entries.map((entry) {
                        int index = entry.key;
                        PriceModel price = entry.value;
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.h),
                          child: Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 50,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(left: 5.w, top: 8.h),
                                    child: Text(
                                      price.carType,
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: 50,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10.w),
                                    child: Textfieldwidget(
                                      controller: _priceControllers[index],
                                      labelTxt: "incentives",
                                      labelTxtClr: const Color(0xFF929292),
                                      enabledBorderClr: const Color(0xFFD4D4D4),
                                      focusedBorderClr: const Color(0xFFD4D4D4),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Buttonwidget(
                      width: 227.w,
                      height: 50.h,
                      buttonClr: const Color(0xFf1E3763),
                      txt: 'Update',
                      textClr: AppTemplate.primaryClr,
                      textSz: 18.sp,
                      onClick: () async {
                        try {
                          for (int i = 0; i < widget.prices.length; i++) {
                            final priceId = widget.prices[i].priceId;
                            final controller = _priceControllers[i];
                            if (controller.text.isEmpty) {
                              _showErrorSnackBar('Incentive cannot be empty');
                              return;
                            }
                            await updatePrices(priceId, controller);
                          }
                          setState(() {
                            _isExpanded = false;
                          });
                          _showErrorSnackBar("Incentives updated successfully");
                        } catch (e) {
                          _showErrorSnackBar(e.toString());
                          print('Error updating prices: $e');
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
