
import 'package:c2c/di/app_providers.dart';
import 'package:c2c/enums/language_code.dart';
import 'package:c2c/src/data/repository/local/local_repository.dart';
import 'package:c2c/src/data/repository/remote/remote_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../../constants/app_constants.dart';
import '../../../../../di/local_notifier.dart';
import '../../../../../enums/picker_type.dart';
import '../../../../../utils/logger_util.dart';
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
      mobileNumberController: TextEditingController(),
      numberNode: FocusNode(),
      nameController: TextEditingController(),
      nameNode: FocusNode(),
      selectedLocale: AppConstants.currentLocale,
      selectedImage: "",
    );
    return state;
  }

  emitCurrentLocale(){
    state = state.copyWith(selectedLocale: AppConstants.currentLocale);
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


  void toggle(LanguageCode selectedLocale) {

    if (state.selectedLocale != selectedLocale) {
      print("called");
      state = state.copyWith(selectedLocale: selectedLocale);
    }

  }

  Future<void> changeLanguageApi() async {
    ref.read(localeNotifierProvider.notifier).changeLocale(lang: state.selectedLocale ?? AppConstants.defaultLocale);
    return;
    // try {
    //
    //   final response =  await remoteRepository?.changeLanguageApi(langCode: state.selectedLocale?.name ?? AppConstants.defaultLocale.name);
    //   if (response?.success ?? false) {
    //     callUserAPI();
    //     final container = ProviderScope.containerOf(
    //       AppConstants.globalKey.currentContext!,
    //     );
    //     container
    //         .read(homeStreetDealsNotifierProvider.notifier)
    //         .getInspectorListAPI();
    //     ref.read(localeNotifierProvider.notifier).changeLocale(lang: state.selectedLocale ?? AppConstants.defaultLocale);
    //     ref.read(
    //       homeStreetDealsNotifierProvider.notifier,
    //     ).homeDetailAPI();
    //     ref.read(
    //       homeStreetDealsNotifierProvider.notifier,
    //     ).purchaseSupport();
    //     ref.read(
    //       homeStreetDealsNotifierProvider.notifier,
    //     ).homeBannerAPI();
    //   } else {
    //   }
    // } catch (e) {
    //   logger.e("changeLanguageApi: $e");
    // }
  }
}
