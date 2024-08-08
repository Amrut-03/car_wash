import 'dart:convert';

import 'package:car_wash/common/utils/constants.dart';
import 'package:car_wash/common/widgets/header.dart';
import 'package:car_wash/features/settings/model/price_model.dart';
import 'package:car_wash/features/settings/widget/custom_washtype_widget.dart';
import 'package:car_wash/features/settings/widget/settings_textfield.dart';
import 'package:car_wash/provider/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  Map<String, List<PriceModel>> groupedPrices = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getPrice();
  }

  Future<void> getPrice() async {
    const url = 'https://wash.sortbe.com/API/Admin/Settings/Get-Pricing';

    final admin = ref.watch(authProvider);

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'enc_key': encKey,
          'emp_id': admin.admin!.id,
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        responseData['data'];
        if (mounted) {
          setState(() {});
        }
      } else {
        throw Exception('Failed to load cars');
      }
    } catch (e) {
      print('Error = $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTemplate.primaryClr,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Header(txt: 'Settings'),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Price List',
                    style: GoogleFonts.inter(
                      color: AppTemplate.textClr,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 0.8 * MediaQuery.of(context).size.height,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: CustomWashtypeWidget(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
