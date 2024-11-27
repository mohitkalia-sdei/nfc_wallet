import 'dart:async';
import 'package:animation_wrappers/animations/faded_slide_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeBody extends ConsumerStatefulWidget {
  const HomeBody({super.key});

  @override
  HomeBodyState createState() => HomeBodyState();
}

class HomeBodyState extends ConsumerState<HomeBody> {
  bool locationSelected = false;
  bool isFindPool = true;
  final Completer<GoogleMapController> _mapController = Completer();
  GoogleMapController? mapStyleController;

  final Set<Marker> _markers = {
    Marker(
      markerId: MarkerId('mark1'),
      position: LatLng(37.42796133580664, -122.085749655962),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Google Map
          GoogleMap(
            markers: _markers,
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: LatLng(37.42796133580664, -122.085749655962),
              zoom: 14.4746,
            ),
            onMapCreated: (GoogleMapController controller) async {
              _mapController.complete(controller);
              mapStyleController = controller;
              // Optionally set custom map style if needed
              // mapStyleController!.setMapStyle(mapStyle);
            },
          ),

          // Additional UI elements
          FadedSlideAnimation(
            beginOffset: Offset(0, 0.4),
            endOffset: Offset(0, 0),
            slideCurve: Curves.linearToEaseOut,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  height: 234,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 15),
                      Container(
                        height: 50,
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            color: Color(0xff3FD390),
                            borderRadius: BorderRadius.circular(50)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isFindPool = true;
                                });
                              },
                              child: Container(
                                height: 50,
                                width: 150,
                                decoration: BoxDecoration(
                                    color: isFindPool
                                        ? Colors.white
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(50)),
                                child: Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.drive_eta,
                                          color: !isFindPool
                                              ? Color(0xff80ffffff)
                                              : Colors.green),
                                      SizedBox(width: 10),
                                      Text(
                                        'Find Pool',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                                fontSize: 13.5,
                                                fontWeight: FontWeight.w600,
                                                color: isFindPool
                                                    ? Color(0xff4d4d4d)
                                                    : Color(0xff80ffffff)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isFindPool = false;
                                });
                              },
                              child: Container(
                                height: 50,
                                width: 150,
                                decoration: BoxDecoration(
                                    color: isFindPool
                                        ? Colors.transparent
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(50)),
                                child: Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.nature_people,
                                        color: isFindPool
                                            ? Color(0xff80ffffff)
                                            : Colors.green,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'Offer Pool',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13.5,
                                                color: !isFindPool
                                                    ? Color(0xff4d4d4d)
                                                    : Color(0xff80ffffff)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Select location on the map',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Colors.grey,
                              fontSize: 13.5,
                            ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
