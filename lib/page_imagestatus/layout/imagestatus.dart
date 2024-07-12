import 'package:bat_loyalty_program_app/page_imagestatus/component/local_components.dart';
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
    initParam().whenComplete(() { setState(() { launchLoading = false; }); });
  
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

    final imageDimension = MySize.Width(context, 0.3);
    
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
                        // itemCount: sections.length,
                        itemCount: 2,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          // return Column( mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [ sections[index] ],
                          // );
                          
                          return Column( mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Today', style: Theme.of(context).textTheme.bodyMedium,),
                              SizedBox(height: 12,),

                              GridView.builder(
                                padding: const EdgeInsets.only(right: 12, bottom: 12),
                                shrinkWrap: true, physics: NeverScrollableScrollPhysics(),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount( crossAxisCount: 3,
                                  mainAxisSpacing: 8, crossAxisSpacing: 8,
                                ),

                                itemCount: 4,
                                itemBuilder: (context, index) {
                                  // return Container(width: imageDimension, height: imageDimension, color: Colors.amber, child: Text('Image'));
                        // done
                                  return InkWell(
                                    onTap: () {},
                                    child: Material(
                                      elevation: 0,
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.transparent,
                                      child: Container(
                                        height: imageDimension,
                                        width: imageDimension,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: Theme.of(context).colorScheme.primary),
                                          color: Colors.transparent
                                        ),
                                        child: Center(child: SizedBox.square( dimension: imageDimension,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Image.asset(receipts[1][index], fit: BoxFit.cover,)),
                                        )
                                        )
                                      ),
                                    ),
                                  );
                                },
                              ),
                              
                              SizedBox(height: 12,),
                            ],
                          );
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