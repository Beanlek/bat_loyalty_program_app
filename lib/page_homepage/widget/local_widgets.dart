import 'package:bat_loyalty_program_app/l10n/l10n.dart';
import 'package:bat_loyalty_program_app/streams/general_stream.dart';
import 'package:flutter/material.dart';

import 'package:bat_loyalty_program_app/services/global_widgets.dart';
import 'package:bat_loyalty_program_app/services/theme.dart';

class HomeWidgets {
  static Widget MyDrawer(BuildContext context, bool isDarkMode,
      {key,
      required String appVersion,
      required String domainName,
      required List<Widget> items}) {
    final _widget = Drawer(
      width: MySize.Width(context, 0.6),
      backgroundColor: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24.0, 24.0, 12, 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              child: Padding(
                padding: const EdgeInsets.only(top: 32.0, left: 10, right: 44),
                child: Image.asset(
                  isDarkMode
                      ? 'assets/logos/bat-logo-white.png'
                      : 'assets/logos/bat-logo-default.png',
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              'Version ${appVersion}\nDomain ${domainName}',
              style: Theme.of(context)
                  .textTheme
                  .labelSmall!
                  .copyWith(fontWeight: FontWeight.w300, fontSize: 8),
            ),
            SizedBox(
              height: 24,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items,
            )
          ],
        ),
      ),
    );

    return _widget;
  }

  static Widget Item(BuildContext context,
      {key,
      required IconData icon,
      required String label,
      void Function()? onTap}) {
    final Color ITEM_COLOR = Theme.of(context).colorScheme.onTertiary;

    final _widget = ListTile(
      leading: Icon(
        icon,
        color: ITEM_COLOR,
        size: 16,
      ),
      title: Text(label,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: ITEM_COLOR, fontWeight: FontWeight.w500)),
      dense: true,
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
    );

    return _widget;
  }

  static PreferredSizeWidget MyAppBar(BuildContext context, bool isDarkMode,
      {key,
      required String appVersion,
      required GlobalKey<ScaffoldState> scaffoldKey,
      void Function()? onTap,
      required Locale selectedLocal}) {
    final _widget = AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      leading: IconButton(
        onPressed: () {
          scaffoldKey.currentState!.openDrawer();
        },
        icon: Icon(
          Icons.menu,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Locale newLocale = selectedLocal.languageCode == 'en'
                ? const Locale('bn')
                : const Locale('en');
            GeneralStreams.languageStream.add(newLocale);
            //  Locale newLocale = L10n.locals.firstWhere((element) => element != selectedLocal);
            //GeneralStreams.languageStream.add(L10n.locals.firstWhere((element) => element != selectedLocal));
          },
          icon: Icon(Icons.language,
              color: Theme.of(context).colorScheme.secondary),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12.0, top: 12, bottom: 12),
          child: InkWell(
            onTap: onTap,
            child: CircleAvatar(
              backgroundColor: MyColors.greyImran2,
              child: Icon(
                Icons.person,
                color: MyColors.greyImran,
              ),
            ),
          ),
        ),
      ],
      title: Stack(
        children: [
          SizedBox(
            width: MySize.Width(context, 0.2),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Image.asset(
                isDarkMode
                    ? 'assets/logos/bat-logo-white.png'
                    : 'assets/logos/bat-logo-default.png',
              ),
            ),
          ),
          Positioned(
              bottom: 7,
              right: 0,
              child: Text(
                appVersion,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall!
                    .copyWith(fontWeight: FontWeight.normal, fontSize: 8),
              ))
        ],
      ),
    );

    return _widget;
  }

  static Widget MyFloatingButton(BuildContext context, double? dimension,
      {key, bool active = true, void Function()? onTap}) {
    final _widget = Material(
      color: Colors.transparent,
      elevation: !active ? 0 : 3,
      borderRadius: BorderRadius.circular(100),
      child: SizedBox.square(
        dimension: dimension ?? 60,
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                    color: !active
                        ? Theme.of(context).colorScheme.primary.withOpacity(0.5)
                        : Theme.of(context).colorScheme.onTertiary),
                gradient: !active
                    ? null
                    : LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                            MyColors.biruImran2,
                            MyColors.biruImran,
                          ]),
                color: active ? null : Colors.transparent),
            child: InkWell(
              onTap: active ? onTap : null,
              child: Icon(Icons.camera_alt_rounded, color: MyColors.myWhite),
            )),
      ),
    );

    return _widget;
  }
}
