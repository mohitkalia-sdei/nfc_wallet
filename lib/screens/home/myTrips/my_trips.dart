import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_wallet/screens/home/myTrips/finding_pool_list.dart';
import 'package:nfc_wallet/screens/home/myTrips/offer_pool_list.dart';
import 'package:nfc_wallet/service/vehicle_service.dart';
import 'package:nfc_wallet/shared/shared_states.dart';

class MyTrips extends ConsumerStatefulWidget {
  const MyTrips({Key? key}) : super(key: key);

  @override
  MyTripsState createState() => MyTripsState();
}

class MyTripsState extends ConsumerState<MyTrips> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final vehicleAsyncValue = ref.watch(VehicleService.vehicleStream(user.id));
    bool hasVehicle = vehicleAsyncValue.value != null;
    var locale = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: hasVehicle ? 2 : 1,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            locale.myTrips,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w600),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.history,
                color: Colors.grey[300],
                size: 17,
              ),
              onPressed: () {},
            )
          ],
          bottom: TabBar(
            labelColor: Theme.of(context).primaryColor,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: Theme.of(context).primaryColor,
            indicatorWeight: 4.0,
            tabs: hasVehicle
                ? [
                    Tab(text: locale.offering),
                    Tab(text: locale.finding),
                  ]
                : [
                    Tab(text: locale.finding),
                  ],
          ),
        ),
        backgroundColor: Colors.white,
        body: TabBarView(
          children: hasVehicle
              ? [
                  OfferingTab(),
                  FindingTab(),
                ]
              : [
                  FindingTab(),
                ],
        ),
      ),
    );
  }
}
