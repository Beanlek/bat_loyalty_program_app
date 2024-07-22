import 'dart:convert';
import 'package:bat_loyalty_program_app/l10n/l10n.dart';
import 'package:bat_loyalty_program_app/streams/general_stream.dart';
import 'package:bat_loyalty_program_app/services/awss3.dart';
import 'package:flutter/material.dart';

import 'package:bat_loyalty_program_app/services/shared_preferences.dart';
import 'package:bat_loyalty_program_app/services/routes.dart';
import 'package:bat_loyalty_program_app/services/theme.dart';
import 'package:bat_loyalty_program_app/services/api.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await AwsS3.configure();

  await Api.setAllDomain();
  String initRoute = '/login';
  String? domainName;

  await Api.checkToken('_', main: true).then((res) async {
    await MyPrefs.init().then((prefs) {
      prefs!;

      final allDomainString = MyPrefs.getAllDomain(prefs: prefs)!;
      Map<String, dynamic> allDomain = jsonDecode(allDomainString);

      print("allDomain['master'] : ${allDomain['master']}");
      domainName = MyPrefs.getDomainName(prefs: prefs) ?? allDomain['master'];
      print("domainName : ${domainName}");

      MyPrefs.setDomainName(domainName!, prefs: prefs);
      MyPrefs.setAppVersion(prefs: prefs);
      MyPrefs.setDeviceID(prefs: prefs);

      if (res) initRoute = '/homepage';
    });
  });

  runApp(MyApp(initRoute));
}

class MyApp extends StatelessWidget {
  const MyApp(this.initRoute, {super.key});

  final String initRoute;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Locale>(
      stream: GeneralStreams.languageStream.stream,
      builder: (context, snapshot) {
        Locale locale = snapshot.data ?? const Locale('en');
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          title: 'BAT Loyalty Program',

          routes: MyRoutes.routes,

          theme: MyTheme.light,
          darkTheme: MyTheme.dark,

          initialRoute: initRoute,
          supportedLocales: L10n.locals,
          locale: locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          // home: LoginPage(),
        );
      },
    );
  }
}
