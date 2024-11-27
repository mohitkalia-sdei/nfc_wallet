import 'dart:io';

import 'package:animation_wrappers/animations/faded_scale_animation.dart';
import 'package:animation_wrappers/animations/faded_slide_animation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:nfc_wallet/components/widgets/buttonbar.dart';
import 'package:nfc_wallet/components/widgets/text_field.dart';
import 'package:nfc_wallet/service/firebase_storage.dart';
import 'package:nfc_wallet/service/image_picker.dart';
import 'package:nfc_wallet/service/user_service.dart';
import 'package:nfc_wallet/shared/shared_states.dart';
import 'package:nfc_wallet/theme/colors.dart';

class AccountInfo extends ConsumerStatefulWidget {
  const AccountInfo({super.key});

  @override
  AccountInfoState createState() => AccountInfoState();
}

class AccountInfoState extends ConsumerState<AccountInfo> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  bool isLoading = false;
  XFile? profileImage;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider)!;
    nameController.text = user.fullName ?? '';
    emailController.text = user.email ?? '';
    phoneController.text = user.phoneNumber;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<XFile?> handleCrop(XFile img) async {
    final croppedImage = await ImageCropper().cropImage(
      sourcePath: img.path,
      maxHeight: 512,
      maxWidth: 512,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: AppLocalizations.of(context)!.cropImage,
          toolbarColor: kMainColor,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          minimumAspectRatio: 1.0,
        ),
      ],
    );
    return croppedImage != null ? XFile(croppedImage.path) : null;
  }

  Future<void> handlePickImage() async {
    final img = await FilePickerService.pickImageWithCompression();
    if (img != null) {
      final cropImg = await handleCrop(img);
      if (cropImg != null) {
        setState(() {
          profileImage = cropImg;
        });
      }
    }
  }

  Future<void> handleUpdate() async {
    setState(() {
      isLoading = true;
    });
    try {
      final user = ref.watch(userProvider)!;
      if (profileImage != null) {
        final url = await FirebaseStorageService.uploadImage(
          File(profileImage!.path),
          'user_profiles',
        );
        UserService.updateUser(user.id, {
          'profilePicture': url,
          'fullName': nameController.text,
          'email': emailController.text,
        });
      } else {
        await UserService.updateUser(user.id, {
          'fullName': nameController.text,
          'email': emailController.text,
        });
      }
      setState(() {
        isLoading = false;
        // Navigator.pop(context);
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  bool isValid() {
    return nameController.text.isNotEmpty || profileImage != null;
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    final user = ref.watch(userProvider)!;

    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: FadedSlideAnimation(
        beginOffset: Offset(0.4, 0),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: GestureDetector(
                  onTap: handlePickImage,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Center(
                        child: GestureDetector(
                          onTap: handlePickImage,
                          child: ClipOval(
                            child: SizedBox.fromSize(
                              size: const Size.fromRadius(50), // Adjust radius as needed
                              child: profileImage != null
                                  ? Image.file(
                                      File(profileImage!.path),
                                      fit: BoxFit.cover,
                                    )
                                  : user.profilePicture != null
                                      ? CachedNetworkImage(
                                          imageUrl: user.profilePicture!,
                                          fit: BoxFit.cover,
                                          progressIndicatorBuilder: (context, url, progress) => Center(
                                            child: SizedBox(
                                              height: 50,
                                              width: 50,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                value: progress.progress,
                                              ),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) => Image.asset(
                                            'assets/1.png',
                                          ),
                                        )
                                      : Image.asset(
                                          'assets/2.png',
                                          fit: BoxFit.cover,
                                        ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              TextFieldInput(
                labelText: locale.fullName,
                hintText: "Enter your full name",
                showSuffixIcon: false,
                controller: nameController,
                onChanged: (value) {},
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Full name is required";
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFieldInput(
                labelText: locale.emailAddress,
                hintText: "Enter your email",
                showSuffixIcon: false,
                controller: emailController,
                onChanged: (value) {},
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email is required";
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return "Enter a valid email";
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFieldInput(
                readOnly: true,
                labelText: locale.phoneNumber,
                hintText: "Enter your phone number",
                showSuffixIcon: false,
                controller: phoneController,
                onChanged: (value) {},
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Phone number is required";
                  } else if (value.length < 10) {
                    return "Enter a valid phone number";
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              FadedScaleAnimation(
                scaleDuration: const Duration(milliseconds: 600),
                child: BottomBar(
                  textColor: kWhiteColor,
                  isValid: isValid(),
                  onTap: () async {
                    if (isValid()) {
                      await handleUpdate();
                    }
                  },
                  text: locale.update,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
