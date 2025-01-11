// import 'package:flutter/material.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// class CustomScannerScreen extends StatelessWidget {
//   final String customText;
//
//   const CustomScannerScreen({Key? key, required this.customText}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Custom Scanner"),
//       ),
//       body: Stack(
//         children: [
//           MobileScanner(
//             onDetect: (BarcodeCapture capture) {
//               for (final barcode in capture.barcodes) {
//                 print('Found barcode: ${barcode.rawValue}');
//               }
//             },
//             onScannerStarted: (arguments) {
//               print('Scanner started');
//             },
//             onScannerError: (error) {
//               print('Scanner error: $error');
//             },
//           ),
//
//           Positioned(
//             bottom: 50,
//             left: 20,
//             right: 20,
//             child: Center(
//               child: Text(
//                 customText,
//                 style: const TextStyle(
//                   fontSize: 18,
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   backgroundColor: Colors.black45,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
