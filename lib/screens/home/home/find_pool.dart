import 'dart:async';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nfc_wallet/components/widgets/color_button.dart';
import 'package:nfc_wallet/components/widgets/entry_field.dart';
import 'package:nfc_wallet/map_utils.dart';
import 'package:nfc_wallet/screens/home/rider_providers.dart';
import 'package:nfc_wallet/shared/shared_states.dart';
import 'package:nfc_wallet/theme/colors.dart';

class Findpool extends ConsumerStatefulWidget {
  bool isFindPool;

  Findpool(this.isFindPool, {super.key});

  @override
  FindpoolConsumerState createState() => FindpoolConsumerState();
}

class FindpoolConsumerState extends ConsumerState<Findpool> {
  List<String> seats = [
    "1 Seat",
    "2 Seat",
    "3 Seat",
    "4 Seat",
  ];
  List<String> cars = [
    "1 Seat",
    "2 Seats",
    "3 Seats",
    "4 Seats",
  ];
  int dayIndex = 0;
  String? seat = '1 Seat';
  String? car = '4 Seats';
  final Completer<GoogleMapController> _mapController = Completer();
  GoogleMapController? mapStyleController;
  final Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    final locationAsyncValue = ref.watch(locationsProvider);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          locationAsyncValue.when(
            data: (position) {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(position.latitude, position.longitude),
                      zoom: 14,
                    ),
                    markers: _markers,
                    onMapCreated: (GoogleMapController controller) async {
                      _mapController.complete(controller);
                      mapStyleController = controller;
                      mapStyleController!.setMapStyle(mapStyle);
                    }),
              );
            },
            loading: () => Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Container(),
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
                  height: 390,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        height: 50,
                        width: 304,
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(color: Color(0xff3FD390), borderRadius: BorderRadius.circular(50)),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  widget.isFindPool = true;
                                });
                              },
                              child: Container(
                                height: 50,
                                width: 150,
                                decoration: BoxDecoration(
                                    color: widget.isFindPool ? Colors.white : Colors.transparent,
                                    borderRadius: BorderRadius.circular(50)),
                                child: Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.drive_eta,
                                        color: !widget.isFindPool ? Color(0xff80ffffff) : primaryColor,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        locale.findPool,
                                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                            color: widget.isFindPool ? Color(0xff4d4d4d) : Color(0xff80ffffff)),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  widget.isFindPool = false;
                                });
                              },
                              child: Container(
                                height: 50,
                                width: 150,
                                decoration: BoxDecoration(
                                    color: widget.isFindPool ? Colors.transparent : Colors.white,
                                    borderRadius: BorderRadius.circular(50)),
                                child: Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.escalator_warning_outlined,
                                        color: widget.isFindPool ? Color(0xff80ffffff) : primaryColor,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        locale.offerPool,
                                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: !widget.isFindPool ? Color(0xff4d4d4d) : Color(0xff80ffffff)),
                                      )
                                    ],
                                  ),
                                ),
                              ),
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
              height: 360,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    TextEntryField(
                      prefixIcon: Icon(
                        Icons.circle,
                        color: primaryColor,
                        size: 17,
                      ),
                      initialValue: "1024, Central Park, Hemilton, New York",
                    ),
                    TextEntryField(
                      prefixIcon: Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 17,
                      ),
                      initialValue: "M141, Food Center, Hemilton, Illinois",
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextEntryField(
                            prefixIcon: Icon(
                              Icons.calendar_today,
                              color: Colors.grey,
                              size: 17,
                            ),
                            initialValue: "25 Jun, 10:30 am",
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(end: 10),
                          child: Icon(
                            Icons.drive_eta,
                            color: Colors.grey,
                            size: 17,
                          ),
                        ),
                        DropdownButton<String>(
                          iconSize: 25,
                          itemHeight: 57,
                          // isDense: true,
                          value: widget.isFindPool ? seat : car,
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 13.5),
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.grey,
                          ),
                          items: widget.isFindPool
                              ? seats.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList()
                              : cars.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              if (widget.isFindPool) {
                                seat = value;
                              } else {
                                car = value;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    if (!widget.isFindPool)
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              // horizontal: 25,
                              vertical: 10,
                            ),
                            child: TextEntryField(
                              prefixIcon: Icon(
                                Icons.local_atm,
                                size: 17,
                                color: Colors.grey,
                              ),
                              initialValue: locale.setPricePerSeat,
                            ),
                          ),
                          Divider(
                            color: Colors.grey[400],
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      )
                    else
                      SizedBox(height: 40),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RideProviders(
                                widget.isFindPool ? true : false,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: FadedScaleAnimation(
                            scaleDuration: const Duration(milliseconds: 600),
                            child: ColorButton(
                              widget.isFindPool ? locale.findPool : locale.offerPool,
                            ),
                          ),
                        )),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
