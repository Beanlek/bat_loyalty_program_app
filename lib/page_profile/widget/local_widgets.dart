import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  static Widget Header(BuildContext context,
    {key, required String title, Widget trailing = PLACEHOLDER_ICON, Widget? secondTrailing}
  ) {
    final _widget = Row(
      children: [
        Expanded(child: Text(title, style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.primary))),
    
        trailing,
        secondTrailing ?? SizedBox()
      ],
    );
  
    return _widget;
  }

  static Widget ConfirmationListTile(BuildContext context,
    { key, required String title, required TextEditingController controller,
      void Function()? onPressed,
      void Function()? onTap,
      void Function(String)? onChanged,
      void Function(String)? onSubmitted,
      required FocusNode focusNode,
      bool readOnly = false,
      bool isPassword = false,
      bool isImage = false,
      bool digitOnly = false,
    }
  ) {
    const ICON_SIZE = 16.0;
    final LISTTILE_HEIGHT = MySize.Height(context, 0.065);
    final IMAGE_DIMENSION = MySize.Height(context, 0.11);
    
    bool _isPasswordVisible = isPassword;

    final _widget = StatefulBuilder(
      builder: (context, setState) {

        IconButton obscureIconButton() {
          return IconButton(
            iconSize: ICON_SIZE,
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

        IconButton editIconButton() {
          return IconButton(
            iconSize: ICON_SIZE,
            icon: Icon(
              focusNode.hasFocus ? Icons.check : Icons.edit
            ),
            onPressed: () => setState(() {
              if (focusNode.hasFocus) {
                focusNode.unfocus();
              } else if (!focusNode.hasFocus) {
                focusNode.requestFocus();
              }
            } )
          );
        }

        return SizedBox(
          height: isImage ? null : LISTTILE_HEIGHT,
          child: ListTile(
            contentPadding: EdgeInsets.only(left: 12),
            visualDensity: isImage ? VisualDensity.standard : VisualDensity.compact,
            
            titleTextStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer
            ),
            iconColor: Theme.of(context).colorScheme.primary,
            
            title: Text(title),
            subtitle:
            isImage ?
            Padding( padding: EdgeInsets.only(top: 12), child: Align( alignment: Alignment.centerLeft,
              child: Container(
                height: IMAGE_DIMENSION,
                width: IMAGE_DIMENSION,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Theme.of(context).colorScheme.primary),
                  color: Colors.transparent
                ),
                child: Center(child: SizedBox(
                  height: IMAGE_DIMENSION - 10,
                  width: IMAGE_DIMENSION - 10,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child:
                    (isImage ? !_isPasswordVisible : isImage) ?
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9),
                        color: Theme.of(context).primaryColor
                      ),
                      child: Center(
                        child: SizedBox.square(
                          dimension: IMAGE_DIMENSION - 10,
                          child: Icon(Icons.hide_image, size: ICON_SIZE, color: Theme.of(context).colorScheme.primary,),
                        ),
                      )
                    )
                    : controller.text.trim() == 'N/A' ?  Icon(Icons.error, size: ICON_SIZE, color: Theme.of(context).colorScheme.error,) : Image.asset(controller.text.trim(), fit: BoxFit.cover,)
                  ),
                ))
              ),
            ))
            
            : EditProfileField( context, title,
              focusNode: focusNode,
              controller: controller,
              obscureText: _isPasswordVisible,
              readOnly: readOnly,
              digitOnly: digitOnly,
            
              onTap: onTap,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
            ),
          
            trailing: (isPassword || isImage) ? SizedBox(
              width: MySize.Width(context, 0.25),
              child: Row( mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  obscureIconButton(),
                  readOnly ? SizedBox() :
                  editIconButton(),
                ],
              ),
            ) : readOnly ? SizedBox() :
        
            editIconButton(),
          ),
        );
      }
    );
  
    return _widget;
  }

  static Widget EditProfileField(BuildContext context, String title,
    {key, required FocusNode focusNode, required TextEditingController controller,
      required bool obscureText, bool readOnly = false,
      void Function()? onTap,
      void Function(String)? onChanged,
      void Function(String)? onSubmitted,
      bool digitOnly = false
    }
  ) {
    final _widget = TextField(
      focusNode: focusNode,
      controller: controller,
      obscureText: obscureText,
      readOnly: readOnly,
      keyboardType: !digitOnly ? null : TextInputType.phone,

      onTap: onTap,
      onChanged: onChanged,
      onSubmitted: onSubmitted,

      decoration: InputDecoration(border: InputBorder.none, isDense: true,
        hintText: title, hintStyle: TextStyle( color: Theme.of(context).colorScheme.onTertiary.withOpacity(0.5), fontWeight: FontWeight.normal),
      ),
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.primary),
    );
  
    return _widget;
  }

  static Widget dropdownField(BuildContext context, String text,
      {key,
      required String selectedFilter,
      required List<String> filters,
      bool active = true,
      void Function(String?)? onChanged}) {


    final DATA_COLOR = Theme.of(context).colorScheme.primary;
    final MENU_HEIGHT = MySize.Height(context, 0.3);
    final Localizations = AppLocalizations.of(context);
    final _widget = StatefulBuilder(builder: (context, setState) {

      return SizedBox(
        child: ListTile(
          contentPadding: EdgeInsets.only(left: 12),
          visualDensity: VisualDensity.compact,
        
          titleTextStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
            color: Theme.of(context).colorScheme.onPrimaryContainer
          ),
        
          title: Padding( padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(text),
          ),
        
          subtitle: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: DATA_COLOR),
            ),
            child: DropdownButtonFormField(
                isExpanded: true, isDense: true,
                menuMaxHeight: MENU_HEIGHT,
                decoration: InputDecoration( border: OutlineInputBorder(borderSide: BorderSide.none)),
                    
                icon: Icon( Icons.arrow_forward_ios_rounded, color: DATA_COLOR.withOpacity(active ? 1 : 0.5) ),
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
          ),
        ),
      );
    });

    return _widget;
  }
}