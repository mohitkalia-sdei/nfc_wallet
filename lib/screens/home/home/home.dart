import 'dart:async';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nfc_wallet/components/widgets/tab_comp.dart';
import 'package:nfc_wallet/map_utils.dart';
import 'package:nfc_wallet/screens/home/home/find_pools.dart';
import 'package:nfc_wallet/screens/home/home/offer_pool.dart';
import 'package:nfc_wallet/service/vehicle_service.dart';
import 'package:nfc_wallet/shared/shared_states.dart';
import 'package:nfc_wallet/theme/colors.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  HomeConsumerState createState() => HomeConsumerState();
}

class HomeConsumerState extends ConsumerState<Home> {
  final Completer<GoogleMapController> _mapController = Completer();
  GoogleMapController? mapStyleController;

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    final user = ref.watch(userProvider)!;
    final vehicleAsyncValue = ref.watch(VehicleService.vehicleStream(user.id));
    final hasVehicle = vehicleAsyncValue.value != null;

    return DefaultTabController(
      length: hasVehicle ? 2 : 1,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            _buildGoogleMap(ref),
            FadedSlideAnimation(
              beginOffset: Offset(0, 0.4),
              endOffset: Offset(0, 0),
              slideCurve: Curves.linearToEaseOut,
              child: Container(
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
                    SizedBox(height: 15),
                    Container(
                      height: 50,
                      width: 304,
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Color(0xff3FD390),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: TabBar(
                        indicator: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Colors.transparent,
                        labelColor: primaryColor,
                        unselectedLabelColor: Color(0xff80ffffff),
                        tabs: [
                          Tabcomp(icon: Icons.drive_eta, text: locale.findPool),
                          if (hasVehicle) Tabcomp(icon: Icons.escalator_warning_outlined, text: locale.offerPool),
                        ],
                      ),
                    ),
                  ],
                ),
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
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: TabBarView(
                    children: [
                      FindPool(),
                      if (hasVehicle) OfferPool(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoogleMap(WidgetRef ref) {
    final locationAsyncValue = ref.watch(locationsProvider);

    return locationAsyncValue.when(
      data: (position) {
        return GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 14,
          ),
          onMapCreated: (controller) async {
            _mapController.complete(controller);
            controller.setMapStyle(mapStyle);
          },
        );
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Failed to load map')),
    );
  }
}
