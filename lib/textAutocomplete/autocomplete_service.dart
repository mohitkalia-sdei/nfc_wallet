import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

const String apiKey = "AIzaSyCePJuN1t2y41ra4FSJHDSbnixMxGotrYU";

Future<List<Map<String, dynamic>>> getAutocompleteSuggestions(String input, LatLng currentPosition) async {
  if (input.isEmpty) return [];

  final url = Uri.parse(
    "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey&location=${currentPosition.latitude},${currentPosition.longitude}&radius=50000",
  );

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        return (data['predictions'] as List).map((suggestion) {
          return {
            'description': suggestion['description'],
            'place_id': suggestion['place_id'],
          };
        }).toList();
      }
    }
  } catch (e) {
    rethrow;
  }

  return []; 
}

Future<LatLng?> getPlaceDetails(String placeId) async {
  final url = Uri.parse(
    "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey",
  );

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        final location = data['result']['geometry']['location'];
        return LatLng(location['lat'], location['lng']);
      }
    }
  } catch (e) {
    rethrow;
  }

  return null;
}
