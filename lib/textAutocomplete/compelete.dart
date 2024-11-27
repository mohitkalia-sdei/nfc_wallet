import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nfc_wallet/textAutocomplete/autocomplete_service.dart';

class MapAutocomplete extends StatefulWidget {
  const MapAutocomplete({super.key});

  @override
  MapAutocompleteState createState() => MapAutocompleteState();
}

class MapAutocompleteState extends State<MapAutocomplete> {
  final TextEditingController _controller = TextEditingController();
  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  List<Map<String, dynamic>> _suggestions = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });

    if (_mapController != null) {
      _mapController!.animateCamera(CameraUpdate.newLatLng(_currentPosition!));
    }
  }

  void _onSearchChanged(String query) async {
    if (_currentPosition == null) return;
    final suggestions = await getAutocompleteSuggestions(query, _currentPosition!);
    setState(() {
      _suggestions = suggestions;
    });
  }

  Future<void> _selectSuggestion(Map<String, dynamic> suggestion) async {
    final placeId = suggestion['place_id'];
    final latLng = await getPlaceDetails(placeId);

    if (latLng != null) {
      _mapController?.animateCamera(CameraUpdate.newLatLng(latLng));
      setState(() {
        _suggestions = [];
        _controller.text = suggestion['description'];
      });
    } else {
      throw ("Failed to fetch place details for placeId");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Search for a location...",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      ),
                      onChanged: _onSearchChanged,
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: _currentPosition!,
                            zoom: 14,
                          ),
                          onMapCreated: (controller) {
                            _mapController = controller;
                            _mapController?.animateCamera(
                              CameraUpdate.newLatLng(_currentPosition!),
                            );
                          },
                        ),
                        if (_suggestions.isNotEmpty)
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Material(
                              color: Colors.white,
                              child: ListView.separated(
                                shrinkWrap: true,
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                itemCount: _suggestions.length,
                                itemBuilder: (context, index) {
                                  final suggestion = _suggestions[index];
                                  return ListTile(
                                    title: Text(
                                      suggestion['description'],
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                                    ),
                                    onTap: () => _selectSuggestion(suggestion),
                                  );
                                },
                                separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey[100]),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
