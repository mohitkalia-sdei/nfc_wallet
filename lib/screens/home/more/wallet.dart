import 'package:animation_wrappers/Animations/faded_scale_animation.dart';
import 'package:animation_wrappers/Animations/faded_slide_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nfc_wallet/theme/colors.dart';

class Wallet extends StatelessWidget {
  const Wallet({super.key});

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    List title = [
      locale.paidToRider,
      locale.addedToWallet,
      locale.receivedFrom,
      locale.paidToRider,
      locale.addedToWallet,
      locale.receivedFrom,
      locale.paidToRider,
      locale.addedToWallet,
      locale.receivedFrom,
      locale.addedToWallet,
    ];
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: Column(
        children: [
          Container(
            color: backgroundColor,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      "\$159.50",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 22),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      locale.availableBalance,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15),
                    ),
                  ],
                ),
                SizedBox(
                  width: 40,
                ),
                Expanded(
                  child: FadedScaleAnimation(
                    scaleDuration: const Duration(milliseconds: 600),
                    child: Image.asset(
                      "assets/img_verification.png",
                      height: 130,
                      alignment: Alignment.bottomCenter,
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: FadedSlideAnimation(
              beginOffset: Offset(0, 0.4),
              endOffset: Offset(0, 0),
              slideCurve: Curves.linearToEaseOut,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Spacer(),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.arrow_downward,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  locale.addMoney,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(color: Colors.white, fontSize: 13.5),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          VerticalDivider(
                            color: Colors.white,
                            indent: 4,
                            endIndent: 4,
                          ),
                          Spacer(),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.arrow_upward,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  locale.sendToBank,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(color: Colors.white, fontSize: 13.5),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Theme.of(context).primaryColor,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: ListView.builder(
                          padding: EdgeInsets.only(
                            top: 10,
                          ),
                          shrinkWrap: true,
                          itemCount: 10,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              title: Row(
                                children: [
                                  Text(
                                    title[index],
                                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 13.5),
                                  ),
                                  Spacer(),
                                  Text(
                                    "\$${index + 100}.00",
                                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                        color: index % 2 == 0 ? Colors.red : primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.5),
                                  ),
                                ],
                              ),
                              subtitle: Row(
                                children: [
                                  Text("Emili Anderson",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(fontSize: 11, color: Color(0xffb3b3b3))),
                                  Spacer(),
                                  Text("21 Jun, 11:02 am",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(fontSize: 11, color: Color(0xffb3b3b3)))
                                ],
                              ),
                            );
                          },
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
    );
  }
}
