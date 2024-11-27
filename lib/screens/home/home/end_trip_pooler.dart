import 'package:animation_wrappers/Animations/faded_scale_animation.dart';
import 'package:animation_wrappers/Animations/faded_slide_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nfc_wallet/components/stars.dart';
import 'package:nfc_wallet/components/widgets/color_button.dart';
import 'package:nfc_wallet/screens/home/home/end_trip_pool_taker.dart';
import 'package:nfc_wallet/theme/colors.dart';

class EndTripPooler extends StatelessWidget {
  const EndTripPooler({super.key});

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;

    return Scaffold(
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
        },
        child: Container(
          height: 55,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: ColorButton(locale.submit),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Container(
        color: backgroundColor,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Spacer(
              flex: 2,
            ),
            FadedScaleAnimation(
              scaleDuration: const Duration(milliseconds: 600),
              child: SizedBox(
                width: 220,
                child: Image.asset("assets/img_tripcomplete.png"),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Text(locale.tripCompleted, style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 22)),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  locale.youHaveEarned,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 15,
                      ),
                ),
                SizedBox(
                  width: 2,
                ),
                Text(" \$34.50",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14, color: Colors.black))
              ],
            ),
            Text(locale.fromThisTrip, style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14)),
            Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EndTripPoolTaker()));
              },
              child: FadedSlideAnimation(
                beginOffset: Offset(0, 0.4),
                endOffset: Offset(0, 0),
                slideCurve: Curves.linearToEaseOut,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 350,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(locale.rateRideTaker,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(fontSize: 13.5, color: Color(0xffa3bccf))),
                                Text("Samantha Smith",
                                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 17))
                              ],
                            ),
                            Spacer(),
                            SizedBox(
                              height: 60,
                              child: Image.asset("assets/profiles/img1.png"),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Stars(),
                      ),
                      Divider(
                        thickness: 7,
                        color: Colors.grey[200],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(locale.rateRideTaker,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(fontSize: 13.5, color: Color(0xffa3bccf))),
                                Text("Peter Taylor",
                                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 17))
                              ],
                            ),
                            Spacer(),
                            SizedBox(
                              height: 60,
                              child: Image.asset("assets/profiles/img4.png"),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Stars(),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
