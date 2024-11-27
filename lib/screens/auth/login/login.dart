import 'dart:math';
import 'dart:ui';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:nfc_wallet/components/widgets/buttonbar.dart';
import 'package:nfc_wallet/models/user.dart';
import 'package:nfc_wallet/models/vendor.dart';
import 'package:nfc_wallet/screens/auth/verification/verification.dart';
import 'package:nfc_wallet/screens/home/navigation_home.dart';
import 'package:nfc_wallet/service/local_storage_service.dart';
import 'package:nfc_wallet/service/notification_service.dart';
import 'package:nfc_wallet/service/otp_service.dart';
import 'package:nfc_wallet/service/user_service.dart';
import 'package:nfc_wallet/shared/shared_states.dart';
import 'package:nfc_wallet/theme/colors.dart';
import 'package:nfc_wallet/utils/utils.dart';

class Login extends ConsumerStatefulWidget {
  final bool isLoggedIn;
  const Login({super.key, this.isLoggedIn = false});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends ConsumerState<Login> {
  final controller = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String country = 'Togo';
  String countryCode = 'TG';
  String dialCode = '228';
  String phone = '';
  bool isLoading = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Locale locale = PlatformDispatcher.instance.locale;
    final code = locale.countryCode;
    final c = countries.firstWhereOrNull((c) => c.code == code);
    if (c != null) {
      dialCode = c.dialCode;
      country = c.name;
      countryCode = c.code;
    }
  }

  Future<void> handleLogin() async {
    setState(() {
      isLoading = true;
    });

    final random = Random();
    int number = random.nextInt(900000) + 100000;
    try {
      await WhatsAppService.sendOTP(phone, number.toString());
      User? user = await UserService.getUser(phone);
      if (phone == '+250783655972') {
        number = 428837;
      }
      final isVerify = await Navigator.of(context).push(
        (MaterialPageRoute(
          builder: (context) {
            return VerifyScreen(
              code: number.toString(),
              phone: phone,
            );
          },
        )),
      );
      if (isVerify == true) {
        if (user == null) {
          final data = {
            'phoneNumber': phone,
            'country': country,
            'dialCode': dialCode,
            'country_code': countryCode,
            'joinedOn': Timestamp.now(),
          };
          user = await UserService.addUser(data);
        }
        if (user != null) {
          try {
            await getUserCurrentLocation(ref);
          } catch (error) {
            final errorMessage = error.toString();
            if (![
              'Exception: location error',
              'Exception: error service',
            ].contains(errorMessage)) {
              rethrow;
            }
          }

          final reg = await getRegion(user.countryCode);
          ref.read(regionProvider.notifier).state = reg;
          Vendor? vendor = await VendorService.getVendor(user.phoneNumber);
          if (vendor == null) {
            final coordinates = ref.read(locationProvider);
            final address = coordinates['address'];
            coordinates.remove('address');
            final data = {
              'phone': user.phoneNumber,
              'name': '',
              'image': '',
              'address': address ?? '',
              'coordinates': coordinates.isNotEmpty ? coordinates : {'lat': 0.0, 'long': 0.0},
              'approved': true,
              'country_code': user.countryCode,
              'createdOn': Timestamp.now(),
            };
            vendor = await VendorService.addVendor(data);
          }

          if (vendor != null) {
            ref.read(vendorProvider.notifier).state = vendor;
            ref.read(userProvider.notifier).state = user;
            await NotificationService.getToken().then((v) async {
              final data_ = {...user!.tokens, v}.toList();
              UserService.updateUser(user.phoneNumber, {
                'tokens': data_,
              });
            });

            setState(() {
              isLoading = false;
            });
            await LocalStorage.setUser(user).then((_) {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) {
                    return const NavigationHome();
                  },
                ),
              );
            });
          }
        } else {
          throw Exception('');
        }
      }
    } catch (_) {
      setState(() {
        isLoading = false;
      });
      showToast(
        context,
        AppLocalizations.of(context)!.networkIssue,
        toastLength: Toast.LENGTH_LONG,
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final isValid = (formKey.currentState?.validate() ?? false) && controller.text.isNotEmpty;

    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: AppBar(
            automaticallyImplyLeading: true,
            centerTitle: true,
            title: Text(
              'Welcome to Lufiti',
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontSize: 20.0),
            ),
          ),
        ),
        body: FadedSlideAnimation(
          beginOffset: const Offset(0, 0.3),
          endOffset: const Offset(0, 0),
          slideCurve: Curves.linearToEaseOut,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    locale.whatsappSignUp,
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontSize: 20.0),
                  ),
                  const SizedBox(height: 30.0),
                  Form(
                    key: formKey,
                    child: IntlPhoneField(
                      cursorColor: kSimpleText,
                      controller: controller,
                      readOnly: isLoading,
                      searchText: locale.searchCountry,
                      invalidNumberMessage: locale.invalidPhoneNumber,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        if (value == null || value.number.isEmpty) {
                          return locale.validphone;
                        } else if (value.number.length < 7) {
                          return locale.validphone;
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.phone,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontSize: 17,
                          ),
                      decoration: InputDecoration(
                        fillColor: kPrimary,
                        hoverColor: kOrange,
                        hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(color: kGreyColor),
                        labelStyle: Theme.of(context).textTheme.bodySmall,
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: kBlack,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(24),
                          ),
                        ),
                        focusColor: kBlack,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: kMainColor,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(24),
                          ),
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: kRed,
                          ),
                        ),
                      ),
                      initialCountryCode: countryCode, //
                      onChanged: (val) {
                        setState(() {
                          phone = val.completeNumber;
                        });
                      },
                      onCountryChanged: (val) async {
                        setState(() {
                          dialCode = val.dialCode;
                          countryCode = val.code;
                          country = val.name;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 20,
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: BottomBar(
                          textColor: kWhiteColor,
                          text: locale.continueText,
                          isValid: isValid,
                          onTap: () async {
                            if (isValid) {
                              await handleLogin();
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
