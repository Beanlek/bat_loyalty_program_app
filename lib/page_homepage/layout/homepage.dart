import 'dart:convert';

import 'package:bat_loyalty_program_app/l10n/l10n.dart';
import 'package:bat_loyalty_program_app/model/product.dart';
import 'package:bat_loyalty_program_app/page_homepage/component/local_components.dart';
import 'package:bat_loyalty_program_app/page_homepage/widget/local_widgets.dart';
import 'package:bat_loyalty_program_app/page_login/layout/login.dart';
import 'package:bat_loyalty_program_app/page_manageoutlet/layout/manageoutlet.dart';
import 'package:bat_loyalty_program_app/page_product/layout/product.dart';
import 'package:bat_loyalty_program_app/page_profile/layout/profile.dart';
import 'package:bat_loyalty_program_app/page_settings/layout/settings.dart';
import 'package:bat_loyalty_program_app/page_track_history/layout/tracking_history.dart';
import 'package:bat_loyalty_program_app/page_imagestatus/layout/imagestatus.dart';
import 'package:bat_loyalty_program_app/page_homepage/layout/homepage_preview.dart';
import 'package:bat_loyalty_program_app/services/api.dart';
import 'package:bat_loyalty_program_app/services/global_components.dart';
import 'package:bat_loyalty_program_app/services/routes.dart';
import 'package:bat_loyalty_program_app/services/shared_preferences.dart';
import 'package:bat_loyalty_program_app/streams/general_stream.dart';
import 'package:bat_loyalty_program_app/services/global_widgets.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  static const routeName = '/homepage';

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with HomeComponents, MyComponents {

VoidCallback? _refreshListener;

  @override
  void initState() {
    super.initState();

  void refreshListener() async {
    print('Homepage: Refresh notifier triggered');
    if (mounted) {
      // Load the new count first
      final newCount = await loadUnopenedCount();
      print('New unopened count: $newCount');
      
      if (mounted) {
        setState(() {
          futureUnopenedCount = Future.value(newCount);  // Use the already loaded value
        });
      }
    }
  }

  ImageStatusNotifier.refreshNotifier.addListener(refreshListener);

  _refreshListener = refreshListener; 

    initParam(context).whenComplete(() {
      setState(() {
        currentLocale = L10n.locals[0]; // Initialize with the first locale
        GeneralStreams.languageStream.stream.listen((locale) => setState(() {
              currentLocale = locale;
            }));
        futureProduct = _loadProducts();
        futureUnopenedCount = loadUnopenedCount();                

        print("currentLocale: $currentLocale");
        launchLoading = false;
      });
    });
     
    setState(() {
    //  futureUnopenedCount = loadUnopenedCount();  
      isRefresh = getIsRefresh();
    });
  }

  @override
  Future<void> initParam(BuildContext context,
      {key, bool needToken = true}) async {
    super.initParam(context);

    await MyPrefs.init().then((prefs) async {
      prefs!;
      final _user = MyPrefs.getUser(prefs: prefs) ?? '{}';
      final _outlets = MyPrefs.getOutlets(prefs: prefs) ?? '{}';     
      user = jsonDecode(_user);
      outlets = jsonDecode(_outlets);
     
    });

    futureLocale = getFutureLocale(context);
  }

  Future<List<Product>> _loadProducts() async {
    dataList = await Api.fetchProducts(domainName, token);      
    filteredDataList = dataList;
    print("dataList: $dataList");
    return dataList;
  }

  Future<int> loadUnopenedCount() async {    
    unopened_count = await Api.fetchUnopenedCount(domainName, token,user['id']);
    print('unopened_count: $unopened_count');
    return unopened_count;
  }


  @override
  void dispose() {
    GeneralStreams.languageStream.close();
    searchController.dispose();

    mainScrollController.dispose();
    searchController.dispose();

    stickyController.dispose();
    productController.dispose();
    
    if (_refreshListener != null) {
    ImageStatusNotifier.refreshNotifier.removeListener(_refreshListener!);
  }
    super.dispose();
    futureLocale = getFutureLocale(context);    
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    futureLocale = getFutureLocale(context);

    return FutureBuilder<AppLocalizations?>(
        future: futureLocale,
        builder: (context, parentSnapshot) {
          if (parentSnapshot.hasData) {
            final Localizations = parentSnapshot.data!;

            return PopScope(
              canPop: false,
              child: launchLoading
                  ? MyWidgets.MyLoading2(context, isDarkMode)
                  : GestureDetector(
                      onTap: () =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                      child: Scaffold(
                          key: scaffoldKey,
                          appBar: HomeWidgets.MyAppBar(
                            context,
                            isDarkMode,
                            appVersion: appVersion,
                            scaffoldKey: scaffoldKey,
                            onTap: () => myPushNamed(context, setState, ProfilePage.routeName,
                                arguments: MyArguments(token,
                                    prevPath: "/home",
                                    user: jsonEncode(user),
                                    outlets: jsonEncode(outlets))),
                            selectedLocal: currentLocale,
                          ),
                          body: FutureBuilder<bool?>(
                              initialData: false,
                              future: isRefresh,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.done) {
                                  if (snapshot.hasError) {
                                    return MyWidgets.MyErrorPage(context, isDarkMode);
                                  } else if (snapshot.hasData) {
                                    isRefresing = snapshot.data!;
                                    print('snapshot has data: $isRefresing');
                                    if (isRefresing) {
                                      refreshPage(context, setState);
                                    }
                                    return Stack(
                                      children: [
                                        CustomMaterialIndicator(
                                          edgeOffset: 10,
                                          backgroundColor: Colors.transparent,
                                          elevation: 0,
                                          onRefresh: () async {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            await refreshPage(context, setState).whenComplete(() => setState(() {isLoading = false;}));},
                                          indicatorBuilder: (context, controller) => Icon(FontAwesomeIcons.rotateRight,size: MySize.Width(context, 0.08),),
                                          child: SizedBox.expand(
                                            child: Padding(
                                              padding:const EdgeInsets.all(3.0),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment:  CrossAxisAlignment.start,
                                                children: [
                                                  // product list
                                                  Expanded(
                                                    child: MyWidgets.MyScrollBar1(
                                                        context,
                                                        controller: mainScrollController,
                                                        child: ListView.builder(
                                                            padding: EdgeInsets.all(9),
                                                            controller:mainScrollController,
                                                            itemCount: 2,
                                                            itemBuilder:(context,index) {
                                                              if (index == 0) {
                                                                return Column(
                                                                  mainAxisAlignment:MainAxisAlignment.start,
                                                                  crossAxisAlignment:CrossAxisAlignment.start,
                                                                    children: [
                                                                      SizedBox(
                                                                          height: MySize.Height(context,0.135),
                                                                          child:Column(
                                                                            mainAxisAlignment:MainAxisAlignment.start,
                                                                            crossAxisAlignment:CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                Localizations.loyalty_points,
                                                                                style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w500),
                                                                              ),
                                                                              Expanded(
                                                                                  child: Row(
                                                                                children: [
                                                                                  Expanded(
                                                                                      child: Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Text(
                                                                                        user['id']!,
                                                                                        style: Theme.of(context).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.normal),
                                                                                      ),
                                                                                      Text.rich(TextSpan(text: user['points'].toString(), style: Theme.of(context).textTheme.displayMedium!.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.outlineVariant), children: [
                                                                                        TextSpan(text: ' pts', style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.outlineVariant))
                                                                                      ]))
                                                                                    ],
                                                                                  )),
                                                                                  Expanded(
                                                                                      child: Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                    MyWidgets.MyTileButton(context, Localizations.tracking_history, icon: Icons.history, onPressed: () => Navigator.pushNamed(context, TrackingHistoryPage.routeName, arguments: MyArguments(token, prevPath: "/home"))),                                                                                                                                                                                                                                                                                                                                                                                                                                        

                                                                                    ValueListenableBuilder<bool>(
                                                                                      valueListenable: ImageStatusNotifier.refreshNotifier,
                                                                                      builder: (context, value, child) {
                                                                                        print('value listenable: $value');
                                                                                        return FutureBuilder(
                                                                                          future: futureUnopenedCount,
                                                                                          builder: (context, snapshot) {
                                                                                            int count = 0;
                                                                                            print('snapshot.data: in value listenable: ${snapshot.data}');
                                                                                            
                                                                                            if (snapshot.hasData) {
                                                                                              count = snapshot.data as int;
                                                                                            } else if (snapshot.hasError) {
                                                                                              print('snapshot.error: ${snapshot.error}');
                                                                                            }

                                                                                            return MyWidgets.MyTileButton(context,Localizations.image_status,icon: Icons.image,onPressed: () async {
                                                                                                print('Navigating to ImageStatusPage');
                                                                                                await myPushNamed(context,setState,ImageStatusPage.routeName,arguments: MyArguments(token,prevPath: "/home",username: user['id'],unopened_count: count,),);
                                                                                                // No need to handle result anymore
                                                                                              },
                                                                                              showBage: count > 0,
                                                                                              BadgeContent: count.toString(),
                                                                                              badgeColor: Theme.of(context).colorScheme.onPrimary,
                                                                                              badgeTextColor: Theme.of(context).colorScheme.primary,
                                                                                            );
                                                                                          },
                                                                                        );
                                                                                      },
                                                                                    ),
                          

                                                                                //     FutureBuilder(
                                                                                //     future: futureUnopenedCount,
                                                                                //     builder: (context, snapshot) {
                                                                                //     int count = 0;                                                                                    
                                                                                //     if (snapshot.hasData) {
                                                                                //       count = snapshot.data as int;
                                                                                //     } else if (snapshot.hasError) {
                                                                                //       print('snapshot.error: ${snapshot.error}');
                                                                                //     }
                                                                                //     return MyWidgets.MyTileButton(context,Localizations.image_status,icon: Icons.image,onPressed: () async {
                                                                                //        print('Navigating to ImageStatusPage'); 
                                                                                //         final result = await myPushNamed(context,setState,ImageStatusPage.routeName,arguments: MyArguments(token,prevPath: "/home",username: user['id'],unopened_count: count,),);
                                                                                //         print('Navigation result from ImageStatusPage: $result');
                                                                                //         if (result == true) {
                                                                                //           setState(() {
                                                                                //             futureUnopenedCount = loadUnopenedCount();
                                                                                //           });
                                                                                //             // unopened_count = await loadUnopenedCount();
                                                                                //             // if(mounted){
                                                                                //             //   setState(() {});
                                                                                //             // }                                                                                                                                                                                             
                                                                                //         await loadUnopenedCount();                                                                                         
                                                                                //         }
                                                                                //       },
                                                                                //       showBage: count > 0,
                                                                                //       BadgeContent: count.toString(),
                                                                                //       badgeColor: Theme.of(context).colorScheme.onPrimary,
                                                                                //       badgeTextColor: Theme.of(context).colorScheme.primary,
                                                                                //     );
                                                                                //   },
                                                                                // ),
                                                                                   
                                                                                    ],
                                                                                  )),
                                                                                ],
                                                                              )),
                                                                            ],
                                                                          )),
                                                                      SizedBox(height:12),
                                                                      Text(
                                                                          Localizations.product_catalogue,
                                                                          style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w500)),
                                                                    ]);
                                                              } else if (index == 1) {
                                                                return StickyHeader(
                                                                    header:
                                                                        Container(
                                                                      color: Theme.of(context).primaryColor,
                                                                      child: Padding(padding: const EdgeInsets.only(bottom: 3.0),
                                                                          child: GradientSearchBar(
                                                                            pageSetState:setState,
                                                                            applyFilters:applyFilters,
                                                                            filtersApplied:filtersApplied,
                                                                            datas: [
                                                                              brandMap,
                                                                              categoryMap
                                                                            ],
                                                                            controller:searchController,
                                                                            focusNode:searchFocusNode,
                                                                            items: [
                                                                              GradientSearchBar.filterMenu(context, title: Localizations.brand, data: brandMap, applyFilters: applyFilters, clearFilters: clearFilters, pageSetState: setState, first: true),
                                                                              GradientSearchBar.filterMenu(context, title: Localizations.category, data: categoryMap, applyFilters: applyFilters, clearFilters: clearFilters, pageSetState: setState),
                                                                            ],
                                                                            onSearch:
                                                                                () {},
                                                                          )),
                                                                    ),
                                                                    content: FutureBuilder(
                                                                      future:futureProduct,
                                                                      builder:(context,snapshot) {
                                                                        if (snapshot.connectionState ==
                                                                            ConnectionState.waiting) {
                                                                          return MyWidgets.MyLoading2(context,isDarkMode);
                                                                        } else if (snapshot.hasError) {
                                                                          return SnackBar(
                                                                            content:Text('${snapshot.error}'),
                                                                          );
                                                                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                                                          return SnackBar(content:Text('No product found.'),
                                                                          );
                                                                        } else { return isSearching || isLoading
                                                                              ? MyWidgets.MyLoading2(context, isDarkMode)
                                                                              : filteredDataList.isEmpty
                                                                                  ? Center(child: Text("No matching products"))
                                                                                  : GridView.builder(
                                                                                      padding: const EdgeInsets.all(15),
                                                                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                                                        crossAxisCount: 2, // row
                                                                                        childAspectRatio: 2.5 / 4,
                                                                                        mainAxisSpacing: 20,
                                                                                        crossAxisSpacing: 20,
                                                                                      ),
                                                                                      itemCount: filteredDataList.length,
                                                                                      shrinkWrap: true,
                                                                                      physics: NeverScrollableScrollPhysics(),
                                                                                      // controller: productController,
                                                                                      itemBuilder: (BuildContext context, int i) {
                                                                                        final product = filteredDataList[i];
                                                                                        return GestureDetector(
                                                                                            onTap: () => Navigator.pushNamed(context,ProductPage.routeName,arguments: MyArguments(token,prevPath: "/home",productId:product.id)),
                                                                                            child: ProductCard(
                                                                                                imageUrl: Image.asset('assets/images_examples/headphone.jpeg'),                                                                                              
                                                                                                title: product.name,
                                                                                                points: product.points,
                                                                                               // onLoveIconTap: () => Navigator.pushNamed(context, ProductPage.routeName, arguments: MyArguments(token, prevPath: "/home", productId: product.id)),
                                                                                                gradient: LinearGradient(
                                                                                                  begin: Alignment.topLeft,
                                                                                                  end: Alignment.bottomRight,
                                                                                                  colors: [
                                                                                                    Theme.of(context).colorScheme.tertiary,
                                                                                                    Theme.of(context).colorScheme.onPrimary,
                                                                                                  ],
                                                                                                )));
                                                                                      },
                                                                                    );
                                                                        }
                                                                      },
                                                                    ));
                                                              } else {
                                                                return SizedBox();
                                                              }
                                                            })),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        MyWidgets.MyLoading(context,(isLoading || isRefresing), isDarkMode)
                                      ],
                                    );
                                  } else {
                                    return MyWidgets.MyLoading2(context, isDarkMode);
                                  }
                                } else {
                                  return MyWidgets.MyLoading2(context, isDarkMode);
                                }
                              }),             
                          floatingActionButton: HomeWidgets.MyFloatingButton(context,60, onTap: () async {
                              try {
                                print("OCR:: Starting image capture process");
                                setState(() {isLoading = true;});

                                bool shouldContinue;
                                do {
                                  shouldContinue = false;
                                  print("OCR:: Attempting to take image");
                                  bool taken = await takeImage(domainName, setState);
                                  print("OCR:: takeImage result: $taken");
                                  
                                  if (taken) {
                                    print('OCR:: Image taken successfully, preparing to navigate to HomepagePreview');
                                    
                                    print('OCR:: Navigating to HomepagePreview');
                                    dynamic submit = await Navigator.of(context).pushNamed(
                                      HomepagePreview.routeName,
                                      arguments: MyArguments(
                                        token,
                                        prevPath: "/home",
                                        urlOriginal: urlOriginal,
                                        urlOcr: urlOcr,
                                        username: user['id'],
                                        imageReceiptId: receiptImageId,
                                        receiptImage: receiptImage                           
                                      )
                                    );
                                    
                                    print('OCR:: HomepagePreview result: $submit');
                                    
                                    if (submit == true) {
                                      print('OCR:: User confirmed image, refreshing page');
                                      await refreshPage(context, setState);
                                    } else if (submit is Map<String, dynamic> && submit['action'] == 'retake') {
                                      print('OCR:: User requested retake, deleting current image');
                                      int result = await Api.deleteImage(domainName, token, receiptImageId);                                      
                                      if (result == 200) {
                                        print('OCR:: Image deleted successfully');
                                        FloatingSnackBar(message: 'Image Receipt deleted!', context: context);
                                        shouldContinue = true;
                                      } else {
                                        print('OCR:: Failed to delete image');
                                        FloatingSnackBar(message: 'Failed to retake!', context: context);
                                      }
                                    } else if(submit is Map<String, dynamic> && submit['action'] == 'calculate') {
                                        // add api here 

                                      final result = await Api.calculatePointReceipts(domainName, token, receiptImageId);

                                          // Check the result and display appropriate messages
                                          if (result['status'] == 'Success') {
                                            FloatingSnackBar(
                                              message: 'Receipts Successfully Submitted. Collected Points: ${result['collected_point']}', 
                                              context: context
                                            );
                                          } else {
                                            FloatingSnackBar(
                                              message: 'Error: ${result['status']}', 
                                              context: context
                                            );
                                          }

                                          print('API result: $result');

                                    }
                                    else{
                                      print('OCR:: Unexpected result from HomepagePreview: $submit');

                                    }

                                  } else {
                                    print('OCR:: Failed to take image');
                                    FloatingSnackBar(message: 'Failed to capture image', context: context);
                                  }
                                } while (shouldContinue);

                              } catch (e, stackTrace) {
                                print("OCR:: Error occurred: $e");
                                print("OCR:: Stack trace: $stackTrace");
                                FloatingSnackBar(message: 'An error occurred: $e', context: context);
                              } finally {
                                print("OCR:: Ending image capture process");
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            }
                          ),                                
                          drawer: HomeWidgets.MyDrawer(context, isDarkMode,
                              appVersion: appVersion,
                              domainName: domainName,
                              items: [
                                HomeWidgets.Item(context,
                                    icon: FontAwesomeIcons.userAlt,
                                    label: Localizations.profile,
                                    onTap: () => myPushNamed(context, setState,
                                        ProfilePage.routeName,
                                        arguments: MyArguments(token,
                                            prevPath: "/home",
                                            user: jsonEncode(user),
                                            outlets: jsonEncode(outlets)))),
                                HomeWidgets.Item(context,
                                    icon: FontAwesomeIcons.storeAlt,
                                    label: Localizations.manage_outlet,
                                    onTap: () {
                                  scaffoldKey.currentState!.closeDrawer();
                                  myPushNamed(context, setState,
                                      ManageOutletPage.routeName,
                                      arguments: MyArguments(token,
                                          prevPath: "/home",
                                          user: jsonEncode(user),
                                          outlets: jsonEncode(outlets)));
                                }),
                                Divider(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onTertiary
                                      .withOpacity(0.5),
                                ),
                                HomeWidgets.Item(context,
                                    icon: FontAwesomeIcons.history,
                                    label: Localizations.track_history,
                                    onTap: () => myPushNamed(context, setState,
                                        TrackingHistoryPage.routeName,
                                        arguments: MyArguments(token,
                                            prevPath: "/home"))),
                                HomeWidgets.Item(context,
                                    icon: FontAwesomeIcons.images,
                                    label: Localizations.image_status,
                                    onTap: () => myPushNamed(context, setState,
                                        ImageStatusPage.routeName,
                                        arguments: MyArguments(token,
                                            prevPath: "/home",
                                            username: user['id']))),
                                Divider(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onTertiary
                                      .withOpacity(0.5),
                                ),
                                HomeWidgets.Item(context,
                                    icon: FontAwesomeIcons.gear,
                                    label: Localizations.settings,
                                    onTap: () => myPushNamed(context, setState,
                                        SettingsPage.routeName,
                                        arguments: MyArguments(token,
                                            prevPath: "/home"))),
                                HomeWidgets.Item(context,
                                    icon: FontAwesomeIcons.signOut,
                                    label: Localizations.log_out,
                                    onTap: () async {
                                  await showDialog(
                                    context: context,
                                    builder: (context) => PopUps.Default(
                                        context, Localizations.logging_out,
                                        subtitle:
                                            Localizations.you_are_logging_out,
                                        warning:
                                            Localizations.progress_not_saved),
                                  ).then((res) async {
                                    if (res ?? false) await Api.logout().whenComplete(() => Navigator.pushNamed(context, LoginPage.routeName));
                                  });
                                }),
                              ]))),
            );
          } else if (parentSnapshot.hasError) {
            return MyWidgets.MyErrorPage(context, isDarkMode);
          } else {
            print(parentSnapshot);
            return MyWidgets.MyLoading2(context, isDarkMode);
          }
        });
  }
}
