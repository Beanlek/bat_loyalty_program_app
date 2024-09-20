import 'dart:convert';

import 'package:bat_loyalty_program_app/page_manageoutlet/component/local_components.dart';
import 'package:bat_loyalty_program_app/page_profile/widget/local_widgets.dart';
import 'package:bat_loyalty_program_app/services/api.dart';
import 'package:bat_loyalty_program_app/services/global_components.dart';
import 'package:bat_loyalty_program_app/services/global_widgets.dart';
import 'package:bat_loyalty_program_app/services/routes.dart';
import 'package:bat_loyalty_program_app/services/shared_preferences.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ManageOutletAddPage extends StatefulWidget {
  const ManageOutletAddPage({super.key});

  static const routeName = '/add';

  @override
  State<ManageOutletAddPage> createState() => _ManageOutletAddPageState();
}

class _ManageOutletAddPageState extends State<ManageOutletAddPage> with ManageOutletComponents, MyComponents{

  @override
  void initState() {
    super.initState();

    initParam(context).whenComplete(() => setState(() { launchLoading = false; }));
  }

  @override
  void dispose() { 
    mainScrollController.dispose();
    disposeAll();
    
    super.dispose();
  }
  
  @override
  Future<void> initParam(BuildContext context, {key, bool needToken = true}) async {
    super.initParam(context).whenComplete((){ setAccountList(domainName, setState); });
    
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

    if (launchLoading) {
      final userMap = jsonDecode(args.user); user = Map.from(userMap);
      final outletsMap = jsonDecode(args.outlets); outlets = Map.from(outletsMap);
    }

    if (!outletInitiated) { outletInitiated = true; }
    if (!launchLoading) { setPath(prevPath: args.prevPath, routeName: ManageOutletAddPage.routeName); }

    return PopScope(
      onPopInvoked: (didPop) async {
        if (didPop) return;
        
        if (!stillEditing) {
          Navigator.pop(context, outletAdded);
        } else {
          await popDialog().then((res) async { print('popscope_res: $res');
              canPop = res; if (res) Navigator.pop(context, outletAdded);
            });
        }
      },
      canPop: canPop,
      child: launchLoading ? MyWidgets.MyLoading2(context, isDarkMode) : GestureDetector( onTap: () async {
        if (outletPostcodeFocusnode.hasFocus) {
          if (outletPostcodeController.text == "") {
            return;
          }

          setState(() => isLoading = true);

          await Future.delayed(const Duration(milliseconds: 400)).whenComplete(() async{
            setState((){ print('postcodeChanged onSubmit: $postcodeChanged');
              if (postcodeChanged) {  setOutletList(context, domainName, setState); setState(() => postcodeChanged = false); print('postcodeChanged falsed: $postcodeChanged');}
              setState(() => isLoading = false);
              
            });
          });
          
          saveButtonValidation(setState);
          outletPostcodeFocusnode.unfocus();
        }
        FocusManager.instance.primaryFocus?.unfocus();
      
      }, child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: MyWidgets.MyAppBar(context, isDarkMode, 'Add Outlet', appVersion: appVersion, refresh: outletAdded, canPop: canPop, popDialog: popDialog),

        body: 
        
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column( mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0), child: Breadcrumb(paths: paths, canPop: !stillEditing, refresh: outletAdded, popDialog: popDialog,)),

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
                                  ProfileWidgets.Header(context, title: 'Outlet Information'),
                                  Column(children: [
                                    
                                    ProfileWidgets.dropdownField(context, 'Company', selectedFilter: accountController.text, filters: accountFilters, onChanged: (String? _filter) async {
                                      if (_filter! == 'Company') {
                                        accountController.text = _filter;
                                        outletController.text = 'Outlet';
                                        
                                        setOutletList(context, domainName, setState);
                                      }
                                      
                                      setState(() => isLoading = true);

                                      if (accountController.text == _filter) {
                                        setState(() => isLoading = false); return;
                                      }

                                      await Future.delayed(const Duration(milliseconds: 400)).whenComplete(() async{
                                        if (accountController.text != _filter) setState((){outletController.text = 'Outlet';});
                                        
                                        setState((){
                                          accountController.text = _filter;
                                          print('outletController!.text: ${outletController.text}');
                                          
                                          if ( outletPostcodeController.text != "" )  setOutletList(context, domainName, setState);
                                          setState(() => isLoading = false);
                                        });
                                      });

                                      saveButtonValidation(setState);
                                    }),

                                    errorMarks[0] ? MyWidgets.MyErrorTextField(context, errMsgs['accountErrorMsg']! ) : SizedBox(),

                                    ProfileWidgets.ConfirmationListTile(context, title: 'PostCode', controller: outletPostcodeController, focusNode: outletPostcodeFocusnode, digitOnly: true,
                                      onTap: () => setState( () {} ), onChanged: (_) => setState(() {canPop = false; stillEditing = true; postcodeChanged = true;} ), onSubmitted: (_) async {
                                        if (outletPostcodeController.text == "") {
                                          return;
                                        }

                                        setState(() => isLoading = true);

                                        await Future.delayed(const Duration(milliseconds: 400)).whenComplete(() async{
                                          setState((){ print('postcodeChanged onSubmit: $postcodeChanged');
                                            if (postcodeChanged) {  setOutletList(context, domainName, setState); setState(() => postcodeChanged = false); print('postcodeChanged falsed: $postcodeChanged');}
                                            setState(() => isLoading = false);
                                            
                                          });
                                        });
                                        
                                        saveButtonValidation(setState);
                                        outletPostcodeFocusnode.unfocus();
                                      },
                                    ), errorMarks[1] ? MyWidgets.MyErrorTextField(context, errMsgs['outletPostcodeErrorMsg']! ) : SizedBox(),

                                    ProfileWidgets.dropdownField(context, 'Outlet', selectedFilter: outletController.text, filters: outletFilters, active: (accountController.text == 'Company' || outletPostcodeController.text == "") ? false : true, onChanged: (String? _filter) async{
                                      setState(() => isLoading = true);

                                      if (outletController.text == _filter!) {
                                        setState(() => isLoading = false); return;
                                      }

                                      setState((){
                                        outletController.text = _filter;
                                        setState(() => isLoading = false);
                                      });

                                      saveButtonValidation(setState);
                                    }),
                                    
                                    errorMarks[2] ? MyWidgets.MyErrorTextField(context, errMsgs['outletErrorMsg']! ) : SizedBox(),
                                  ],),
                                ],
                              ),
                          
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 80.0),
                                child: MyWidgets.MyButton1(context, 150, 'Add', active: saveButtonActive,
                                  () async {

                                    await showDialog(context: context, builder: (context) => PopUps.Default(context, 'Adding New Outlet',
                                      confirmText: 'Add',
                                      cancelText: 'Cancel',
                                      subtitle: 'Add this outlet as your other outlet?'),).then((res) async {
                                        if (res ?? false) {
                                          setState(() { isLoading = true; });

                                          Map<dynamic, dynamic> outlet = outletsList.where((_outlet) {
                                            final _outletName = _outlet['name'].toString();
                                            
                                            return _outletName == outletController.text;
                                          }).toList().first;

                                          final outletId = outlet['id'];
                                    
                                          await Api.user_account_insert(context, domainName, token, outletId: outletId).then((statusCode) async {
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
                                                    setState(() => outletAdded = true );
                                                    setState(() => stillEditing = false );

                                                    Navigator.pop(context, outletAdded);

                                                  } else { FloatingSnackBar(message: 'Something went wrong. Error ${statusCode}.', context: context);
                                                  } setState(() { isLoading = false; });
                                                }); setState(() { isLoading = false; });
                                              });
                                            } else {

                                              if (statusCode == 422) {FloatingSnackBar(message: 'Outlet is already added.', context: context);}
                                              else {FloatingSnackBar(message: 'Something went wrong. Error ${statusCode}.', context: context);}
                                              
                                            } setState(() { isLoading = false; });
                                          });
                                    
                                          setState(() { isLoading = false; });
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