import 'package:flutter/material.dart';

class ProfileWidgets {
  
  static Widget InfoTile(BuildContext context, String label,
    {key, required String subtitle}
  ) {
    final Color TEXT_COLOR = Theme.of(context).colorScheme.onSecondary;
    
    final _widget = Row( crossAxisAlignment: CrossAxisAlignment.start ,children: [
      Expanded( flex: 2, child: Text(label, style: Theme.of(context).textTheme.bodySmall!.copyWith( color: TEXT_COLOR.withOpacity(0.6)),)),
      Expanded( flex: 5, child: Text(subtitle, style: Theme.of(context).textTheme.bodyMedium!.copyWith( color: TEXT_COLOR), textAlign: TextAlign.end, ))
    ],);
  
    return _widget;
  }
}