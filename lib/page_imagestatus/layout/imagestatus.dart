import 'package:bat_loyalty_program_app/page_imagestatus/component/local_components.dart';
import 'package:bat_loyalty_program_app/page_imagestatus/widget/local_widgets.dart';
import 'package:bat_loyalty_program_app/services/global_components.dart';
import 'package:bat_loyalty_program_app/services/global_widgets.dart';
import 'package:bat_loyalty_program_app/services/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ImageStatusPage extends StatefulWidget {
  const ImageStatusPage({super.key});

  static const routeName = '/image_status';

  @override
  State<ImageStatusPage> createState() => _ImageStatusPageState();
}

class _ImageStatusPageState extends State<ImageStatusPage> with ImageStatusComponents, MyComponents {
  @override
  void initState() {
    super.initState();
  
    initParam(context).whenComplete(() { setState(() { launchLoading = false; }); });
  }
  
  @override
  void dispose() {
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as MyArguments;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Localizations = AppLocalizations.of(context);

    if (!launchLoading) setPath(prevPath: args.prevPath, routeName: ImageStatusPage.routeName);
    
    return PopScope(
      canPop: canPop,
      child: launchLoading ? MyWidgets.MyLoading2(context, isDarkMode) : GestureDetector( onTap: () => FocusManager.instance.primaryFocus?.unfocus(), child: Scaffold(
        appBar: MyWidgets.MyAppBar(context, isDarkMode, Localizations!.image_status, appVersion: appVersion),
        body:
    
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column( mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0), child: Breadcrumb(paths: paths)),

                  GradientSearchBar( pageSetState: setState,
                    applyFilters: applyFilters,
                    filtersApplied: filtersApplied,
                    datas: [ dateMap ],
                                    
                    controller: searchController,
                    focusNode: searchFocusNode,

                    items: [
                      GradientSearchBar.filterMenu(context, title: 'Date', data: dateMap, single: true,
                        applyFilters: applyFilters, clearFilters: clearFilters, pageSetState: setState, first: true),
                    ],
                    onSearch: () {},
                  ),

                  Expanded(
                    child: MyWidgets.MyScrollBar1(context, controller: mainScrollController,
                      child: ListView.builder(                                                            
                        controller: mainScrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: receipts.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          print('inside listview');
                          List<Map<dynamic, dynamic>> receipt = receipts.values.elementAt(index);
                          String date = receipts.keys.elementAt(index);
                          print('image status page : ${receipt.length}');
                          print('date: $date');
                          String imagePath = 'assets/account_images/company.png';                          
                        
                        return ImageStatusWidgets.receiptCard(context: context, date: date, imagePath: imagePath, status:'In Proccess' , createdAt: '2024-07-03 09:11:30',);                        
                        },
                      ),
                   
                    ),
                  ),
                  
                  // Expanded(
                  //   child: MyWidgets.MyScrollBar1( context, controller: mainScrollController,
                  //     child: ListView.builder( controller: mainScrollController,
                  //       padding: const EdgeInsets.symmetric(horizontal: 12),
                  //       itemCount: receipts.length,
                  //       physics: AlwaysScrollableScrollPhysics(),
                  //       itemBuilder: (context, index) {
                  //         List<Map<dynamic, dynamic>> receipt = receipts.values.elementAt(index);
                  //         String date = receipts.keys.elementAt(index);
                          
                  //         return ImageStatusWidgets.ReceiptSections(context, date, receipt: receipt, userId: args.username);
                  //       },
                  //     ),
                  //   ),
                  // ),
                
                
                ],
              )
            ),
    
            MyWidgets.MyLoading(context, isLoading, isDarkMode)
          ]
        )
      ))
    );
  }
}