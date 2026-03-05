import 'package:flutter/material.dart';

import '../enums/text_color_type.dart';
import '../gen/assets.gen.dart';
import '../theme/app_colors.dart';
import '../theme/text_styles.dart';

class CustomExpansionTile extends StatefulWidget {
  final String? title;
  final Widget content;
  final Widget? titleWidget;
  final bool isExpanded;
  final bool showArrow;
  final bool showBorder;
  final VoidCallback onExpand;

  const CustomExpansionTile({
    super.key,
     this.title,
    required this.content,
    required this.isExpanded,
    this.showArrow = true,
    required this.onExpand,
     this.titleWidget,
    this.showBorder = true,
  });

  @override
  _CustomExpansionTileState createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: widget.showBorder ? Border.all(
          color:widget.isExpanded ? TextColorType.defaultColor.resolve(context) : TextColorType.borderStroke.resolve(context), // Change border color
          width: 1.5,
        ) : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Header (Clickable)
          InkWell(
            onTap: widget.onExpand,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding:  EdgeInsetsDirectional.only(
                top: 10,
                bottom: widget.isExpanded ? 0 : 10,
                  start: 16,
                  end: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.titleWidget ?? Text(
                    widget.title ?? "",
                    style: TextStyles.body1Medium.copyWith(color: TextColorType.defaultColor.resolve(context)),
                  ),
                  Visibility(
                    visible: widget.showArrow,
                    child: AnimatedRotation(
                      turns: widget.isExpanded ? 0.25 : -0.25, // Rotates 90° when expanded
                      duration: const Duration(milliseconds: 300),
                      child: Assets.images.svg.backIcon.svg(matchTextDirection: true,color: TextColorType.defaultColor.resolve(context)),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Visibility(
            visible: widget.isExpanded && widget.showBorder,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0,vertical: 4),
                child: Divider(),
              )
          ),

          // Expandable Content
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(), // Hidden when collapsed
            secondChild: widget.content,
            crossFadeState:
            widget.isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }
}
