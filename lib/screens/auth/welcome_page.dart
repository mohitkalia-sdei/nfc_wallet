import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_wallet/components/widgets/buttonbar.dart';
import 'package:nfc_wallet/models/region.dart';
import 'package:nfc_wallet/screens/auth/login/login.dart';
import 'package:nfc_wallet/service/user_service.dart';
import 'package:nfc_wallet/shared/shared_states.dart';
import 'package:nfc_wallet/theme/colors.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => WelcomeScreenState();
}

class WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      final user = ref.read(userProvider);
      if (user != null) {
        UserService.unregisterForNotifications(user);
      }
      ref.read(vendorProvider.notifier).state = null;
      ref.read(userProvider.notifier).state = null;
      ref.read(regionProvider.notifier).state = Region('', '', 0, {});
      ref.read(locationProvider.notifier).state = {};
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
        ),
      ),
      body: FadedSlideAnimation(
        beginOffset: const Offset(0, 0.3),
        endOffset: const Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              const Spacer(),
              Expanded(
                flex: 3,
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(
                      maxWidth: 400,
                    ),
                    child: Image.asset('assets/2.png'),
                  ),
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  constraints: const BoxConstraints(
                    maxWidth: 600,
                  ),
                  child: BottomBar(
                    color: primaryColor,
                    textColor: kWhiteColor,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const Login();
                          },
                        ),
                      );
                    },
                    text: "Login",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
