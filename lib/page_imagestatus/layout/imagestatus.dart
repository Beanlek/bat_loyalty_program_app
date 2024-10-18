import 'dart:convert';

import 'package:bat_loyalty_program_app/page_imagestatus/component/local_components.dart';
import 'package:bat_loyalty_program_app/page_imagestatus/widget/local_widgets.dart';
import 'package:bat_loyalty_program_app/services/global_components.dart';
import 'package:bat_loyalty_program_app/services/global_widgets.dart';
import 'package:bat_loyalty_program_app/services/routes.dart';
import 'package:bat_loyalty_program_app/services/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';

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
    initParam(context).whenComplete(() { 
      setState(() {
         launchLoading = false; 
         }); 

          pagingController.addPageRequestListener((pageKey) {
            print('Page request listener called for page: $pageKey');
          if (!isFetchingNextPage) {
            fetchPage(pageKey, token, domainName);
          }
        });
      });  
  }
  

  @override
  Future<void> initParam(BuildContext context, {key, bool needToken = true}) async {
    await super.initParam(context); 
    await setAccountImages();
    
    dateTime = DateFormat('dd/MM/yyyy').add_Hms();
  }

    @override
  Future<void> refreshPage(BuildContext context, void Function(void Function() fn) setState) async {  
    await super.refreshPage(context, setState).whenComplete(() async {
      await MyPrefs.init().then((prefs) async { prefs!;
        final _user = MyPrefs.getUser(prefs: prefs) ?? '{}';
        setState(() { user = jsonDecode(_user); });
      });      
      pagingController.refresh();   
    });
  }

    @override
void dispose() { 
  mainScrollController.dispose();
  pagingController.dispose();
  super.dispose();
}
  
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as MyArguments;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Localizations = AppLocalizations.of(context);

    if (launchLoading){            
      final userMap = jsonDecode(args.user); user = Map.from(userMap); print('user: $user');            
    } 

    if (!launchLoading){
      setPath(prevPath: args.prevPath, routeName: ImageStatusPage.routeName);
    } 
    
    return PopScope(
      canPop: canPop,
      child: launchLoading 
      ? MyWidgets.MyLoading2(context, isDarkMode) 
      : GestureDetector( onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
       child: Scaffold(
        appBar: MyWidgets.MyAppBar(context, isDarkMode, Localizations!.image_status, appVersion: appVersion),
        body:    
        FutureBuilder<bool?>(
          initialData: false,
          future: isRefresh,
          builder: (context, snapshot) { if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return MyWidgets.MyErrorPage(context, isDarkMode);
            } else if (snapshot.hasData) 
            {
              isRefresing = snapshot.data!;
              print('snapshot has data: $isRefresing');

          return 
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
                      datas: [dateMap],                      
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
                              child: RefreshIndicator(
                                  onRefresh: () => Future.sync(() => pagingController.refresh()),
                                  child: PagedListView<int,MapEntry<String, List<Map<String, dynamic>>>> (
                                    pagingController: pagingController,
                                    scrollController: mainScrollController,                                    
                                    builderDelegate: PagedChildBuilderDelegate<MapEntry<String, List<Map<String, dynamic>>>>(
                                    newPageProgressIndicatorBuilder: (context) => Center(child: CircularProgressIndicator(),),  
                                    itemBuilder: (context, item, index) {return ImageStatusWidgets.buildDateGroup(context, item.key, item.value, args,domainName,token);},
                                    firstPageErrorIndicatorBuilder: (context) => MyWidgets.MyErrorPage(context, isDarkMode),
                                    noItemsFoundIndicatorBuilder: (context) => Center(child: Column(
                                        children: [
                                          Text('No items found'),
                                          TextButton(onPressed: () => pagingController.refresh(), child: Text('Refresh'))
                                        ],
                                      ),
                                    ),)                                      
                                   )
                                 )                                                                                                                               
                                ),
                              ),                                                                                                                     
                          ],
                      )
                    ),                
                    MyWidgets.MyLoading(context, isLoading, isDarkMode)
                  ]
                );         
              } else {
              return MyWidgets.MyLoading2(context, isDarkMode);
              }
            } else { 
              return MyWidgets.MyLoading2(context, isDarkMode);
            }
            }
         )
      ))
    );
  }



}

