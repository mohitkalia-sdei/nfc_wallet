import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_wallet/payment_screens/payment_screen.dart';
import 'package:nfc_wallet/screens/account/account.dart';
import 'package:nfc_wallet/screens/home/myTrips/my_trips.dart';
import 'package:nfc_wallet/service/user_service.dart';
import 'package:nfc_wallet/shared/shared_states.dart';
import 'package:nfc_wallet/shared/widgets/animated_bottom_bar.dart';

class NavigationHome extends ConsumerStatefulWidget {
  final int currentIndex;

  const NavigationHome([this.currentIndex = 0]);

  @override
  NavigationHomeConsumerState createState() => NavigationHomeConsumerState();
}

class NavigationHomeConsumerState extends ConsumerState<NavigationHome> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    final user = ref.watch(userProvider)!;
    final vendor = ref.watch(vendorProvider)!;
    ref.watch(VendorService.vendorStream(user.phoneNumber));
    ref.watch(UserService.userStream(user.phoneNumber));
    ref.watch(VendorService.vendorStream(vendor.id));
    final List<Widget> children = [
      PaymentScreen(),
      MyTrips(),
      Account(),
    ];
    final List<BarItem> barItems = [
      BarItem(locale.payment, Icon(Icons.wallet_outlined)),
      BarItem(locale.myTrips, Icon(Icons.navigation)),
      BarItem(locale.account, Icon(Icons.account_circle_outlined)),
    ];
    return Scaffold(
      body: children[currentIndex],
      bottomNavigationBar: AnimatedBottomBar(
        barItems: barItems,
        onBarTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
