import 'package:animation_wrappers/Animations/faded_scale_animation.dart';
import 'package:animation_wrappers/Animations/faded_slide_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nfc_wallet/components/stars.dart';
import 'package:nfc_wallet/components/widgets/color_button.dart';
import 'package:nfc_wallet/screens/home/navigation_home.dart';
import 'package:nfc_wallet/theme/colors.dart';

class EndTripPoolTaker extends StatefulWidget {
  const EndTripPoolTaker({super.key});

  @override
  EndTripPoolTakerState createState() => EndTripPoolTakerState();
}

class EndTripPoolTakerState extends State<EndTripPoolTaker> {
  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;

    return Scaffold(
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
            Text(
              locale.hopeYouHad,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 15,
                  ),
            ),
            Spacer(),
            FadedSlideAnimation(
              beginOffset: Offset(0, 0.4),
              endOffset: Offset(0, 0),
              slideCurve: Curves.linearToEaseOut,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 280,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(locale.rateRider,
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
                          Text(locale.amountToPay,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(fontSize: 13.5, color: Color(0xffa3bccf))),
                          Spacer(),
                          Text("\$24.00", style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 20))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context, MaterialPageRoute(builder: (context) => NavigationHome()));
                          },
                          child: FadedScaleAnimation(
                            scaleDuration: const Duration(milliseconds: 600),
                            child: ColorButton(locale.submitPay),
                          )),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
