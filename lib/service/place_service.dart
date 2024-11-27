import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GooglePlacesService {
  final String apiKey;

  GooglePlacesService(this.apiKey);

  Future<List<Map<String, dynamic>>> searchPlaceAutocomplete(String input, LatLng location) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&location=${location.latitude},${location.longitude}&radius=5000&key=$apiKey');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['predictions'] as List).map((prediction) => {
        "placeId": prediction['place_id'],
        "description": prediction['description'],
      }).toList();
    } else {
      throw Exception('Failed to load autocomplete results');
    }
  }

  Future<Map<String, dynamic>> getPlaceDetails(String placeId) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final result = data['result'];
      return {
        "name": result['name'],
        "address": result['formatted_address'],
        "location": result['geometry']['location'],
        "openingHours": result['opening_hours']?['weekday_text'] ?? [],
        "photos": result['photos'] ?? [],
      };
    } else {
      throw Exception('Failed to load place details');
    }
  }

  Future<Map<String, dynamic>> geocodeAddress(String address) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=$apiKey');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final result = data['results'][0];
      return {
        "location": result['geometry']['location'],
        "formattedAddress": result['formatted_address'],
      };
    } else {
      throw Exception('Failed to geocode address');
    }
  }

  Future<Map<String, dynamic>> reverseGeocode(double lat, double lng) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final result = data['results'][0];
      return {
        "formattedAddress": result['formatted_address'],
      };
    } else {
      throw Exception('Failed to reverse geocode location');
    }
  }
}
