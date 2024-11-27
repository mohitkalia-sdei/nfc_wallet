import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:nfc_wallet/models/region.dart';
import 'package:nfc_wallet/screens/auth/welcome_page.dart';
import 'package:nfc_wallet/service/local_storage_service.dart';
import 'package:nfc_wallet/service/location_service.dart';
import 'package:nfc_wallet/service/user_service.dart';
import 'package:nfc_wallet/shared/shared_states.dart';
import 'package:nfc_wallet/theme/colors.dart';
import 'package:nfc_wallet/theme/style_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

Future<Region> getRegion(String countryCode) async {
  late String localCode;
  try {
    localCode = Platform.localeName.split('_')[1];
  } catch (_) {
    localCode = countryCode;
  }
  final reg = await UserService.getRegion(localCode);
  return reg ?? Region('', '', 0, {});
}

String formatDate(Timestamp timestamp) {
  DateTime date = timestamp.toDate();
  return DateFormat('MMMM d, yyyy').format(date);
}

String formatTime(Timestamp timestamp) {
  DateTime date = timestamp.toDate();
  return DateFormat('h:mm a').format(date);
}

dynamic showToast(BuildContext context, String message, {Toast toastLength = Toast.LENGTH_SHORT}) {
  return Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    fontSize: 16.0,
  );
}

Future<void> showLanguageSelectionDialog(BuildContext context, WidgetRef ref) async {
  final prefs = await SharedPreferences.getInstance();

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      final locale = AppLocalizations.of(context)!;
      return AlertDialog(
        title: Text(
          locale.selectLanguage,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () {
                ref.read(localeProvider.notifier).state = const Locale('en');
                prefs.setString('locale', 'en');
                Navigator.pop(context);
              },
              child: Text(
                'English',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            TextButton(
              onPressed: () {
                ref.read(localeProvider.notifier).state = const Locale('fr');
                prefs.setString('locale', 'fr');
                Navigator.pop(context);
              },
              child: Text(
                'French',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      );
    },
  );
}

Future getUserCurrentLocation(WidgetRef ref) async {
  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (serviceEnabled) {
    try {
      await Geolocator.getCurrentPosition().then((value) async {
        var address = await LocationService.getAddressFromCoordinates(
          value.latitude,
          value.longitude,
        );
        final data = {
          'address': address,
          'lat': value.latitude,
          'long': value.longitude,
        };
        ref.read(locationProvider.notifier).state = data;
        LocalStorage.setUserLocation(data);
      });
    } catch (_) {
      return throw Exception('location error');
    }
  } else {
    return throw Exception('error service');
  }
}

String formatDateTime(BuildContext context, DateTime date) {
  final now = DateTime.now();
  final todayStart = DateTime(now.year, now.month, now.day);
  final yesterdayStart = todayStart.subtract(const Duration(days: 1));

  AppLocalizations locale = AppLocalizations.of(context)!;
  String format = locale.localeName == 'en' ? 'en_US' : 'fr_FR';

  if (date.isAfter(todayStart)) {
    return '${locale.today}, ${DateFormat('HH:mm', format).format(date)}';
  } else if (date.isAfter(yesterdayStart) && date.isBefore(todayStart)) {
    return '${locale.yesterday}, ${DateFormat('HH:mm', format).format(date)}';
  } else {
    return DateFormat('d MMMM, HH:mm', format).format(date);
  }
}

InputDecoration inputDecorationWithLabel(String hint, String labelText) {
  return InputDecoration(
    hintStyle: TextStyle(fontSize: 14, color: kHintColor, height: 1.5, fontWeight: FontWeight.w500),
    hintText: hint,
    labelStyle: const TextStyle(fontSize: 14, color: Colors.black, height: 1, fontWeight: FontWeight.w500),
    labelText: labelText,
    filled: true,
    alignLabelWithHint: true,
    fillColor: kWhiteColor,
    contentPadding: const EdgeInsets.all(15),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: kLightGreyColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: kMainColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: kLightGreyColor),
    ),
  );
}

bool isValidNumber(String phone) {
  if (phone.isEmpty || phone[0] != '+') return false;
  try {
    final number = PhoneNumber.fromCompleteNumber(completeNumber: phone);
    return number.isValidNumber();
  } catch (_) {
    return false;
  }
}

String hideDigits(String input, int visibleCount) {
  if (input.length <= visibleCount) {
    return input;
  }

  String hiddenPart = '*' * (input.length - visibleCount);
  return hiddenPart + input.substring(input.length - visibleCount);
}

bool isValidPCode(String code) {
  return code.isNotEmpty && RegExp(r'^[0-9]+$').hasMatch(code);
}

void messageToWhatApp(String message, String phone) async {
  String url = 'https://wa.me/$phone?text=${Uri.encodeComponent(message)}/';
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  }
}

String formatBalance(double price) {
  return NumberFormat('#,##0.00', 'en_US').format(price);
}

String localeFormatDate(BuildContext context, DateTime date) {
  AppLocalizations locale = AppLocalizations.of(context)!;
  String format = locale.localeName == 'en' ? 'en_US' : 'fr_FR';
  return DateFormat('d-MM-yyyy', format).format(date);
}

String getPhone(String phone) {
  return PhoneNumber.fromCompleteNumber(completeNumber: phone).number;
}

String getCountryCode(String phone) {
  return PhoneNumber.fromCompleteNumber(completeNumber: phone).countryISOCode;
}

bool isEmail(String em) {
  String p =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = RegExp(p);
  return regExp.hasMatch(em);
}

String randomReqId(prefix) {
  int randomNumber = Random().nextInt(1000);
  return '$prefix$randomNumber';
}

String formatPDateTime(DateTime dateTime) {
  return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
}

void showLogoutBottomSheet(BuildContext context, WidgetRef ref) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(32.0)),
    ),
    builder: (BuildContext context) {
      final locale = AppLocalizations.of(context)!;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Container(
          height: 230.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                locale.loggingOut,
                style: AppStyles.headerTextStyle,
              ),
              const SizedBox(height: 40.0),
              InkWell(
                onTap: () async {
                  Navigator.pop(context);
                  await LocalStorage.removeUserLocation();
                  await LocalStorage.removeUser().then(
                    (v) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const WelcomeScreen();
                          },
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    locale.logout,
                    style: AppStyles.accountTextStyle.copyWith(color: Color(0xffF15C5A)),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    "Cancel",
                    style: AppStyles.accountTextStyle.copyWith(color: const Color(0xff101010)),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> showLanguageSelectionModal(BuildContext context, WidgetRef ref) async {
  final prefs = await SharedPreferences.getInstance();

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(32.0)),
    ),
    backgroundColor: Colors.white,
    builder: (BuildContext context) {
      final locale = AppLocalizations.of(context)!;
      return Container(
        height: 290.0,
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                locale.selectLanguage,
                style: AppStyles.headerTextStyle,
              ),
            ),
            const SizedBox(height: 40.0),
            InkWell(
              onTap: () {
                ref.read(localeProvider.notifier).state = const Locale('en');
                prefs.setString('locale', 'en');
                Navigator.pop(context);
              },
              child: Container(
                height: 60,
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  color: ref.watch(localeProvider) == const Locale('en')
                      ? const Color(0xff0ECB6F).withOpacity(0.1)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: ref.watch(localeProvider) == const Locale('en')
                        ? const Color(0xff0ECB6F)
                        : const Color(0xffE0E0E0),
                    width: 0.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'English',
                      style: AppStyles.accountTextStyle,
                    ),
                    if (ref.watch(localeProvider) == const Locale('en'))
                      const Icon(Icons.check_circle, color: Colors.green),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            InkWell(
              onTap: () {
                ref.read(localeProvider.notifier).state = const Locale('fr');
                prefs.setString('locale', 'fr');
                Navigator.pop(context);
              },
              child: Container(
                height: 60,
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  color: ref.watch(localeProvider) == const Locale('fr')
                      ? const Color(0xff0ECB6F).withOpacity(0.1)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: ref.watch(localeProvider) == const Locale('fr')
                        ? const Color(0xff0ECB6F)
                        : const Color(0xffE0E0E0),
                    width: 0.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'French',
                      style: AppStyles.accountTextStyle,
                    ),
                    if (ref.watch(localeProvider) == const Locale('fr'))
                      const Icon(Icons.check_circle, color: Colors.green),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
