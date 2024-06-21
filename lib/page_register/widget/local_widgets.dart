import 'package:flutter/material.dart';

import 'package:bat_loyalty_program_app/services/global_widgets.dart';
import 'package:country_state_city/country_state_city.dart' as country;
import 'package:geocoding/geocoding.dart';

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

  static Widget MyPage(BuildContext context, {
    required int index, void Function()? onSubmit,
    required bool isDarkMode,
    List<dynamic>? states,
    List<dynamic>? city,
    List<String>? stateFilters,
    List<String>? cityFilters,

    TextEditingController? usernameController,
    TextEditingController? fullNameController,
    TextEditingController? emailController,
    TextEditingController? passwordController,
    TextEditingController? confirmPasswordController,

    TextEditingController? address1Controller,
    TextEditingController? address2Controller,
    TextEditingController? address3Controller,
    TextEditingController? postcodeController,

    TextEditingController? stateController,
    TextEditingController? cityController,
  }) {
    final ScrollController page1ScrollController = ScrollController();
    final ScrollController page2ScrollController = ScrollController();
    final ScrollController page3ScrollController = ScrollController();
    final ScrollController page4ScrollController = ScrollController();

    bool isLoading = false;

    Widget _widget;

    switch (index) {
      case 1:
        _widget = MyWidgets.MyScroll1( context,
        height: MySize.Height(context, 0.85),
          controller: page1ScrollController,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    GradientText('Personal Information',
                      style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w800),
                      gradient: LinearGradient(colors: [
                        Theme.of(context).colorScheme.secondary,
                        Theme.of(context).colorScheme.primary,
                      ]),
                    ),
                    SizedBox(height: 12,),
                    Text('Enter your personal information.', style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center,),
                    SizedBox(height: 24,),
            
                    MyWidgets.MyTextField1(context, 'Username', usernameController!, compulsory: true),
                    SizedBox(height: 12,),
                    MyWidgets.MyTextField1(context, 'Full Name', fullNameController!, compulsory: true),
                    SizedBox(height: 12,),
                    MyWidgets.MyTextField1(context, 'Email', emailController!),
                    SizedBox(height: 12,),
                    MyWidgets.MyTextField1(context, 'Password', passwordController!, compulsory: true, isPassword: true),
                    SizedBox(height: 12,),
                    MyWidgets.MyTextField1(context, 'Confirm Password', confirmPasswordController!, compulsory: true, isPassword: true),
                  ],
                ),
            
                MyWidgets.MyButton1(context, 150, 'Next', 
                  onSubmit
                ),
              ],
            ),
          ),
        );
        break;
      case 2:
        _widget = StatefulBuilder(
          builder: (context, setState) {

            return Stack(
              children: [
                
                MyWidgets.MyScroll1( context,
                height: MySize.Height(context, 1),
                  controller: page2ScrollController,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            GradientText('Address',
                              style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.w800),
                              gradient: LinearGradient(colors: [
                                Theme.of(context).colorScheme.secondary,
                                Theme.of(context).colorScheme.primary,
                              ]),
                            ),
                            SizedBox(height: 12,),
                            Text('Enter your shipping address.', style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center,),
                            SizedBox(height: 24,),
                    
                            MyWidgets.MyTextField1(context, 'Unit No. / House No.', address1Controller!, compulsory: true),
                            Align(alignment: Alignment.centerLeft, 
                              child: Padding(
                                padding: const EdgeInsets.only(left: 24.0, top: 6, bottom: 2),
                                child: Text('Eg: No. 10 1D/KU6', style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                  color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.5),
                                  fontWeight: FontWeight.normal
                                )),
                              )),
                            SizedBox(height: 12,),
                            MyWidgets.MyTextField1(context, 'Street Name', address2Controller!, compulsory: true),
                            Align(alignment: Alignment.centerLeft, 
                              child: Padding(
                                padding: const EdgeInsets.only(left: 24.0, top: 6, bottom: 2),
                                child: Text('Eg: Jalan Sumazau', style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                  color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.5),
                                  fontWeight: FontWeight.normal
                                )),
                              )),
                            SizedBox(height: 12,),
                            MyWidgets.MyTextField1(context, 'Residential Area', address3Controller!, compulsory: true),
                            Align(alignment: Alignment.centerLeft, 
                              child: Padding(
                                padding: const EdgeInsets.only(left: 24.0, top: 6, bottom: 2),
                                child: Text('Eg: Bandar Bukit Raja', style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                  color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.5),
                                  fontWeight: FontWeight.normal
                                )),
                              )),
                            SizedBox(height: 24,),
                            
                            MyWidgets.MyTextField3(context, 'State', selectedFilter: stateController!.text, filters: stateFilters!, onChanged: (String? _filter) async {
                              setState(() {
                                isLoading = true;
                              });

                              if (stateController.text == _filter) {
                                setState(() {
                                  isLoading = false;
                                });

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
                                  setState(() {
                                    isLoading = false;
                                    print('finished...');
                                  });

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
                                  
                                  setState(() {
                                    isLoading = false;
                                  });
                                });
                              }); 

                            },),
                            SizedBox(height: 12,),
                            MyWidgets.MyTextField3(context, 'City', selectedFilter: cityController!.text, filters: cityFilters!,
                              active: stateController.text == 'State' ? false : true, onChanged: (String? _filter) async{
                                setState(() {
                                  isLoading = true;
                                });

                                if (cityController.text == _filter) {
                                  setState(() {
                                    isLoading = false;
                                  });

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

                                    setState(() {
                                      postcodeController!.text = postcode!;
                                      isLoading = false;
                                    });
                                  });
                                });
                            }),
                            SizedBox(height: 12,),
                            MyWidgets.MyTextField1(context, 'PostCode', postcodeController!, digitOnly: true, compulsory: true)
                          ],
                        ),
                    
                        MyWidgets.MyButton1(context, 150, 'Next', 
                          onSubmit
                        ),
                      ],
                    ),
                  ),
                ),

                MyWidgets.MyLoading(context, isLoading, isDarkMode)
              ],
            );
          }
        );
        break;
      case 3:
        _widget = StatefulBuilder(
          builder: (context, setState) {

            return Stack(
              children: [
                
                MyWidgets.MyScroll1( context,
                height: MySize.Height(context, 1),
                  controller: page3ScrollController,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            GradientText('Security',
                              style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.w800),
                              gradient: LinearGradient(colors: [
                                Theme.of(context).colorScheme.secondary,
                                Theme.of(context).colorScheme.primary,
                              ]),
                            ),
                            SizedBox(height: 12,),
                            Text('Please choose a security phrase along with\na security image.', style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center,),
                            SizedBox(height: 24,),

                          ],
                        ),
                    
                        MyWidgets.MyButton1(context, 150, 'Next', 
                          onSubmit
                        ),
                      ],
                    ),
                  ),
                ),

                MyWidgets.MyLoading(context, isLoading, isDarkMode)
              ],
            );
          }
        );
        break;
      case 4:
        _widget = StatefulBuilder(
          builder: (context, setState) {

            return Stack(
              children: [
                
                MyWidgets.MyScroll1( context,
                height: MySize.Height(context, 1),
                  controller: page4ScrollController,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            GradientText('Confirmation',
                              style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.w800),
                              gradient: LinearGradient(colors: [
                                Theme.of(context).colorScheme.secondary,
                                Theme.of(context).colorScheme.primary,
                              ]),
                            ),
                            SizedBox(height: 12,),
                            Text('Double check your information and you are all set!', style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center,),
                            SizedBox(height: 24,),
                            
                          ],
                        ),
                    
                        MyWidgets.MyButton1(context, 150, 'Next', 
                          onSubmit
                        ),
                      ],
                    ),
                  ),
                ),

                MyWidgets.MyLoading(context, isLoading, isDarkMode)
              ],
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