import 'package:bat_loyalty_program_app/services/global_widgets.dart';
import 'package:flutter/material.dart';

class ImageStatusWidgets {
  static Widget ReceiptImage(BuildContext context,
    {key, required String receipt, void Function()? onTap}
  ) {
    final IMAGE_DIMENSION = MySize.Width(context, 0.3);
    
    final _widget = Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: onTap,
        child: Material(
          elevation: 2,
          borderRadius: BorderRadius.circular(8),
          color: Colors.transparent,
          child: Container(
            height: IMAGE_DIMENSION,
            width: IMAGE_DIMENSION,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Theme.of(context).colorScheme.primary),
              color: Colors.transparent
            ),
            child: Center(child: SizedBox.square( dimension: IMAGE_DIMENSION, child: ClipRRect( 
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(receipt, fit: BoxFit.cover,)))
            )
          ),
        ),
      ),
    );
  
    return _widget;
  }

  static List<Widget> Section(BuildContext context, String date,
    {key, required List<String> receipt }
  ) {
    final _widget = [
      Text(date, style: Theme.of(context).textTheme.bodyMedium,),
      SizedBox(height: 12,),

      GridView.builder(
        padding: const EdgeInsets.only(right: 12, bottom: 12),
        shrinkWrap: true, physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount( crossAxisCount: 3,
          mainAxisSpacing: 8, crossAxisSpacing: 8,
        ),

        itemCount: receipt.length,
        itemBuilder: (context, index) {
          return ReceiptImage(context, receipt: receipt[index]);
        },
      ),
    ];
    
  
    return _widget;
  }
}