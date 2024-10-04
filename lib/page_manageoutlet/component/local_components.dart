import 'package:bat_loyalty_program_app/services/api.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

mixin ManageOutletComponents {
  DateFormat? dateTime;

  final List<Map<dynamic,dynamic>> accounts = [
    {
      "data": "7-11",
      "filter": false
    },
    {
      "data": "Family Mart",
      "filter": false
    },
  ];

  int activeCount = 0;

  List<dynamic> accountImages = [];
  List<dynamic> accountImagesTemp = [];

  bool activeTemp = true;
  bool showInactiveOutlets = false;

  bool postcodeChanged = false;
  bool outletInitiated = false;
  bool outletListEditted = false;
  bool outletAdded = false;
  bool stillEditing = false;
  bool saveButtonActive = false;

  List<Map<dynamic, dynamic>> accountsList = [];
  List<String> accountFilters = ['Company'];
  List<Map<dynamic, dynamic>> outletsList = [];
  List<String> outletFilters = ['Outlet'];
  
  // error handlers
  Map<String, String> errMsgs = {
    "outletErrorMsg" : '',
    "accountErrorMsg" : '',
    "outletPostcodeErrorMsg" : '',
  };
  List<bool> errorMarks = [false, false, false];

  final TextEditingController accountController = TextEditingController(text: 'Company');
  final TextEditingController outletPostcodeController = TextEditingController();
  final TextEditingController outletController = TextEditingController(text: 'Outlet');

  final FocusNode outletPostcodeFocusnode = FocusNode();
  
  Map<String, dynamic> user = {};
  Map<String, dynamic> outlets = {};
  Map<String, dynamic> updateActiveData = {};

  void disposeAll() {
    accountController.dispose();
    outletController.dispose();
    outletPostcodeController.dispose();
  }

  void setActiveCount(Map<String, dynamic> outlets) { activeCount = 0;
    for (var i = 0; i < outlets['count']; i++) { if (outlets['rows'][i]['active']) { activeCount++; } }
  }

  void saveButtonValidation(void Function(void Function()) setState) {
    if (
      outletController.text != 'Outlet' &&
      accountController.text != 'Company' &&
      outletPostcodeController.text != ''
    ) { setState((){ saveButtonActive = true; }); }
    else { setState((){ saveButtonActive = false; }); }
  }

  Future<void> setAccountList(String domainName, void Function(void Function()) setState) async {
    accountFilters.clear(); accountsList.clear();
    accountFilters.add('Company');
    
    await Api.account_list(domainName).then((res) {
      print("res['result']: ${res['result']}");
      
      final int statusCode = res['status_code'];

      List<dynamic> results = List.from(res['result']);

      setState(() {
        if (statusCode == 200) {
          for (var account in results) {
            accountFilters.add(account['name']);
          }
          
          accountsList = List.from( results );
        } else {
          accountFilters.add('Error');
        }
      });


      print('accounts: $accounts');
    });
  }

  Future<void> setOutletList(BuildContext context, String domainName, void Function(void Function() fn) setState ) async {
    outletFilters.clear(); outletsList.clear();
    outletFilters.add('Outlet');

    print('outletsList: $outletsList');
    print('accountsList: $accountsList');
    Map<dynamic, dynamic> accountId = accountsList.where((_account) {
      final _accountName = _account['name'].toString();
      
      return _accountName == accountController.text;
    }).toList().first;

    print('accountId: ${accountId['id']}');
    
    await Api.outlet_list(domainName, account: accountId['id'], postcode: outletPostcodeController.text).then((res) {
      final int statusCode = res['status_code'];
      print(res);
      print(statusCode);

      List<dynamic> rows = List.from(res['result']['data']['rows']);

      setState(() {
        if (statusCode == 200) {
          for (var outlet in rows) {
            outletFilters.add(outlet['name']);
          }
          
          outletsList = List.from( rows );

          if (outletFilters.length == 1) FloatingSnackBar(message: 'No outlets in the desribed postcode.', context: context);
        } else {
          outletFilters.add('Error');
        }
      });


      print('outlets: $outletsList');
      print('outletFilters: $outletFilters');
    });
  }

  Future<void> setAccountImages() async {
    final regEx = RegExp(r'(?<=assets/account_images/)(.*)(?=.png)');

    await AssetManifest.loadFromAssetBundle(rootBundle).then((_assetManifest) async {
      final List<String> assetsAccountImages = _assetManifest.listAssets().where((string) => string.startsWith("assets/account_images/")).toList();
      
      print('assetsAccountImages.length: ${assetsAccountImages.length}');
      for (var i = 0; i < assetsAccountImages.length; i++) {
        print('count: $i');
        Map<String, dynamic> singleAccountImage = {};

        if (i == assetsAccountImages.length) {
          singleAccountImage.addEntries({
            "name": 'company',
            "path": 'assets/account_images/company.png',
          }.entries);
        } else {
          String? imageName;
          String imagePath;
          
          var match = regEx.firstMatch(assetsAccountImages[i]);
          if (match != null) imageName = match.group(0);

          imagePath = 'assets/account_images/${imageName}.png';

          singleAccountImage.addEntries({
            "name": imageName,
            "path": imagePath,
          }.entries);
        }
        
        accountImages.add(singleAccountImage);
      }

      accountImagesTemp = List<dynamic>.from(accountImages);

    });
  }
}