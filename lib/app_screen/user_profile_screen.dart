import 'dart:convert';

import 'package:eventprimeadmin/global/SizeConfig.dart';
import 'package:eventprimeadmin/global/model_my_patients.dart';
import 'package:eventprimeadmin/global/progress_dialog.dart';
import 'package:eventprimeadmin/global/response_main_model.dart';
import 'package:eventprimeadmin/global/utils.dart';
import 'package:flutter/material.dart';

class UserProfileScreen extends StatefulWidget {

  final String? UserIDP;
  final String? UserType;
  final String? type;
  final String? activityName;
  final String? activityIDP;

  const UserProfileScreen({super.key, this.UserIDP, this.UserType, this.type , this.activityName, this.activityIDP});


  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  List<ModelMyPatients> listMyPatients = [];
  List<ModelMyPatients> listMyPatientsSearchResults = [];
  bool isLoading = true;  // Add the loading state


  @override
  void initState() {
    super.initState();
    getMyPatientsDetails(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator()) // Show loading indicator while fetching data
            : (listMyPatientsSearchResults.isEmpty
            ? Container()
            : Column(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child:
              // (listMyPatientsSearchResults[0].imgUrl != "")
              //     ? CircleAvatar(
              //     radius: SizeConfig.blockSizeHorizontal! * 40,
              //     backgroundColor: Colors.grey,
              //     backgroundImage: NetworkImage(
              //         "$userImgUrl${listMyPatientsSearchResults[0].imgUrl}"))
              //     :
              CircleAvatar(
                radius: SizeConfig.blockSizeHorizontal! * 40,
                backgroundColor: Colors.grey,
                backgroundImage:
                AssetImage("images/ic_user_placeholder.png"),
              ),
            ),
            const SizedBox(height: 16.0),
            // Name
            Text(
              "Name: ${listMyPatientsSearchResults[0].fName + listMyPatientsSearchResults[0].lName}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            // ID
            Text(
              "ID: ${listMyPatientsSearchResults[0].patientIDP}",
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16.0),
            // Details
            Text(
              "Catagory: ${listMyPatientsSearchResults[0].category}",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8.0),
            Text(
              "Mo. Number: ${listMyPatientsSearchResults[0].number}",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8.0),
            Text(
              "Email: ${listMyPatientsSearchResults[0].email}",
              style: TextStyle(fontSize: 18),
            ),
            const Spacer(),
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if(widget.type! == "ScanUser"){
                      submitEventScan();
                    }else if(widget.type! == "RedeemCoupon"){
                      submitEventRedeemCoupon();
                    }else if(widget.type! == "HallScan"){
                      submitHallScan();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: Text('OK'),
                ),
              ],
            ),
          ],
        )),
      ),
    );
  }

  String encodeBase64(String text) {
    var bytes = utf8.encode(text);
    //var base64str =
    return base64.encode(bytes);
    //= Base64Encoder().convert()
  }

  String decodeBase64(String text) {
    var bytes = base64.decode(text);
    return String.fromCharCodes(bytes);
  }

  void getMyPatientsDetails(BuildContext context) async {
    listMyPatients = [];
    listMyPatientsSearchResults = [];
    ProgressDialog? pr;
    Future.delayed(Duration.zero, () {
      pr = ProgressDialog(context);
      pr!.show();
    });

    final String loginUrl = "${baseURL}user_details.php";
    String patientUniqueKey = await getPatientUniqueKey();
    String userType = await getUserType();
    String eventIDP = await getEventIDP();
    String userPassword = await getPassword();

    String jsonStr =
        "{" + "\"" + "EventIDP" + "\"" + ":" + "\"" + eventIDP + "\"" +
            "," + "\"" + "UserIDP" + "\"" + ":" + "\"" + widget.UserIDP! + "\"" +
            "}";

    String encodedJSONStr = encodeBase64(jsonStr);
    var response = await apiHelper.callApiWithHeadersAndBody(
      url: loginUrl,
      headers: {
        "u": patientUniqueKey,
        "p": userPassword,
        "type": userType,
      },
      body: {"getjson": encodedJSONStr},
    );

    final jsonResponse = json.decode(response.body.toString());
    ResponseModel model = ResponseModel.fromJSON(jsonResponse);
    pr!.hide();

    if (model.status == "OK") {
      var data = jsonResponse['Data'];
      var strData = decodeBase64(data);
      final jsonData = json.decode(strData);

      print("112222222---$strData");

      // [{"UserIDP":484,"Salutation":"Mr.","FirstName":"Rushil","LastName":"Soni",
      // "Contact1":"8000083323","Email1":"rushilsoni01@gmail.com",
      // "Photo":"484-202209270233.jpg","RegistrationID":"AMBI536","RegistrationCategory":"Delegate"}]

      for (var i = 0; i < jsonData.length; i++) {
        var jo = jsonData[i];
        listMyPatients.add(ModelMyPatients(
          jo['UserIDP'].toString(),
          jo['FirstName'],
          "",
          jo['LastName'],
          jo['RegistrationCategory'],
          jo['Email1'],
          "",
          "",
          jo['Contact1'],
          "",
          "",
          jo['Photo'] ?? "",
          "",
          "",
        ));
      }
      setState(() {
        listMyPatientsSearchResults = listMyPatients;
        isLoading = false;  // Set loading to false after data is fetched
      });
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
            ","+ "\"" + "FreeGiftIDP" + "\"" + ":" + "\"" + widget.activityIDP! + "\""
            ","+ "\"" + "GiftName" + "\"" + ":" + "\"" + widget.activityIDP! + "\""
            ","+ "\"" + "UserType" + "\"" + ":" + "\"" + widget.UserType! + "\""
            ","+ "\"" + "UserIDP" + "\"" + ":" + "\"" + widget.UserIDP! + "\""
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
                  submitEventScan();
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
            ","+ "\"" + "EventCouponIDP" + "\"" + ":" + "\"" + widget.activityIDP! + "\""
            ","+ "\"" + "CouponName" + "\"" + ":" + "\"" + widget.activityName! + "\""
            ","+ "\"" + "CouponType" + "\"" + ":" + "\"" + widget.UserType! + "\""
            ","+ "\"" + "UserIDP" + "\"" + ":" + "\"" + widget.UserIDP! + "\""
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
                  submitEventScan();
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
            ","+ "\"" + "HallActivityIDP" + "\"" + ":" + "\"" + widget.activityName! + "\""
            ","+ "\"" + "HallIDP" + "\"" + ":" + "\"" + widget.activityIDP! + "\""
            ","+ "\"" + "UserIDP" + "\"" + ":" + "\"" + widget.UserIDP! + "\""
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
                  submitEventScan();
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
