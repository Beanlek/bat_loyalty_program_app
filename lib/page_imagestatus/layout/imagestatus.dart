import 'package:bat_loyalty_program_app/page_imagestatus/component/local_components.dart';
import 'package:bat_loyalty_program_app/page_imagestatus/widget/local_widgets.dart';
import 'package:bat_loyalty_program_app/services/global_components.dart';
import 'package:bat_loyalty_program_app/services/global_widgets.dart';
import 'package:bat_loyalty_program_app/services/routes.dart';
import 'package:flutter/material.dart';

class ImageStatusPage extends StatefulWidget {
  const ImageStatusPage({super.key});

  static const routeName = '/image_status';

  @override
  State<ImageStatusPage> createState() => _ImageStatusPageState();
}

class _ImageStatusPageState extends State<ImageStatusPage> with ImageStatusComponents, MyComponents {
  @override
  void initState() {
    initParam(context).whenComplete(() { setState(() { launchLoading = false; }); });
  
    super.initState();
  }
  
  @override
  void dispose() {
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as MyArguments;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (!launchLoading) setPath(prevPath: args.prevPath, routeName: ImageStatusPage.routeName);
    
    return PopScope(
      canPop: true,
      child: launchLoading ? MyWidgets.MyLoading2(context, isDarkMode) : Scaffold(
        appBar: MyWidgets.MyAppBar(context, isDarkMode, 'Image Status', appVersion: appVersion),
        body:
    
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column( mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0), child: Breadcrumb(paths: paths)),

                  GradientSearchBar(
                    controller: searchController,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).colorScheme.tertiary,
                        Theme.of(context).colorScheme.onPrimary,
                      ],
                    ),
                  ),

                  Expanded(
                    child: MyWidgets.MyScrollBar1( context, controller: mainScrollController,
                      child: ListView.builder( controller: mainScrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: receipts.length,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          List<Map<dynamic, dynamic>> receipt = receipts.values.elementAt(index);
                          String date = receipts.keys.elementAt(index);
                          
                          return ImageStatusWidgets.ReceiptSections(context, date, receipt: receipt, userId: args.username);
                        },
                      ),
                    ),
                  ),
                ],
              )
            ),
    
            MyWidgets.MyLoading(context, isLoading, isDarkMode)
          ]
        )
      )
    );
  }
}