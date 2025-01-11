import 'dart:convert';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:eventprimeadmin/global/color.dart';
import 'package:eventprimeadmin/global/model_my_patients.dart';
import 'package:eventprimeadmin/global/progress_dialog.dart';
import 'package:eventprimeadmin/global/response_main_model.dart';
import 'package:flutter/material.dart';
import 'package:eventprimeadmin/global/SizeConfig.dart';
import 'package:eventprimeadmin/global/utils.dart';



class OthersList extends StatefulWidget {
  final String? selectedGiftOptionIDP;
  final String? selectedGiftOption;
  final String? type;

  const OthersList({super.key, this.selectedGiftOptionIDP, this.selectedGiftOption, this.type});

  @override
  State<StatefulWidget> createState() {
    return OthersListState();
  }
}

class OthersListState extends State<OthersList> {
  Icon icon = Icon(
    Icons.search,
    color: black,
  );
  Widget titleWidget = Text(
    "Select Gift Receiver",
    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, ),
  );
  TextEditingController? searchController;
  var focusNode = new FocusNode();

  String scanResult = "No data scanned yet.";
  String UserIDP = "";
  String UserType = "";
  String userType = '';
  String CollectionUserIDP = "";
  List<ModelMyPatients> listMyPatients = [];
  List<ModelMyPatients> listMyPatientsSearchResults = [];

  @override
  void initState() {
    super.initState();
    getUserType().then((value) {
      userType = value;
    });
    getMyPatientsList(context);
  }

  @override
  void dispose() {
    listMyPatients = [];
    listMyPatientsSearchResults = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: titleWidget,
        backgroundColor: Colors.green,
        iconTheme: IconThemeData(color: Colorsblack), toolbarTextStyle: TextTheme(
          titleMedium: TextStyle(
            color: Colorsblack,
            fontFamily: "Ubuntu",
            fontSize: SizeConfig.blockSizeVertical !* 2.5,
          )).bodyMedium, titleTextStyle: TextTheme(
          titleMedium: TextStyle(
            color: Colorsblack,
            fontFamily: "Ubuntu",
            fontSize: SizeConfig.blockSizeVertical !* 2.5,
          )).titleLarge,
      ),
      body: Builder(
        builder: (context) {
          return Container(
            color: colorGrayApp,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: SizeConfig.blockSizeVertical !* 2,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.blockSizeHorizontal !* 3.0,
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      //border corner radius
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2), //color of shadow
                          spreadRadius: 3, //spread radius
                          blurRadius: 7, // blur radius
                          offset: Offset(0, 1), // changes position of shadow
                        ),
                        //you can set more BoxShadow() here
                      ],
                    ),
                    child: TextField(
                      onChanged: (text) {
                        setState(() {
                          listMyPatientsSearchResults = listMyPatients
                              .where((model) =>
                          (model.fName.toLowerCase().trim() +
                              " " +
                              model.lName.toLowerCase().trim())
                              .replaceAll("  ", " ")
                              .contains(text.toLowerCase()) ||
                              model.number
                                  .toLowerCase()
                                  .contains(text.toLowerCase()))
                              .toList();
                        });
                      },
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(15),
                          border: InputBorder.none,
                          hintText: 'Search',
                          hintStyle: TextStyle(fontSize: 16),
                          suffixIcon: Icon(
                            Icons.search,
                            color: Color(0xFF70a5db),
                          )),
                    ),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.blockSizeVertical !* 1.2,
                ),
                Expanded(
                  child: listMyPatientsSearchResults.length > 0
                      ? ListView.builder(
                      itemCount: listMyPatientsSearchResults.length,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                SizeConfig.blockSizeHorizontal !* 3),
                            child: InkWell(
                                onTap: () async {
                                  debugPrint("12222------");

                                  // openScanner(context, "$selectedGiftOption");
                                  CollectionUserIDP = listMyPatientsSearchResults[index].patientIDP.toString();

                                  try {
                                    debugPrint("Selected12344: ");
                                    var result = await BarcodeScanner.scan();
                                    setState(() {
                                      scanResult = result.rawContent.isEmpty ? "No data found" : result.rawContent;
                                      debugPrint("Selected Gift: $scanResult");
                                      String decodedContent = decodeBase64(result.rawContent);
                                      // user-484
                                      // UserIDP =
                                      //     decodedContent.replaceAll("user-", "");

                                      // Split the string at the '-'
                                      List<String> parts = decodedContent.split('-');

                                      // Store the parts into separate variables
                                      UserType ="other"; // "user"
                                      UserIDP = parts[1];  // "484"

                                      print('Before dash: $UserType');
                                      print('After dash: $UserIDP');

                                    });
                                  } catch (e) {
                                    setState(() {
                                      scanResult = "Error: $e";
                                    });
                                  }
                                  submitEventScan();

                                  Navigator.of(context).pop();

                                  // Navigator.of(context).push(
                                  //     PageRouteBuilder(
                                  //         transitionDuration:
                                  //         Duration(milliseconds: 500),
                                  //         pageBuilder: (context, _, __) {
                                  //           return SelectedPatientScreen(
                                  //             listMyPatientsSearchResults[index].patientIDP,
                                  //             listMyPatientsSearchResults[
                                  //             index]
                                  //                 .healthRecordsDisplayStatus,
                                  //             "selectedPatient_$index",
                                  //             notificationDisplayStatus:
                                  //             listMyPatientsSearchResults[
                                  //             index]
                                  //                 .notificationDisplayStatus,
                                  //           );
                                  //         }));

                                },
                                child: Hero(
                                  tag: "selectedPatient_$index",
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(15.0),
                                    ),
                                    child: IntrinsicHeight(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Visibility(
                                              visible: false,
                                              child: VerticalDivider(
                                                width: SizeConfig
                                                    .blockSizeHorizontal !*
                                                    2,
                                                thickness: SizeConfig
                                                    .blockSizeHorizontal !*
                                                    2,
                                                color: Colors.green,
                                              ),
                                            ),
                                            SizedBox(
                                              width: SizeConfig
                                                  .blockSizeHorizontal !*
                                                  3,
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                debugPrint("12222------");

                                                // openScanner(context, "$selectedGiftOption");
                                                CollectionUserIDP = listMyPatientsSearchResults[index].patientIDP.toString();

                                                try {
                                                  debugPrint("Selected12344: ");
                                                  var result = await BarcodeScanner.scan();
                                                  setState(() {
                                                    scanResult = result.rawContent.isEmpty ? "No data found" : result.rawContent;
                                                    debugPrint("Selected Gift: $scanResult");
                                                    String decodedContent = decodeBase64(result.rawContent);
                                                    // user-484
                                                    // UserIDP =
                                                    //     decodedContent.replaceAll("user-", "");

                                                    // Split the string at the '-'
                                                    List<String> parts = decodedContent.split('-');

                                                    // Store the parts into separate variables
                                                    UserType = "other"; // "user"
                                                    UserIDP = parts[1];  // "484"

                                                    print('Before dash: $UserType');
                                                    print('After dash: $UserIDP');

                                                  });
                                                } catch (e) {
                                                  setState(() {
                                                    scanResult = "Error: $e";
                                                  });
                                                }
                                                submitEventScan();

                                                Navigator.of(context).pop();
                                              },
                                              child: CircleAvatar(
                                                radius: SizeConfig
                                                    .blockSizeHorizontal !*
                                                    6.5,
                                                backgroundColor: colorBlueApp,
                                                child:
                                                (listMyPatientsSearchResults[index].imgUrl != "") ?
                                                CircleAvatar(
                                                    radius: SizeConfig.blockSizeHorizontal !* 6,
                                                    backgroundColor: Colors.grey,
                                                    backgroundImage: NetworkImage("$userImgUrl${listMyPatientsSearchResults[index].imgUrl}")
                                                )
                                                    :
                                                CircleAvatar(
                                                    radius: SizeConfig.blockSizeHorizontal !* 6,
                                                    backgroundColor: Colors.grey,
                                                    backgroundImage: AssetImage(
                                                        "images/ic_user_placeholder.png")),),
                                            ),
                                            SizedBox(
                                              width: SizeConfig
                                                  .blockSizeHorizontal !*
                                                  5,
                                            ),
                                            Expanded(
                                              child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: SizeConfig
                                                          .blockSizeHorizontal !*
                                                          3),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    mainAxisSize:
                                                    MainAxisSize.min,
                                                    children: <Widget>[
                                                      Text(
                                                        (listMyPatientsSearchResults[index].fName.trim() +
                                                            " " +
                                                            listMyPatientsSearchResults[
                                                            index]
                                                                .mName
                                                                .trim() +
                                                            " " +
                                                            listMyPatientsSearchResults[
                                                            index]
                                                                .lName
                                                                .trim())
                                                            .replaceAll(
                                                            "  ", " "),
                                                        style: TextStyle(
                                                            fontWeight:
                                                            FontWeight.w700,
                                                            fontSize: SizeConfig
                                                                .blockSizeHorizontal !*
                                                                4),
                                                      ),
                                                      SizedBox(
                                                        height: SizeConfig
                                                            .blockSizeVertical !*
                                                            1,
                                                      ),
                                                      Row(children: <Widget>[
                                                        Text(
                                                          " Number - ${listMyPatientsSearchResults[index].number}",
                                                          style: TextStyle(
                                                            fontSize: SizeConfig
                                                                .blockSizeHorizontal !*
                                                                3.5,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: SizeConfig
                                                              .blockSizeHorizontal !*
                                                              5,
                                                        ),

                                                      ]),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            listMyPatientsSearchResults[
                                                            index]
                                                                .cityName,
                                                            style: TextStyle(
                                                                fontSize: SizeConfig
                                                                    .blockSizeHorizontal !*
                                                                    3.5,
                                                                color:
                                                                Colors.grey),
                                                          ),
                                                          SizedBox(
                                                            width: SizeConfig.blockSizeHorizontal !* 3.0,),

                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: SizeConfig
                                                            .blockSizeVertical !*
                                                            1.0,
                                                      ),
                                                    ],
                                                  )),
                                            )
                                          ],
                                        )),
                                  ),
                                )));
                      })
                      : Container(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }


  void getMyPatientsList(BuildContext context) async {
    listMyPatients = [];
    listMyPatientsSearchResults = [];
    ProgressDialog? pr;
    Future.delayed(Duration.zero, () {
      pr = ProgressDialog(context);
      pr!.show();
    });
    //listIcon = new List();
    final String loginUrl = "${baseURL}event_user_all.php";
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

    debugPrint(jsonStr);
    debugPrint("---------------------------------------------");

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
    pr!.hide();
    if (model.status == "OK") {
      var data = jsonResponse['Data'];
      var strData = decodeBase64(data);
      debugPrint("Decoded Data Investigation Masters list : " + strData);
      final jsonData = json.decode(strData);

      // {"UserIDP":111529,"Salutation":"","FirstName":"Abbvie",
      // "LastName":"","Contact1":"1234567928","Email1":"email39@email.com",
      // "Photo":null},{"UserIDP":111528,"Salutation":"","FirstName":"Abbvie","
      // LastName":"","Contact1":"1234567927","Email1":"email38@email.com","Photo":null},
      for (var i = 0; i < jsonData.length; i++) {
        var jo = jsonData[i];
        listMyPatients.add(ModelMyPatients(
          jo['UserIDP'].toString(),
          jo['FirstName'],
          "",
          jo['LastName'],
          "",
          "",
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
      listMyPatientsSearchResults = listMyPatients;
      setState(() {});
    }
  }

  void submitEventScan() async {


    final String loginUrl = "${baseURL}add_gift.php";
    String patientUniqueKey = await getPatientUniqueKey();
    String userType = await getUserType();
    String eventIDP = await getEventIDP();
    String userPassword = await getPassword();

    String selectedGiftOptionIDP = widget.selectedGiftOptionIDP == ""
        || widget.selectedGiftOptionIDP == null
        || widget.selectedGiftOptionIDP == "null"
        ? "" : widget.selectedGiftOptionIDP! ;
    String selectedGiftOption = widget.selectedGiftOption == ""
        || widget.selectedGiftOption == null
        || widget.selectedGiftOption == "null"
        ? "" : widget.selectedGiftOption! ;

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
            ","+ "\"" + "CollectionUserIDP" + "\"" + ":" + "\"" + CollectionUserIDP + "\""
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
      var data = jsonResponse['Data'];
      var strData = decodeBase64(data);
      debugPrint("Decoded Data Array : " + strData);
      final jsonData = json.decode(strData);

      // for (var i = 0; i < jsonData.length; i++)
      // {
      //   final jo = jsonData[i];
      //   String freeGiftIDP = jo['FreeGiftIDP'].toString();
      //   listFreeGiftIDP.add(freeGiftIDP);
      //   debugPrint("Added to list: $listFreeGiftIDP");
      //
      //   String GiftDetails = jo['GiftDetails'].toString();
      //   listGiftName.add(GiftDetails);
      //   debugPrint("Added to list: $listGiftName");
      // }


    } else {
      final snackBar = SnackBar(
        backgroundColor: Colors.red,
        content: Text(model.message!),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
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

}
