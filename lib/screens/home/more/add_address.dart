import 'dart:async';

import 'package:animation_wrappers/Animations/faded_scale_animation.dart';
import 'package:animation_wrappers/Animations/faded_slide_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nfc_wallet/components/widgets/color_button.dart';
import 'package:nfc_wallet/components/widgets/text_field.dart';
import 'package:nfc_wallet/map_utils.dart';
import 'package:nfc_wallet/theme/colors.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({super.key});

  @override
  AddAddressState createState() => AddAddressState();
}

class AddAddressState extends State<AddAddress> {
  int? groupValue = 0;
  final Completer<GoogleMapController> _mapController = Completer();
  GoogleMapController? mapStyleController;

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: GoogleMap(
                // polylines: state.polylines,
                mapType: MapType.normal,
                initialCameraPosition: kGooglePlex,
                // markers: _markers,
                onMapCreated: (GoogleMapController controller) async {
                  _mapController.complete(controller);
                  mapStyleController = controller;
                  mapStyleController!.setMapStyle(mapStyle);
                }),
          ),
          FadedSlideAnimation(
            beginOffset: Offset(0, 0.4),
            endOffset: Offset(0, 0),
            slideCurve: Curves.linearToEaseOut,
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 50),
                  width: MediaQuery.of(context).size.width,
                  height: 280,
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: 50,
                        child: Row(
                          children: [
                            Expanded(
                              child: RadioListTile(
                                  activeColor: Theme.of(context).scaffoldBackgroundColor,
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                  title: Text(
                                    locale.home,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(color: Colors.white, fontSize: 14),
                                  ),
                                  value: 1,
                                  groupValue: groupValue,
                                  onChanged: (dynamic value) {
                                    setState(() {
                                      groupValue = value;
                                    });
                                  }),
                            ),
                            Container(padding: EdgeInsets.symmetric(vertical: 5), child: VerticalDivider()),
                            Expanded(
                              child: RadioListTile(
                                  activeColor: Theme.of(context).scaffoldBackgroundColor,
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    locale.office,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(color: Colors.white, fontSize: 14),
                                  ),
                                  value: 2,
                                  groupValue: groupValue,
                                  onChanged: (dynamic value) {
                                    setState(() {
                                      groupValue = value;
                                    });
                                  }),
                            ),
                            Container(padding: EdgeInsets.symmetric(vertical: 5), child: VerticalDivider()),
                            Expanded(
                              child: RadioListTile(
                                  dense: true,
                                  activeColor: Theme.of(context).scaffoldBackgroundColor,
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    locale.other,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(color: Colors.white, fontSize: 14),
                                  ),
                                  value: 3,
                                  groupValue: groupValue,
                                  onChanged: (dynamic value) {
                                    setState(() {
                                      groupValue = value;
                                    });
                                  }),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          FadedSlideAnimation(
            beginOffset: Offset(0, 0.4),
            endOffset: Offset(0, 0),
            slideCurve: Curves.linearToEaseOut,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 260,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      horizontalTitleGap: 0,
                      leading: SizedBox(
                        height: 20,
                        child: Icon(
                          Icons.location_on,
                          color: primaryColor,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        "B121- Galaxy Residency, Hemiltone Tower",
                        style:
                            Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 13.5, color: Color(0xffb3b3b3)),
                      ),
                      subtitle: Text(
                        "New York, USA",
                        style:
                            Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 13.5, color: Color(0xffb3b3b3)),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    EntryField(locale.addLandmark, locale.writeAddressLandmark, false),
                    Spacer(),
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(
                            context,
                          );
                        },
                        child: FadedScaleAnimation(
                          scaleDuration: const Duration(milliseconds: 600),
                          child: ColorButton(locale.saveAddress),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 110,
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width * 0.9,
              padding: EdgeInsets.symmetric(horizontal: 13),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.white),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    size: 25,
                    color: Colors.grey[200],
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.white),
                      child: TextFormField(
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey[300]),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                          border: InputBorder.none,
                          hintText: locale.searchLocation,
                          hintStyle:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 14, color: Colors.grey[400]),
                        ),
                      ),
                    ),
                  ),
                  Icon(
                    Icons.gps_fixed,
                    size: 20,
                    color: Colors.grey[400],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
