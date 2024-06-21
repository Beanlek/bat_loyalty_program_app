import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:bat_loyalty_program_app/services/shared_preferences.dart';
import 'package:bat_loyalty_program_app/services/routes.dart';
import 'package:bat_loyalty_program_app/services/theme.dart';
import 'package:bat_loyalty_program_app/services/api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  String domainName = dotenv.env['DOMAIN_LOCAL']!;
  
  String initRoute = '/login';

  await Api.checkToken().then((res) async {
    await MyPrefs.init().then((prefs) {
      prefs!;

      MyPrefs.setDomainName(domainName, prefs: prefs);
      MyPrefs.setAppVersion(prefs: prefs);
      MyPrefs.setDeviceID(prefs: prefs);

      // if (res) initRoute = '/homepage';
    });
  });

  runApp(MyApp(initRoute));
}

class MyApp extends StatelessWidget {
  const MyApp(this.initRoute, {super.key});

  final String initRoute;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'BAT Loyalty Program',

      routes: MyRoutes.routes,

      theme: MyTheme.light,
      darkTheme: MyTheme.dark,

      initialRoute: initRoute,
      // home: LoginPage(),
    );
  }
}
