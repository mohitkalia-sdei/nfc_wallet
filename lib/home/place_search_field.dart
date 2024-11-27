import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nfc_wallet/service/location_service.dart';

class PlaceSearchField extends StatefulWidget {
  final Function(LatLng location, String placeId) onPlaceSelected;

  const PlaceSearchField({super.key, required this.onPlaceSelected});

  @override
  PlaceSearchFieldState createState() => PlaceSearchFieldState();
}

class PlaceSearchFieldState extends State<PlaceSearchField> {
  final PlacesService placesService = PlacesService();
  List<dynamic> suggestions = [];

  void onSearchChanged(String query) async {
    if (query.isNotEmpty) {
      final results = await placesService.getAutocompleteSuggestions(query);
      setState(() {
        suggestions = results;
      });
    } else {
      setState(() {
        suggestions = [];
      });
    }
  }

  void onSuggestionTapped(dynamic suggestion) async {
    final placeId = suggestion['place_id'];
    final placeDetails = await placesService.getPlaceDetails(placeId);
    final location = LatLng(
      placeDetails['geometry']['location']['lat'],
      placeDetails['geometry']['location']['lng'],
    );

    // Call the onPlaceSelected callback
    widget.onPlaceSelected(location, placeId);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          onChanged: onSearchChanged,
          decoration: InputDecoration(hintText: 'Enter pickup/drop-off location'),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            final suggestion = suggestions[index]['description'];
            return ListTile(
              title: Text(suggestion),
              onTap: () => onSuggestionTapped(suggestions[index]),
            );
          },
        ),
      ],
    );
  }
}
