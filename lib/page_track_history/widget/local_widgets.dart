import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';

class TrackWidget {
  
  static Widget myProductItem(BuildContext context, String date,
  {
    key,
    required  List<Map<dynamic,dynamic>> products, 
  }){  
    return 
    Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(date,style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),),
          ],
        ),

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: products.length,
          itemBuilder: (context, index) {              
            return Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  // Column to show image
                  Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                              color: Theme.of(context).colorScheme.secondary, width: 1),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(23),
                          child: Image.asset(
                            products[index]['imagePath'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  // Column for product details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          // title,
                          products[index]['title'],
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold,)
                        ),
                        const SizedBox(height: 8),
                        Row(children: [
                          GestureDetector(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: products[index]['code']));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Copied to clipboard')),
                              );
                            },
                            child: Icon(
                              FontAwesomeIcons.copy,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              // code,
                              products[index]['code'],
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w400, ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ]),
                        const SizedBox(height: 8),
                        Text(
                          'Redeemed On',
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w400,color: Theme.of(context).colorScheme.onPrimaryContainer ),                                                  
                        ),
                        Text(
                          // redeemedDate,
                          products[index]['redeemedDate'],
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w400, ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Column to show product points
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [                          
                          const SizedBox(width: 7),
                          FaIcon(FontAwesomeIcons.database, color: Theme.of(context).colorScheme.outlineVariant),
                          const SizedBox(width: 10),
                          Text(
                            // '$points Pts',                      
                            '${products[index]['points']} Pts',
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w400,
                            color:Theme.of(context).colorScheme.outlineVariant), 
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        ),
      ],
    );
  }
}
