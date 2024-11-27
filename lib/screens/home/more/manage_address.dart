import 'package:animation_wrappers/Animations/faded_scale_animation.dart';
import 'package:animation_wrappers/Animations/faded_slide_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nfc_wallet/screens/home/more/add_address.dart';
import 'package:nfc_wallet/theme/colors.dart';

class ManageAddress extends StatelessWidget {
  final List icons = [
    Icons.home,
    Icons.shop,
    Icons.escalator_warning_outlined,
  ];

  ManageAddress({super.key});
  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    List title = [
      locale.home,
      locale.office,
      locale.other,
    ];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            color: backgroundColor,
            padding: EdgeInsetsDirectional.only(start: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Expanded(
                      child: Text(
                        locale.manageAddress,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 22),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      locale.presavedAddress,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
                Spacer(),
                Expanded(
                  flex: 5,
                  child: FadedScaleAnimation(
                    scaleDuration: const Duration(milliseconds: 600),
                    child: Image.asset("assets/head_address.png"),
                  ),
                )
              ],
            ),
          ),
          FadedSlideAnimation(
            beginOffset: Offset(0, 0.4),
            endOffset: Offset(0, 0),
            slideCurve: Curves.linearToEaseOut,
            child: Stack(alignment: Alignment.bottomCenter, children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.7,
                decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AddAddress()));
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                          child: Text(
                            locale.addNewAddress,
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white, fontSize: 13.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.6,
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
                  itemCount: 3,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      horizontalTitleGap: 0,
                      leading: Icon(
                        icons[index],
                        color: primaryColor,
                        size: 22,
                      ),
                      minVerticalPadding: 10,
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 7),
                          Text(
                            title[index],
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 13.5),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "B121- Galaxy Residency, Hemiltone Tower",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(fontSize: 13.5, color: Color(0xffb3b3b3)),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "New York, USA",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(fontSize: 13.5, color: Color(0xffb3b3b3)),
                          )
                        ],
                      ),
                    );
                  },
                ),
              )
            ]),
          )
        ],
      ),
    );
  }
}
