// import 'dart:io';

// import 'package:car_wash/provider/provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// @override
// Widget build(BuildContext context, WidgetRef ref) {
//   print('Building CreateCustomerCard widget');
//   final customerCards = ref.watch(customerCardProvider);

//   File? _imageFile;
//   if (index < customerCards.length && customerCards[index].image != null) {
//     _imageFile = customerCards[index].image!;
//   }

//   return Center(
//     child: Column(
//       children: [
//         GestureDetector(
//           onTap: () => _pickImage(context, ref),
//           child: Container(
//             width: 120,
//             height: 80,
//             color: Colors.grey,
//             child: _imageFile != null
//                 ? Image.file(
//                     _imageFile,
//                     fit: BoxFit.cover,
//                   )
//                 : Icon(Icons.camera_alt),
//           ),
//         ),
//         if (_imageFile != null)
//           Text('Image path: ${_imageFile.path}'),
//       ],
//     ),
//   );
// }
