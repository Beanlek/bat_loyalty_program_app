// import 'dart:io';

import 'package:amplify_core/amplify_core.dart';
import 'package:bat_loyalty_program_app/page_homepage/component/local_components.dart';
import 'package:bat_loyalty_program_app/services/awss3.dart';
import 'package:bat_loyalty_program_app/services/global_components.dart';
import 'package:bat_loyalty_program_app/services/global_widgets.dart';
import 'package:bat_loyalty_program_app/services/routes.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';

class HomepagePreview extends StatefulWidget {
  const HomepagePreview({super.key});

  static const routeName = '/preview';

  @override
  State<HomepagePreview> createState() => _HomepagePreviewState();
}

class _HomepagePreviewState extends State<HomepagePreview> with HomeComponents, MyComponents{

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
  Future<void> initParam(BuildContext context, {key, bool needToken = true}) async {
    super.initParam(context);
  }
  
  @override
  Widget build(BuildContext context) { 
    final args = ModalRoute.of(context)!.settings.arguments as MyArguments;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    

    if (!launchLoading) { setPath(prevPath: args.prevPath, routeName: HomepagePreview.routeName);

      urlOriginal = args.urlOriginal!;
      urlOcr = args.urlOcr!;
    }

    print('imageRetake: $imageRetake');
    
    return PopScope(
      canPop: canPop,
      child: launchLoading ? MyWidgets.MyLoading2(context, isDarkMode) : Scaffold(
        body:
    
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column( mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: Center(
                    child: CarouselSlider(
                      options: CarouselOptions(
                        height: MySize.Height(context, 0.5),
                        viewportFraction: 0.9,
                      ),
                      items: [urlOriginal, urlOcr].map((i) {
                        return Builder(
                          builder: (context) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(32),
                              child: Image.network(
                                i,
                                fit: BoxFit.cover,
                              ),
                            
                              // child: Image.file(
                              //   File(receiptImage.path),
                              //   fit: BoxFit.cover,
                              // ),
                            
                            );
                          }
                        );
                      }).toList(),
                    ),
                  )),

                  Padding( padding: const EdgeInsets.only(bottom: 24.0),
                    child: Row( mainAxisAlignment: MainAxisAlignment.spaceAround, crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyWidgets.MyTileButton(context, 'Retake', icon: Icons.refresh_rounded, textStyle: Theme.of(context).textTheme.bodyLarge,
                          iconSize: MySize.Width(context, 0.06),
                          onPressed: () async { Navigator.pop(context, 'retake'); }),

                        MyWidgets.MyTileButton(context, 'Submit', icon: Icons.send, textStyle: Theme.of(context).textTheme.bodyLarge,
                          iconSize: MySize.Width(context, 0.06),
                          onPressed: () async {
                            setState(() { isLoading = true; });
                            
                            try {
                              await AwsS3.uploadImageReceipt(
                                userId: args.username,
                                receipt: receiptImage
                              ).then((res) {
                                if (res == true) {
                                  Navigator.pop(context, true);
                                  
                                  FloatingSnackBar(message: 'Receipt submitted!', context: context);
                                  setState(() { isLoading = false; });
                                } else {
                                  FloatingSnackBar(message: 'Error. ${res}', context: context);
                                  setState(() { isLoading = false; });
                                }
                              });
                            } catch (e) {
                              safePrint(e);
                              FloatingSnackBar(message: 'Error. ${e}', context: context);
                            }
                            
                            // await Future.delayed( Duration(milliseconds: 700 )).whenComplete(() {
                            //   Navigator.pop(context, true);
                              
                            //   FloatingSnackBar(message: 'Receipt submitted!', context: context);
                            //   setState(() { isLoading = false; });
                            // });
                            
                          }),
                      ],
                    ),
                  )
                ],
              ),
            ),
    
            MyWidgets.MyLoading(context, isLoading, isDarkMode)
          ]
        )
      )
    );
  }
}