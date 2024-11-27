import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nfc_wallet/components/widgets/color_button.dart';
import 'package:nfc_wallet/map_utils.dart';
import 'package:nfc_wallet/screens/home/home/end_trip_pool_taker.dart';

class PoolTakerAcceptedOffer extends StatefulWidget {
  const PoolTakerAcceptedOffer({super.key});

  @override
  State<PoolTakerAcceptedOffer> createState() => _PoolTakerAcceptedOfferState();
}

class _PoolTakerAcceptedOfferState extends State<PoolTakerAcceptedOffer> {
  final Set<Marker> _markers = {};
  final Completer<GoogleMapController> _mapController = Completer();
  GoogleMapController? mapStyleController;
  bool isRideStarted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
              markers: _markers,
              mapType: MapType.normal,
              initialCameraPosition: kGooglePlex,
              onMapCreated: (GoogleMapController controller) async {
                _mapController.complete(controller);
                mapStyleController = controller;
                mapStyleController!.setMapStyle(mapStyle);
                setState(() {
                  _markers.add(
                    Marker(
                      markerId: MarkerId('mark1'),
                      position: LatLng(37.42796133580664, -122.085749655962),
                      icon: markerss.first,
                    ),
                  );
                });
              }),
          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18.0,
                  vertical: 4.0,
                ),
                child: FloatingActionButton(
                  onPressed: () {},
                  backgroundColor: Color(0xffe32727),
                  child: Icon(Icons.navigation),
                ),
              ),
            ],
          ),
          if (!isRideStarted) startRideSheet() else buildRoadmapSheet(),
        ],
      ),
    );
  }

  DraggableScrollableSheet buildRoadmapSheet() {
    return DraggableScrollableSheet(
      maxChildSize: 0.85,
      minChildSize: 0.5,
      builder: (context, controller) => ListView(
        padding: EdgeInsets.zero,
        controller: controller,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xfffcfdfd),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 4,
                    width: 66,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                    top: 10.0,
                    bottom: 2.0,
                  ),
                  child: Text(
                    AppLocalizations.of(context)?.tripRoadmap ?? '',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14.0),
                      child: Column(
                        children: [
                          SizedBox(height: 18),
                          Row(
                            children: [
                              Image.asset(
                                'assets/profiles/img${index + 1}.png',
                                height: 40,
                                width: 40,
                              ),
                              SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  'Samantha Smith',
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EndTripPoolTaker(),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 100,
                                  padding: EdgeInsets.only(top: 8, bottom: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(28),
                                    color: index == 0 ? Color(0xffe3ac17) : Theme.of(context).primaryColor,
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 14),
                                      Icon(
                                        index == 0 ? Icons.arrow_downward : Icons.arrow_upward,
                                        size: 16,
                                        color: Theme.of(context).scaffoldBackgroundColor,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        index == 0
                                            ? AppLocalizations.of(context)!.drop.toUpperCase()
                                            : AppLocalizations.of(context)?.pick.toUpperCase() ?? '',
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      SizedBox(width: 20),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          buildPickupDropLocn(context),
                          SizedBox(height: 16),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      thickness: 4,
                      height: 4,
                    );
                  },
                  itemCount: 4,
                ),
                Divider(
                  thickness: 4,
                  height: 4,
                ),
                SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Color(0xffe32727),
                      ),
                      child: Center(
                          child: Text(
                        AppLocalizations.of(context)?.endRide.toUpperCase() ?? '',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontSize: 15, letterSpacing: 3, color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                    ),
                  ],
                ),
                SizedBox(height: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DraggableScrollableSheet startRideSheet() {
    return DraggableScrollableSheet(
      maxChildSize: 0.7,
      builder: (context, controller) => Container(
        decoration: BoxDecoration(
          color: Color(0xfffcfdfd),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          controller: controller,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 20),
                  Text(
                    '${AppLocalizations.of(context)?.rideStartson} 25 Jun, 10:30 am',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  SizedBox(height: 30),
                  buildPickupDropLocn(context),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)?.passengers ?? '',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 14),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildPassenger(
                        context,
                        'assets/profiles/img1.png',
                        'Samantha\nSmith',
                      ),
                      buildPassenger(
                        context,
                        'assets/profiles/img3.png',
                        'Peter\nTaylor',
                      ),
                      buildPassenger(
                        context,
                        'assets/profiles/img2.png',
                        'Emili\nWilliamson',
                      ),
                      buildPassenger(
                        context,
                        'assets/profiles/img4.png',
                        'Josh\nHaydon',
                      ),
                    ],
                  ),
                  SizedBox(height: 50),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isRideStarted = true;
                      });
                    },
                    child: ColorButton(AppLocalizations.of(context)?.startRide),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row buildPickupDropLocn(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Icon(
              Icons.circle,
              size: 14,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(height: 4),
            Icon(
              Icons.circle,
              size: 3,
              color: Theme.of(context).hintColor,
            ),
            SizedBox(height: 4),
            Icon(
              Icons.circle,
              size: 3,
              color: Theme.of(context).hintColor,
            ),
            SizedBox(height: 4),
            Icon(
              Icons.circle,
              size: 3,
              color: Theme.of(context).hintColor,
            ),
            SizedBox(height: 4),
            Icon(
              Icons.location_on,
              color: Color(0xffdd142c),
            ),
          ],
        ),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '1024, Central Park, Hemiltone, New York',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            SizedBox(height: 18),
            Text(
              'M141, NY Food Center, Williomson st, Illinois',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ],
    );
  }

  Column buildPassenger(
    BuildContext context,
    String image,
    String name,
  ) {
    return Column(
      children: [
        Image.asset(
          image,
          height: 40,
          width: 40,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          name,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
