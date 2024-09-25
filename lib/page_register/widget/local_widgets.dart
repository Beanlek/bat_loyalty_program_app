import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:country_state_city/country_state_city.dart' as country;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:bat_loyalty_program_app/services/global_components.dart';
import 'package:bat_loyalty_program_app/services/global_widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class RegisterWidgets {

  static Widget MySingleStep(BuildContext context, {required List<Color> gradient}) {
    final _widget = GradientWidget(
      Icon(Icons.circle, size: 12,),

      gradient: LinearGradient(colors: gradient),
    );
  
    return _widget;
  }

  static List<Widget> MySteps(BuildContext context, {required int activeStep, required int totalSteps}) {
    final List<Widget> _widget = [];

    final List<Color> activeGradient = [
      Theme.of(context).colorScheme.secondary,
      Theme.of(context).colorScheme.primary,
    ];
    final List<Color> inactiveGradient = [
      Theme.of(context).colorScheme.tertiary,
      Theme.of(context).colorScheme.onPrimary,
    ];

    for (var i = 0; i < totalSteps; i++) {
      _widget.add(RegisterWidgets.MySingleStep(context,
        gradient: activeStep <= i ? inactiveGradient : activeGradient
      ));
    }
  
    return _widget;
  }

  static Widget PhraseSelection(
    BuildContext context, String text,
    {key, void Function()? onTap, required bool selected}
  ) {
    Color dataColor = !selected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSecondary;
    
    final _widget = StatefulBuilder(
      builder: (context, setState) {

        return InkWell(
          onTap: onTap,
          child: Material(
            elevation: 0,
            borderRadius: BorderRadius.circular(100),
            color: Colors.transparent,
            child: Container(
              height: 45,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: dataColor),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
          
                  colors: selected ? [
                    Theme.of(context).colorScheme.secondary,
                    Theme.of(context).colorScheme.primary,
                  ] : [Colors.transparent, Colors.transparent]
                )
              ),
              child: Center(child: Text(text, style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: dataColor),))
            ),
          ),
        );
      }
    );
  
    return _widget;
  }

  static Widget ImageSelection(
    BuildContext context, String path, bool isDarkMode,
    {key, void Function()? onTap, required bool selected}
  ) {
    final DATA_COLOR = Theme.of(context).colorScheme.primary;
    final SELECTION_WIDTH = MySize.Width(context, 0.43);
    const ICON_SIZE = 52.0;
    
    final _widget = StatefulBuilder(
      builder: (context, setState) {

        return InkWell(
          onTap: onTap,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Material(
                elevation: 0,
                borderRadius: BorderRadius.circular(24),
                color: Colors.transparent,
                child: Container(
                  height: SELECTION_WIDTH,
                  width: SELECTION_WIDTH,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: DATA_COLOR),
                    color: Colors.transparent
                  ),
                  child: Center(child: SizedBox(
                    height: SELECTION_WIDTH - 10,
                    width: SELECTION_WIDTH - 10,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(path, fit: BoxFit.cover,)
                    ),
                  ))
                ),
              ),

              selected ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).primaryColor.withOpacity(isDarkMode ? 0.8 : 0.5)
                ),
                child: Center(
                  child: SizedBox.square(
                    dimension: SELECTION_WIDTH - 10,
                    child: Icon(FontAwesomeIcons.check, size: ICON_SIZE, color: Theme.of(context).colorScheme.primary,),
                  ),
                )
              ) : SizedBox(),
            ],
          ),
        );
      }
    );
  
    return _widget;
  }

  static Widget ConfirmationListTile(BuildContext context,
    { key, required String title, required String subtitle, void Function()? onEdit,
      bool isPhone = false,
      bool isPassword = false,
      bool isImage = false,
    }
  ) {
    const ICON_SIZE = 16.0;
    final LISTTILE_HEIGHT = MySize.Height(context, 0.065);
    final IMAGE_DIMENSION = MySize.Height(context, 0.11);
    
    bool _isPasswordVisible = false;
    subtitle = subtitle != '' ? subtitle : 'N/A';

    final _widget = StatefulBuilder(
      builder: (context, setState) {
        IconButton obscureIconButton() {
          return IconButton(
            iconSize: ICON_SIZE,
            icon: Icon(
              _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
                print('_isPasswordVisible : ${_isPasswordVisible}');
              });
            },
          );
        }

        return SizedBox(
          height: isImage ? null : LISTTILE_HEIGHT,
          child: ListTile(
            contentPadding: EdgeInsets.only(left: 12),
            visualDensity: isImage ? VisualDensity.standard : VisualDensity.compact,
            
            titleTextStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer
            ),
            subtitleTextStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500
            ),
            iconColor: Theme.of(context).colorScheme.primary,
            
            title: Text(title),
            subtitle:
            isImage ?
            Padding( padding: EdgeInsets.only(top: 12), child: Align( alignment: Alignment.centerLeft,
              child: Container(
                height: IMAGE_DIMENSION,
                width: IMAGE_DIMENSION,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Theme.of(context).colorScheme.primary),
                  color: Colors.transparent
                ),
                child: Center(child: SizedBox(
                  height: IMAGE_DIMENSION - 10,
                  width: IMAGE_DIMENSION - 10,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child:
                    (isImage ? !_isPasswordVisible : isImage) ?
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9),
                        color: Theme.of(context).primaryColor
                      ),
                      child: Center(
                        child: SizedBox.square(
                          dimension: IMAGE_DIMENSION - 10,
                          child: Icon(Icons.hide_image, size: ICON_SIZE, color: Theme.of(context).colorScheme.primary,),
                        ),
                      )
                    )
                    : subtitle == 'N/A' ?  Icon(Icons.error, size: ICON_SIZE, color: Theme.of(context).colorScheme.error,) : Image.asset(subtitle, fit: BoxFit.cover,)
                  ),
                ))
              ),
            ))
            : (isPassword ? !_isPasswordVisible : isPassword) ? Text(subtitle.obscure()) : Text(subtitle),
          
            trailing: (isPassword || isImage) ? SizedBox(
              width: MySize.Width(context, 0.25),
              child: Row(
                children: [
                  obscureIconButton(),
                  IconButton(onPressed: onEdit, icon: Icon(Icons.edit, size: ICON_SIZE,)),
                ],
              ),
            ) : isPhone ? SizedBox() :
        
            IconButton(onPressed: onEdit, icon: Icon(Icons.edit, size: ICON_SIZE,)),
          ),
        );
      }
    );
  
    return _widget;
  }

  static Widget Header(BuildContext context,
    {key, required String title, required Widget trailing, Widget? secondTrailing}
  ) {
    final _widget = Row(
      children: [
        Expanded(child: Text(title, style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.primary))),
    
        trailing,
        secondTrailing ?? SizedBox()
      ],
    );
  
    return _widget;
  }

  static Widget MyPage(BuildContext context, {
    required int index,
    required bool isDarkMode,
    required bool stepButtonActive,
    required Map<String, String> errMsgs,
    required List<bool> pageError,
    required String phone,

    required void Function() stepButtonValidation,
    
    void Function()? isLoadingTrue,
    void Function()? isLoadingFalse,

    bool? viewPhrase,
    bool? viewPersonalInfo,
    bool? viewAddress,
    bool? viewOutlet,
    bool? viewSecurity,

    bool? postcodeChanged,

    void Function()? postcodeChangedTrue,
    void Function()? postcodeChangedFalse,

    void Function()? onSubmit,
    void Function()? setOutletList,
    void Function()? onPhraseRefresh,
    void Function()? onImageRefresh,
    void Function()? changeViewPhrase,

    void Function()? changeViewPersonalInfo,
    void Function()? changeViewAddress,
    void Function()? changeViewOutlet,
    void Function()? changeViewSecurity,

    void Function()? toPage1,
    void Function()? toPage2,
    void Function()? toPage3,
    void Function()? toPage4,

    List<dynamic>? states,
    List<dynamic>? city,
    List<String>? stateFilters,
    List<String>? cityFilters,
    List<dynamic>? accounts,
    List<dynamic>? outlets,
    List<String>? accountFilters,
    List<String>? outletFilters,

    List<bool>? imageSelections,
    List<bool>? phraseSelections,
    List<dynamic>? securityImages,
    List<dynamic>? securityImagesTemp,
    List<dynamic>? securityImagesRandomed,
    List<String>? securityPhrases,
    List<dynamic>? securityPhrasesTemp,
    List<dynamic>? securityPhrasesRandomed,

    PageController? pageController,

    TextEditingController? securityImageController,
    TextEditingController? securityPhraseController,

    TextEditingController? usernameController,
    TextEditingController? fullNameController,
    TextEditingController? emailController,
    TextEditingController? passwordController,
    TextEditingController? confirmPasswordController,

    TextEditingController? address1Controller,
    TextEditingController? address2Controller,
    TextEditingController? address3Controller,
    TextEditingController? postcodeController,

    TextEditingController? outletPostcodeController,
    TextEditingController? accountController,
    TextEditingController? outletController,

    FocusNode? usernameFocusnode,
    FocusNode? fullNameFocusnode,
    FocusNode? emailFocusnode,
    FocusNode? passwordFocusnode,
    FocusNode? confirmPasswordFocusnode,

    FocusNode? address1Focusnode,
    FocusNode? address2Focusnode,
    FocusNode? address3Focusnode,
    FocusNode? postcodeFocusnode,

    FocusNode? outletPostcodeFocusnode,

    TextEditingController? stateController,
    TextEditingController? cityController,
  }) {
    final ScrollController page1ScrollController = ScrollController();
    final ScrollController page2ScrollController = ScrollController();
    final ScrollController page3ScrollController = ScrollController();
    final ScrollController page4ScrollController = ScrollController();

    final Localizations = AppLocalizations.of(context);

    Widget _widget;

    switch (index) {
      case 1:
        _widget = StatefulBuilder(
          builder: (context, setState) {
            return MyWidgets.MyScroll1( context,
            height: MySize.Height(context, 0.85),
              controller: page1ScrollController,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        GradientText(Localizations!.personal_information,
                          style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w800),
                          gradient: LinearGradient(colors: [
                            Theme.of(context).colorScheme.secondary,
                            Theme.of(context).colorScheme.primary,
                          ]),
                        ),
                        SizedBox(height: 12,),
                        Text( Localizations.enter_your_personal_information, style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center,),
                        SizedBox(height: 24,),
                                    
                        MyWidgets.MyTextField1(context, Localizations.username, usernameController!, focusNode: usernameFocusnode, compulsory: true,
                          onChanged: (_) => stepButtonValidation(),
                          onSubmit: (_) => fullNameFocusnode!.requestFocus(),
                        ),
                        !pageError[0] ? MyWidgets.MyErrorTextField(context, errMsgs['usernameErrorMsg']! ) : SizedBox(),
                        SizedBox(height: 12,),
                        MyWidgets.MyTextField1(context, Localizations.fullname, fullNameController!, focusNode: fullNameFocusnode, compulsory: true,
                          onChanged: (_) => stepButtonValidation(),
                          onSubmit: (_) => emailFocusnode!.requestFocus(),
                        ),
                        !pageError[1] ? MyWidgets.MyErrorTextField(context, errMsgs['fullNameErrorMsg']! ) : SizedBox(),
                        SizedBox(height: 12,),
                        MyWidgets.MyTextField1(context,Localizations.email, emailController!, focusNode: emailFocusnode,
                          onChanged: (_) => stepButtonValidation(),
                          onSubmit: (_) => passwordFocusnode!.requestFocus(),
                        ),
                        !pageError[2] ? MyWidgets.MyErrorTextField(context, errMsgs['emailErrorMsg']! ) : SizedBox(),
                        SizedBox(height: 12,),
                        MyWidgets.MyTextField1(context, Localizations.password, passwordController!, focusNode: passwordFocusnode, compulsory: true, isPassword: true,
                          onChanged: (_) => stepButtonValidation(),
                          onSubmit: (_) => confirmPasswordFocusnode!.requestFocus(),
                        ),
                        !pageError[3] ? MyWidgets.MyErrorTextField(context, errMsgs['passwordErrorMsg']! ) : SizedBox(),
                        SizedBox(height: 12,),
                        MyWidgets.MyTextField1(context, Localizations.confirm_password, confirmPasswordController!, focusNode: confirmPasswordFocusnode, compulsory: true, isPassword: true,
                          onChanged: (_) => stepButtonValidation(),
                          onSubmit: (_) { confirmPasswordFocusnode!.unfocus(); onSubmit!(); },
                        ),
                        !pageError[4] ? MyWidgets.MyErrorTextField(context, errMsgs['confirmPasswordErrorMsg']! ) : SizedBox(),
                      ],
                    ),
                
                    MyWidgets.MyButton1(context, 150, Localizations.next, active: stepButtonActive,
                      onSubmit
                    ),
                  ],
                ),
              ),
            );
          }
        );
        break;
      case 2:
        _widget = StatefulBuilder(
          builder: (context, setState) {

            return MyWidgets.MyScroll1( context,
            height: MySize.Height(context, 1),
              controller: page2ScrollController,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        GradientText(Localizations!.address,
                          style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.w800),
                          gradient: LinearGradient(colors: [
                            Theme.of(context).colorScheme.secondary,
                            Theme.of(context).colorScheme.primary,
                          ]),
                        ),
                        SizedBox(height: 12,),
                        Text(Localizations.enter_your_shipping_address, style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center,),
                        SizedBox(height: 24,),
                                        
                        MyWidgets.MyTextField1(context, Localizations.unit_no_house_no , address1Controller!, focusNode: address1Focusnode, compulsory: true,
                          onChanged: (_) => stepButtonValidation(),
                          onSubmit: (_) => address2Focusnode!.requestFocus(),
                        ),
                        !pageError[0] ? MyWidgets.MyErrorTextField(context, errMsgs['address1ErrorMsg']! ) : SizedBox(),
                        MyWidgets.MyInfoTextField(context, 'Eg: No. 10 1D/KU6'),
                        SizedBox(height: 12,),
                        MyWidgets.MyTextField1(context, Localizations.street_name, address2Controller!, focusNode: address2Focusnode, compulsory: true,
                          onChanged: (_) => stepButtonValidation(),
                          onSubmit: (_) => address3Focusnode!.requestFocus(),
                        ),
                        !pageError[1] ? MyWidgets.MyErrorTextField(context, errMsgs['address2ErrorMsg']! ) : SizedBox(),
                        MyWidgets.MyInfoTextField(context, 'Eg: Jalan Sumazau'),
                        SizedBox(height: 12,),
                        MyWidgets.MyTextField1(context, Localizations.residential_area, address3Controller!, focusNode: address3Focusnode, compulsory: true,
                          onChanged: (_) => stepButtonValidation(),
                          onSubmit: (_) => address3Focusnode!.unfocus(),
                        ),
                        !pageError[2] ? MyWidgets.MyErrorTextField(context, errMsgs['address3ErrorMsg']! ) : SizedBox(),
                        MyWidgets.MyInfoTextField(context, 'Eg: Bandar Bukit Raja'),
                        SizedBox(height: 24,),
                        
                        MyWidgets.MyTextField3(context, Localizations.state, selectedFilter: stateController!.text, filters: stateFilters!, onChanged: (String? _filter) async {
                          isLoadingTrue!();
                    
                          if (stateController.text == _filter) {
                            isLoadingFalse!();
                    
                            return;
                          }
                    
                          await Future.delayed(const Duration(milliseconds: 700)).whenComplete(() async{
                    
                            if (stateController.text != _filter!) setState((){cityController!.text = 'City';});
                            
                            setState(() {
                              stateController.text = _filter;
                              postcodeController!.text = '';
                              city!.clear();
                              cityFilters!.clear();
                              cityFilters.add('City');
                            });
                    
                            if (stateController.text == 'State') {
                              isLoadingFalse!();
                    
                              return;
                            }
                                      
                            var stateChosen = states!.where((_singleState) {
                              final stateName = _singleState['name'];
                              
                              return stateName.contains(stateController.text);
                            }).toList();
                                      
                            print('stateChosen : ${stateChosen}');
                            var stateCode = stateChosen[0]['isoCode'];
                                      
                            await country.getStateCities('MY',stateCode).then((_cities) {
                              setState(() {
                                for (var i = 0; i < _cities.length; i++) {
                                  var singleCity = _cities[i].toJson();
                                  var cityName = singleCity['name'];
                                  
                                  city!.add(singleCity);
                                  cityFilters!.add(cityName);
                                }
                              });
                              
                              isLoadingFalse!();
            
                              setState(() {
                                stepButtonValidation();
                              });
                            });
                          }); 
                    
                        },),
                        !pageError[3] ? MyWidgets.MyErrorTextField(context, errMsgs['stateErrorMsg']! ) : SizedBox(),
                        SizedBox(height: 12,),
                        MyWidgets.MyTextField3(context, Localizations.city, selectedFilter: cityController!.text, filters: cityFilters!,
                          active: stateController.text == 'State' ? false : true, onChanged: (String? _filter) async{
                            isLoadingTrue!();
                    
                            if (cityController.text == _filter) {
                              isLoadingFalse!();
                    
                              return;
                            }
                    
                            await Future.delayed(const Duration(milliseconds: 400)).whenComplete(() async{
                              if (cityController.text != _filter!) setState((){postcodeController!.text = '';});
                              
                              setState(() {
                                cityController.text = _filter;
                              });
                    
                              var cityChosen = city!.where((_singleCity) {
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
                    
                                isLoadingFalse!();
                                
                                setState(() {
                                  postcodeController!.text = postcode!;
                                  stepButtonValidation();
                                });
                              });
                            });
                        }),
                        !pageError[4] ? MyWidgets.MyErrorTextField(context, errMsgs['cityErrorMsg']! ) : SizedBox(),
                        SizedBox(height: 12,),
                    
                        MyWidgets.MyTextField1(context,Localizations.postcode, postcodeController!, digitOnly: true, focusNode: postcodeFocusnode, compulsory: true,
                          onChanged: (_) => stepButtonValidation(),
                          onSubmit: (_) { postcodeFocusnode!.unfocus(); onSubmit!(); },
                        ),
                        !pageError[5] ? MyWidgets.MyErrorTextField(context, errMsgs['postcodeErrorMsg']! ) : SizedBox(),
                      ],
                    ),
                
                    MyWidgets.MyButton1(context, 150, Localizations.next, active: stepButtonActive,
                      onSubmit
                    ),
                  ],
                ),
              ),
            );
          }
        );
        break;
      case 3:
        _widget = StatefulBuilder(
          builder: (context, setState) {

            double widgetHeight = MySize.Height(context, viewPhrase! ? 1.2 : 0.9);
            double phraseSelectionHeight = MySize.Height(context, 0.35);
            double imageSelectionHeight = MySize.Height(context, 0.5);

            print("viewPhrase : ${viewPhrase}");

            // print("randomsecurityimages: ${securityImagesRandomed}");
            // print("randomsecurityimages.length: ${securityImagesRandomed!.length}");

            return MyWidgets.MyScroll1( context,
            height: widgetHeight,
              controller: page3ScrollController,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        GradientText(Localizations!.security,
                          style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.w800),
                          gradient: LinearGradient(colors: [
                            Theme.of(context).colorScheme.secondary,
                            Theme.of(context).colorScheme.primary,
                          ]),
                        ),
                        SizedBox(height: 12,),
                        Text(Localizations.please_choose_security_phrase_image, style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center,),
                        SizedBox(height: 24,),
                        
                        Header(context, title: Localizations.choose_a_phrase,
                          trailing: IconButton(onPressed: onPhraseRefresh, icon: Icon(FontAwesomeIcons.arrowsRotate, color: Theme.of(context).colorScheme.primary, size: 16,)),
                          secondTrailing: IconButton(onPressed: changeViewPhrase, icon: Icon(viewPhrase ? FontAwesomeIcons.chevronDown : FontAwesomeIcons.chevronLeft, color: Theme.of(context).colorScheme.primary, size: 16,)),
                        ),
                        !viewPhrase ? SizedBox() :
                        SizedBox(
                          height: phraseSelectionHeight,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  PhraseSelection(context, securityPhrasesRandomed![index], selected: phraseSelections![index], onTap: () {
                                    var selected = phraseSelections[index];
                                    print('My phrase $index is tapped!');
                                    
                                    setState((){
                                      securityPhraseController!.text = securityPhrasesRandomed[index];
                                      for (var i = 0; i < phraseSelections.length; i++) { i != (index) ? phraseSelections[i] = false : null;}
                    
                                      phraseSelections[index] = !selected;

                                      if (phraseSelections.every((e) => e == false)) securityPhraseController.clear();
                                      
                                      print('phraseSelections : ${phraseSelections}');

                                      stepButtonValidation();
                                    });
                                  }),
                                  SizedBox(height: 12,),
                                ],
                              );
                            }
                          ),
                        ),
                        
                        Header(context, title: Localizations.choose_an_image,
                          trailing: IconButton(onPressed: onImageRefresh, icon: Icon(FontAwesomeIcons.arrowsRotate, color: Theme.of(context).colorScheme.primary, size: 16,)),
                        ),
                        SizedBox(
                          height: imageSelectionHeight,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: 2,
                            itemBuilder: (context, index) {
                              final count = index*1;
                              // print(securityImagesRandomed![index+count]['path']);
                              // print(securityImagesRandomed![index+1+count]['path']);
                              
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ImageSelection(context, securityImagesRandomed![index+count]['path'], selected: imageSelections![index+count], isDarkMode, onTap: () {
                                        var selected = imageSelections[index+count];
                                        print('My image ${index+count} are tapped : $selected');
                                        
                                        setState((){
                                          securityImageController!.text = securityImagesRandomed[index+count]['path'];
                                          for (var i = 0; i < imageSelections.length; i++) { i != (index+count) ? imageSelections[i] = false : null;}
                    
                                          imageSelections[index+count] = !selected;

                                          if (imageSelections.every((e) => e == false)) securityImageController.clear();
                                          
                                          print('imageSelections : ${imageSelections}');

                                          stepButtonValidation();
                                        });
                                      }),
                                      SizedBox(width: 12,),
                                      ImageSelection(context, securityImagesRandomed[index+1+count]['path'], selected: imageSelections[index+1+count], isDarkMode, onTap: () {
                                        var selected = imageSelections[index+1+count];
                                        print('My image ${index+1+count} are tapped : $selected');
                                        
                                        setState((){
                                          securityImageController!.text = securityImagesRandomed[index+1+count]['path'];
                                          for (var i = 0; i < imageSelections.length; i++) { i != (index+1+count) ? imageSelections[i] = false : null;}
                    
                                          imageSelections[index+1+count] = !selected;

                                          if (imageSelections.every((e) => e == false)) securityImageController.clear();
                                          
                                          print('imageSelections : ${imageSelections}');

                                          stepButtonValidation();
                                        });
                                      }),
                                    ],
                                  ),
                                  SizedBox(height: 12,),
                                ],
                              );
                            }
                          ),
                        )
                      ],
                    ),
                
                    MyWidgets.MyButton1(context, 150, Localizations.next, active: stepButtonActive,
                      onSubmit
                    ),
                  ],
                ),
              ),
            );
          }
        );
        break;
      case 4:
        _widget = StatefulBuilder(
          builder: (context, setState) {
            double pageHeight = MySize.Height(context, 0.75);

            return MyWidgets.MyScroll1( context,
            height: pageHeight,
              controller: page4ScrollController,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        GradientText(Localizations!.outlet_information,
                          style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w800),
                          gradient: LinearGradient(colors: [
                            Theme.of(context).colorScheme.secondary,
                            Theme.of(context).colorScheme.primary,
                          ]),
                        ),
                        SizedBox(height: 12,),
                        Text(Localizations.please_choose_main_workplace_location , style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center,),
                        SizedBox(height: 24,),
                        
                        MyWidgets.MyTextField3(context, Localizations.company , selectedFilter: accountController!.text, filters: accountFilters!,
                          onChanged: (String? _filter) async{
                            if (_filter! == 'Company') {
                              accountController.text = _filter;
                              outletController!.text = 'Outlet';
                              
                              setOutletList!();
                              stepButtonValidation();
                            }
                            
                            isLoadingTrue!();

                            if (accountController.text == _filter) {
                              isLoadingFalse!(); return;
                            }

                            await Future.delayed(const Duration(milliseconds: 400)).whenComplete(() async{
                              if (accountController.text != _filter) setState((){outletController!.text = 'Outlet';});
                              
                              setState((){
                                accountController.text = _filter;
                                print('outletController!.text: ${outletController!.text}');
                                
                                if ( outletPostcodeController!.text != "" ) setOutletList!();
                                isLoadingFalse!();

                                stepButtonValidation();
                              });
                            });
                        }),
                        !pageError[0] ? MyWidgets.MyErrorTextField(context, errMsgs['accountErrorMsg']! ) : SizedBox(),
                        SizedBox(height: 12,),
                        
                        MyWidgets.MyTextField1(context, Localizations.postcode, outletPostcodeController!, focusNode: outletPostcodeFocusnode, compulsory: true, digitOnly: true,
                          onChanged: (_) { stepButtonValidation(); setState((){ postcodeChangedTrue!(); outletController!.text = 'Outlet';}); print('postcodeChanged onChanged: $postcodeChanged');},
                          onSubmit: (_) async {
                            if (outletPostcodeController.text == "") {
                              return;
                            }

                            isLoadingTrue!();

                            await Future.delayed(const Duration(milliseconds: 400)).whenComplete(() async{
                              setState((){ print('postcodeChanged onSubmit: $postcodeChanged');
                                if (postcodeChanged ?? false) { setOutletList!(); postcodeChangedFalse!(); print('postcodeChanged falsed: $postcodeChanged');}
                                isLoadingFalse!();

                                stepButtonValidation();
                              });
                            });
                            
                            outletPostcodeFocusnode!.unfocus();
                          },
                        ),
                        !pageError[1] ? MyWidgets.MyErrorTextField(context, errMsgs['usernameErrorMsg']! ) : SizedBox(),
                        SizedBox(height: 12,),

                        MyWidgets.MyTextField3(context, Localizations.outlet, selectedFilter: outletController!.text, filters: outletFilters!,
                          active: (accountController.text == 'Company' || outletPostcodeController.text == "") ? false : true, onChanged: (String? _filter) async{
                            isLoadingTrue!();

                            if (outletController.text == _filter!) {
                              isLoadingFalse!(); return;
                            }

                            setState((){
                              outletController.text = _filter;
                              isLoadingFalse!();

                              stepButtonValidation();
                            });
                            
                        }),
                        !pageError[2] ? MyWidgets.MyErrorTextField(context, errMsgs['outletErrorMsg']! ) : SizedBox(),
                      ],
                    ),
                
                    Column(
                      children: [
                        MyWidgets.MyButton1(context, 150, Localizations.next, active: stepButtonActive,
                          onSubmit
                        ),
                        SizedBox(height: 12,),
                        MyWidgets.MyInfoTextField2(context, Localizations.choose_main_outlet,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        );
        break;
      case 5:
        _widget = StatefulBuilder(
          builder: (context, setState) {
            double multiplier = 1.8;
            double multiplierPersonalInfo = 0;
            double multiplierAddress = 0;
            double multiplierOutlet = 0;
            double multiplierSecurity = 0;

            if (!viewPersonalInfo!) multiplierPersonalInfo = 0.3;
            if (!viewAddress!) multiplierAddress = 0.5;
            if (!viewOutlet!) multiplierOutlet = 0.2;
            if (!viewSecurity!) multiplierSecurity = 0.3;

            double multiplierTotal = multiplier
              - multiplierPersonalInfo - multiplierAddress - multiplierSecurity - multiplierOutlet;

            double pageHeight = MySize.Height(context, multiplierTotal);
            print('multiplierTotal : ${multiplierTotal}');

            return MyWidgets.MyScroll1( context,
            height: pageHeight,
              controller: page4ScrollController,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        GradientText(Localizations!.confirmation,
                          style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.w800),
                          gradient: LinearGradient(colors: [
                            Theme.of(context).colorScheme.secondary,
                            Theme.of(context).colorScheme.primary,
                          ]),
                        ),
                        SizedBox(height: 12,),
                        Text(Localizations.double_check_info_and_all_set, style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center,),
                        SizedBox(height: 24,),
                        
                        Header(context, title:Localizations.personal_information,
                          trailing: IconButton(onPressed: changeViewPersonalInfo, icon: Icon(viewPersonalInfo ? FontAwesomeIcons.chevronDown : FontAwesomeIcons.chevronLeft, color: Theme.of(context).colorScheme.primary, size: 16,)),
                        ),
                        !viewPersonalInfo ? SizedBox() :
                        Column(children: [
                          ConfirmationListTile(context, title: Localizations.phone_no , subtitle: phone, isPhone: true, onEdit: null),
                          ConfirmationListTile(context, title: Localizations.username, subtitle: usernameController!.text.trim(), onEdit: toPage1),
                          ConfirmationListTile(context, title: Localizations.fullname , subtitle: fullNameController!.text.trim(), onEdit: toPage1),
                        ],),
                    
                        Divider(color: Theme.of(context).colorScheme.onTertiary,),
                        
                        Header(context, title: Localizations.address_information,
                          trailing: IconButton(onPressed: changeViewAddress, icon: Icon(viewAddress ? FontAwesomeIcons.chevronDown : FontAwesomeIcons.chevronLeft, color: Theme.of(context).colorScheme.primary, size: 16,)),
                        ),
                        !viewAddress ? SizedBox() :
                        Column(children: [
                          ConfirmationListTile(context, title: Localizations.unit_no_house_no, subtitle: address1Controller!.text.trim(), onEdit: toPage2),
                          ConfirmationListTile(context, title: Localizations.street_name, subtitle: address2Controller!.text.trim(), onEdit: toPage2),
                          ConfirmationListTile(context, title: Localizations.residential_area, subtitle: address3Controller!.text.trim(), onEdit: toPage2),
                          ConfirmationListTile(context, title: Localizations.state, subtitle: stateController!.text.trim(), onEdit: toPage2),
                          ConfirmationListTile(context, title: Localizations.city, subtitle: cityController!.text.trim(), onEdit: toPage2),
                          ConfirmationListTile(context, title: Localizations.postcode, subtitle: postcodeController!.text.trim(), onEdit: toPage2),
                        ],),
                    
                        Divider(color: Theme.of(context).colorScheme.onTertiary,),
                        
                        Header(context, title: Localizations.outlet_information,
                          trailing: IconButton(onPressed: changeViewOutlet, icon: Icon(viewOutlet ? FontAwesomeIcons.chevronDown : FontAwesomeIcons.chevronLeft, color: Theme.of(context).colorScheme.primary, size: 16,)),
                        ),
                        !viewOutlet ? SizedBox() :
                        Column(children: [
                          ConfirmationListTile(context, title: Localizations.company, subtitle: accountController!.text.trim(), onEdit: toPage4),
                          ConfirmationListTile(context, title: Localizations.outlet, subtitle: outletController!.text.trim(), onEdit: toPage4),
                        ],),
                    
                        Divider(color: Theme.of(context).colorScheme.onTertiary,),
                        
                        Header(context, title: Localizations.security_information,
                          trailing: IconButton(onPressed: changeViewSecurity, icon: Icon(viewSecurity ? FontAwesomeIcons.chevronDown : FontAwesomeIcons.chevronLeft, color: Theme.of(context).colorScheme.primary, size: 16,)),
                        ),
                        !viewSecurity ? SizedBox() :
                        Column(children: [
                          ConfirmationListTile(context, title: Localizations.password , subtitle: passwordController!.text.trim(), isPassword: true, onEdit: toPage1),
                          ConfirmationListTile(context, title: Localizations.security_image, subtitle: securityImageController!.text.trim(), isImage: true, onEdit: toPage3),
                          ConfirmationListTile(context, title: Localizations.security_phrase, subtitle: securityPhraseController!.text.trim(), isPassword: true, onEdit: toPage3),
                        ],),
                      ],
                    ),
                
                    MyWidgets.MyButton1(context, 150, Localizations.register, active: stepButtonActive,
                      onSubmit
                    ),
                  ],
                ),
              ),
            );
          }
        );
        break;
      default:
        _widget = Center(child: Text('Page N/A'),);
    }
  
    return _widget;
  }

}