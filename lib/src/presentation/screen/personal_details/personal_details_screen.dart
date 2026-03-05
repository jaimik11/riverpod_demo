import 'dart:io';

import 'package:c2c/constants/api_constants.dart';
import 'package:c2c/constants/app_constants.dart';
import 'package:c2c/enums/profile_details_type.dart';
import 'package:c2c/l10n/localization.dart';
import 'package:c2c/router/navigation_methods.dart';
import 'package:c2c/src/presentation/screen/personal_details/personal_details_args.dart';
import 'package:c2c/widget/app_scaffold.dart';
import 'package:c2c/widget/network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/app_size_constants.dart';
import '../../../../enums/text_color_type.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/text_styles.dart';
import '../../../../utils/app_validator.dart';
import '../../../../utils/common_consumer.dart';
import '../../../../widget/app_button.dart';
import '../../../../widget/app_text_field.dart';
import '../../../../widget/custom_app_bar.dart';
import 'notifier/personal_details_notifier.dart';
import 'state/personal_details_state.dart';

class PersonalDetailsScreen extends StatelessWidget {
  final PersonalDetailsArgs args;

  const PersonalDetailsScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return AutoConsumerBuilder<PersonalDetailsState, PersonalDetailsNotifier>(
      provider: personalDetailsNotifierProvider,
      builder: (context, state, notifier, ref) {
        return AppScaffold(
          appBar: getAppbar(args.type),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
              child: AppButton(
                onPressed: () {
                  // notifier.onButtonTap(context,args.type);
                },
                buttonText:
                    args.type == ProfileDetailsType.editProfile
                        ? context.translate.save
                        : context.translate.register,
                buttonRadius: AppSizeConstants.kBorderRadius,
                textStyle: TextStyles.body1Medium,
                buttonColor: AppColors.primary,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Visibility(
                  visible: args.type == ProfileDetailsType.editProfile,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      ProfileDetailsType.createProfile.value,
                      style: TextStyles.subtitle2SemiBold.copyWith(
                        color: TextColorType.defaultColor.resolve(context),
                      ),
                    ),
                  ),
                ),
                profileWidget(),
                Form(
                  key: state.formKey,
                  child: Column(
                    spacing: 10,
                    children: [
                      fullNameField(context: context, state: state, ref: ref,type: args.type,),
                      mobileField(
                        context: context,
                        state: state,
                        ref: ref,
                        type: args.type,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  CustomAppBar getAppbar(ProfileDetailsType type) {
    if (type == ProfileDetailsType.createProfile) {
      return CustomAppBar(
        titleText: args.type.value,
        showBackIcon: false,
        centerTitle: true,
      );
    } else {
      return CustomAppBar(titleText: args.type.value, showBottomDivider: true);
    }
  }

  Widget profileWidget() {
    // final state = ref.watch(personalDetailsNotifierProvider);
    return AutoConsumerBuilder<PersonalDetailsState, PersonalDetailsNotifier>(
      provider: personalDetailsNotifierProvider,
      builder: (
        BuildContext context,
        PersonalDetailsState state,
        PersonalDetailsNotifier notifier,
        WidgetRef ref,
      ) {
        print("state.selectedImage ${state.selectedImage}");
        return Row(
          spacing: 12,
          children: [
            Container(
              height: 90,
              width: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white,
                border: Border.all(color: AppColors.stroke),
              ),
              child:
                  state.selectedImage.isNotEmpty &&
                          state.selectedImage.startsWith('http')
                      ? NetworkImageWidget(url: state.selectedImage,borderRadius: 100,height: 50,width: 50,)
                      : state.selectedImage.isNotEmpty
                      ? ClipRRect(borderRadius: BorderRadius.circular(100),
                      child: Image.file(File(state.selectedImage),fit: BoxFit.cover,))
                      : Container(),
            ),
            InkWell(
              onTap: () {
                notifier.pickImage();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.neutral2),
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.white,
                ),
                child: Center(
                  child: Text(
                    state.selectedImage != null
                        ? context.translate.changePhoto
                        : context.translate.uploadPhoto,
                    style: TextStyles.body1Medium.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget mobileField({
    required BuildContext context,
    required PersonalDetailsState state,
    required WidgetRef ref,
    required ProfileDetailsType type,
  }) {
    return Directionality(
      textDirection: AppConstants.ltrDirection,
      child: AppTextField(
        headerText: context.translate.mobileNumber,
        textFieldType: TextFieldType.required,
        hintText: context.translate.enterMobileNumber,
        textEditingController: state.mobileNumberController!,
        textInputAction: TextInputAction.done,
        focusNode: state.numberNode,
        textInputType: TextInputType.phone,
        enabled: type == ProfileDetailsType.createProfile ? false : true,
        filled: true,
        inputFormat: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        maxLength: 10,
        counterText: "",
        onChanged: (value){
          // if(value == AppConstants.userModel!.phone){
          //   AppConstants.isOtpVerified = true;
          // }else{
          //   AppConstants.isOtpVerified = false;
          // }
        },
        suffixWidget: Visibility(
          visible: type == ProfileDetailsType.editProfile,
          child: StreamBuilder<String>(
            stream: Stream.periodic(const Duration(milliseconds: 1), (_) => state.mobileNumberController!.text),
            builder: (context, snapshot) {
              final text = snapshot.data ?? '';
              return Visibility(
                visible: true,
                // visible: text.trim() != AppConstants.userModel!.phone && !AppConstants.isOtpVerified && AppValidator.isMobile(text.trim()),
                child: InkWell(
                  onTap: (){
                    if (state.formKey!.currentState!.validate()) {
                      AppConstants.isOtpVerified = false;
                  }
                    },
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(top: 12, end: 10),
                    child: Text(
                      context.translate.verify,
                      style: TextStyles.body1Regular.copyWith(color: AppColors.primary),
                    ),
                  ),
                ),
              );
            },
          )
          ,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsetsDirectional.only(top: 13.5, start: 8),
          child: Text(
            '+966',
            style: TextStyles.body1Regular.copyWith(
              color: TextColorType.defaultColor.resolve(context),
            ),
          ),
        ),
        validator: (value) => AppValidator.mobileNumber(value: value ?? ""),
      ),
    );
  }

  Widget fullNameField({
    required BuildContext context,
    required PersonalDetailsState state,
    required WidgetRef ref, required ProfileDetailsType type,
  }) {
    return AppTextField(
      headerText: context.translate.fullName,
      textFieldType: TextFieldType.required,
      hintText: context.translate.enterFullName,
      textEditingController: state.nameController!,
      focusNode: state.nameNode,
      nextFocusNode: state.numberNode,
      textInputAction: type == ProfileDetailsType.createProfile ? TextInputAction.done : TextInputAction.next,
      textInputType: TextInputType.text,
      inputFormat: [
        FilteringTextInputFormatter.allow(
          AppValidator.allowedNameRegex,
        ),
      ],
      maxLength: 70,
      counterText: "",
      textCapitalization: TextCapitalization.words,
      filled: true,
      validator:
          (value) => AppValidator.name(value: value!),
    );
  }
}
