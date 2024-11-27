import 'package:animation_wrappers/Animations/faded_scale_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nfc_wallet/components/widgets/color_button.dart';
import 'package:nfc_wallet/screens/home/navigation_home.dart';
import 'package:nfc_wallet/theme/colors.dart';

class PoolingConfirmed extends StatelessWidget {
  const PoolingConfirmed({super.key});

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(
              flex: 1,
            ),
            FadedScaleAnimation(
              scaleDuration: const Duration(milliseconds: 600),
              child: SizedBox(
                width: 200,
                child: Image.asset("assets/img_confirmed.png"),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              locale.congrats!,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              locale.yourCarConfirmed!,
              textAlign: TextAlign.center,
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NavigationHome(1),
                    ),
                  );
                },
                child: FadedScaleAnimation(
                  scaleDuration: const Duration(milliseconds: 600),
                  child: ColorButton(locale.myTrips),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
