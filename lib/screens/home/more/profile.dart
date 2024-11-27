import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_wallet/screens/home/more/account_info.dart';
import 'package:nfc_wallet/screens/home/more/myvehicle.dart';
import 'package:nfc_wallet/screens/home/more/profile_info.dart';
import 'package:nfc_wallet/shared/shared_states.dart';
import 'package:nfc_wallet/theme/colors.dart';

class MyProfile extends ConsumerWidget {
  const MyProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    var locale = AppLocalizations.of(context)!;
    final List<Widget> tabs = <Widget>[
      Tab(text: locale.profileInfo),
      Tab(text: locale.accountInfo),
      Tab(text: locale.myVehicle),
    ];
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: backgroundColor,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(150),
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: backgroundColor,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              locale.myProfile,
                              style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 22),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              locale.everythingAboutyou,
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                        Spacer(),
                        Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            FadedScaleAnimation(
                              scaleDuration: const Duration(milliseconds: 600),
                              child: Container(
                                padding: EdgeInsets.all(10),
                                width: 90,
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
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))),
                    alignment: Alignment.topLeft,
                    child: TabBar(
                      indicatorWeight: 4.0,
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: tabs,
                      isScrollable: true,
                      labelStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 13.5),
                      labelColor: primaryColor,
                      indicatorColor: primaryColor,
                      unselectedLabelColor: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            ProfileInfo(),
            AccountInfo(),
            MyVehicleTab(),
          ],
        ),
      ),
    );
  }
}
