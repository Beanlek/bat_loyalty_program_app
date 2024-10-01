import 'package:bat_loyalty_program_app/page_product/component/local_components.dart';
import 'package:bat_loyalty_program_app/services/global_widgets.dart';
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
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  (currentPage == index) ? Colors.grey[600] : Colors.grey[400],
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
              
              },
              icon: Icons.shopping_cart,
            ),
          ],
        ),
      ],
    );
  }
}

  

  



  