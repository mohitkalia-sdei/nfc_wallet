import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_wallet/screens/home/more/change_language.dart';
import 'package:nfc_wallet/screens/home/more/manage_address.dart';
import 'package:nfc_wallet/screens/home/more/privacy_policy.dart';
import 'package:nfc_wallet/screens/home/more/profile.dart';
import 'package:nfc_wallet/screens/home/more/support.dart';
import 'package:nfc_wallet/screens/home/more/wallet.dart';
import 'package:nfc_wallet/shared/shared_states.dart';
import 'package:nfc_wallet/theme/colors.dart';
import 'package:nfc_wallet/utils/utils.dart';

class More extends ConsumerWidget {
  final List<IconData> icons = [
    Icons.location_pin,
    Icons.email,
    Icons.clear_all_outlined,
    Icons.language,
    Icons.power_settings_new,
  ];

  final List<Widget> routes = [
    ManageAddress(),
    Support(),
    PrivacyPolicy(),
    ChangeLanguage(),
  ];

  More({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = AppLocalizations.of(context)!;
    final user = ref.watch(userProvider)!;

    List<String> title = [
      locale.manageAddress,
      locale.support,
      locale.privacyPolicy,
      locale.changeLanguage,
      locale.logout,
    ];
    List<String> subtitle = [
      locale.presavedAddress,
      locale.connectUsFor,
      locale.knowPrivacy,
      locale.setYourlanguage,
      locale.logout,
    ];

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              height: 180,
              width: MediaQuery.of(context).size.width,
              color: backgroundColor,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Text(
                    locale.account,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 17),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MyProfile()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.fullName ?? user.phoneNumber,
                                style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 20),
                              ),
                              SizedBox(width: 5),
                              Row(
                                children: [
                                  Icon(
                                    Icons.verified_user,
                                    color: primaryColor,
                                    size: 20,
                                  ),
                                  SizedBox(width: 5),
                                  Text(locale.viewProfile)
                                ],
                              ),
                            ],
                          ),
                          Spacer(),
                          FadedScaleAnimation(
                            scaleDuration: const Duration(milliseconds: 600),
                            child: SizedBox(
                              width: 70,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: SizedBox(
                                  height: 70,
                                  width: 50,
                                  child: user.profilePicture != null
                                      ? CachedNetworkImage(
                                          imageUrl: user.profilePicture!,
                                          fit: BoxFit.cover,
                                          progressIndicatorBuilder: (context, url, progress) => Center(
                                            child: CircularProgressIndicator(
                                              value: progress.progress,
                                              strokeWidth: 2,
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Image.asset('assets/profile_placeholder.png'),
                                        )
                                      : Image.asset(
                                          'assets/profile_placeholder.png',
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
                ],
              ),
            ),
            // Wallet Section
            FadedSlideAnimation(
              beginOffset: Offset(0, 0.4),
              endOffset: Offset(0, 0),
              slideCurve: Curves.linearToEaseOut,
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    SizedBox(height: 15),
                    SizedBox(
                      height: 50,
                      child: ListTile(
                        contentPadding: EdgeInsets.only(left: 26, right: 20),
                        horizontalTitleGap: 0,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Wallet(),
                              ));
                        },
                        leading: Icon(
                          Icons.account_balance_wallet,
                          color: Colors.white,
                          size: 20,
                        ),
                        title: Row(
                          children: [
                            Text(
                              locale.wallet,
                              style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white, fontSize: 14),
                            ),
                            Spacer(),
                            Row(
                              children: [
                                Text("\$159.50"),
                                Icon(
                                  Icons.chevron_right,
                                  size: 25,
                                  color: Colors.white,
                                )
                              ],
                            )
                          ],
                        ),
                        subtitle: Text(
                          locale.quickPayments,
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    // Settings Options List
                    FadedSlideAnimation(
                      beginOffset: Offset(0, 0.4),
                      endOffset: Offset(0, 0),
                      slideCurve: Curves.linearToEaseOut,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          itemCount: title.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              onTap: () {
                                if (index == title.length - 1) {
                                  showLogoutBottomSheet(context, ref);
                                } else {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => routes[index]));
                                }
                              },
                              horizontalTitleGap: 0,
                              leading: Padding(
                                padding: const EdgeInsets.only(top: 3),
                                child: Icon(
                                  icons[index],
                                  size: 20,
                                  color: primaryColor,
                                ),
                              ),
                              title: Text(
                                title[index],
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(color: Colors.black, fontSize: 13.5),
                              ),
                              subtitle: Text(
                                subtitle[index],
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontSize: 12, color: Color(0xffb3b3b3)),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
