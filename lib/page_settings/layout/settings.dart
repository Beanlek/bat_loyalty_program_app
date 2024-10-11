import 'package:bat_loyalty_program_app/page_settings/component/local_components.dart';
import 'package:bat_loyalty_program_app/services/global_components.dart';
import 'package:bat_loyalty_program_app/services/global_widgets.dart';
import 'package:bat_loyalty_program_app/services/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  static const routeName = '/settings';

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with SettingsComponents, MyComponents{
  
  @override
  void initState() {
    super.initState();
    
    initParam(context, needToken: false).whenComplete(() { setState(() { launchLoading = false; }); });
  }

  @override
  void dispose() { 
    mainScrollController.dispose();
    
    super.dispose();
  }
  
  @override
  Future<void> initParam(BuildContext context, {key, bool needToken = true}) async {
    super.initParam(context);
    
    // dateTime = DateFormat('dd/MM/yyyy').add_Hms();
  }
  
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as MyArguments;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Localizations = AppLocalizations.of(context);
    // final outletsMap = jsonDecode(args.outlets); outlets = Map.from(outletsMap);
    
    if (!launchLoading) setPath(prevPath: args.prevPath, routeName: SettingsPage.routeName);

    return PopScope(
      // onPopInvoked: (value) {
      //   if (value) return;

      //   showDialog(context: context, builder: (context) => PopUps.Default(context, 'Unsaved Data',
      //     confirmText: 'Yes',
      //     cancelText: 'Continue Editing',
      //     subtitle: 'Are you sure you want to exit this page?', warning: 'Once exit, all progress will not be saved.'),).then((res) async {
      //       canPop = res; if (res) Navigator.pop(context);
      //     });
      // },
      canPop: canPop,
      child: launchLoading ? MyWidgets.MyLoading2(context, isDarkMode) : GestureDetector( onTap: () => FocusManager.instance.primaryFocus?.unfocus(), child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: MyWidgets.MyAppBar(context, isDarkMode, Localizations!.settings, appVersion: appVersion),
        
        body:
        
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column( mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0), child: Breadcrumb(paths: paths)),
                      
                  Expanded(child: Center(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(Localizations.settings),
                      Text('Coming soon'),
                    ],
                  ))),
                ],
              ),
            ),

            MyWidgets.MyLoading(context, isLoading, isDarkMode)
          ],
        ),),
    ));
  }
}