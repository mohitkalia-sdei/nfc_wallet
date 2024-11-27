import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_geocoder/location_geocoder.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class LocationService {
String apiKey = 'AIzaSyAHaQx4V7jspYt9jX9k83F1P-24IT3ya1E';
  static Future<Map<String, double>> getCoordinatesFromAddress(
      String address) async {
    final LocatitonGeocoder geocoder = LocatitonGeocoder('AIzaSyAHaQx4V7jspYt9jX9k83F1P-24IT3ya1E');
    final response = await geocoder.findAddressesFromQuery(address);
    if (response.isNotEmpty) {
      final res = response.first.coordinates;
      return {'lat': res.latitude ?? 0.0, 'long': res.longitude ?? 0.0};
    }
    return {'lat': 0.0, 'long': 0.0};
  }



  static Future<String> getAddressFromCoordinates(
      double lat, double long) async {
    final LocatitonGeocoder geocoder = LocatitonGeocoder('AIzaSyAHaQx4V7jspYt9jX9k83F1P-24IT3ya1E');
    final address = await geocoder.findAddressesFromCoordinates(
      Coordinates(
        lat,
        long,
      ),
    );
    if (address.isEmpty) return '';
    return address.first.addressLine ?? '';
  }
}





class PlacesService {
  final String apiKey = "AIzaSyAHaQx4V7jspYt9jX9k83F1P-24IT3ya1E";

  Future<List<dynamic>> getAutocompleteSuggestions(String input) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey&components=country:rw');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['predictions'];
    } else {
      throw Exception("Failed to load suggestions");
    }
  }

  Future<Map<String, dynamic>> getPlaceDetails(String placeId) async {
  final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&key=$apiKey');

  final response = await http.get(url);
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['result'];
  } else {
    throw Exception("Failed to load place details");
  }
}


Future<Map<String, dynamic>> geocodeAddress(String address) async {
  final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=$apiKey');

  final response = await http.get(url);
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['results'][0]['geometry']['location'];
  } else {
    throw Exception("Failed to geocode address");
  }
}


Future<String> reverseGeocode(LatLng location) async {
  final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=${location.latitude},${location.longitude}&key=$apiKey');

  final response = await http.get(url);
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['results'][0]['formatted_address'];
  } else {
    throw Exception("Failed to reverse geocode");
  }
}


Future<List<dynamic>> getNearbyPlaces(LatLng location) async {
  final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${location.latitude},${location.longitude}&radius=1500&type=restaurant&key=$apiKey');

  final response = await http.get(url);
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['results'];
  } else {
    throw Exception("Failed to load nearby places");
  }
}
}



class LocationsService {
  Stream<Position> get locationStream {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, 
      ),
    );
  }

  Future<void> checkLocationPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }
  }
}
