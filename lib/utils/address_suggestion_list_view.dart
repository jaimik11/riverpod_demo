import 'package:c2c/utils/loader_util/loading_dialog.dart';
import 'package:c2c/utils/logger_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../services/google_place/google_place_model.dart';
import '../../services/google_place/google_place_service.dart';
import '../enums/text_color_type.dart';
import '../theme/app_colors.dart';


class AddressSuggestionListView extends StatelessWidget {
  final double? listHeight;
  final List locationList;
  final CancelToken? cancelToken;
  final void Function(GooglePlaceModel googlePlaceModel)? onTapPlace;

  const AddressSuggestionListView({
    super.key,
    this.listHeight,
    this.cancelToken,
    required this.locationList,
    this.onTapPlace,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: locationList.isEmpty ? 0 : listHeight,
      child: Card(
        color:TextColorType.bgColor.resolve(
          context,
        ),
        elevation: 2,
        margin: const EdgeInsetsDirectional.only(top: 8),
        child: Scrollbar(
          child: ListView.separated(
            shrinkWrap: true,
            primary: false,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: locationList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsetsDirectional.symmetric(vertical: 8, horizontal: 8),
                child: InkWell(
                  splashColor: AppColors.transparent,
                  highlightColor: AppColors.transparent,
                  onTap: () async {
                    LoadingDialog.of(context).show();

                    logger.i("LOC ID: ${locationList[index]['place_id']}");

                    GooglePlaceModel googlePlaceModel =
                        await GooglePlaceService.getPlaceDetails(
                          placeId: locationList[index]['place_id'],
                          cancelToken: cancelToken,
                        );

                    if (googlePlaceModel.locationAddressFull.isNotEmpty) {
                      onTapPlace?.call(googlePlaceModel);
                    }
                    LoadingDialog.of(context).hide();
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on_rounded),
                      const SizedBox(width: 16),
                      Expanded(child: Text(locationList[index]['description'])),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const Divider(),
          ),
        ),
      ),
    );
  }
}
