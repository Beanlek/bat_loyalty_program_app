import 'package:bat_loyalty_program_app/page_product/component/local_components.dart';
import 'package:bat_loyalty_program_app/services/global_widgets.dart';
import 'package:bat_loyalty_program_app/services/theme.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:shimmer/shimmer.dart';

class ProductWidget{

static Widget buildCarousel({
    required BuildContext context,
    required List<String> imgList,
    required int currentPage,
    required Function(int) onPageChanged,
    required Function(int) onPageSelected,
  }) {
    return Column(
      children: [
        CarouselSlider(
          items: imgList
              .map((e) => Center(
                    child: Image.network(
                      e,
                      fit: BoxFit.cover,
                      height: MediaQuery.of(context).size.height / 2,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ))
              .toList(),
          options: CarouselOptions(
            autoPlay: false,
            enableInfiniteScroll: false,
            viewportFraction: 1.0,
            height: MediaQuery.of(context).size.height / 2,
            onPageChanged: (value, _) {
              onPageChanged(value); // Callback to update current page
            },
          ),
        ),
        const SizedBox(
            height: 10), // Adds spacing between carousel and indicators
        ProductWidget.buildCarouselIndicator(
          currentPage: currentPage,
          itemCount: imgList.length,
          onPageSelected: onPageSelected,
        ),
      ],
    );
  }

  static Widget buildShimmerImage({
    required BuildContext context,
    required double height,
    required double width,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        width: width,
        color: Colors.white,
      ),
    );
  }
  
 

  // Function to build carousel indicators
  static Widget buildCarouselIndicator({
    required int currentPage,
    required int itemCount,
    required Function(int) onPageSelected,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        return GestureDetector(
          onTap: () => onPageSelected(index),
          child: Container(
            width: 8.0,
            height: 8.0,
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            
            decoration: BoxDecoration( shape: BoxShape.circle,
            color: (currentPage == index) ? MyColors.biruImran3 : MyColors.biruImran.withOpacity(.5),
            border: Border.all(color: (currentPage == index) ? MyColors.biruImran : MyColors.biruImran3.withOpacity(.5), )            
            ),
          ),
        );
      }),
    );
  }

// Widget to display stock
  static Widget productCartDisplay({
    required String imagePath, // Path to your image asset
    required String label, // Text to be displayed next to the icon
    double iconHeight = 24, // Default height of the icon
    double iconWidth = 24, // Default width of the icon
    EdgeInsets padding = const EdgeInsets.symmetric(
        horizontal: 8.0), // Padding around the content
    TextStyle? textStyle, // Text style for the label
    double spacing = 8.0, // Space between the icon and the text
  }) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            imagePath,
            height: iconHeight,
            width: iconWidth,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              // Placeholder icon if the image fails to load
              return Icon(Icons.image_not_supported, size: iconHeight);
            },
          ),
          SizedBox(width: spacing), // Space between the icon and text
          Text(
            label,
            style: textStyle ??
                const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
          ),
        ],
      ),
    );
  }

  static Widget buildReadMoreText(BuildContext context, String text) {
final ScrollController _scrollController = ScrollController();

    return Padding(
      padding: const EdgeInsets.all(1),
      child: SizedBox(
        height: 100,
        child: MyWidgets.MyScrollBar1(
          context,
          controller: _scrollController,

          child: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: ReadMoreText(
                text,
                trimLines: 3, // Set the max lines to 3
                colorClickableText: Colors.blue, // Customize the clickable text color
                trimMode: TrimMode.Line, // Set the trim mode
                trimCollapsedText: '  Read More', // Text to show when trimmed
                trimExpandedText: '  Show Less', // Text to show when expanded        
                style: TextStyle(
                   fontSize: Theme.of(context).textTheme.labelMedium?.fontSize ?? 14,
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,                
                ),
                textAlign: TextAlign.justify,
              ),
            ),
          ),
        ),
      ),
    );
  }

 static Widget buildProductDetails(
    BuildContext context,
    List<String> imgList,
    int currentPage,
    Function(int) onPageChanged,
    Function(int) onPageSelected, {
    required String productName,
    required String productModel,
    required String stockLabel,
    required String descriptionTitle,
    required String description,
    required String pointsLabel,
    required String pointsValue,
  }) {
    return Column(
      children: [
        imgList.isEmpty
            ? ProductWidget.buildShimmerImage(
                context: context,
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
              )
            : ProductWidget.buildCarousel(
                context: context,
                imgList: imgList,
                currentPage: currentPage,
                onPageChanged: onPageChanged,
                onPageSelected: onPageSelected,
              ),
        SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      productName,
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                            fontWeight: FontWeight.normal,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                    ),
                    Text(
                      productModel,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    ProductWidget.productCartDisplay(
                      imagePath: 'assets/images_examples/icon_stock1.png',
                      label: stockLabel,
                      textStyle: Theme.of(context).textTheme.labelMedium!.copyWith(
                            fontWeight: FontWeight.normal,
                            color: Theme.of(context).colorScheme.outlineVariant,
                          ),
                    ),
                    Text(
                      descriptionTitle,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    ProductWidget.buildReadMoreText(
                      context,
                      description,
                    ),
                    SizedBox(height: 8),
                    Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              pointsLabel,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(fontWeight: FontWeight.w500),
                            ),
                            SizedBox(width: 5),
                            Text(
                              pointsValue,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        ProductQuantityWidget(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


static Widget buildSkeletonLoader(BuildContext context) {
  return Column(
    children: [
      // Skeleton for the image carousel
      Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: MediaQuery.of(context).size.height / 2,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
        ),
      ),
      SizedBox(height: 12),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Skeleton for the product name
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 20,
                width: double.infinity,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),

            // Skeleton for the product model
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 16,
                width: 150,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),

            // Skeleton for the stock label
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 16,
                width: 100,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 12),

            // Skeleton for the description title
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 16,
                width: 200,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),

            // Skeleton for the description text
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 50,
                width: double.infinity,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 12),

            // Skeleton for the points label
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Row(
                children: [
                  Container(
                    height: 16,
                    width: 80,
                    color: Colors.white,
                  ),
                  SizedBox(width: 5),
                  Container(
                    height: 16,
                    width: 100,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),

            // Skeleton for the quantity widget
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 40,
                width: double.infinity,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}



}



class ProductQuantityWidget extends StatefulWidget {
  const ProductQuantityWidget({super.key});

  @override
  _ProductQuantityWidgetState createState() => _ProductQuantityWidgetState();
}

class _ProductQuantityWidgetState extends State<ProductQuantityWidget>
    with CounterMixin {
  @override
  Widget build(BuildContext context) {
    return Row(          
      mainAxisAlignment: MainAxisAlignment.spaceBetween,        
      children: [
        // + button
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.add_circle),
                  onPressed: increment, // Calls the increment method from the mixin
                  iconSize: 30,
                ),
                SizedBox(width: 5),
                // Display the count
                       
                 ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: 30,
                    minHeight:30,
                    maxWidth: 30,
                    maxHeight: 30,
                  ),
                  
                   child: Text(
                      '$count',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                 ),
                
                SizedBox(width: 5),
                // - button
                IconButton(
                  icon: Icon(Icons.remove_circle),
                  onPressed: decrement, // Calls the decrement method from the mixin
                  iconSize: 30,
                ),
              ],
            ),
          ],
        ),
        
          SizedBox(width: 10),
        // Button to add the product to the cart
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyWidgets.MyButton3(
              context,
              200,
              'Add to Cart',
              () {
                // Add the product to the cart              
              },
              icon: Icons.shopping_cart,
            ),
          ],
        ),
      ],
    );
  }
}
  