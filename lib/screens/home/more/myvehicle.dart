import 'package:animation_wrappers/animations/faded_scale_animation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:nfc_wallet/components/widgets/buttonbar.dart';
import 'package:nfc_wallet/components/widgets/text_field.dart';
import 'package:nfc_wallet/models/vehicle_model.dart';
import 'package:nfc_wallet/service/vehicle_service.dart';
import 'package:nfc_wallet/shared/shared_states.dart';
import 'package:nfc_wallet/theme/colors.dart';

class MyVehicleTab extends ConsumerStatefulWidget {
  const MyVehicleTab({super.key});

  @override
  MyVehicleTabState createState() => MyVehicleTabState();
}

class MyVehicleTabState extends ConsumerState<MyVehicleTab> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _vehicleTypeController = TextEditingController();
  final TextEditingController _vehicleNameController = TextEditingController();
  final TextEditingController _vehicleRegNumberController = TextEditingController();
  final TextEditingController _pricePerSeatController = TextEditingController();
  final TextEditingController _facilitiesController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> saveVehicle(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final user = ref.read(userProvider);
      final pricePerSeatText = _pricePerSeatController.text.trim();
      final int? pricePerSeat = int.tryParse(pricePerSeatText);
      if (user == null) return;

      final vehicle = Vehicle(
          vehicleType: _vehicleTypeController.text,
          vehicleName: _vehicleNameController.text,
          vehicleRegNumber: _vehicleRegNumberController.text,
          pricePerSeat: pricePerSeat,
          facilities: _facilitiesController.text,
          instructions: _instructionsController.text,
          userId: user.phoneNumber,
          createdOn: Timestamp.now());

      await VehicleService().saveOrUpdateVehicle(vehicle, ref);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.green[700], content: Text("Vehicle saved successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Color.fromARGB(255, 227, 85, 50),
            content: Text("Failed to save vehicle. Please check your internet connection.")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _vehicleTypeController.dispose();
    _vehicleNameController.dispose();
    _vehicleRegNumberController.dispose();
    _pricePerSeatController.dispose();
    _facilitiesController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final user = ref.read(userProvider)!;

    final vehicleAsyncValue = ref.watch(VehicleService.vehicleStream(user.id));
    isLoading = vehicleAsyncValue.isLoading;
    if (vehicleAsyncValue.value != null) {
      final vehicle = vehicleAsyncValue.value!;
      if (_vehicleTypeController.text.isEmpty) {
        _vehicleTypeController.text = vehicle.vehicleType;
        _vehicleNameController.text = vehicle.vehicleName;
        _vehicleRegNumberController.text = vehicle.vehicleRegNumber;
        _pricePerSeatController.text = vehicle.pricePerSeat.toString();
        _facilitiesController.text = vehicle.facilities;
        _instructionsController.text = vehicle.instructions;
      }
    }
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Form(
        key: _formKey,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ListView(
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      TextFieldInput(
                        labelText: locale.vehicleType,
                        controller: _vehicleTypeController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Vehicle type is required";
                          }
                          return null;
                        },
                      ),
                      TextFieldInput(
                        labelText: locale.vehicleName,
                        controller: _vehicleNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Vehicle Name is required";
                          }
                          return null;
                        },
                      ),
                      TextFieldInput(
                        labelText: locale.vehicleReg,
                        controller: _vehicleRegNumberController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Vehicle Reg is required";
                          }
                          return null;
                        },
                      ),
                      TextFieldInput(
                        labelText: '${locale.pricePerSeat} \$',
                        controller: _pricePerSeatController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Price is required";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFieldInput(
                        labelText: 'Facilities (i.e AC, Extra Luggage, etc)',
                        controller: _facilitiesController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Facilities is required";
                          }
                          return null;
                        },
                      ),
                      TextFieldInput(
                        labelText: 'Instructions (No Smoking, pets)',
                        controller: _instructionsController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Instructions is required";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                const SizedBox(height: 60),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: GestureDetector(
                onTap: () {
                  saveVehicle(context);
                },
                child: FadedScaleAnimation(
                  scaleDuration: const Duration(milliseconds: 600),
                  child: BottomBar(
                    textColor: kWhiteColor,
                    color: kMainColor,
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        saveVehicle(context);
                      }
                    },
                    text: locale.update,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
