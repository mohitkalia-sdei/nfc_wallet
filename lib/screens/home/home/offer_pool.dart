import 'dart:async';

import 'package:animation_wrappers/animations/faded_scale_animation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:modern_dialog/dialogs/vertical.dart';
import 'package:modern_dialog/modern_dialog.dart';
import 'package:nfc_wallet/components/widgets/buttonbar.dart';
import 'package:nfc_wallet/components/widgets/entry_field.dart';
import 'package:nfc_wallet/components/widgets/locationinput.dart';
import 'package:nfc_wallet/models/offer_pool_model.dart';
import 'package:nfc_wallet/service/offer_pool_service.dart';
import 'package:nfc_wallet/shared/shared_states.dart';
import 'package:nfc_wallet/theme/colors.dart';
import 'package:nfc_wallet/utils/contants.dart';

class OfferPool extends ConsumerStatefulWidget {
  const OfferPool({Key? key}) : super(key: key);

  @override
  OfferPoolState createState() => OfferPoolState();
}

class OfferPoolState extends ConsumerState<OfferPool> {
  double? userLatitude;
  double? userLongitude;
  String? selectedSeat = '1 Seat';
  bool isLoading = false;
  final List<String> seats = [
    "1 Seat",
    "2 Seats",
    "3 Seats",
    "4 Seats",
    "5 Seats",
    "6 Seats",
    "7 Seats",
    "8 Seats",
    "9 Seats",
    "10 Seats"
  ];
  final TextEditingController pickupController = TextEditingController();
  final TextEditingController dropoffController = TextEditingController();
  final TextEditingController dateTimeController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, dynamic>? pickupLocationData;
  Map<String, dynamic>? dropoffLocationData;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        userLatitude = position.latitude;
        userLongitude = position.longitude;
      });
    } catch (e) {
      print("Error retrieving location: $e");
    }
  }

  Future<void> onSuggestionSelected(
      Map<String, dynamic> locationData, TextEditingController controller, bool isPickup) async {
    controller.text = locationData['address'];
    setState(() {
      if (isPickup) {
        pickupLocationData = locationData;
      } else {
        dropoffLocationData = locationData;
      }
    });
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      final TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        final formattedDateTime = "${selectedDate.toLocal().toString().split(' ')[0]} ${selectedTime.format(context)}";
        dateTimeController.text = formattedDateTime;
      }
    }
  }

  Location _mapToLocation(Map<String, dynamic> data) {
    return Location(
      address: data['address'] ?? '',
      latitude: data['latitude'] ?? 0.0,
      longitude: data['longitude'] ?? 0.0,
    );
  }

  Future<void> _submitForm() async {
    setState(() {
      isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      final user = ref.read(userProvider)!;
      final dateFormat = DateFormat("yyyy-MM-dd h:mm a");
      DateTime parsedDate = dateFormat.parse(dateTimeController.text);
      Timestamp dateTime = Timestamp.fromDate(parsedDate);
      final price = int.parse(priceController.text);

      Location pickupLocation = _mapToLocation(pickupLocationData!);
      Location dropoffLocation = _mapToLocation(dropoffLocationData!);

      final offerpool = PassengerOfferPool(
          pickupLocation: pickupLocation,
          dropoffLocation: dropoffLocation,
          dateTime: dateTime,
          selectedSeat: selectedSeat ?? '1 seat',
          pricePerSeat: price,
          user: user.id);
      try {
        await OfferPoolService.createFindPool(offerpool);
        setState(() {
          isLoading = false;
        });

        pickupController.clear();
        dropoffController.clear();
        dateTimeController.clear();
        priceController.clear();
        selectedSeat = null;

        ModernDialog.showVerticalDialog(
          context,
          title: "Offer Pool published",
          content: const Text(
            "Your pool has been successfully located. Would you like to proceed with this ride?",
            style: TextStyle(fontSize: 16),
          ),
          buttons: [
            DialogButton(
              title: "Proceed",
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.green,
            ),
          ],
        );
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Color.fromARGB(255, 227, 85, 50), content: Text("Failed to save pool.")),
        );
      }
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Color.fromARGB(255, 227, 85, 50), content: Text("Failed to save pool.")),
      );
    }
  }

  bool isValid() {
    return pickupController.text.trim().isNotEmpty &&
        dropoffController.text.trim().isNotEmpty &&
        dateTimeController.text.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    final region = ref.watch(regionProvider);

    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LocationAutocompleteField(
                    prefixIcon: Icon(Icons.circle, color: primaryColor, size: 17),
                    googleMapApiKey: gKApi,
                    controller: pickupController,
                    hint: 'Pick a location',
                    onSuggestionSelected: (suggestion) => onSuggestionSelected(suggestion, pickupController, true),
                    hintStyle: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.grey),
                  ),
                  LocationAutocompleteField(
                    prefixIcon: Icon(Icons.location_on, color: Colors.red, size: 17),
                    googleMapApiKey: gKApi,
                    controller: dropoffController,
                    hint: 'Drop off a location',
                    onSuggestionSelected: (suggestion) => onSuggestionSelected(suggestion, dropoffController, false),
                    hintStyle: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.grey),
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: GestureDetector(
                          onTap: () => _selectDateTime(context),
                          child: AbsorbPointer(
                            child: TextEntryField(
                              controller: dateTimeController,
                              hint: 'Date and time',
                              prefixIcon: Icon(Icons.calendar_today, color: Colors.grey, size: 17),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: DropdownButtonFormField<String>(
                          iconSize: 25,
                          itemHeight: 57,
                          value: selectedSeat,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                          ),
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 13.5),
                          icon: Icon(Icons.arrow_drop_down, color: Colors.grey),
                          items: seats.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(value: value, child: Text(value));
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              selectedSeat = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a seat count';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  TextEntryField(
                    controller: priceController,
                    prefixIcon: Icon(Icons.local_atm, size: 17, color: Colors.grey),
                    suffixIcon: Text(region.currency),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter a price per Seat';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FadedScaleAnimation(
                    scaleDuration: const Duration(milliseconds: 600),
                    child: BottomBar(
                      isValid: isValid(),
                      onTap: () {
                        _submitForm();
                      },
                      text: locale.offerPool,
                      textColor: kWhiteColor,
                    ),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
