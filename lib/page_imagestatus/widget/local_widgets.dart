import 'package:bat_loyalty_program_app/services/global_components.dart';
import 'package:bat_loyalty_program_app/services/global_widgets.dart';
import 'package:flutter/material.dart';

class ImageStatusWidgets {

  static Widget ReceiptSections(BuildContext context, String date,
    {key, required List<Map<dynamic, dynamic>> receipt, required String userId }
  ) {
    final IMAGE_DIMENSION = MySize.Width(context, 0.3);
    
    final _widget = Column( mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            
            return InkWell(
              onTap: () async => await showDialog(context: context, builder: (context) => 
                ImageStatusWidgets.ReceiptPopUp(context, path: receipt[index]['image'], takenAt: receipt[index]['created_at'], userId: userId)
              ),
              child: Material(
                elevation: 0,
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
                  child: Center(child: SizedBox.square( dimension: IMAGE_DIMENSION,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(receipt[index]['image'], fit: BoxFit.cover,)),
                  )
                  )
                ),
              ),
            );
          },
        ),
        
        SizedBox(height: 12,),
      ],
    );
    
  
    return _widget;
  }

  static AlertDialog ReceiptPopUp(BuildContext context,
    {key, required String path, required String takenAt, required String userId}
  ) {
    final Color BACKGROUND_COLOR = Theme.of(context).primaryColor;

    Widget infoField(String title, String subtitle) => Column ( crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: Theme.of(context).textTheme.labelMedium!.copyWith(
          color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.9),
          fontWeight: FontWeight.normal )),
      Text(subtitle),
    ]);

    final _dialog = AlertDialog(
      backgroundColor: BACKGROUND_COLOR,
      
      content: Column( crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
        Align( alignment: Alignment.center, child: Center(child: SizedBox( width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(path, fit: BoxFit.cover,)),
        ))),
        SizedBox(height: 12,),

        Text(path.split('/')[2].capitalize(), style: Theme.of(context).textTheme.titleMedium!.copyWith( fontWeight: FontWeight.bold)),
        SizedBox(height: 12,),
        
        infoField('Image Taken At', takenAt),
        SizedBox(height: 12,),
        infoField('By', userId),
      ],),

      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        SizedBox(
          child: TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text( "Back" ),
          ),
        )
      ],
    );
  
    return _dialog;
  }
}