import 'dart:convert';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:eventprimeadmin/api/api_helper.dart';
import 'package:eventprimeadmin/app_screen/list_others.dart';
import 'package:eventprimeadmin/app_screen/login_screen.dart';
import 'package:eventprimeadmin/app_screen/user_profile_screen.dart';
// import 'package:eventprimeadmin/app_screen/qr_code_screen.dart';
import 'package:eventprimeadmin/global/SizeConfig.dart';
import 'package:eventprimeadmin/global/response_main_model.dart';
import 'package:eventprimeadmin/global/utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final focus = FocusNode();
TextEditingController mobileNoController = new TextEditingController();
TextEditingController passwordController = new TextEditingController();


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  bool _passwordVisible = false;
  ApiHelper apiHelper = ApiHelper();


  List<String> listGiftName = [];
  List<String> listFreeGiftIDP = [];
  String selectedGiftOption = "";
  String selectedGiftOptionIDP = "";
  String UserIDP = "";
  String UserType = "";

  List<String> listCouponName = [];
  List<String> listEventCouponIDP = [];
  String selectedCouponName = "";
  String selectedCouponIDP = "";
  String CouponIDP = "";
  String CouponType = "";

  List<String> listHallScanName = [];
  List<String> listHallScanIDP = [];
  String selectedHallScanName = "";
  String selectedHallScanIDP = "";
  // String CouponIDP = "";
  // String CouponType = "";


  List<String> listHallScanNameDetails = [];
  List<String> listHallScanIDPDetails = [];

  String selectedHallScanNameDetails = "";
  String selectedHallScanIDPDetails = "";


  String _selectedOption = "";
  String _selectedOptionmain = "";
  bool _isLoading = false; // To manage the loading state

  String scanResult = "No data scanned yet.";
  String type = "";


  @override
  void initState() {
    mobileNoController = new TextEditingController();
    passwordController = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    //   mobileNoController.text = '8000083323';
    return Scaffold(
      appBar: AppBar(
        title: const Text("Eventprime Admin",style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold, // Apply bold style
        ),

        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Stack(
        children: [
          _isLoading
          ? Container(
            color: Colors.white,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
          : Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
                children: [
                  // InkWell(
                  //   onTap: (){
                  //   },
                  //   child: Container(
                  //     height:  MediaQuery.of(context).size.height * 0.04,
                  //     width: MediaQuery.of(context).size.width * 0.90,
                  //     color: Colors.grey[400],
                  //     child: Center(
                  //       child: const Text("Redeem Coupon",
                  //         style: TextStyle(
                  //           color: Colors.black,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.90,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isLoading = true;
                        });
                        getEventRedeemCoupon();
                        _showLoaderAndDialogRedeemCoupon();
                      },
                      child: const Text("Redeem Coupon",
                        style: TextStyle(
                        color: Colors.black,
                      ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.05,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.90,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isLoading = true;
                        });
                        getEventScanUser();
                        _showLoaderAndDialog();
                      },
                      child: const Text("Scan User",
                        style: TextStyle(
                          color: Colors.black,
                        ),),
                    ),

                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.05,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.90,
                    child: ElevatedButton(
                      onPressed: () {
                      },
                      child: const Text("Find User",
                        style: TextStyle(
                          color: Colors.black,
                        ),),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.05,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.90,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isLoading = true;
                        });
                        getHallScan();
                        _showLoaderAndDialogHallScan();
                      },
                      child: const Text("Hall Scan",
                        style: TextStyle(
                          color: Colors.black,
                        ),),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.05,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.90,
                    child: ElevatedButton(
                      onPressed: () {
                      },
                      child: const Text("Scan Report",
                        style: TextStyle(
                          color: Colors.black,
                        ),),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.05,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.90,
                    child: ElevatedButton(
                      onPressed: () {
                        showConfirmationDialogLogout(context);
                      },
                      child: const Text("Log-out",
                        style: TextStyle(
                          color: Colors.black,
                        ),),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.05,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }



  Future<void> _showLoaderAndDialog() async {
    // Show loader for 3 seconds
    await Future.delayed(const Duration(seconds: 2));

    // Stop showing the loader
    setState(() {
      _isLoading = false;
    });

    // Show dialog after the delay
    _showCustomDialogScanUser(context);
  }

  void _showCustomDialogScanUser(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Green header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: const Text(
                  "Choose Gift Coupon Type",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Dialog content with dynamic radio buttons
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: listGiftName.asMap().entries.map((entry) {
                    var index = entry.key;
                    var option = entry.value;

                    return RadioListTile<String>(
                      title: Text(option),
                      value: option,
                      groupValue: _selectedOption,
                      onChanged: (value) {
                        setState(() {
                          // Set selected option
                          selectedGiftOption = value ?? "";

                          // Get corresponding FreeGiftIDP
                          selectedGiftOptionIDP = listFreeGiftIDP[index];
                          debugPrint("Selected Gift: $selectedGiftOption");
                          debugPrint("Selected FreeGiftIDP: $selectedGiftOptionIDP");
                        });
                        Navigator.of(context).pop();
                        _showCustomDialogForGiftReceiver(context);
                      },
                    );
                  }).toList(),
                ),
              ),

              // // Dialog content with dynamic radio buttons
              // Padding(
              //   padding: const EdgeInsets.all(16),
              //   child: Column(
              //     children: listGiftName.map((option) => RadioListTile<String>(
              //       title: Text(option),
              //       value: option,
              //       groupValue: _selectedOption,
              //       onChanged: (value) {
              //         setState(() {
              //           selectedGiftOption = value ?? "";
              //           print("12344444---${selectedGiftOption}");
              //
              //           selectedGiftOptionIDP = "";
              //         });
              //         Navigator.of(context).pop();
              //         _showCustomDialogForGiftReceiver(context);
              //       },
              //     ))
              //         .toList(),
              //   ),
              // ),

              // Cancel button
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCustomDialogForGiftReceiver(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Green header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: const Text(
                  "Gift Receiver",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Dialog content with radio buttons
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    RadioListTile<String>(
                      title: const Text("Self"),
                      value: "Option 1",
                      groupValue: _selectedOption,
                      onChanged: (value) async {
                        debugPrint("12222------");

                        String Status =  await getStatus();
                        print("11222-----${Status}");
                          // openScanner(context, "$selectedGiftOption");

                          try {
                            debugPrint("Selected12344: ");
                            var result = await BarcodeScanner.scan();
                            setState(() {
                              scanResult = result.rawContent.isEmpty
                                  ? "No data found"
                                  : result.rawContent;
                              debugPrint("Selected Gift: $scanResult");
                              String decodedContent = decodeBase64(
                                  result.rawContent);
                              // user-484
                              // UserIDP =
                              //     decodedContent.replaceAll("user-", "");

                              // Split the string at the '-'
                              List<String> parts = decodedContent.split('-');

                              // Store the parts into separate variables
                              UserType = "direct"; // "user"
                              UserIDP = parts[1]; // "484"

                              print('Before dash: $UserType');
                              print('After dash: $UserIDP');
                            });
                          } catch (e) {
                            setState(() {
                              scanResult = "Error: $e";
                            });
                          }
                        if(Status == "0")  {
                          submitEventScan();
                        }else{
                          Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      UserProfileScreen(
                                        UserIDP: UserIDP,
                                        UserType: UserType,
                                        type: "ScanUser",
                                        activityIDP: selectedGiftOptionIDP,
                                        activityName: selectedGiftOption,
                                      )));
                        }



                        Navigator.of(context).pop();


                        // Scanner logic
                        // var result = await BarcodeScanner.scan();
                        // if (result.type.toString() != "Cancelled" &&
                        //     result.rawContent != "") {
                        //   String decodedContent = decodeBase64(result.rawContent);
                        // patientIDPSelected =
                        //     decodedContent.replaceAll("patient-", "");
                        // patientDetailsSelected = listFullNameDetails[
                        // listPatientIDP.indexOf(patientIDPSelected)];
                        // }
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text("Other"),
                      value: "Option 2",
                      groupValue: _selectedOption,
                      onChanged: (value) {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    OthersList(
                                        selectedGiftOptionIDP: selectedGiftOptionIDP,
                                        selectedGiftOption: selectedGiftOption,
                                        type: "ScanUser"
                                    )));
                        // Perform other action
                      },
                    ),
                  ],
                ),
              ),

              // Cancel button
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  Future<void> _showLoaderAndDialogRedeemCoupon() async {
    // Show loader for 3 seconds
    await Future.delayed(const Duration(seconds: 2));

    // Stop showing the loader
    setState(() {
      _isLoading = false;
    });

    // Show dialog after the delay
    _showCustomDialogRedeemCoupon(context);
  }

  void _showCustomDialogRedeemCoupon(BuildContext parentContext) {
    showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Green header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: const Text(
                  "Choose Coupon Type",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Dialog content with dynamic radio buttons
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: listCouponName.asMap().entries.map((entry) {
                    var index = entry.key;
                    var option = entry.value;

                    return RadioListTile<String>(
                      title: Text(option),
                      value: option,
                      groupValue: _selectedOption,
                      onChanged: (value) async {
                        setState(() {
                          selectedCouponName = value ?? "";
                          selectedCouponIDP = listEventCouponIDP[index];
                          debugPrint("Selected Gift: $selectedCouponName");
                          debugPrint("Selected FreeGiftIDP: $selectedCouponIDP");
                        });

                        Navigator.of(context).pop(); // Close the dialog

                        String status = await getStatus();

                        try {
                          var result = await BarcodeScanner.scan();
                          setState(() {
                            scanResult = result.rawContent.isEmpty
                                ? "No data found"
                                : result.rawContent;
                            debugPrint("Selected Redeem: $scanResult");
                            String decodedContent =
                            decodeBase64(result.rawContent);

                            List<String> parts = decodedContent.split('-');
                            CouponType = parts[0];
                            CouponIDP = parts[1];

                            debugPrint('Before dash: $CouponType');
                            debugPrint('After dash: $CouponIDP');

                            newScreen(CouponIDP);

                            if (status == "0") {
                              submitEventRedeemCoupon();
                            } else {
                              print("121212----${CouponIDP}");

                              if (CouponIDP != null && CouponIDP.isNotEmpty) {
                                print("1111111111----${CouponIDP}");
                                Navigator.of(parentContext).push(
                                  MaterialPageRoute(
                                    builder: (context) => UserProfileScreen(
                                      UserIDP: CouponIDP,
                                      UserType: CouponType,
                                      type: "RedeemCoupon",
                                      activityIDP: selectedCouponIDP,
                                      activityName: selectedCouponName,),
                                  ),
                                );
                              } else {
                                debugPrint("Error: CouponIDP is null or empty");
                                // Show an error dialog or toast message
                              }
                            }
                          });
                        } catch (e) {
                          setState(() {
                            scanResult = "Error: $e";


                          });
                        }


                      },
                    );
                  }).toList(),
                ),
              ),

              // Cancel button
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void newScreen (String IDP){

  }


  Future<void> _showLoaderAndDialogHallScan() async {
    // Show loader for 3 seconds
    await Future.delayed(const Duration(seconds: 2));

    // Stop showing the loader
    setState(() {
      _isLoading = false;
    });

    // Show dialog after the delay
    _showCustomDialogHallScan(context);
  }

  void _showCustomDialogHallScan(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Green header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: const Text(
                  "Choose Hall",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Scrollable dialog content with dynamic radio buttons
              Flexible(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: listHallScanName.asMap().entries.map((entry) {
                        var index = entry.key;
                        var option = entry.value;

                        return RadioListTile<String>(
                          title: Text(option),
                          value: option,
                          groupValue: _selectedOption,
                          onChanged: (value) {
                            setState(() {

                              // Set selected option
                              selectedHallScanName = value ?? "";

                              // Get corresponding FreeGiftIDP
                              selectedHallScanIDP = listHallScanIDP[index];
                              debugPrint("Selected Gift: $selectedHallScanName");
                              debugPrint("Selected FreeGiftIDP: $selectedHallScanIDP");
                            });
                            Navigator.of(context).pop();
                            _showLoaderAndDialogForHallScan();
                            getHallScanDetails(selectedHallScanIDP);
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),

              // Cancel button
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showLoaderAndDialogForHallScan() async {
    // Show loader for 3 seconds
    await Future.delayed(const Duration(seconds: 1,milliseconds: 50));

    // Stop showing the loader
    setState(() {
      _isLoading = false;
    });

    // Show dialog after the delay
    _showCustomDialogForhallScan(context);
  }

  void _showCustomDialogForhallScan(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Green header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Text(
                  "$selectedHallScanName",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Dialog content with dynamic radio buttons
              Flexible(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: listHallScanNameDetails.asMap().entries.map((entry) {
                        var index = entry.key;
                        var option = entry.value;

                        return RadioListTile<String>(
                          title: Text(option),
                          value: option,
                          groupValue: _selectedOption,
                          onChanged: (value) async{
                            setState(() {
                              // Set selected option
                              selectedHallScanNameDetails = value ?? "";

                              // Get corresponding FreeGiftIDP
                              selectedHallScanIDPDetails = listHallScanIDPDetails[index];
                              debugPrint("Selected Gift: $selectedHallScanNameDetails");
                              debugPrint("Selected FreeGiftIDP: $selectedHallScanIDPDetails");
                            });
                            Navigator.of(context).pop();
                            // _showCustomDialogForhallScan(context);

                            debugPrint("12222------");

                            String Status =  await getStatus();
                            print("11222-----${Status}");
                              // openScanner(context, "$selectedGiftOption");

                              try {
                                debugPrint("Selected12344: ");
                                var result = await BarcodeScanner.scan();
                                setState(() {
                                  scanResult = result.rawContent.isEmpty
                                      ? "No data found"
                                      : result.rawContent;
                                  debugPrint("Selected Gift: $scanResult");
                                  String decodedContent = decodeBase64(
                                      result.rawContent);
                                  // user-484
                                  // UserIDP =
                                  //     decodedContent.replaceAll("user-", "");

                                  // Split the string at the '-'
                                  List<String> parts = decodedContent.split('-');

                                  // Store the parts into separate variables
                                  UserType = parts[0]; // "user"
                                  UserIDP = parts[1]; // "484"

                                  print('Before dash: $UserType');
                                  print('After dash: $UserIDP');

                                  if(Status == "0")  {
                                    submitHallScan();
                                  }else{
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                UserProfileScreen(
                                                    UserIDP: UserIDP,
                                                    UserType: UserType,
                                                    type: "HallScan",
                                                    activityIDP: selectedHallScanIDPDetails,
                                                    activityName: selectedHallScanNameDetails
                                                )));
                                  }
                                });
                              } catch (e) {
                                setState(() {
                                  scanResult = "Error: $e";
                                });
                              }


                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),

              // // Dialog content with dynamic radio buttons
              // Padding(
              //   padding: const EdgeInsets.all(16),
              //   child: Column(
              //     children: listGiftName.map((option) => RadioListTile<String>(
              //       title: Text(option),
              //       value: option,
              //       groupValue: _selectedOption,
              //       onChanged: (value) {
              //         setState(() {
              //           selectedGiftOption = value ?? "";
              //           print("12344444---${selectedGiftOption}");
              //
              //           selectedGiftOptionIDP = "";
              //         });
              //         Navigator.of(context).pop();
              //         _showCustomDialogForGiftReceiver(context);
              //       },
              //     ))
              //         .toList(),
              //   ),
              // ),

              // Cancel button
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // void _showCustomDialogForhallScan(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(10),
  //         ),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             // Green header
  //             Container(
  //               width: double.infinity,
  //               padding: const EdgeInsets.all(16),
  //               decoration: const BoxDecoration(
  //                 color: Colors.green,
  //                 borderRadius: BorderRadius.only(
  //                   topLeft: Radius.circular(10),
  //                   topRight: Radius.circular(10),
  //                 ),
  //               ),
  //               child: const Text(
  //                 "Gift Receiver",
  //                 style: TextStyle(
  //                   color: Colors.white,
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //                 textAlign: TextAlign.center,
  //               ),
  //             ),
  //
  //             // Dialog content with radio buttons
  //             Padding(
  //               padding: const EdgeInsets.all(16),
  //               child: Column(
  //                 children: [
  //                   RadioListTile<String>(
  //                     title: const Text("Self"),
  //                     value: "Option 1",
  //                     groupValue: _selectedOption,
  //                     onChanged: (value) async {
  //                       debugPrint("12222------");
  //
  //                       // openScanner(context, "$selectedGiftOption");
  //
  //                       try {
  //                         debugPrint("Selected12344: ");
  //                         var result = await BarcodeScanner.scan();
  //                         setState(() {
  //                           scanResult = result.rawContent.isEmpty ? "No data found" : result.rawContent;
  //                           debugPrint("Selected Gift: $scanResult");
  //                           String decodedContent = decodeBase64(result.rawContent);
  //                           // user-484
  //                           // UserIDP =
  //                           //     decodedContent.replaceAll("user-", "");
  //
  //                           // Split the string at the '-'
  //                           List<String> parts = decodedContent.split('-');
  //
  //                           // Store the parts into separate variables
  //                           CouponType = parts[0]; // "user"
  //                           CouponIDP = parts[1];  // "484"
  //
  //                           print('Before dash: $CouponType');
  //                           print('After dash: $CouponIDP');
  //
  //                         });
  //                       } catch (e) {
  //                         setState(() {
  //                           scanResult = "Error: $e";
  //                         });
  //                       }
  //                       submitEventScan();
  //
  //                       Navigator.of(context).pop();
  //
  //
  //                       // Scanner logic
  //                       // var result = await BarcodeScanner.scan();
  //                       // if (result.type.toString() != "Cancelled" &&
  //                       //     result.rawContent != "") {
  //                       //   String decodedContent = decodeBase64(result.rawContent);
  //                       // patientIDPSelected =
  //                       //     decodedContent.replaceAll("patient-", "");
  //                       // patientDetailsSelected = listFullNameDetails[
  //                       // listPatientIDP.indexOf(patientIDPSelected)];
  //                       // }
  //                     },
  //                   ),
  //                   RadioListTile<String>(
  //                     title: const Text("Other"),
  //                     value: "Option 2",
  //                     groupValue: _selectedOption,
  //                     onChanged: (value) {
  //                       Navigator.of(context).pop();
  //                       Navigator.of(context).push(
  //                           MaterialPageRoute(
  //                               builder: (context) =>
  //                                   OthersList(
  //                                       selectedGiftOptionIDP: selectedGiftOptionIDP,
  //                                       selectedGiftOption: selectedGiftOption,
  //                                       type: "RedeemCoupon"
  //                                   )));
  //                       // Perform other action
  //                     },
  //                   ),
  //                 ],
  //               ),
  //             ),
  //
  //             // Cancel button
  //             Align(
  //               alignment: Alignment.centerRight,
  //               child: TextButton(
  //                 onPressed: () {
  //                   Navigator.of(context).pop(); // Close the dialog
  //                 },
  //                 child: const Text(
  //                   "Cancel",
  //                   style: TextStyle(color: Colors.green),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  // Future<void> openScanner(BuildContext context, String customText) async {
  //   debugPrint("112222---");
  //   final result = await Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => CustomScannerScreen(customText: customText),
  //     ),
  //   );
  //
  //   if (result != null) {
  //     debugPrint("11111---");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Scanned: $result")),
  //     );
  //   }
  // }

  showConfirmationDialogLogout(BuildContext context) {
    var title = "Do you really want to Logout?";
    showDialog(
        context: context,
        barrierDismissible: false,
        // user must tap button for close dialog!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("No")),
              TextButton(
                  onPressed: () {
                    logOut(context);
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginScreen()));
                  },
                  child: const Text("Yes"))
            ],
          );
        });
  }

  logOut(BuildContext context) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.clear();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (mContext) => LoginScreen()),
    );
    Navigator.pop(context);
  }

  String encodeBase64(String text) {
    var bytes = utf8.encode(text);
    return base64.encode(bytes);
  }

  String decodeBase64(String text) {
    var bytes = base64.decode(text);
    return String.fromCharCodes(bytes);
  }
  void getEventScanUser() async {

    listFreeGiftIDP.clear();
    listGiftName.clear();

    final String loginUrl = "${baseURL}gift_type.php";
    String patientUniqueKey = await getPatientUniqueKey();
    String userType = await getUserType();
    String eventIDP = await getEventIDP();
    String userPassword = await getPassword();

    print("123333333 ----${eventIDP}");
    print("1111-------${userType}");
    print("123333333 ----${userPassword}");
    print("1111-------${patientUniqueKey}");
    debugPrint("Key and type");
    debugPrint(patientUniqueKey);
    debugPrint(userType);
    String jsonStr =
        "{" + "\"" + "EventIDP" + "\"" + ":" + "\"" + eventIDP + "\"" + "}";

    debugPrint(jsonStr);

    String encodedJSONStr = encodeBase64(jsonStr);
    var response = await apiHelper.callApiWithHeadersAndBody(
      url: loginUrl,
      //Uri.parse(loginUrl),
      headers: {
        "u": patientUniqueKey,
        "p": userPassword,
        "type": userType,
      },
      body: {"getjson": encodedJSONStr},
    );
    //var resBody = json.decode(response.body);
    debugPrint(response.body.toString());
    final jsonResponse = json.decode(response.body.toString());
    ResponseModel model = ResponseModel.fromJSON(jsonResponse);
    /*pr.hide();*/
    if (model.status == "OK") {
      var data = jsonResponse['Data'];
      var strData = decodeBase64(data);
      debugPrint("Decoded Data Array : " + strData);
      final jsonData = json.decode(strData);

      for (var i = 0; i < jsonData.length; i++)
      {
        final jo = jsonData[i];
        String freeGiftIDP = jo['FreeGiftIDP'].toString();
        listFreeGiftIDP.add(freeGiftIDP);
        debugPrint("Added to list: $listFreeGiftIDP");

        String GiftDetails = jo['GiftDetails'].toString();
        listGiftName.add(GiftDetails);
        debugPrint("Added to list: $listGiftName");
      }


    } else {
      final snackBar = SnackBar(
        backgroundColor: Colors.red,
        content: Text(model.message!),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void getEventRedeemCoupon() async {

    listEventCouponIDP.clear();
    listCouponName.clear();

    final String loginUrl = "${baseURL}coupon_type.php";
    String patientUniqueKey = await getPatientUniqueKey();
    String userType = await getUserType();
    String eventIDP = await getEventIDP();
    String userPassword = await getPassword();

    print("123333333 ----${eventIDP}");
    print("1111-------${userType}");
    print("123333333 ----${userPassword}");
    print("1111-------${patientUniqueKey}");
    debugPrint("Key and type");
    debugPrint(patientUniqueKey);
    debugPrint(userType);
    String jsonStr =
        "{" + "\"" + "EventIDP" + "\"" + ":" + "\"" + eventIDP + "\"" + "}";

    debugPrint(jsonStr);

    String encodedJSONStr = encodeBase64(jsonStr);
    var response = await apiHelper.callApiWithHeadersAndBody(
      url: loginUrl,
      //Uri.parse(loginUrl),
      headers: {
        "u": patientUniqueKey,
        "p": userPassword,
        "type": userType,
      },
      body: {"getjson": encodedJSONStr},
    );
    //var resBody = json.decode(response.body);
    debugPrint(response.body.toString());
    final jsonResponse = json.decode(response.body.toString());
    ResponseModel model = ResponseModel.fromJSON(jsonResponse);
    /*pr.hide();*/
    if (model.status == "OK") {
      var data = jsonResponse['Data'];
      var strData = decodeBase64(data);
      debugPrint("Decoded Data Array : " + strData);
      final jsonData = json.decode(strData);

      for (var i = 0; i < jsonData.length; i++)
      {
        final jo = jsonData[i];
        String freeGiftIDP = jo['EventCouponIDP'].toString();
        listEventCouponIDP.add(freeGiftIDP);
        debugPrint("Added to list: $listEventCouponIDP");

        String GiftDetails = jo['CouponType'].toString();
        listCouponName.add(GiftDetails);
        debugPrint("Added to list: $listCouponName");
      }


    } else {
      final snackBar = SnackBar(
        backgroundColor: Colors.red,
        content: Text(model.message!),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void getHallScan() async {

    listHallScanIDP.clear();
    listHallScanName.clear();

    final String loginUrl = "${baseURL}event_hall.php";
    String patientUniqueKey = await getPatientUniqueKey();
    String userType = await getUserType();
    String eventIDP = await getEventIDP();
    String userPassword = await getPassword();

    print("123333333 ----${eventIDP}");
    print("1111-------${userType}");
    print("123333333 ----${userPassword}");
    print("1111-------${patientUniqueKey}");
    debugPrint("Key and type");
    debugPrint(patientUniqueKey);
    debugPrint(userType);
    String jsonStr =
        "{" + "\"" + "EventIDP" + "\"" + ":" + "\"" + eventIDP + "\"" + "}";

    debugPrint(jsonStr);

    String encodedJSONStr = encodeBase64(jsonStr);
    var response = await apiHelper.callApiWithHeadersAndBody(
      url: loginUrl,
      //Uri.parse(loginUrl),
      headers: {
        "u": patientUniqueKey,
        "p": userPassword,
        "type": userType,
      },
      body: {"getjson": encodedJSONStr},
    );
    //var resBody = json.decode(response.body);
    debugPrint(response.body.toString());
    final jsonResponse = json.decode(response.body.toString());
    ResponseModel model = ResponseModel.fromJSON(jsonResponse);
    /*pr.hide();*/
    if (model.status == "OK") {
      var data = jsonResponse['Data'];
      var strData = decodeBase64(data);
      debugPrint("Decoded Data Array : " + strData);
      final jsonData = json.decode(strData);

      for (var i = 0; i < jsonData.length; i++)
      {
        final jo = jsonData[i];
        String freeGiftIDP = jo['HallIDP'].toString();
        listHallScanIDP.add(freeGiftIDP);
        debugPrint("Added to list: $listHallScanIDP");

        String GiftDetails = jo['HallName'].toString();
        listHallScanName.add(GiftDetails);
        debugPrint("Added to list: $listHallScanName");
      }


    } else {
      final snackBar = SnackBar(
        backgroundColor: Colors.red,
        content: Text(model.message!),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void getHallScanDetails(String HallIDP) async {

    listHallScanIDPDetails.clear();
    listHallScanNameDetails.clear();

    final String loginUrl = "${baseURL}hall_activity_type.php";
    String patientUniqueKey = await getPatientUniqueKey();
    String userType = await getUserType();
    String eventIDP = await getEventIDP();
    String userPassword = await getPassword();

    print("123333333 ----${eventIDP}");
    print("1111-------${userType}");
    print("123333333 ----${userPassword}");
    print("1111-------${patientUniqueKey}");
    debugPrint("Key and type");
    debugPrint(patientUniqueKey);
    debugPrint(userType);
    String jsonStr =
        "{" + "\"" + "EventIDP" + "\"" + ":" + "\"" + eventIDP + "\"" +
            "," + "\"" + "HallIDP" + "\"" + ":" + "\"" + HallIDP + "\"" +
            "}";

    debugPrint(jsonStr);

    String encodedJSONStr = encodeBase64(jsonStr);
    var response = await apiHelper.callApiWithHeadersAndBody(
      url: loginUrl,
      //Uri.parse(loginUrl),
      headers: {
        "u": patientUniqueKey,
        "p": userPassword,
        "type": userType,
      },
      body: {"getjson": encodedJSONStr},
    );
    //var resBody = json.decode(response.body);
    debugPrint(response.body.toString());
    final jsonResponse = json.decode(response.body.toString());
    ResponseModel model = ResponseModel.fromJSON(jsonResponse);
    /*pr.hide();*/
    if (model.status == "OK") {
      var data = jsonResponse['Data'];
      var strData = decodeBase64(data);
      debugPrint("Decoded Data Array : " + strData);
      final jsonData = json.decode(strData);

      for (var i = 0; i < jsonData.length; i++)
      {
        final jo = jsonData[i];
        String freeGiftIDP = jo['HallActivityIDP'].toString();
        listHallScanIDPDetails.add(freeGiftIDP);
        debugPrint("Added to list: $listHallScanIDPDetails");

        String GiftDetails = jo['ActivityName'].toString();
        listHallScanNameDetails.add(GiftDetails);
        debugPrint("Added to list: $listHallScanNameDetails");
      }


    } else {
      final snackBar = SnackBar(
        backgroundColor: Colors.red,
        content: Text(model.message!),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }


  void submitEventScan() async {

    final String loginUrl = "${baseURL}add_gift.php";
    String patientUniqueKey = await getPatientUniqueKey();
    String userType = await getUserType();
    String eventIDP = await getEventIDP();
    String userPassword = await getPassword();

    print("123333333 ----${eventIDP}");
    print("1111-------${userType}");
    print("123333333 ----${userPassword}");
    print("1111-------${patientUniqueKey}");
    debugPrint("Key and type");
    debugPrint(patientUniqueKey);
    debugPrint(userType);
    String jsonStr =
        "{" + "\"" + "EventIDP" + "\"" + ":" + "\"" + eventIDP + "\""
            ","+ "\"" + "FreeGiftIDP" + "\"" + ":" + "\"" + selectedGiftOptionIDP + "\""
            ","+ "\"" + "GiftName" + "\"" + ":" + "\"" + selectedGiftOption + "\""
            ","+ "\"" + "UserType" + "\"" + ":" + "\"" + UserType + "\""
            ","+ "\"" + "UserIDP" + "\"" + ":" + "\"" + UserIDP + "\""
            ","+ "\"" + "CollectionUserIDP" + "\"" + ":" + "\"" + "" + "\""
            + "}";

    debugPrint(jsonStr);

    String encodedJSONStr = encodeBase64(jsonStr);
    var response = await apiHelper.callApiWithHeadersAndBody(
      url: loginUrl,
      //Uri.parse(loginUrl),
      headers: {
        "u": patientUniqueKey,
        "p": userPassword,
        "type": userType,
      },
      body: {"getjson": encodedJSONStr},
    );
    //var resBody = json.decode(response.body);
    debugPrint(response.body.toString());
    final jsonResponse = json.decode(response.body.toString());
    ResponseModel model = ResponseModel.fromJSON(jsonResponse);
    /*pr.hide();*/
    if (model.status == "OK") {
      // Show success dialog with two options
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
              child: Text(
                model.message ?? "Something went wrong.",
                style: const TextStyle(fontSize: 24),
              ),
            ),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Divider(thickness: 1, color: Colors.grey),
              ],
            ),
            // content: Text(model.message ?? "Gift added successfully!"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Center(
                    child: Text("Cancel",style: TextStyle(color: Colors.black))
                ),
              ),
            ],
          );
        },
      );
    }
    else {
      // Show failure dialog with one option

      if(model.message == "Scan already submitted"){
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              // title: Text(model.message!),
              title: Text(
                model.message ?? "Something went wrong.",
                style: const TextStyle(fontSize: 24),
              ),
              content: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Divider(thickness: 1, color: Colors.grey),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () async{
                    Navigator.of(context).pop();
                  },
                  child: const Center(
                      child: Text("Cancel",style: TextStyle(color: Colors.red),
                      )),
                ),              ],
            );
          },
        );
      }else{
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              // title: Text(model.message!),
              title: Text(
                model.message ?? "Something went wrong.",
                style: const TextStyle(fontSize: 24),
              ),
              content: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Divider(thickness: 1, color: Colors.grey),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () async{
                    debugPrint("12222------");

                    String Status =  await getStatus();
                    print("11222-----${Status}");
                    // openScanner(context, "$selectedGiftOption");

                    try {
                      debugPrint("Selected12344: ");
                      var result = await BarcodeScanner.scan();
                      setState(() {
                        scanResult = result.rawContent.isEmpty
                            ? "No data found"
                            : result.rawContent;
                        debugPrint("Selected Gift: $scanResult");
                        String decodedContent = decodeBase64(
                            result.rawContent);
                        // user-484
                        // UserIDP =
                        //     decodedContent.replaceAll("user-", "");

                        // Split the string at the '-'
                        List<String> parts = decodedContent.split('-');

                        // Store the parts into separate variables
                        UserType = parts[0]; // "user"
                        UserIDP = parts[1]; // "484"

                        print('Before dash: $UserType');
                        print('After dash: $UserIDP');

                        submitEventScan();
                      });
                    } catch (e) {
                      setState(() {
                        scanResult = "Error: $e";
                      });
                    }


                    Navigator.of(context).pop();

                  },
                  child: const Center(
                      child: Text("Retry",style: TextStyle(color: Colors.red),
                      )),
                ),
              ],
            );
          },
        );
      }

    }
  }

  void submitEventRedeemCoupon() async {

    print("submitEventRedeemCoupon");

    final String loginUrl = "${baseURL}add_coupon.php";
    String patientUniqueKey = await getPatientUniqueKey();
    String userType = await getUserType();
    String eventIDP = await getEventIDP();
    String userPassword = await getPassword();

    print("123333333 ----${eventIDP}");
    print("1111-------${userType}");
    print("123333333 ----${userPassword}");
    print("1111-------${patientUniqueKey}");
    debugPrint("Key and type");
    debugPrint(patientUniqueKey);
    debugPrint(userType);
    String jsonStr =
        "{" + "\"" + "EventIDP" + "\"" + ":" + "\"" + eventIDP + "\""
            ","+ "\"" + "EventCouponIDP" + "\"" + ":" + "\"" + selectedCouponIDP + "\""
            ","+ "\"" + "CouponName" + "\"" + ":" + "\"" + selectedCouponName + "\""
            ","+ "\"" + "CouponType" + "\"" + ":" + "\"" + CouponType + "\""
            ","+ "\"" + "UserIDP" + "\"" + ":" + "\"" + CouponIDP + "\""
            ","+ "\"" + "sequence" + "\"" + ":" + "\"" + "" + "\""
            ","+ "\"" + "CouponUsageIDP" + "\"" + ":" + "\"" + "" + "\""
            + "}";

    debugPrint(jsonStr);

    String encodedJSONStr = encodeBase64(jsonStr);
    var response = await apiHelper.callApiWithHeadersAndBody(
      url: loginUrl,
      //Uri.parse(loginUrl),
      headers: {
        "u": patientUniqueKey,
        "p": userPassword,
        "type": userType,
      },
      body: {"getjson": encodedJSONStr},
    );
    //var resBody = json.decode(response.body);
    debugPrint(response.body.toString());
    final jsonResponse = json.decode(response.body.toString());
    ResponseModel model = ResponseModel.fromJSON(jsonResponse);
    /*pr.hide();*/
    if (model.status == "OK") {
      // Show success dialog with two options
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
              child: Text(
                model.message ?? "Something went wrong.",
                style: const TextStyle(fontSize: 24),
              ),
            ),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Divider(thickness: 1, color: Colors.grey),
              ],
            ),
            // content: Text(model.message ?? "Gift added successfully!"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Center(
                    child: Text("Cancel",style: TextStyle(color: Colors.black))
                ),
              ),
            ],
          );
        },
      );
    }
    else {
      // Show failure dialog with one option

      if(model.message == "Scan already submitted"){
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              // title: Text(model.message!),
              title: Text(
                model.message ?? "Something went wrong.",
                style: const TextStyle(fontSize: 24),
              ),
              content: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Divider(thickness: 1, color: Colors.grey),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () async{
                    Navigator.of(context).pop();
                  },
                  child: const Center(
                      child: Text("Cancel",style: TextStyle(color: Colors.red),
                      )),
                ),
              ],
            );
          },
        );
      }
      else{
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              // title: Text(model.message!),
              title: Text(
                model.message ?? "Something went wrong.",
                style: const TextStyle(fontSize: 24),
              ),
              content: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Divider(thickness: 1, color: Colors.grey),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () async{
                    debugPrint("12222------");


                    String status = await getStatus();

                    try {
                      var result = await BarcodeScanner.scan();
                      setState(() {
                        scanResult = result.rawContent.isEmpty
                            ? "No data found"
                            : result.rawContent;
                        debugPrint("Selected Redeem: $scanResult");
                        String decodedContent =
                        decodeBase64(result.rawContent);

                        List<String> parts = decodedContent.split('-');
                        CouponType = parts[0];
                        CouponIDP = parts[1];

                        debugPrint('Before dash: $CouponType');
                        debugPrint('After dash: $CouponIDP');

                        submitEventRedeemCoupon();

                      });
                    } catch (e) {
                      setState(() {
                        scanResult = "Error: $e";


                      });
                    }
                    Navigator.of(context).pop();

                  },
                  child: const Center(
                      child: Text("Retry",style: TextStyle(color: Colors.red),
                      )),
                ),

              ],
            );
          },
        );
      }

    }
  }

  void submitHallScan() async {

    print("submitHallScan");

    final String loginUrl = "${baseURL}add_hall_scan.php";
    String patientUniqueKey = await getPatientUniqueKey();
    String userType = await getUserType();
    String eventIDP = await getEventIDP();
    String userPassword = await getPassword();

    print("123333333 ----${eventIDP}");
    print("1111-------${userType}");
    print("123333333 ----${userPassword}");
    print("1111-------${patientUniqueKey}");
    debugPrint("Key and type");
    debugPrint(patientUniqueKey);
    debugPrint(userType);
    String jsonStr =
        "{" + "\"" + "EventIDP" + "\"" + ":" + "\"" + eventIDP + "\""
            ","+ "\"" + "HallActivityIDP" + "\"" + ":" + "\"" + selectedHallScanIDPDetails + "\""
            ","+ "\"" + "HallIDP" + "\"" + ":" + "\"" + selectedHallScanIDP + "\""
            ","+ "\"" + "UserIDP" + "\"" + ":" + "\"" + UserIDP + "\""
            + "}";

    debugPrint(jsonStr);

    String encodedJSONStr = encodeBase64(jsonStr);
    var response = await apiHelper.callApiWithHeadersAndBody(
      url: loginUrl,
      //Uri.parse(loginUrl),
      headers: {
        "u": patientUniqueKey,
        "p": userPassword,
        "type": userType,
      },
      body: {"getjson": encodedJSONStr},
    );
    //var resBody = json.decode(response.body);
    debugPrint(response.body.toString());
    final jsonResponse = json.decode(response.body.toString());
    ResponseModel model = ResponseModel.fromJSON(jsonResponse);
    /*pr.hide();*/
    if (model.status == "OK") {
      // Show success dialog with two options
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
              child: Text(
                model.message ?? "Something went wrong.",
                style: const TextStyle(fontSize: 24),
              ),
            ),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Divider(thickness: 1, color: Colors.grey),
              ],
            ),
            // content: Text(model.message ?? "Gift added successfully!"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Center(
                    child: Text("Cancel",style: TextStyle(color: Colors.black))
                ),
              ),
            ],
          );
        },
      );
    }
    else {
      // Show failure dialog with one option

      if(model.message == "Scan already submitted"){
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              // title: Text(model.message!),
              title: Text(
                model.message ?? "Something went wrong.",
                style: const TextStyle(fontSize: 24),
              ),
              content: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Divider(thickness: 1, color: Colors.grey),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () async{
                    Navigator.of(context).pop();
                  },
                  child: const Center(
                      child: Text("Cancel",style: TextStyle(color: Colors.red),
                      )),
                ),
              ],
            );
          },
        );
      }else{
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              // title: Text(model.message!),
              title: Text(
                model.message ?? "Something went wrong.",
                style: const TextStyle(fontSize: 24),
              ),
              content: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Divider(thickness: 1, color: Colors.grey),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () async{
                    debugPrint("12222------");

                    String Status =  await getStatus();
                    print("11222-----${Status}");
                    // openScanner(context, "$selectedGiftOption");

                    try {
                      debugPrint("Selected12344: ");
                      var result = await BarcodeScanner.scan();
                      setState(() {
                        scanResult = result.rawContent.isEmpty
                            ? "No data found"
                            : result.rawContent;
                        debugPrint("Selected Gift: $scanResult");
                        String decodedContent = decodeBase64(
                            result.rawContent);
                        // user-484
                        // UserIDP =
                        //     decodedContent.replaceAll("user-", "");

                        // Split the string at the '-'
                        List<String> parts = decodedContent.split('-');

                        // Store the parts into separate variables
                        UserType = parts[0]; // "user"
                        UserIDP = parts[1]; // "484"

                        print('Before dash: $UserType');
                        print('After dash: $UserIDP');

                        submitHallScan();

                      });
                    } catch (e) {
                      setState(() {
                        scanResult = "Error: $e";
                      });
                    }
                    Navigator.of(context).pop();

                  },
                  child: const Center(
                      child: Text("Retry",style: TextStyle(color: Colors.red),
                      )),
                ),
              ],
            );
          },
        );
      }

    }
  }


}
