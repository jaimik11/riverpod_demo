import 'dart:io';

import 'package:c2c/di/app_providers.dart';
import 'package:c2c/enums/profile_details_type.dart';
import 'package:c2c/l10n/localization.dart';
import 'package:c2c/router/navigation_methods.dart';
import 'package:c2c/src/data/repository/local/local_repository.dart';
import 'package:c2c/src/data/repository/remote/remote_repository.dart';
import 'package:c2c/utils/loader_util/loading_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../../constants/app_constants.dart';
import '../../../../../enums/picker_type.dart';
import '../../../../../enums/s3_bucket_folder_enum.dart';
import '../../../../../services/aws_s3_service.dart';
import '../../../../../utils/common_methods.dart';
import '../../../../../utils/logger_util.dart';
import '../../../../../utils/snackbar_widget.dart';
import '../../../../../widget/image_picker_bottom_sheet.dart';
import '../state/personal_details_state.dart';

part 'personal_details_notifier.g.dart';

@riverpod
class PersonalDetailsNotifier extends _$PersonalDetailsNotifier {
  RemoteRepository? remoteRepository = ProviderContainer().read(
    remoteRepositoryProvider,
  );
  LocalRepository? localRepository = ProviderContainer().read(
    localRepositoryProvider,
  );

  @override
  PersonalDetailsState build() {
    state = PersonalDetailsState(
      formKey: GlobalKey<FormState>(),
      mobileNumberController: TextEditingController(
        text: "AppConstants.userModel!.phone",
      ),
      numberNode: FocusNode(),
      nameController: TextEditingController(
        text: "AppConstants.userModel?.name "?? "",
      ),
      nameNode: FocusNode(),
      selectedImage: "AppConstants.userModel?.profilePicture" ?? "",
    );
    return state;
  }

  void pickImage() {
    ImagePickSheet.showImagePickBottomSheet(
      context: AppConstants.globalKey.currentContext!,
      type: PickerType.image,
      limit: 1,
      onGalleryPhotos: (List<XFile> selectedImg) async {
        if (selectedImg.isNotEmpty) {
          state = state.copyWith(selectedImage: selectedImg[0].path);
        }
        logger.i("Selected gallery path: ${selectedImg.first.path}");
        logger.i("Selected gallery name: ${selectedImg.first.name}");
      },
      onCameraImage: (XFile file) {
        state = state.copyWith(selectedImage: file.path);
        logger.i("Captured image path: ${file.path}");
        logger.i("Captured image name: ${file.name}");
      },

    );
  }
  //
  // void onButtonTap(BuildContext context,ProfileDetailsType profileDetailsType) {
  //   if (state.formKey!.currentState!.validate()) {
  //       if(state.mobileNumberController!.text.trim() != AppConstants.userModel!.phone && profileDetailsType == ProfileDetailsType.editProfile && !AppConstants.isOtpVerified){
  //         showToast(context.translate.verifyMobileNumber,success: false);
  //         return;
  //       }
  //   }
  // }


  Future<String> getUploadImageUrl(String imagePath) async {
    try {
      final XFile imageFile = XFile(imagePath);
      final String extensionName = extension(imageFile.path);
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}$extensionName';

      logger.i('IMAGE FILE - ${imageFile.path}');
      logger.i('fileName - $fileName');
      logger.i('extensionName - $extensionName');

      final bytes = await imageFile.readAsBytes();

      final uploadedUrl = await AwsS3Service.uploadFile(
        folderName: S3BucketFolderEnum.profilePicture.name,
        fileName: fileName,
        fileBytes: bytes,
        onProgress: (int sent, int total) {
          double progress = (sent / total) * 100;
          double remainingMB = (total - sent) / (1024 * 1024);
          logger.i("Upload File: $fileName");
          logger.i("Upload Progress: ${progress.toStringAsFixed(2)}%");
          logger.i("Remaining Size: ${remainingMB.toStringAsFixed(2)} MB");
        },
      );

      return uploadedUrl;
    } catch (e) {
      logger.e("Upload failed for $imagePath: $e");
      return '';
    }
  }



  /// Handles deeplink
  Future<void> _handleDeepLink() async {
    print(
      'AppConstants.deepLinkUrl -- ${AppConstants.deepLinkUrl}',
    );
    if (AppConstants.deepLinkUrl != null) {

      final data = AppConstants.deepLinkUrl;
      AppConstants.deepLinkUrl = null; // Clear after handling
      print(
        'AppConstants.data -- ${data}',
      );
      if (data != null && data.isNotEmpty) {
        CommonMethods.getRouteFromDynamicLinks(Uri.parse(data), AppConstants.globalKey.currentContext!);
      }
    } else {
      // AppConstants.globalKey.currentContext?.popAllAndPush(
      //   Routes.homeStreetDeals,
      // );
    }
  }
}
