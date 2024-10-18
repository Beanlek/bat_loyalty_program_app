import 'package:bat_loyalty_program_app/services/api.dart';
import 'package:bat_loyalty_program_app/services/global_widgets.dart';
import 'package:bat_loyalty_program_app/services/routes.dart';
import 'package:bat_loyalty_program_app/services/theme.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ImageStatusWidgets  {

  // static Widget ReceiptSections(BuildContext context, String date,
  //   {key, required List<Map<dynamic, dynamic>> receipt, required String userId }
  // ) {
  //   final IMAGE_DIMENSION = MySize.Width(context, 0.3);   
  //   final _widget = Column( mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(date, style: Theme.of(context).textTheme.bodyMedium,),
  //       SizedBox(height: 12,),
  //       GridView.builder(
  //         padding: const EdgeInsets.only(right: 12, bottom: 12),
  //         shrinkWrap: true, physics: NeverScrollableScrollPhysics(),
  //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount( crossAxisCount: 3,
  //           mainAxisSpacing: 8, crossAxisSpacing: 8,
  //         ),
  //         itemCount: receipt.length,
  //         itemBuilder: (context, index) {           
  //           return InkWell(
  //             onTap: () async => await showDialog(context: context, builder: (context) => 
  //               ImageStatusWidgets.ReceiptPopUp(context, path: receipt[index]['image'], takenAt: receipt[index]['created_at'], userId: userId, status: receipt[index]['status'], points: '10')
  //             ),
  //             child: Material(
  //               elevation: 0,
  //               borderRadius: BorderRadius.circular(8),
  //               color: Colors.transparent,
  //               child: Container(
  //                 height: IMAGE_DIMENSION,
  //                 width: IMAGE_DIMENSION,
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(8),
  //                   border: Border.all(color: Theme.of(context).colorScheme.primary),
  //                   color: Colors.transparent
  //                 ),
  //                 child: Center(child: SizedBox.square( dimension: IMAGE_DIMENSION,
  //                   child: ClipRRect(
  //                     borderRadius: BorderRadius.circular(8),
  //                     child: Image.asset(receipt[index]['image'], fit: BoxFit.cover,)),
  //                 )
  //                 )
  //               ),
  //             ),
  //           );
  //         },
  //       ),        
  //       SizedBox(height: 12,),
  //     ],
  //   );      
  //   return _widget;
  // }

      static Widget receiptCard({
          required BuildContext context,
          required String outlet_image,
          required String imagePath,
          required String status,
          required String createdAt,
          required String userId,
          required String domainName,
          required String token,

        }) {
      
      
          String formattedDate = createdAt.substring(0, 19);

          Color statusColor = Theme.of(context).primaryColor;                          
         
          if (status.contains('In Process')) {
              statusColor = MyColors.biruImran2;
          }else if(status.contains('Success')){
            statusColor = MyColors.hijauImran2;
          }else if(status.contains('Failed')){
            statusColor = MyColors.merahImran;
          }



          return GestureDetector(
      
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => FutureBuilder<Map<String, dynamic>>(
                  future: Api.getReceiptImageUrl(domainName,token,imagePath),
                  builder: (context, snapshot) {
                    // if (snapshot.hasData) {
                                     
                if (snapshot.connectionState == ConnectionState.waiting) {
                          return ReceiptShimmerPopUp(context);
                        } else if (snapshot.hasData && snapshot.data != null) {
                          String url = snapshot.data!['result'][0]['data']['url_original'];
                          return ReceiptPopUp(
                            context,
                            path: url,
                            takenAt: createdAt,
                            userId: userId,
                            status: status,
                            points: '1400',
                          );
                        } else if (snapshot.hasError) {
                          return AlertDialog(content: Text('Error: ${snapshot.error}'));
                        } else {
                          return AlertDialog(content: Text('No image found'));
                        }                      
                   },
                ),
              );
            },
            child: Card(
              color: Theme.of(context).primaryColor,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: SizedBox(
                        width: MySize.Width(context, 0.15),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Image.asset(outlet_image),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status:',
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith( color: Theme.of(context).colorScheme.onPrimaryContainer),
                        ),
                        Text(
                          status,
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: statusColor,fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Text(
                      formattedDate,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          );
        }

  static AlertDialog ReceiptPopUp(BuildContext context,
    {key, required String path, required String takenAt, required String userId,required String status, required String points}
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
      
      content: Column( crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min,
       children: [
        Align( alignment: Alignment.center, child: Center(child: SizedBox( width: double.infinity,
          child: FutureBuilder<String>(
          future: Future.value(path),
          builder: (context, snapshot) {                          
             if(snapshot.hasData) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  snapshot.data!,
                   fit: BoxFit.cover,
                   loadingBuilder: (context, child, loadingProgress) {
                     if (loadingProgress == null) {
                      return child;
                     }else {
                       return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: double.infinity,
                        height: 200.0, // You can adjust this to match the image size
                        color: Colors.grey,
                      ),
                    );
                     }
                   },),
              );

              // return ClipRRect(
              //   borderRadius: BorderRadius.circular(12),
              //   child: Image.network(snapshot.data!, fit: BoxFit.cover,),
              // );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
        ))),
        
        SizedBox(height: 12,),        
        infoField('Image Taken At', takenAt),
        SizedBox(height: 12,),
        infoField('By', userId),
        SizedBox(height: 12,),
        infoField('Status', status),
        SizedBox(height: 12,),
        infoField('Points', points),
      ],),

      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {},
              child: Text( "Report",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error
                ),
               ),
            ),
            TextButton(
              onPressed: () {},
              child: Text( "Retake"),
            ),
            Expanded(
              child: Card(
               elevation: 2,
               color: MyColors.hijauImran2,               
                 child: InkWell(
                   onTap: () {},
                   child: Padding(                    
                     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 3.0),                     
                     child: Text('Claim' , style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).primaryColor),
                     textAlign: TextAlign.center, ),
                   ),
                 )
                   ),
            ),
          ],
        )
      ],
    );
  
    return _dialog;
  }

  static AlertDialog ReceiptShimmerPopUp(BuildContext context) {
    final Color BACKGROUND_COLOR = Theme.of(context).primaryColor;

    final _dialog = AlertDialog(
      backgroundColor: BACKGROUND_COLOR,
      
      content: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column( crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Align( alignment: Alignment.center, child: Center(child: SizedBox( width: double.infinity,
            child: Container(
              height: 200,
              color: Colors.white,
            ),
          ))),
          
          SizedBox(height: 12,),        
          Container(
            height: 16,
            color: Colors.white,
          ),
          SizedBox(height: 12,),
          Container(
            height: 16,
            color: Colors.white,
          ),
          SizedBox(height: 12,),
          Container(
            height: 16,
            color: Colors.white,
          ),
          SizedBox(height: 12,),
          Container(
            height: 16,
            color: Colors.white,
          ),
        ],),
      ),
      
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {},
              child: Text( "Report",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error
                ),
               ),
            ),
            TextButton(
              onPressed: () {},
              child: Text( "Retake"),
            ),
            Expanded(
              child: Card(
               elevation: 2,
               color: MyColors.hijauImran2,               
                 child: InkWell(
                   onTap: () {},
                   child: Padding(                    
                     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 3.0),                     
                     child: Text('Claim' , style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).primaryColor),
                     textAlign: TextAlign.center, ),
                   ),
                 )
                   ),
            ),
          ],
        )
      ],
    );
  
    return _dialog;
  }


  // Modified receiptCard with shimmer effect
static Widget receiptShimmerCard(BuildContext context) {    
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MySize.Width(context, 0.15),
                  height: MySize.Width(context, 0.15),
                  color: Colors.grey[300],
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        height: 20,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 150,
                        height: 20,
                        color: Colors.grey[300],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 80,
                  height: 20,
                  color: Colors.grey[300],
                ),
              ],
            ),
          ),
        ),
      );
}


static Widget buildDateGroup(BuildContext context, String date, List<Map<String, dynamic>> receipts, MyArguments args, String domainName, String token) {
    String imagePath = 'assets/account_images/company.png';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(date, style: Theme.of(context).textTheme.bodyMedium),
        ),
        ...receipts.map((receipt) => ImageStatusWidgets.receiptCard(
          context: context,
          outlet_image: imagePath,
          imagePath: receipt['id'],
          status: receipt['status'],
          createdAt: receipt['created_at'],
          userId: args.username,
          domainName: domainName,
          token: token,
        )),
      ],
    );
  }
}