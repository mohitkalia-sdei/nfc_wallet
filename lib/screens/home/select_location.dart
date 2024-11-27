import 'package:animation_wrappers/Animations/faded_slide_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nfc_wallet/components/widgets/entry_field.dart';
import 'package:nfc_wallet/theme/colors.dart';

class SelectLocation extends StatelessWidget {
  final List icons = [Icons.history, Icons.history, Icons.history, Icons.home, Icons.shop, Icons.store];
  final List title = ["New York", "Jorder Park", "Illinois", "Home", "Office", "Other"];
  final String address = "1024, Central Park, Hemiltone, New York";

  SelectLocation({super.key});

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          locale.selectLocation!,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      body: FadedSlideAnimation(
        beginOffset: Offset(0, 0.4),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              TextEntryField(
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.black,
                  size: 19,
                ),
                hint: locale.enterLocation,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 15),
                child: Row(
                  children: [
                    Icon(
                      Icons.pin_drop,
                      color: primaryColor,
                      size: 17,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      locale.pinOnMap!,
                      style: TextStyle(color: primaryColor),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.only(top: 15),
                  shrinkWrap: true,
                  itemCount: 6,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {},
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20,
                              // width: 20,
                              child: Icon(
                                icons[index],
                                color: Colors.grey,
                                size: 17,
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(title[index],
                                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 13.5)),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Text(
                                    address,
                                    style: TextStyle(fontSize: 12, color: Color(0xffd9e3ea)),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
