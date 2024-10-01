import 'package:bat_loyalty_program_app/services/theme.dart';
import 'package:flutter/material.dart';

class CartWidget {

static Widget MyButton1(
      BuildContext context, double? width, String text, void Function()? onTap,
      {key, bool active = true}) {
    final _widget = Material(
      color: Colors.transparent,
      elevation: !active ? 0 : 3,
      borderRadius: BorderRadius.circular(10),
      child: Container(
          width: width ?? null,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: !active
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.5)
                      : Theme.of(context).colorScheme.onTertiary),
              gradient: !active
                  ? null
                  : LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                          MyColors.biruImran2,
                          MyColors.biruImran,
                        ]),
              color: active ? null : Colors.transparent),
          child: ListTile(
            title: Center(
              child: (Text(text,
                  style: TextStyle(
                      color: !active
                          ? Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.5)
                          : MyColors.myWhite))),
            ),
            onTap: active ? onTap : null,
          )),
    );

    return _widget;
  }

}