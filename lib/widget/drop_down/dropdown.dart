import 'package:c2c/gen/assets.gen.dart';
import 'package:c2c/l10n/localization.dart';
import 'package:c2c/router/navigation_methods.dart';
import 'package:c2c/utils/snackbar_widget.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../enums/text_color_type.dart';
import '../../router/route_observer.dart';
import '../../theme/text_styles.dart';
import '../../utils/app_validator.dart';
import '../app_check_box.dart';
import '../app_text_field.dart';
import '../app_text_field_label.dart';

class CommonDropDown<T> extends StatefulWidget {
  final Function(dynamic)? selectedValue;
  final List<T>? dropDownValueList;
  final dynamic dropDownValue; // T or List<T>
  final String placeHolder;
  final ScrollController? scrollController;
  final bool showPlaceHolder;
  final TextFieldType textFieldType;
  final String Function(T item) getTitle;
  final bool readOnly;
  final bool isMultiSelect;
  final int maxSelection;
  final String maxSelectionMsg;
  final bool allowValidate;

  const CommonDropDown({
    super.key,
    required this.placeHolder,
    this.selectedValue,
    this.scrollController,
    this.dropDownValueList,
    this.dropDownValue,
    this.textFieldType = TextFieldType.required,
    required this.getTitle,
    this.readOnly = false,
    this.isMultiSelect = false,
    this.maxSelection = 0,
    this.maxSelectionMsg = "",
    this.showPlaceHolder = true,
    this.allowValidate = false,
  });

  @override
  State<CommonDropDown<T>> createState() => _CommonDropDownState<T>();
}

class _CommonDropDownState<T> extends State<CommonDropDown<T>> {
  late dynamic selected; // T or List<T>
  bool isDropdownOpen = false;
  final GlobalKey _buttonKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    selected = widget.dropDownValue ?? (widget.isMultiSelect ? <T>[] : null);
    setState(() {});
  }


  void _scrollToDropdown() {
    // Delay ensures the dropdown menu is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox? box =
      _buttonKey.currentContext?.findRenderObject() as RenderBox?;
      if (box != null) {
        final position = box.localToGlobal(Offset.zero).dy;
        if(widget.scrollController != null){
          widget.scrollController!.animateTo(
            widget.scrollController!.offset + position, // 100 = padding
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayText = () {
      if (widget.isMultiSelect) {
        final items = selected as List<T>;
        return items.isEmpty
            ? "${context.translate.select} ${widget.placeHolder}"
            : items.map(widget.getTitle).join(', ');
      } else {
        if (selected == null && widget.showPlaceHolder) {
          return "${context.translate.select} ${widget.placeHolder}";
        } else if (selected == null && !widget.showPlaceHolder) {
          return widget.placeHolder;
        } else {
          return widget.getTitle(selected as T);
        }
      }
    }();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.placeHolder.isNotEmpty && widget.showPlaceHolder)
          Padding(
            padding: const EdgeInsetsDirectional.only(bottom: 6),
            child: AppTextFieldHeader(
              headerTxt: widget.placeHolder,
              textFieldType: widget.textFieldType,
              headerTxtStyle: TextStyles.body2Medium,
            ),
          ),
        IgnorePointer(
          ignoring: widget.readOnly,
          child: DropdownButtonFormField2<T?>(
            isExpanded: true,
            key: _buttonKey,
            onMenuStateChange: (isOpen) {
              isDropdownOpen = isOpen;
              setState(() {});
              if (isDropdownOpen) {
                _scrollToDropdown();
              }
            },
            value: widget.isMultiSelect ? null : selected,
            validator: (value) {
              if (!widget.isMultiSelect &&
                  value == null &&
                  widget.allowValidate) {
                return context.translate.pleaseSelect(
                  widget.placeHolder.toLowerCase(),
                );
              }
              return null;
            },
            decoration: InputDecoration(
              isDense: false,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: TextColorType.borderStroke.resolve(context),
                ),
              ),
              filled: true,
              fillColor: TextColorType.defaultColor.resolve(
                context,
                invertColor: true,
              ),
            ),
            // hint:widget.isMultiSelect
            //     ? (selected as List<T>).isEmpty
            //     ? Text(
            //   displayText,
            //   style: TextStyles.body1Regular.copyWith(
            //     color: TextColorType.defaultColor.resolve(context),
            //   ),
            // )
            //     : Wrap(
            //       spacing: 2,
            //       runSpacing: 0,
            //       children: (selected as List<T>)
            //           .asMap()
            //           .entries
            //           .map((entry) {
            //         final index = entry.key;
            //         final value = entry.value;
            //         final isLast =
            //             index == (selected as List<T>).length - 1;
            //
            //         return Text(
            //           "${widget.getTitle(value)}${isLast ? '' : ','}",
            //           style: TextStyles.body1Regular.copyWith(
            //             color: TextColorType.defaultColor.resolve(context),
            //           ),
            //         );
            //       }).toList(),
            //     )
            //     : Text(
            //   displayText,
            //   style: TextStyles.body1Regular.copyWith(
            //     color: TextColorType.defaultColor.resolve(context),
            //   ),
            // ),
            // 🚀 use customButton instead of hint/value
            customButton: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 👈 left: selected text(s)
                  Expanded(
                    child: (widget.isMultiSelect && (selected as List<T>).isNotEmpty)
                        ? Wrap(
                      spacing: 2,
                      runSpacing: 0,
                      children: (selected as List<T>)
                          .asMap()
                          .entries
                          .map((entry) {
                        final index = entry.key;
                        final value = entry.value;
                        final isLast =
                            index == (selected as List<T>).length - 1;
                        return Text(
                          "${widget.getTitle(value)}${isLast ? '' : ','}",
                          style: TextStyles.body1Regular.copyWith(
                            color: TextColorType.defaultColor.resolve(context),
                          ),
                        );
                      }).toList(),
                    )
                        : Text(
                      displayText,
                      style: TextStyles.body1Regular.copyWith(
                        color: TextColorType.defaultColor.resolve(context),
                      ),
                    ),
                  ),
                  // 👉 right: arrow icon
                  AnimatedRotation(
                    turns: isDropdownOpen ? 0.75 : 0.25,
                    duration: const Duration(milliseconds: 300),
                    child: SvgPicture.asset(
                      "Assets.images.svg.arrowRight.path",
                      height: 20,
                      color: !widget.readOnly
                          ? TextColorType.defaultColor.resolve(context)
                          : Colors.transparent,
                    ),
                  ),
                ],
              ),
            ),
            // iconStyleData: IconStyleData(
            //   icon: Padding(
            //     padding: const EdgeInsetsDirectional.only(end: 8),
            //     child: AnimatedRotation(
            //       turns: isDropdownOpen ? 0.75 :0.25,
            //       duration: const Duration(milliseconds: 500),
            //       child: SvgPicture.asset(
            //         Assets.images.svg.arrowRight.path,
            //         color: !widget.readOnly
            //             ? TextColorType.defaultColor.resolve(context)
            //             : Colors.transparent,
            //       ),
            //     ),
            //   ),
            // ),
            items: widget.dropDownValueList?.map((T item) {
              return DropdownMenuItem<T>(
                enabled: !widget.isMultiSelect,
                value: item,
                child: StatefulBuilder(
                  builder: (context, setInnerState) {
                    final isChecked =
                        widget.isMultiSelect &&
                            (selected as List<T>?)?.contains(item) == true;

                    return GestureDetector(
                      onTap: (){
                        if(widget.isMultiSelect){
                          final list = List<T>.from(selected ?? []);
                          if (isChecked) {
                            list.remove(item);
                          } else {
                            if((selected as List<T>).length < widget.maxSelection){
                              list.add(item);
                            }else{
                              showToast(widget.maxSelectionMsg,success: false);
                            }
                          }
                          setState(() {
                            selected = list;
                            widget.selectedValue?.call(list);
                          });

                          // 🔥 this ensures the checkbox redraws immediately
                          setInnerState(() {});
                        }else{
                          if (!widget.isMultiSelect && item != null) {
                            widget.selectedValue?.call(item);
                            setState(() => selected = item);
                            context.pop();
                          }
                        }

                      },
                      child: Row(
                        children: [
                          if (widget.isMultiSelect)
                            AppCheckBox(
                              isSelected: isChecked,
                              onCheck: (_) {
                                final list = List<T>.from(selected ?? []);
                                if (isChecked) {
                                  list.remove(item);
                                } else {
                                  if((selected as List<T>).length < widget.maxSelection){
                                    list.add(item);
                                  }else{
                                    showToast(widget.maxSelectionMsg,success: false);
                                  }
                                }
                                setState(() {
                                  selected = list;
                                  widget.selectedValue?.call(list);
                                });

                                // 🔥 this ensures the checkbox redraws immediately
                                setInnerState(() {});
                              },
                            ),
                            SizedBox(width: 16,),
                            Expanded(
                            child: Text(
                              widget.getTitle(item),
                              style: TextStyles.body1Regular.copyWith(
                                color: TextColorType.defaultColor.resolve(context),
                              ),
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }).toList(),
            onChanged: (value) {
              print("widget.isMultiSelect ${widget.isMultiSelect} value $value");
              if (!widget.isMultiSelect && value != null) {
                widget.selectedValue?.call(value);
                setState(() => selected = value);
              }
            },
            isDense: false,
            buttonStyleData: const ButtonStyleData(
              elevation: 2,
              height: null, // 🚀 allow dynamic height
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
              ),
              offset: const Offset(0, 0),
              scrollbarTheme: ScrollbarThemeData(
                radius: const Radius.circular(40),
                thickness: MaterialStateProperty.all(6),
                thumbVisibility: MaterialStateProperty.all(true),
              ),
            ),
            menuItemStyleData: const MenuItemStyleData(
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 14),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void didUpdateWidget(covariant CommonDropDown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.dropDownValue != oldWidget.dropDownValue) {
      selected = widget.dropDownValue ?? (widget.isMultiSelect ? <T>[] : null);
    }
  }
}
