import 'dart:io';
import 'dart:ui';

import 'package:c2c/enums/text_color_type.dart';
import 'package:c2c/l10n/localization.dart';
import 'package:c2c/router/navigation_methods.dart';
import 'package:c2c/theme/app_colors.dart';
import 'package:c2c/utils/loader_util/loading_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:image_picker/image_picker.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:picker_pro_max_ultra/media_picker_widget.dart';


import '../../../utils/logger_util.dart';

import '../../enums/image_type.dart';
import '../constants/app_constants.dart';
import '../enums/picker_type.dart';
import '../theme/text_styles.dart';
import '../utils/common_methods.dart';
import '../utils/snackbar_widget.dart';

class ImagePickSheet extends StatelessWidget {
  final PickerType type;
  final Function()? onGallerySelect;
  final Function()? onCameraSelect;
  final Function()? onVideoSelect;
  final Function()? onDocumentSelect;

  const ImagePickSheet({
    super.key,
    this.onGallerySelect,
    this.onCameraSelect,
    this.onVideoSelect,
    this.onDocumentSelect,
    this.type = PickerType.gallery,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool isDarkMode = theme.brightness == Brightness.dark;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX:0, sigmaY: 0),
      child: Container(
        decoration: BoxDecoration(
          color: TextColorType.defaultColor.resolve(context,invertColor: true),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(16),topRight: Radius.circular(16)),
        ),
        padding:
        const EdgeInsets.only(left: 16, right: 16, top: 16),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                  context.translate.selectUploadOption,
                  style: TextStyles.body1Regular.copyWith(color: TextColorType.defaultColor.resolve(context),),
              ),
              const SizedBox(height: 24),
              Row(
                spacing: 10,
                mainAxisAlignment:  MainAxisAlignment.center,
                children: [
                  /// Camera
                  ///
                  if(type == PickerType.all || type == PickerType.image || type == PickerType.camera || type == PickerType.excludeVideo)
                  InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      onCameraSelect!();
                    },
                    child: _imageTypeContainer(
                      context,
                      title: context.translate.takeAPhoto,
                      icon: Icons.camera_alt_rounded,
                    ),
                  ),
          
          
                  /// Gallery
                  ///
                  if(type == PickerType.all || type == PickerType.image || type == PickerType.gallery || type == PickerType.excludeVideo)
                  InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      onGallerySelect!();
                    },
                    child: _imageTypeContainer(
                      context,
                      title: context.translate.chooseFromGallery,
                      icon: Icons.photo,
                    ),
                  ),
          
          
          
                  if(type == PickerType.all || type == PickerType.video )
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        onVideoSelect!();
                      },
                      child: _imageTypeContainer(
                        context,
                        title: "Choose From Gallery",
                        icon: Icons.video_call_rounded,
                      ),
                    ),
          
          
                  if(type == PickerType.all || type == PickerType.document  || type == PickerType.excludeVideo)
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        onDocumentSelect!();
                      },
                      child: _imageTypeContainer(
                        context,
                        title: "Document",
                        icon: Icons.file_copy,
                      ),
                    ),
          
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imageTypeContainer(
      BuildContext context, {
        required String title,
        required IconData? icon,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: AppColors.primary,
        ),
        height: 80,
        width: 80,
        child: Center(
          child: Icon(
            icon,
            size: 32,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }

  static Future<void> showImagePickBottomSheet({
    required BuildContext context,
    bool isDismissible = true,
    int limit = 1,
    PickerType type = PickerType.all,
    Function(XFile selectedImg)? onCameraImage,
    Function(List<XFile> selecteVideo)? onSelectVideo,
    Function(File selecteDocument)? onSelectDocument,
    Function(List<XFile> multiSelect)? onGalleryPhotos,
  }) async {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      useSafeArea: true,
      isDismissible: isDismissible,
      builder: (context) {
        return ImagePickSheet(
          onGallerySelect: () async {

            context.pop();

            bool isEnable = false;
            if (Platform.isAndroid) {
              isEnable = true;
            } else {
              isEnable = await CommonMethods.askPermission(
                  permission: await CommonMethods.getPermission(MediaType.image), // todo manage this dynamic
                  whichPermission: AppConstants.globalKey.currentContext?.translate.gallery,
                );
            }

            // bool isEnable = await CommonMethods.askPermission(
            //   permission: await CommonMethods.getPermission(MediaType.image), // todo manage this dynamic
            //   whichPermission: AppConstants.globalKey.currentContext?.translate.gallery,
            // );
            if (isEnable) {
              print("limit------ $limit");
              // return;
              List<XFile>? result;
                AppConstants.globalKey.currentContext?.loading.show();
              if(limit == 1){
                final XFile? imageFile = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 65,
                );
                if(imageFile != null){
                  result = [imageFile];
                }
              }else{
                result = await ImagePicker().pickMultiImage(
                    imageQuality: 65,
                );
              }
                if (result != null && result.isNotEmpty) {
                  for(int i = 0;i<result.length;i++){
                    logger.i("IMAGE PICKED: ${result[i]}");
                    final XFile imageFile = XFile(result[i].path!);

                    if (CommonMethods.isValidFile(imageFile.path)) {
                      bool isValidImage = await CommonMethods.imageSize(imageFile);
                      logger.i("IMAGE PICKED $isValidImage : $imageFile");

                      if (isValidImage) {
                        if(i == result.length-1){
                          onGalleryPhotos!(result.map((f)=>XFile(f.path!)).toList());
                        }

                      } else {
                        showToast(AppConstants.globalKey.currentState!.context.translate.fileSizeValidation,success: false);
                        break;
                      }
                    } else {
                      showToast(AppConstants.globalKey.currentState!.context.translate.imageFormatValidation,success: false);

                    }
                  }
                } else {
                  logger.i("else PICKED:}");
                }
              AppConstants.globalKey.currentContext?.loading.hide();

                /// USING FILE PICKER
               /* FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.image,
                  allowCompression: true,
                  allowMultiple: true,
                  // allowedExtensions: CommonMethods.imageExtensions,
                );

                AppConstants.globalKey.currentContext?.loading.hide();
                if (result != null) {
                  if ( result.files != null && result.files.isNotEmpty) {


                    for(int i = 0;i<result.files.length;i++){
                      logger.i("IMAGE PICKED: ${result.files[i]}");
                      final XFile imageFile = XFile(result.files[i].path!);

                      if (CommonMethods.isValidFile(imageFile.path)) {
                        bool isValidImage = await CommonMethods.imageSize(imageFile);
                        logger.i("IMAGE PICKED $isValidImage : $imageFile");

                        if (isValidImage) {
                          if(i == result.files.length-1){
                            onGalleryPhotos!(result.files.map((f)=>XFile(f.path!)).toList());
                          }

                        } else {
                          showToast(AppConstants.globalKey.currentState!.context.translate.fileSizeValidation,success: false);
                          break;
                        }
                      } else {
                        showToast(AppConstants.globalKey.currentState!.context.translate.imageFormatValidation,success: false);

                      }
                    }
                  }
                } else {
                  logger.i("else PICKED:}");
                }*/
             // await  MediaPicker(
             //        context: AppConstants.globalKey.currentContext!,maxLimit: limit,
             //         mediaType: MediaType.image,
             //
             //         doneText: AppConstants.globalKey.currentContext!.translate.done,
             //   cancelText: AppConstants.globalKey.currentContext!.translate.cancel
             // ).showPicker().then((images) async {
             //
             //   AppConstants.globalKey.currentContext?.loading.hide();
             //      if ( images != null && images.isNotEmpty) {
             //
             //
             //        for(int i = 0;i<images.length;i++){
             //          logger.i("IMAGE PICKED: ${images[i]}");
             //          final XFile imageFile = XFile(images[i]);
             //
             //          if (CommonMethods.isValidFile(imageFile.path)) {
             //            bool isValidImage = await CommonMethods.imageSize(imageFile);
             //            logger.i("IMAGE PICKED $isValidImage : $imageFile");
             //
             //            if (isValidImage) {
             //              if(i == images.length-1){
             //                onGalleryPhotos!(images.map((f)=>XFile(f)).toList());
             //              }
             //
             //            } else {
             //              showToast(AppConstants.globalKey.currentState!.context.translate.fileSizeValidation,success: false);
             //              break;
             //            }
             //          } else {
             //            showToast(AppConstants.globalKey.currentState!.context.translate.imageFormatValidation,success: false);
             //
             //          }
             //        }
             //      }
             //
             //    }).catchError((_){
             //      AppConstants.globalKey.currentContext?.loading.hide();
             // });
            }
          },
          onCameraSelect: () async {

            context.pop();

            bool isEnable = await CommonMethods.askPermission(
              permission: Permission.camera, // todo manage this dynamic
              whichPermission: AppConstants.globalKey.currentContext?.translate.camera,
            );
            if (isEnable) {
                // AppConstants.globalKey.currentContext?.loading.show();
                final XFile? imageFile = await ImagePicker().pickImage(
                  source: ImageSource.camera,
                  imageQuality: 65,
                );
                // AppConstants.globalKey.currentContext?.loading.hide();
                if (imageFile != null) {

                  if (CommonMethods.isValidFile(imageFile.path)) {
                    bool isValidImage = await CommonMethods.imageSize(imageFile);
                    logger.i("CAMERA IMAGE $isValidImage : $imageFile");

                    if (isValidImage) {
                      onCameraImage!(imageFile);
                    } else {
                      showToast(AppConstants.globalKey.currentState!.context.translate.fileSizeValidation,success: false);
                    }
                  } else {
                    showToast(AppConstants.globalKey.currentState!.context.translate.imageFormatValidation,success: false);
                  }
                  logger.i("IMAGE PICKED: ${imageFile.path}");
                }
              }
          },
          onVideoSelect: () async {

            context.pop();

            bool isEnable = await CommonMethods.askPermission(
              permission: await CommonMethods.getPermission(MediaType.video), // todo manage this dynamic
              whichPermission: AppConstants.globalKey.currentContext?.translate.gallery,
            );
            if (isEnable) {
              AppConstants.globalKey.currentContext?.loading.show();
              await  MediaPicker(
                  context: AppConstants.globalKey.currentContext!,maxLimit: limit,
                  mediaType: MediaType.video
              ).showPicker().then((images) async {
                AppConstants.globalKey.currentContext?.loading.hide();
                if ( images != null && images.isNotEmpty) {



                  for(int i = 0;i<images.length;i++){
                    var d = File(images[i]);
                    print(d.path);
                    final XFile imageFile = XFile(images[i]);
                     print(images[i]);


                    if (
                        imageFile.path.toLowerCase().endsWith("mp4") ||
                        imageFile.path.toLowerCase().endsWith("mov") ||
                        imageFile.path.toLowerCase().endsWith("avi") ||
                        imageFile.path.toLowerCase().endsWith("mkv") ||
                        imageFile.path.toLowerCase().endsWith("flv") ||
                        imageFile.path.toLowerCase().endsWith("wmv") ||
                        imageFile.path.toLowerCase().endsWith("webm") ||
                        imageFile.path.toLowerCase().endsWith("3gp") ||
                        imageFile.path.toLowerCase().endsWith("mpeg")
                    ) {
                      bool isValidImage = await CommonMethods.imageSize(imageFile);
                      logger.i("IMAGE PICKED: $imageFile");

                      if (isValidImage) {
                        if(i == images.length-1){
                          onSelectVideo!(images.map((f)=>XFile(f)).toList());
                        }

                      } else {
                        showToast(AppConstants.globalKey.currentState!.context.translate.pleaseSelectProperFormat,success: false);
                        break;
                      }
                    }
                    else {
                      showToast(AppConstants.globalKey.currentState!.context.translate.pleaseSelectProperFormat,success: false);
                    }
                  }
                }

              }).catchError((_){
                AppConstants.globalKey.currentContext?.loading.hide();
              });




            }
          },
          onDocumentSelect: ()async{
            context.pop();
            FilePickerResult? result = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['pdf',],
            );
            if (result != null) {
              File file = File(result.files.single.path!);
              onSelectDocument!(file);
              logger.i("File PICKED: ${result.files.single.path!}");
            } else {
              logger.i("else PICKED:}");
            }
          },
          type: type,

        );
      },
    );
  }
}
