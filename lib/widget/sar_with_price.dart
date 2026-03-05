import 'package:c2c/gen/assets.gen.dart';
import 'package:flutter/material.dart';

import '../enums/text_color_type.dart';
import '../theme/text_styles.dart';

class SarWithPrice extends StatelessWidget {
  String? price;
  TextStyle? style;
  SarWithPrice({super.key,this.price,this.style});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Assets.images.svg.backIcon.svg(
              height: 14,
              width: 14,
              colorFilter: ColorFilter.mode(TextColorType.defaultColor.resolve(context), BlendMode.srcIn)),
          SizedBox(width: 5,),
          Text(
            price ?? "0.0",
            style: style ?? TextStyles.body1Medium.copyWith(
              color: TextColorType.defaultColor.resolve(context),
            ),
          ),
        ],
      ),
    );
  }
}
