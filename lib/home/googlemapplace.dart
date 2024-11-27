import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nfc_wallet/service/place_service.dart';

class MapSearchPage extends StatefulWidget {
  const MapSearchPage({super.key});

  @override
  MapSearchPageState createState() => MapSearchPageState();
}

class MapSearchPageState extends State<MapSearchPage> {
  late GoogleMapController _mapController;
  final TextEditingController _searchController = TextEditingController();
  final GooglePlacesService _placesService = GooglePlacesService('AIzaSyAHaQx4V7jspYt9jX9k83F1P-24IT3ya1E');

  List<Map<String, dynamic>> _autocompleteResults = [];
  final LatLng _currentLocation = LatLng(-1.9441, 30.0897);
  final Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Map Search')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => _onSearchChanged(value),
              decoration: InputDecoration(
                hintText: 'Search place',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(target: _currentLocation, zoom: 12),
                  onMapCreated: (controller) {
                    _mapController = controller;
                    _setInitialMarkers();
                  },
                  markers: _markers,
                  myLocationEnabled: true,
                ),
                if (_autocompleteResults.isNotEmpty)
                  Positioned(
                    top: 60,
                    left: 10,
                    right: 10,
                    child: Material(
                      elevation: 5,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _autocompleteResults.length,
                        itemBuilder: (context, index) {
                          final result = _autocompleteResults[index];
                          return ListTile(
                            title: Text(result['description']),
                            onTap: () => _onAutocompleteSelected(result['placeId']),
                          );
                        },
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

  void _onSearchChanged(String query) async {
    if (query.isEmpty) {
      setState(() {
        _autocompleteResults = [];
      });
      return;
    }

    try {
      final results = await _placesService.searchPlaceAutocomplete(query, _currentLocation);
      setState(() {
        _autocompleteResults = results;
      });
      // ignore: empty_catches
    } catch (e) {}
  }

  void _onAutocompleteSelected(String placeId) async {
    final placeDetails = await _placesService.getPlaceDetails(placeId);
    final location = placeDetails['location'];
    final latLng = LatLng(location['lat'], location['lng']);

    _searchController.clear();
    setState(() {
      _autocompleteResults = [];
      _markers.add(
        Marker(
          markerId: MarkerId(placeId),
          position: latLng,
          infoWindow: InfoWindow(
            title: placeDetails['name'],
            snippet: placeDetails['address'],
          ),
        ),
      );
    });

    _mapController.animateCamera(CameraUpdate.newLatLngZoom(latLng, 15));
  }

  void _setInitialMarkers() {
    _markers.add(
      Marker(
        markerId: MarkerId('initial'),
        position: _currentLocation,
        infoWindow: InfoWindow(title: 'Current Location'),
      ),
    );
  }
}
