import 'dart:convert';

import 'package:bat_loyalty_program_app/page_profile/component/local_components.dart';
import 'package:bat_loyalty_program_app/page_profile/widget/local_widgets.dart';
import 'package:bat_loyalty_program_app/services/api.dart';
import 'package:bat_loyalty_program_app/services/global_components.dart';
import 'package:bat_loyalty_program_app/services/global_widgets.dart';
import 'package:bat_loyalty_program_app/services/routes.dart';
import 'package:bat_loyalty_program_app/services/shared_preferences.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  static const routeName = '/edit_profile';

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> with ProfileComponents, MyComponents{

  @override
  void initState() {
    super.initState();

    initParam(context);
  }

  @override
  void dispose() { 
    mainScrollController.dispose();
    disposeAll();
    
    super.dispose();
  }
  
  @override
  Future<void> initParam(BuildContext context, {key, bool needToken = true}) async {
    super.initParam(context);
    
    dateTime = DateFormat('dd/MM/yyyy').add_Hms();
  }

  @override
  Future<bool> popDialog() async {
    bool res = false;

    await showDialog(context: context, builder: (context) => PopUps.Default(context, 'Unsaved Data',
      confirmText: 'Yes',
      cancelText: 'Continue Editing',
      subtitle: 'Are you sure you want to exit this page?', warning: 'Once exit, all progress will not be saved.'
      
    )).then((_res) async { print('_res: $_res'); res = _res; });

    return res;
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as MyArguments;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final userMap = jsonDecode(args.user); user = Map.from(userMap);

    if (createUser) { setControllers(); createUser = false;
      setCountryStates().whenComplete(() async {
        await setCity(setState: setState).whenComplete(() { setState(() { launchLoading = false; }); });
       });
    }
    if (!launchLoading) { setPath(prevPath: args.prevPath, routeName: ProfileEditPage.routeName); }

    return PopScope(
      onPopInvoked: (didPop) async {
        if (didPop) return;
        
        if (!stillEditing) {
          Navigator.pop(context, userUpdated);
        } else {
          await popDialog().then((res) async { print('popscope_res: $res');
              canPop = res; if (res) Navigator.pop(context, userUpdated);
            });
        }
      },
      canPop: canPop,
      child: launchLoading ? MyWidgets.MyLoading2(context, isDarkMode) : GestureDetector( onTap: () => FocusManager.instance.primaryFocus?.unfocus(), child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: MyWidgets.MyAppBar(context, isDarkMode, 'Edit Profile', appVersion: appVersion, canPop: canPop, popDialog: popDialog),

        body: 
        
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column( mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0), child: Breadcrumb(paths: paths, canPop: !stillEditing, refresh: userUpdated, popDialog: popDialog,)),

                  Expanded(
                    child: MyWidgets.MyScroll2( context,
                      height: MySize.Height(context, 1.5),
                        controller: mainScrollController,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  
                                  ProfileWidgets.Header(context, title: 'Personal Information'),
                                  Column(children: [
                                    ProfileWidgets.ConfirmationListTile(context, title: 'Phone No', controller: phoneController, readOnly: true, focusNode: dummyFocusnode,
                                      onTap: () => setState( () {} ), onChanged: (_) => setState(() {canPop = false; stillEditing = true;} ),
                                    ), errorMarks[0] ? MyWidgets.MyErrorTextField(context, "Error TextField" ) : SizedBox(),
                                    ProfileWidgets.ConfirmationListTile(context, title: 'Username', controller: usernameController, readOnly: true, focusNode: usernameFocusnode,
                                      onTap: () => setState( () {} ), onChanged: (_) => setState(() {canPop = false; stillEditing = true;} ),
                                    ), errorMarks[1] ? MyWidgets.MyErrorTextField(context, "Error TextField" ) : SizedBox(),
                                    ProfileWidgets.ConfirmationListTile(context, title: 'Full Name', controller: fullNameController, focusNode: fullNameFocusnode,
                                      onTap: () => setState( () {} ), onChanged: (_) => setState(() {canPop = false; stillEditing = true;} ),
                                    ), errorMarks[2] ? MyWidgets.MyErrorTextField(context, errMsgs['fullNameErrorMsg']! ) : SizedBox(),
                                    ProfileWidgets.ConfirmationListTile(context, title: 'Email', controller: emailController, focusNode: emailFocusnode,
                                      onTap: () => setState( () {} ), onChanged: (_) => setState(() {canPop = false; stillEditing = true;} ),
                                    ), errorMarks[3] ? MyWidgets.MyErrorTextField(context, errMsgs['emailErrorMsg']! ) : SizedBox(),
                                  ],),

                                  Divider(color: Theme.of(context).colorScheme.onTertiary,),
                                  
                                  ProfileWidgets.Header(context, title: 'Security Information'),
                                  Column(children: [
                                    ProfileWidgets.ConfirmationListTile(context, title: 'Password', controller: passwordController, isPassword: true, focusNode: passwordFocusnode, readOnly: true,
                                      onTap: () => setState( () {} ), onChanged: (_) => setState(() {canPop = false; stillEditing = true;} ),
                                    ), errorMarks[4] ? MyWidgets.MyErrorTextField(context, errMsgs['passwordErrorMsg']! ) : SizedBox(),
                                  ],),
                              
                                  Divider(color: Theme.of(context).colorScheme.onTertiary,),
                                  
                                  ProfileWidgets.Header(context, title: 'Address Information'),
                                  Column(children: [
                                    ProfileWidgets.ConfirmationListTile(context, title: 'Unit No. / House No.', controller: address1Controller, focusNode: address1Focusnode,
                                      onTap: () => setState( () {} ), onChanged: (_) => setState(() {canPop = false; stillEditing = true;} ),
                                    ), errorMarks[5] ? MyWidgets.MyErrorTextField(context, errMsgs['address1ErrorMsg']! ) : SizedBox(),
                                    ProfileWidgets.ConfirmationListTile(context, title: 'Street Name', controller: address2Controller, focusNode: address2Focusnode,
                                      onTap: () => setState( () {} ), onChanged: (_) => setState(() {canPop = false; stillEditing = true;} ),
                                    ), errorMarks[6] ? MyWidgets.MyErrorTextField(context, errMsgs['address2ErrorMsg']! ) : SizedBox(),
                                    ProfileWidgets.ConfirmationListTile(context, title: 'Residential Area', controller: address3Controller, focusNode: address3Focusnode,
                                      onTap: () => setState( () {} ), onChanged: (_) => setState(() {canPop = false; stillEditing = true;} ),
                                    ), errorMarks[7] ? MyWidgets.MyErrorTextField(context, errMsgs['address3ErrorMsg']! ) : SizedBox(),
                                    
                                    ProfileWidgets.dropdownField(context, 'State', selectedFilter: stateController.text, filters: statesFilters, onChanged: (String? _filter) async {
                                      setState(() => isLoading = true);
                                
                                      if (stateController.text == _filter) {
                                        setState(() => isLoading = false);
                                
                                        return;
                                      }
                                
                                      await Future.delayed(const Duration(milliseconds: 700)).whenComplete(() async{
                                
                                        if (stateController.text != _filter!) setState((){cityController.text = 'City';});
                                        
                                        setState(() {
                                          stateController.text = _filter;
                                          postcodeController.text = '';
                                          city.clear();
                                          cityFilters.clear();
                                          cityFilters.add('City');
                                        });
                                
                                        if (stateController.text == 'State') {
                                          setState(() => isLoading = false);
                                
                                          return;
                                        }

                                        await setCity(setState: setState).whenComplete(() => setState(() => isLoading = false));
                        
                                        setState(() => saveButtonValidation(setState) );
                                      }); 
                                
                                    },),

                                    errorMarks[8] ? MyWidgets.MyErrorTextField(context, errMsgs['stateErrorMsg']! ) : SizedBox(),

                                    ProfileWidgets.dropdownField(context, 'City', selectedFilter: cityController.text, filters: cityFilters,active: stateController.text == 'State' ? false : true, onChanged: (String? _filter) async{
                                      setState(() => isLoading = true);
                              
                                      if (cityController.text == _filter) {
                                        setState(() => isLoading = false);
                              
                                        return;
                                      }
                              
                                      await Future.delayed(const Duration(milliseconds: 400)).whenComplete(() async{
                                        if (cityController.text != _filter!) setState((){postcodeController.text = '';});
                                        
                                        setState(() {
                                          cityController.text = _filter;
                                        });
                              
                                        var cityChosen = city.where((_singleCity) {
                                          final cityName = _singleCity['name'];
                                          
                                          return cityName.contains(cityController.text);
                                        }).toList();
                              
                                        print("lat long : ${cityChosen[0]['latitude']},${cityChosen[0]['longitude']}");
                              
                                        double latitude = double.parse(cityChosen[0]['latitude']);
                                        double longitude = double.parse(cityChosen[0]['longitude']);
                              
                                        print('latitude : ${latitude}');
                                        print('longitude : ${longitude}');
                              
                                        await placemarkFromCoordinates(latitude, longitude).then((_placemarks) {
                                          // print('_placemarks : ${_placemarks.toString()}');
                                          // print('_placemarks.length : ${_placemarks.length.toString()}');
                                          
                                          Placemark singlePlacemark;
                                          String? postcode;
                              
                                          if (_placemarks.isEmpty) {postcode = '0';} else {
                                            var _placemarksFiltered = _placemarks.where((_singlePlacemark) => _singlePlacemark.postalCode != null).toList();
                                            singlePlacemark = _placemarksFiltered.first;
                              
                                            postcode = singlePlacemark.postalCode;
                                          }
                              
                                          print('postcode : ${postcode}');
                              
                                          setState(() => isLoading = false);
                                          
                                          setState(() {
                                            postcodeController.text = postcode!;
                                            saveButtonValidation(setState);
                                          });
                                        });
                                      });
                                    }),
                                    
                                    errorMarks[9] ? MyWidgets.MyErrorTextField(context, errMsgs['cityErrorMsg']! ) : SizedBox(),
                                    
                                    ProfileWidgets.ConfirmationListTile(context, title: 'PostCode', controller: postcodeController, focusNode: postcodeFocusnode, digitOnly: true,
                                      onTap: () => setState( () {} ), onChanged: (_) => setState(() {canPop = false; stillEditing = true;} ),
                                    ), errorMarks[10] ? MyWidgets.MyErrorTextField(context, errMsgs['postcodeErrorMsg']! ) : SizedBox(),
                                  ],),
                                ],
                              ),
                          
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 80.0),
                                child: MyWidgets.MyButton1(context, 150, 'Save', active: saveButtonActive,
                                  () async {

                                    await showDialog(context: context, builder: (context) => PopUps.Default(context, 'Save Changes',
                                      confirmText: 'Save',
                                      cancelText: 'Cancel',
                                      subtitle: 'Save your changes?'),).then((res) async {
                                        if (res ?? false) {
                                          setState(() { isLoading = true; phoneController.text = args.phone; });
                                    
                                          await updateSelfDataValidation(context, domainName, setState).then((valid) async {
                                            if (valid) { print('success');
                                              await Api.user_update_self(context, domainName, token, updateSelfData: updateSelfData).then((statusCode) async {
                                                print({ statusCode });

                                                if (statusCode == 200) {
                                                  await MyPrefs.init().then((prefs) async {
                                                    prefs!;
                                                    
                                                    final String cachedUser = MyPrefs.getUser(prefs: prefs)!;
                                                    final Map<String, dynamic> mappedUser = jsonDecode(cachedUser);
                                                    final String password = mappedUser['password'];
                                                    
                                                    await Api.user_self(domainName, token, password: password).then((res) {

                                                      if (res == 200) {
                                                        // success
                                                        FloatingSnackBar(message: 'Successful. Edit saved', context: context);
                                                        setState(() => userUpdated = true );
                                                        setState(() => stillEditing = false );

                                                      } else { FloatingSnackBar(message: 'Something went wrong. Error ${statusCode}.', context: context);
                                                      } setState(() { isLoading = false; });
                                                    }); setState(() { isLoading = false; });
                                                  });
                                                } else { FloatingSnackBar(message: 'Something went wrong. Error ${statusCode}.', context: context);
                                                } setState(() { isLoading = false; });
                                              });
                                            } else { print('failed');
                                              FloatingSnackBar(message: 'Unsuccessful. Please enter your info correctly.', context: context);
                                            } setState(() { isLoading = false; });
                                          }); setState(() { isLoading = false; });
                                        }
                                      }
                                    );
                                    
                                  }
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                  ),
                ],
              )
            ),

            MyWidgets.MyLoading(context, isLoading, isDarkMode)
          ],
        ),
      )
    ));
  }
}