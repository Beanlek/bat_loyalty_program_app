import 'package:bat_loyalty_program_app/services/theme.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

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


static Widget buildProductListItem(
    BuildContext context, {
    required String imagePath,
    required String productName,
    required String brandName,
    required String points,
    required int count,
    required VoidCallback onAddPressed,
    required VoidCallback onRemovePressed,
    required VoidCallback onClearPressed,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          buildProductImage(context, imagePath),
          const SizedBox(width: 12),
          buildProductDetails(context, productName, brandName, points),
          const SizedBox(width: 10),
          buildCountButton(context, count, onAddPressed, onRemovePressed, onClearPressed),
        ],
      ),
    );
  }

  static Widget buildProductImage(BuildContext context, String imagePath) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Theme.of(context).colorScheme.secondary,
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(23),
            child: Image.asset(
              imagePath, // Image path as parameter
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  static Widget buildProductDetails(BuildContext context, String productName, String brandName, String points) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product name
          Text(
            productName,
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(fontWeight: FontWeight.w600),
          ),
          // Brand name
          Text(
            brandName,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 5),
          // Points
          Text(
            points,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

 static Widget buildCountButton(
    BuildContext context,
    int count,
    VoidCallback onAddPressed,
    VoidCallback onRemovePressed,
    VoidCallback onClearPressed,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 60),
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: onClearPressed, // Clear button action
                ),
              ],
            ),
            const SizedBox(width: 5),
            Row(
              children: [
                // + button
                IconButton(
                  icon: const Icon(Icons.add_circle),
                  onPressed: onAddPressed, // Add button action
                  iconSize: 30,
                ),
                // Count
                Text(
                  '$count',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                // - button
                IconButton(
                  icon: const Icon(Icons.remove_circle),
                  onPressed: onRemovePressed, // Remove button action
                  iconSize: 30,
                ),
              ],
            ),
          ],
        )
      ],
    );
  }

static Widget buildProductListItemShimmer({
  required BuildContext context,
  required double imageWidth,
  required double imageHeight,
  double borderRadius = 16.0,
}) {
  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Row(
        children: [
          // Column for image shimmer
          ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: Container(
              width: imageWidth,
              height: imageHeight,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 12),
          
          // Column for product details shimmer
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title shimmer
                Container(
                  height: 16,
                  width: 120,
                  color: Colors.white,
                ),
                SizedBox(height: 5),
                
                // Brand shimmer
                Container(
                  height: 14,
                  width: 80,
                  color: Colors.white,
                ),
                SizedBox(height: 5),
                
                // Points shimmer
                Container(
                  height: 18,
                  width: 60,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          
          SizedBox(width: 10),
          
          // Column for action buttons (like count, etc.)
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 60,
                    height: 20,
                    child: Container(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  // Shimmer for count buttons
                  Icon(Icons.add_circle, color: Colors.grey[300], size: 30),
                  SizedBox(width: 5),
                  Container(
                    height: 20,
                    width: 20,
                    color: Colors.white,
                  ),
                  SizedBox(width: 5),
                  Icon(Icons.remove_circle, color: Colors.grey[300], size: 30),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}



}
