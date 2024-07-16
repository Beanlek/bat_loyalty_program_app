import 'package:bat_loyalty_program_app/services/global_components.dart';
import 'package:bat_loyalty_program_app/services/global_widgets.dart';
import 'package:bat_loyalty_program_app/services/routes.dart';
import 'package:flutter/material.dart';

class Dummy extends StatefulWidget {
  const Dummy({super.key});

  static const routeName = '/dummy';

  @override
  State<Dummy> createState() => _DummyState();
}

class _DummyState extends State<Dummy> with MyComponents{
  
  @override
  void initState() {
    initParam(context, needToken: false).whenComplete(() { setState(() { launchLoading = false; }); });
    
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as MyArguments;
    if (!launchLoading) setPath(prevPath: args.prevPath, routeName: Dummy.routeName);

    return Scaffold(body: Center(child: Column( mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Breadcrumb(paths: paths),

        Text('Dummy'),
      ],
    )),);
  }
}