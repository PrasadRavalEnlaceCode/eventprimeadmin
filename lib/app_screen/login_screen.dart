import 'dart:convert';

import 'package:eventprimeadmin/api/api_helper.dart';
import 'package:eventprimeadmin/app_screen/home_screen.dart';
import 'package:eventprimeadmin/global/SizeConfig.dart';
import 'package:eventprimeadmin/global/color.dart';
import 'package:eventprimeadmin/global/progress_dialog.dart';
import 'package:eventprimeadmin/global/response_main_model.dart';
import 'package:eventprimeadmin/global/utils.dart';
import 'package:flutter/material.dart';

final focus = FocusNode();
TextEditingController mobileNoController = new TextEditingController();
TextEditingController passwordController = new TextEditingController();

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  bool _passwordVisible = false;
  ApiHelper apiHelper = ApiHelper();

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
        toolbarHeight: 0,
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 30,
          ),
          Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(0),
              height: MediaQuery.of(context).size.height * 0.20,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/Event-Prim-Admin.jpg"),
                  // fit: BoxFit.,
                ),
              ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(0),
            child: const Center(
              child: Text(
                "Manage your all events at one place",
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
            ),
          ),
          Container(
            color: Colors.white,
            // height: MediaQuery.of(context).size.height * 0.20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Center(
                    //   child: Text(
                    //     "123",
                    //     style: TextStyle(fontSize: 12, color: Colors.black),
                    //   ),
                    // ),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: TextField(
                        controller: mobileNoController,
                        // keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: "Email or Number",
                          hintStyle: TextStyle(fontSize: 16),
                          // border: OutlineInputBorder(
                          //   borderRadius: BorderRadius.circular(30),
                          //   borderSide: BorderSide(
                          //     width: 0,
                          //     style: BorderStyle.none,
                          //   ),
                          // ),
                          filled: true,
                          contentPadding: EdgeInsets.all(16),
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 30.0,
                            vertical: SizeConfig.blockSizeVertical! * 2,
                          ),
                          child: Container(
                            width: SizeConfig.screenWidth,
                            child: TextField(
                              controller: passwordController,
                              obscureText: !_passwordVisible,
                              // style: TextStyle(color: black),
                              decoration: InputDecoration(
                                hintText: 'Password',
                                hintStyle: const TextStyle(fontSize: 16),
                                // border: OutlineInputBorder(
                                //   borderRadius: BorderRadius.circular(30),
                                //   borderSide: BorderSide(
                                //     width: 0,
                                //     style: BorderStyle.none,
                                //   ),
                                // ),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  },
                                  child: Icon(
                                      _passwordVisible
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: black),
                                ),
                                filled: true,
                                contentPadding: const EdgeInsets.all(12),
                                fillColor: Colors.white,
                              ),
                            ),
                          ),
                        )),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Container(
                        child: SizedBox(
                          width: SizeConfig.screenWidth,
                          child: TextButton(
                              child: const Text("Login",
                                  style: TextStyle(fontSize: 16)),
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all<EdgeInsets>(
                                      const EdgeInsets.all(15)),
                                  foregroundColor:
                                  MaterialStateProperty.all<Color>(
                                      colorWhite),
                                  backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.green),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(30.0)))),
                              onPressed: () => doLogin(context)),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: SizeConfig.blockSizeVertical !* 0.3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String encodeBase64(String text) {
    var bytes = utf8.encode(text);
    return base64.encode(bytes);
  }

  String decodeBase64(String text) {
    var bytes = base64.decode(text);
    return String.fromCharCodes(bytes);
  }

  void doLogin(BuildContext context) async {
    final String loginUrl = "${baseURL}login_general.php";
    /*List<IconModel> listIcon;*/
    String mobNoToValidate = mobileNoController.text;
    if (mobileNoController.text.length >= 12) {
      if (mobileNoController.text.startsWith("+91")) {
        mobNoToValidate = mobileNoController.text.replaceFirst("+91", "");
      } else if (mobileNoController.text.startsWith("91")) {
        mobNoToValidate = mobileNoController.text.replaceFirst("91", "");
      }
    }

    if (mobNoToValidate == "") {
      final snackBar = const SnackBar(
        backgroundColor: Colors.red,
        content: Text("Please enter Username"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (passwordController.text.trim() == "") {
      final snackBar = const SnackBar(
        backgroundColor: Colors.red,
        content: Text("Please enter Password"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      ProgressDialog pr = ProgressDialog(context);
      pr.show();
      //listIcon = new List();
      var response =
      await apiHelper.callApiWithHeadersAndBody(
          url: loginUrl, headers: {
        "u": mobNoToValidate,
        "p": passwordController.text.trim(),
        "type": "general",
      });

      debugPrint(response.body.toString());
      final jsonResponse = json.decode(response.body.toString());
      ResponseModel model = ResponseModel.fromJSON(jsonResponse);
      pr.hide();
      debugPrint(
          "------------------------------------------------------------------");

      // Decoded Data Array : [{"EventIDP":304,"EventName":"AOCR 2025",
      // "EventCode":"AOCR 2025","EventSlogan":"AOCR 2025",
      // "EventLogo":"304-202401081739.jpg","EventStartDate":"2025-01-23",
      // "EventEndDate":"2025-01-26","EventVenueName":"-","EventAddress":"-",
      // "VenueImage":null,"WebsiteURL":"https:\/\/rxregistrations.com\/aocr2025"}]

      try {
        if (model.status == "OK") {
          var data = jsonResponse['Data'];
          var strData = decodeBase64(data);
          debugPrint("Decoded Data Array : $strData");

          final jsonData = json.decode(strData);

          setEventIDP(jsonData[0]['EventIDP'].toString());
          setUserType("general");
          setPassword(passwordController.text.trim());
          setPatientUniqueKey(mobNoToValidate);
          setStatus(jsonData[0]['ScanProfileStatus'].toString());

          String userType = await getUserType();
          String userIDP = await getEventIDP();
          String userPassword = await getPassword();
          String userPatientUniqueKey = await getPatientUniqueKey();


          print("123333333 ----${userIDP}");
          print("1111-------${userType}");
          print("123333333 ----${userPassword}");
          print("1111-------${userPatientUniqueKey}");

          Navigator.of(context).push(
              MaterialPageRoute(builder: (context){
                return const HomeScreen();
              })
          );

        } else {
          final snackBar = SnackBar(
            backgroundColor: Colors.red,
            content: Text(model.message!),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } catch (e) {
        // Handle any errors that occur during the login process
        print("Error during login: $e");
        final snackBar = const SnackBar(
          backgroundColor: Colors.red,
          content: Text("An error occurred during login. Please try again."),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }
}
