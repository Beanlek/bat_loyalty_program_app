import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:bat_loyalty_program_app/services/theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const PLACEHOLDER_ICON = Icon(Icons.abc, color: Colors.transparent);

class MyWidgets {
  static Widget MyButton1(BuildContext context, double? width, String text, void Function()? onTap, 
    {key, bool active = true}
  ) {
    final _widget = Material(
      color: Colors.transparent,
      elevation: !active ? 0 : 3,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        width: width ?? null,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: !active ? Theme.of(context).colorScheme.primary.withOpacity(0.5) : Theme.of(context).colorScheme.onTertiary),

          gradient: !active ? null : LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,

            colors: [
              MyColors.biruImran,
              MyColors.biruImran2,
            ]
          ),

          color: active ? null : Colors.transparent
        ),
        child: ListTile(
          title: Center(
            child: (
              Text(
                text,
                style: TextStyle(color: !active ? Theme.of(context).colorScheme.primary.withOpacity(0.5) : MyColors.myWhite)
              )
            ),
          ),
          onTap: active ? onTap : null,
        )
      ),
    );

    return _widget;
  }

  static Widget MyButton2(BuildContext context, double? width, String text, void Function()? onTap) {
    final _widget = Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        width: width ?? null,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,

            colors: [
              MyColors.biruImran3,
              MyColors.biruImran4,
            ]
          )
        ),
        child: ListTile(
          title: (
            Text(
              text,
              style: TextStyle(color: MyColors.biruImran5)
            )
          ),
          onTap: onTap,
        )
      ),
    );

    return _widget;
  }

  static Widget MyTextField1(
    BuildContext context, String text, TextEditingController controller,
    {key, bool digitOnly = false, bool compulsory = false, bool isPassword = false, void Function(String)? onChanged, void Function(String)? onSubmit}
  ) {
    bool _isPasswordVisible = false;
    final DATA_COLOR = Theme.of(context).colorScheme.onTertiary;
    
    final _widget = StatefulBuilder(
      builder: (context, setState) {

        IconButton obscureIconButton() {
          return IconButton(
            iconSize: MySize.Width(context, 0.05),
            icon: Icon(
              _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
                print('_isPasswordVisible : ${_isPasswordVisible}');
              });
            },
          );
        }

        return Material(
          elevation: 0,
          borderRadius: BorderRadius.circular(100),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
        
                colors: [
                  Theme.of(context).colorScheme.tertiary,
                  Theme.of(context).colorScheme.onPrimary,
                ]
              )
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
              child: TextFormField(
                controller: controller,

                onChanged: onChanged,
                onFieldSubmitted: onSubmit,
                
                obscureText: isPassword ? !_isPasswordVisible : isPassword,
                keyboardType: !digitOnly ? null : TextInputType.phone,
                
                style: TextStyle(color: DATA_COLOR, fontWeight: FontWeight.w500),
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  border: InputBorder.none,
                  errorBorder: InputBorder.none,
        
                  hintText: text,
                  hintStyle: TextStyle(color: DATA_COLOR, fontWeight: FontWeight.normal),
        
                  suffixIconColor: DATA_COLOR,
                  suffixIcon:

                  (compulsory && isPassword) ? SizedBox(
                    width: MySize.Width(context, 0.17),
                    child: Row(
                      children: [
                        obscureIconButton(),
                        Icon(FontAwesomeIcons.asterisk, size: 12,)
                      ],
                    ),
                  ) :

                  compulsory ? Icon(FontAwesomeIcons.asterisk, size: 12,) :

                  !isPassword ? PLACEHOLDER_ICON :
                  obscureIconButton()
                ),
              ),
            )
          ),
        );
      }
    );
  
    return _widget;
  }

  static Widget MyTextField2(
    BuildContext context, String text, TextEditingController controller, FocusNode focusNode,
    {key, required bool isDark, double? width, void Function()? onFilter, void Function()? onSearch}
  ) {
    final DATA_COLOR = Theme.of(context).colorScheme.onTertiary;
    
    final _widget = StatefulBuilder(
      builder: (context, setState) {
        return Material(
          elevation: 0,
          borderRadius: BorderRadius.circular(100),
          child: Container(
            width: width ?? null,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
        
                colors: [
                  MyColors.biruImran3,
                  MyColors.biruImran4,
                ]
              )
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
              child: TextFormField(
                focusNode: focusNode,
                controller: controller,
                
                style: TextStyle(color: DATA_COLOR, fontWeight: FontWeight.w500),
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  border: !isDark ? InputBorder.none :
                  OutlineInputBorder(borderSide: BorderSide(color: MyColors.myWhite)),
                  errorBorder: InputBorder.none,
        
                  hintText: text,
                  hintStyle: TextStyle(color: DATA_COLOR.withOpacity(0.5), fontWeight: FontWeight.w300),
        
                  suffixIconColor: DATA_COLOR,
                  suffixIcon:
                  IconButton(
                    iconSize: MySize.Width(context, 0.05),
                    icon: Icon(
                      Icons.tune_rounded,
                    ),
                    onPressed: onFilter,
                  ),
        
                  prefixIconColor: DATA_COLOR,
                  prefixIcon:
                  IconButton(
                    iconSize: MySize.Width(context, 0.05),
                    icon: Icon(
                      Icons.search_rounded,
                    ),
                    onPressed: onSearch,
                  )
                ),
              ),
            )
          ),
        );
      }
    );
  
    return _widget;
  }

  static Widget MyTextField3(
    BuildContext context, String text,
    {key, required String selectedFilter, required List<String> filters, bool active = true, void Function(String?)? onChanged}
  ) {
    final DATA_COLOR = Theme.of(context).colorScheme.onTertiary;
    
    final _widget = StatefulBuilder(
      builder: (context, setState) {

        return Material(
          elevation: 0,
          borderRadius: BorderRadius.circular(100),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
        
                colors: [
                  Theme.of(context).colorScheme.tertiary,
                  Theme.of(context).colorScheme.onPrimary,
                ]
              )
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 24),
              child: DropdownButtonFormField(
                elevation: 5,
                isExpanded: true,

                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none
                  )
                ),

                // icon: Icon(Icons.arrow_forward_ios_rounded, color: DATA_COLOR,),
                icon: SizedBox(
                  // width: MySize.Width(context, 0.17),
                  child: Row(
                    children: [
                      Icon(Icons.arrow_forward_ios_rounded, color: DATA_COLOR.withOpacity(active ? 1 : 0.5),),
                      SizedBox(width: 12,),
                      Icon(FontAwesomeIcons.asterisk, color: DATA_COLOR, size: 12,),
                      SizedBox(width: 6,),
                    ],
                  ),
                ),
                iconSize: 18,
                
                dropdownColor: Theme.of(context).colorScheme.onSecondary,

                value: selectedFilter,
                items: filters.map((filter) => DropdownMenuItem<String>(
                  alignment: AlignmentDirectional.centerStart,
                  value: filter,

                  child: Text(
                    filter,
                    style: TextStyle(color: DATA_COLOR.withOpacity(active ? 1 : 0.5), fontWeight: FontWeight.normal),
                  ),
                )).toList(),

                onChanged: active ? onChanged : null
              ),
            )
          ),
        );
      }
    );
  
    return _widget;
  }
  
  static Widget MyLoading(BuildContext context, bool isLoading, bool isDarkMode) {
    final _widget = isLoading ? Container(
      color: Theme.of(context).primaryColor.withOpacity(isDarkMode ? 0.8 : 0.5),
      child: Center(
        child: SizedBox.square(
          dimension: MySize.Width(context, 0.5),
          child: GradientWidget(Lottie.asset('assets/lotties/loading_002.json', fit: BoxFit.contain), gradient: LinearGradient(colors: [
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context).colorScheme.primary,
          ]),),
        ),
      )
    ) : SizedBox();
  
    return _widget;
  }

  static Widget MyLoading2(BuildContext context, bool isDarkMode) {
    final _widget = Scaffold(
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Center(
          child: SizedBox.square(
            dimension: MySize.Width(context, 0.5),
            child: GradientWidget(Lottie.asset('assets/lotties/loading_002.json', fit: BoxFit.contain), gradient: LinearGradient(colors: [
                    Theme.of(context).colorScheme.secondary,
                    Theme.of(context).colorScheme.primary,
            ]),),
          ),
        )
      ),
    );
  
    return _widget;
  }

  static Widget MyErrorPage(BuildContext context, bool isDarkMode) {
    final _widget = Scaffold(
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox.square(
                dimension: MySize.Width(context, 0.3),
                // child: Icon(Icons.error, color: MyColors.merahImran, size: MySize.Width(context, 0.3),)
                child: Lottie.asset('assets/lotties/error_001.json', fit: BoxFit.contain),
              ),

              SizedBox(height: 12,),

              Text('Error loading page.\nPlease contact system admin.', style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center,)
            ],
          ),
        )
      ),
    );
  
    return _widget;
  }

  static Widget MyLogoHeader(BuildContext context, bool isDarkMode, {required String appVersion }) {
    final _widget = Stack(
      children: [
        SizedBox(
          width: MySize.Width(context, 0.45),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Image.asset(
              isDarkMode ?
              'assets/logos/logo_bat_v002.png' :
              'assets/logos/logo_bat.png',
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Text('Version ${appVersion}',
            style: Theme.of(context).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.normal),
          )
        )
      ],
    );
  
    return _widget;
  }

  static Widget MyFooter1(BuildContext context) {
    final _widget = Column(
      children: [
        Divider(color: Theme.of(context).colorScheme.onTertiary,),
        SizedBox(height: 12,),
        Text.rich(style: Theme.of(context).textTheme.bodySmall,
          TextSpan(text: 'Need any help? ',
            children: [
              TextSpan(text: 'Contact Us.', style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),)
            ]
          )
        )
      ],
    );
  
    return _widget;
  }

  static Widget MyScroll1(BuildContext context, {required ScrollController controller, required Widget child, double? height}) {
    final _widget = RawScrollbar(
      controller: controller,
      thumbVisibility: true,
      thumbColor: Theme.of(context).colorScheme.secondary,
      radius: Radius.circular(100),
      thickness: 3,
    
      child: SingleChildScrollView(
        controller: controller,
        child: SizedBox(
          width: MySize.Width(context, 1),
          height: height ?? MySize.Height(context, 0.6),
        
          child: child
        )
      ),
    );
  
    return _widget;
  }

  
}

class MySize {
  static double Height(BuildContext context, double multiplier) {
    double _height = MediaQuery.of(context).size.height * multiplier;

    return _height;
  }

  static double Width(BuildContext context, double multiplier) {
    double _width = MediaQuery.of(context).size.width * multiplier;

    return _width;
  }
}

class GradientText extends StatelessWidget {
  const GradientText(
    this.text,
    {
      super.key,
      
      required this.gradient,
      this.style,
    }
  );

  final String text;
  final TextStyle? style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style),
    );
  }
}

class GradientWidget extends StatelessWidget {
  const GradientWidget(
    this.widget,
    {
      super.key,
      
      required this.gradient,
    }
  );

  final Widget widget;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: widget,
    );
  }
}