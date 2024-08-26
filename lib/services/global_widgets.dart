import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:bat_loyalty_program_app/services/theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const PLACEHOLDER_ICON = Icon(Icons.abc, color: Colors.transparent);

class MyWidgets {
  static Widget MyButton1(
      BuildContext context, double? width, String text, void Function()? onTap,
      {key, bool active = true}) {
    final _widget = Material(
      color: Colors.transparent,
      elevation: !active ? 0 : 3,
      borderRadius: BorderRadius.circular(100),
      child: Container(
          width: width ?? null,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
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
                          MyColors.biruImran,
                          MyColors.biruImran2,
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

  static Widget MyButton2(BuildContext context, double? width, String text,
      void Function()? onTap) {
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
                  ])),
          child: ListTile(
            title: (Text(text, style: TextStyle(color: MyColors.biruImran5))),
            onTap: onTap,
          )),
    );

    return _widget;
  }

  static Widget MyTextField1(
      BuildContext context, String text, TextEditingController controller,
      {key,
      bool digitOnly = false,
      bool compulsory = false,
      bool isPassword = false,
      FocusNode? focusNode,
      void Function(String)? onChanged,
      void Function(String)? onSubmit}) {
    bool _isPasswordVisible = false;
    final DATA_COLOR = Theme.of(context).colorScheme.onTertiary;

    final _widget = StatefulBuilder(builder: (context, setState) {
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
                    ])),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
              child: TextFormField(
                controller: controller,
                focusNode: focusNode,
                onChanged: onChanged,
                onFieldSubmitted: onSubmit,
                obscureText: isPassword ? !_isPasswordVisible : isPassword,
                keyboardType: !digitOnly ? null : TextInputType.phone,
                style:
                    TextStyle(color: DATA_COLOR, fontWeight: FontWeight.w500),
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    border: InputBorder.none,
                    errorBorder: InputBorder.none,
                    hintText: text,
                    hintStyle: TextStyle(
                        color: DATA_COLOR, fontWeight: FontWeight.normal),
                    suffixIconColor: DATA_COLOR,
                    suffixIcon: (compulsory && isPassword)
                        ? SizedBox(
                            width: MySize.Width(context, 0.17),
                            child: Row(
                              children: [
                                obscureIconButton(),
                                Icon(
                                  FontAwesomeIcons.asterisk,
                                  size: 12,
                                )
                              ],
                            ),
                          )
                        : compulsory
                            ? Icon(
                                FontAwesomeIcons.asterisk,
                                size: 12,
                              )
                            : !isPassword
                                ? PLACEHOLDER_ICON
                                : obscureIconButton()),
              ),
            )),
      );
    });

    return _widget;
  }

  static Widget MyTextField2(BuildContext context, String text,
      TextEditingController controller, FocusNode focusNode,
      {key,
      required bool isDark,
      double? width,
      void Function()? onFilter,
      void Function()? onSearch}) {
    final DATA_COLOR = Theme.of(context).colorScheme.onTertiary;

    final _widget = StatefulBuilder(builder: (context, setState) {
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
                    ])),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
              child: TextFormField(
                focusNode: focusNode,
                controller: controller,
                style:
                    TextStyle(color: DATA_COLOR, fontWeight: FontWeight.w500),
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    border: !isDark
                        ? InputBorder.none
                        : OutlineInputBorder(
                            borderSide: BorderSide(color: MyColors.myWhite)),
                    errorBorder: InputBorder.none,
                    hintText: text,
                    hintStyle: TextStyle(
                        color: DATA_COLOR.withOpacity(0.5),
                        fontWeight: FontWeight.w300),
                    suffixIconColor: DATA_COLOR,
                    suffixIcon: IconButton(
                      iconSize: MySize.Width(context, 0.05),
                      icon: Icon(
                        Icons.tune_rounded,
                      ),
                      onPressed: onFilter,
                    ),
                    prefixIconColor: DATA_COLOR,
                    prefixIcon: IconButton(
                      iconSize: MySize.Width(context, 0.05),
                      icon: Icon(
                        Icons.search_rounded,
                      ),
                      onPressed: onSearch,
                    )),
              ),
            )),
      );
    });

    return _widget;
  }

  static Widget MyTextField3(BuildContext context, String text,
      {key,
      required String selectedFilter,
      required List<String> filters,
      bool active = true,
      void Function(String?)? onChanged}) {
    final DATA_COLOR = Theme.of(context).colorScheme.onTertiary;

    final _widget = StatefulBuilder(builder: (context, setState) {
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
                    ])),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 24),
              child: DropdownButtonFormField(
                  elevation: 5,
                  isExpanded: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide.none)),

                  // icon: Icon(Icons.arrow_forward_ios_rounded, color: DATA_COLOR,),
                  icon: SizedBox(
                    // width: MySize.Width(context, 0.17),
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: DATA_COLOR.withOpacity(active ? 1 : 0.5),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Icon(
                          FontAwesomeIcons.asterisk,
                          color: DATA_COLOR,
                          size: 12,
                        ),
                        SizedBox(
                          width: 6,
                        ),
                      ],
                    ),
                  ),
                  iconSize: 18,
                  dropdownColor: Theme.of(context).colorScheme.onSecondary,
                  value: selectedFilter,
                  items: filters
                      .map((filter) => DropdownMenuItem<String>(
                            alignment: AlignmentDirectional.centerStart,
                            value: filter,
                            child: Text(
                              filter,
                              style: TextStyle(
                                  color:
                                      DATA_COLOR.withOpacity(active ? 1 : 0.5),
                                  fontWeight: FontWeight.normal),
                            ),
                          ))
                      .toList(),
                  onChanged: active ? onChanged : null),
            )),
      );
    });

    return _widget;
  }

  static Widget MyDropDown(BuildContext context, String text,
      {key,
      required String selectedFilter,
      required List<String> filters,
      bool active = true,
      void Function(String?)? onChanged}) {
    final DATA_COLOR = Theme.of(context).colorScheme.onTertiary;

    final _widget = StatefulBuilder(builder: (context, setState) {
      return Material(
        elevation: 0,
        borderRadius: BorderRadius.circular(24),
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.tertiary,
                      Theme.of(context).colorScheme.onPrimary,
                    ])),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 24),
              child: DropdownButtonFormField(
                  elevation: 5,
                  isExpanded: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide.none)),
                  icon: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: DATA_COLOR.withOpacity(active ? 1 : 0.5),
                  ),
                  iconSize: 18,
                  dropdownColor: Theme.of(context).colorScheme.onSecondary,
                  value: selectedFilter,
                  items: filters
                      .map((filter) => DropdownMenuItem<String>(
                            alignment: AlignmentDirectional.centerStart,
                            value: filter,
                            child: Text(
                              filter,
                              style: TextStyle(
                                  color:
                                      DATA_COLOR.withOpacity(active ? 1 : 0.5),
                                  fontWeight: FontWeight.normal),
                            ),
                          ))
                      .toList(),
                  onChanged: active ? onChanged : null),
            )),
      );
    });

    return _widget;
  }

  static Widget MyLoading(
      BuildContext context, bool isLoading, bool isDarkMode) {
    final _widget = isLoading
        ? Container(
            color: Theme.of(context)
                .primaryColor
                .withOpacity(isDarkMode ? 0.8 : 0.5),
            child: Center(
              child: SizedBox.square(
                dimension: MySize.Width(context, 0.5),
                child: GradientWidget(
                  Lottie.asset('assets/lotties/loading_002.json',
                      fit: BoxFit.contain),
                  gradient: LinearGradient(colors: [
                    Theme.of(context).colorScheme.secondary,
                    Theme.of(context).colorScheme.primary,
                  ]),
                ),
              ),
            ))
        : SizedBox();

    return _widget;
  }

  static Widget MyLoading2(BuildContext context, bool isDarkMode) {
    final _widget = Scaffold(
      body: Container(
          color: Theme.of(context).primaryColor,
          child: Center(
            child: SizedBox.square(
              dimension: MySize.Width(context, 0.5),
              child: GradientWidget(
                Lottie.asset('assets/lotties/loading_002.json',
                    fit: BoxFit.contain),
                gradient: LinearGradient(colors: [
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context).colorScheme.primary,
                ]),
              ),
            ),
          )),
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
                  child: Lottie.asset('assets/lotties/error_001.json',
                      fit: BoxFit.contain),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  'Error loading page.\nPlease contact system admin.',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                )
              ],
            ),
          )),
    );

    return _widget;
  }

  static Widget MyErrorTextField(BuildContext context, String text, {key}) {
    final Color ERROR_COLORS = MyColors.merahImran;

    final _widget = Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 24.0, top: 6, bottom: 2),
          child: Row(
            children: [
              Icon(
                Icons.error,
                color: ERROR_COLORS,
                size: 16,
              ),
              SizedBox(
                width: 12,
              ),
              Text(text,
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: ERROR_COLORS, fontWeight: FontWeight.normal)),
            ],
          ),
        ));

    return _widget;
  }

  static Widget ToChangeEnv(BuildContext context,
      {key,
      required String domainNow,
      required List<String> domainList,
      required void Function(String?)? onChanged}) {
    final _widget = FloatingActionButton(
      elevation: 0,
      backgroundColor: Colors.transparent,
      onPressed: () {
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                width: double.infinity,
                height: MySize.Height(context, 0.25),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadiusDirectional.only(
                      topStart: Radius.circular(24),
                      topEnd: Radius.circular(24)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 32.0, horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GradientText(
                        'Environment Change',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(fontWeight: FontWeight.w800),
                        gradient: LinearGradient(colors: [
                          Theme.of(context).colorScheme.secondary,
                          Theme.of(context).colorScheme.primary,
                        ]),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      MyDropDown(
                        context,
                        '_',
                        selectedFilter: domainNow,
                        filters: domainList,
                        onChanged: onChanged,
                      )
                    ],
                  ),
                ),
              );
            });
      },
      child: Icon(
        FontAwesomeIcons.userGear,
        color: Theme.of(context).colorScheme.onTertiary,
      ),
    );

    return _widget;
  }

  static Widget MyInfoTextField(BuildContext context, String text, {key}) {
    final _widget = Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 24.0, top: 6, bottom: 2),
          child: Text(text,
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onPrimaryContainer
                      .withOpacity(0.5),
                  fontWeight: FontWeight.normal)),
        ));

    return _widget;
  }

  static Widget MyLogoHeader(BuildContext context, bool isDarkMode,
      {required String appVersion}) {
    final _widget = Stack(
      children: [
        SizedBox(
          width: MySize.Width(context, 0.4),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Image.asset(
              isDarkMode
                  ? 'assets/logos/bat-logo-white.png'
                  : 'assets/logos/bat-logo-default.png',
            ),
          ),
        ),
        Positioned(
            bottom: 8,
            right: 6,
            child: Text(
              appVersion,
              style: Theme.of(context)
                  .textTheme
                  .labelSmall!
                  .copyWith(fontWeight: FontWeight.normal),
            ))
      ],
    );

    return _widget;
  }

  static Widget MyFooter1(BuildContext context) {
    final _widget = Column(
      children: [
        Divider(
          color: Theme.of(context).colorScheme.onTertiary,
        ),
        SizedBox(
          height: 12,
        ),
        Text.rich(
            style: Theme.of(context).textTheme.bodySmall,
            TextSpan(text: 'Need any help? ', children: [
              TextSpan(
                text: 'Contact Us.',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              )
            ]))
      ],
    );

    return _widget;
  }

  static Widget MyScroll1(BuildContext context,
      {required ScrollController controller,
      required Widget child,
      double? height}) {
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
              child: child)),
    );

    return _widget;
  }
  

static Widget MyScrollBar1(BuildContext context,
 {required ScrollController controller, required Widget child, bool thumbVisibility = true} ) {
    final _widget = RawScrollbar(
      controller: controller,
      thumbVisibility: thumbVisibility,
      thumbColor: Theme.of(context).colorScheme.secondary,
      radius: Radius.circular(100),
      thickness: 3,
      child: child
    );

    return _widget;
  }

  static Widget MyTileButton(BuildContext context, String label,
      {key,
      Color? color,
      void Function()? onPressed,
      IconData? icon,
      double? iconSize}) {
    final _widget = SizedBox(
      height: 35,
      child: TextButton.icon(
        onPressed: onPressed,
        label: Text(label,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontWeight: FontWeight.w500,
                color: color ?? Theme.of(context).colorScheme.primary)),
        icon: Icon(icon ?? Icons.abc,
            size: iconSize ?? MySize.Width(context, 0.05),
            color: color ?? Theme.of(context).colorScheme.primary),
      ),
    );

    return _widget;
  }

  static Widget MyLogoBar(BuildContext context, bool isDarkMode,
      {key, required String appVersion}) {
    final _widget = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Stack(
        children: [
          SizedBox(
            width: MySize.Width(context, 0.2),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Image.asset(
                isDarkMode
                    ? 'assets/logos/bat-logo-white.png'
                    : 'assets/logos/bat-logo-default.png',
              ),
            ),
          ),
          Positioned(
              bottom: 7,
              right: 0,
              child: Text(
                appVersion,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall!
                    .copyWith(fontWeight: FontWeight.normal, fontSize: 8),
              ))
        ],
      ),
    );

    return _widget;
  }

  static PreferredSizeWidget MyAppBar(
      BuildContext context, bool isDarkMode, String title,
      {key, required String appVersion}) {
    final Color DATA_COLOR = Theme.of(context).colorScheme.secondary;

    final _widget = AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      leading: IconButton(
          onPressed: () => Navigator.pop(context, true),
          icon: Icon(
            Icons.arrow_back,
            color: DATA_COLOR,
          )),
      leadingWidth: MySize.Width(context, 0.15),
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(fontWeight: FontWeight.normal, color: DATA_COLOR),
      ),
      actions: [MyLogoBar(context, isDarkMode, appVersion: appVersion)],
    );

    return _widget;
  }
}

class PopUps {
  static Color CONFIRM_COLOR = MyColors.hijauImran;
  static Color CONFIRM_TEXT_COLOR = MyColors.hijauImran2;
  static Color WARNING_COLOR = MyColors.merahImran;

  static AlertDialog Default(BuildContext context, String title,
      {key,
      required String subtitle,
      String? warning,
      String? confirmText,
      String? cancelText}) {
    final Color BACKGROUND_COLOR = Theme.of(context).primaryColor;

    final _dialog = AlertDialog(
      backgroundColor: BACKGROUND_COLOR,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
              alignment: Alignment.center,
              child: Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              )),
          SizedBox(
            height: 12,
          ),
          Text(subtitle),
          warning == null
              ? SizedBox()
              : Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        FontAwesomeIcons.warning,
                        color: WARNING_COLOR,
                        size: 12,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Expanded(
                          child: Text(
                        warning,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: WARNING_COLOR),
                      )),
                    ],
                  )),
        ],
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        SizedBox(
          child: TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelText ?? "Cancel"),
          ),
        ),
        Container(
          height: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: CONFIRM_COLOR.withOpacity(0.3)),
          child: TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(confirmText ?? "Confirm",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: CONFIRM_TEXT_COLOR)),
          ),
        ),
      ],
    );

    return _dialog;
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
    this.text, {
    super.key,
    required this.gradient,
    this.style,
  });

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
    this.widget, {
    super.key,
    required this.gradient,
  });

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

class ProductCard extends StatelessWidget {
  final Image imageUrl;
  final String title;
  final int points;
  final VoidCallback onLoveIconTap;
  final Gradient gradient;

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.points,
    required this.onLoveIconTap,
    required this.gradient,
  });

// letak stack atas gmbr bawah container

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Theme.of(context).colorScheme.onSecondary,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: imageUrl,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            const SizedBox(height: 4.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$points pts',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.w300, fontSize: 14),
                ),
                IconButton(
                  icon: Icon(
                    Icons.favorite_outline_rounded,
                    color: Theme.of(context).colorScheme.onTertiary,
                  ),
                  onPressed: onLoveIconTap,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FilterButton extends StatefulWidget {
  final VoidCallback onPressed;
  final LinearGradient gradient;
  final String label;

  const FilterButton({
    super.key,
    required this.onPressed,
    required this.gradient,
    required this.label,
  });

  @override
  _FilterButtonState createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTapDown: (_) {
          setState(() {
            _isPressed = true;
          });
        },
        onTapUp: (_) {
          setState(() {
            _isPressed = false;
          });
          widget.onPressed();
        },
        onTapCancel: () {
          setState(() {
            _isPressed = false;
          });
        },
        child: Column(
          children: [
            Directionality(
                textDirection: TextDirection.rtl,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: _isPressed
                        ? widget.gradient
                        : LinearGradient(colors: [
                            Theme.of(context).colorScheme.onTertiary,
                            Theme.of(context).colorScheme.primary,
                          ]),
                    borderRadius: BorderRadius.circular(28.0),
                  ),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28.0),
                      ),
                    ),
                    icon: Icon(
                      Icons.clear_rounded,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    onPressed: widget.onPressed,
                    label: Text(
                      widget.label,
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimary, // Set text color to white
                          ),
                    ),
                  ),
                )),
          ],
        ));
  }
}

class GradientSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Gradient gradient;
  final VoidCallback onFilterPressed;
  final bool showFilterOptions;
  final List<Widget> filterOptions;
  final Function(String) onSearchChanged;

  const GradientSearchBar({
    super.key,
    required this.controller,
    required this.gradient,
    required this.onSearchChanged,
    required this.onFilterPressed,
    this.showFilterOptions = false,
    this.filterOptions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(24.0),
              ),
              child: TextField(
                controller: controller,
                onChanged: onSearchChanged,
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {},
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.tune_rounded),
                    onPressed: onFilterPressed,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor:
                      Colors.transparent, // Ensure fill color is transparent
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0.0,
                    horizontal: 20.0,
                  ),
                ),
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                child: showFilterOptions
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  FilterButton(
                                    onPressed: () {},
                                    gradient: LinearGradient(colors: [
                                      Theme.of(context).colorScheme.onTertiary,
                                      Theme.of(context).colorScheme.primary,
                                    ]),
                                    label: "Today",
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  FilterButton(
                                    onPressed: () {},
                                    gradient: LinearGradient(colors: [
                                      Theme.of(context).colorScheme.onTertiary,
                                      Theme.of(context).colorScheme.primary,
                                    ]),
                                    label: "Last Week",
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  FilterButton(
                                    onPressed: () {},
                                    gradient: LinearGradient(colors: [
                                      Theme.of(context).colorScheme.onTertiary,
                                      Theme.of(context).colorScheme.primary,
                                    ]),
                                    label: "Last Month",
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.clear_outlined),
                              ),
                            ],
                          )
                        ],
                      )
                    : SizedBox.shrink(),
                // Container(),
              ),
            ),
          ],
        ));
  }
}

// for breadcrumb
class Breadcrumb extends StatelessWidget {
  final List<String> paths;

  const Breadcrumb({super.key, required this.paths});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: paths
          .map((path) => Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (path == paths.last) {
                        return;
                      } else {
                        int index = paths.indexOf(path);
                        for (var i = paths.length - 1; i > index; i--) {
                          Navigator.pop(context);
                        }
                      }
                    },
                    child: Text(
                      path,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.normal),
                    ),
                  ),
                  if (path != paths.last)
                    Icon(
                      Icons.chevron_right,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                ],
              ))
          .toList(),
    );
  }
}
