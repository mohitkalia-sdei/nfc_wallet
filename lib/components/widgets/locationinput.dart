import 'package:flutter/material.dart';
import 'package:map_autocomplete_field/map_autocomplete_field.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationAutocompleteField extends StatefulWidget {
  final String googleMapApiKey;
  final TextEditingController controller;
  final Function(Map<String, dynamic> locationData) onSuggestionSelected;
  final TextStyle? hintStyle;
  final TextCapitalization textCapitalization;
  final bool readOnly;
  final int? maxLength;
  final TextInputType keyboardType;
  final int maxLines;
  final String? label;
  final String? hint;
  final Widget? prefix;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final InputBorder? border;
  final String? image;

  const LocationAutocompleteField({
    super.key,
    required this.googleMapApiKey,
    required this.controller,
    required this.onSuggestionSelected,
    this.hintStyle,
    this.textCapitalization = TextCapitalization.sentences,
    this.readOnly = false,
    this.maxLength,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.label,
    this.hint,
    this.prefix,
    this.prefixIcon,
    this.suffixIcon,
    this.border,
    this.image,
  });

  @override
  LocationAutocompleteFieldState createState() =>
      LocationAutocompleteFieldState();
}

class LocationAutocompleteFieldState extends State<LocationAutocompleteField> {
  double? userLatitude;
  double? userLongitude;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        userLatitude = position.latitude;
        userLongitude = position.longitude;
      });
    } catch (e) {
    rethrow;
    }
  }


  Future<Iterable<dynamic>> _fetchSuggestions(String query) async {
    if (userLatitude == null || userLongitude == null || query.isEmpty) {
      return [];
    }

    final String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&location=$userLatitude,$userLongitude&radius=500000&key=${widget.googleMapApiKey}';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['predictions'];
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }


  Future<void> _fetchPlaceDetails(String placeId) async {
    final String url ='https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=${widget.googleMapApiKey}';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final locationData = {
          'address': data['result']['formatted_address'],
          'latitude': data['result']['geometry']['location']['lat'],
          'longitude': data['result']['geometry']['location']['lng'],
        };
        widget.onSuggestionSelected(locationData);
      } else {
        return ;
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
      child: MapAutoCompleteField(
        googleMapApiKey: widget.googleMapApiKey,
        controller: widget.controller,
        suggestionsCallback: _fetchSuggestions, 
        inputDecoration: InputDecoration(
          filled: true,
          isDense: false,
          contentPadding: EdgeInsets.only(top: 15,),
          prefix: widget.prefix,
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
          labelText: widget.label,
          hintText: widget.hint,
          hintStyle:Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Color(0xffb2b2b2), fontSize: 13.5),
          border: widget.border ??
              UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[200]!),
              ),
          enabledBorder: widget.border ??
              UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[200]!),
              ),
          focusedBorder: widget.border ??
              UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[200]!),
              ),
          counter: Offstage(),
          icon: widget.image != null
              ? ImageIcon(
                  AssetImage(widget.image!),
                  color: Theme.of(context).primaryColor,
                  size: 20.0,
                )
              : null,
        ),
        itemBuilder: (BuildContext context, suggestion) {
          final description = suggestion['description'] ?? "No description available";
          return Container(
            color: Colors.grey[200],
            child: ListTile(
              leading: Icon(Icons.location_on,
                  color: const Color.fromARGB(255, 75, 138, 55)),
              title: Text(
                description,
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          );
        },
        onSuggestionSelected: (suggestion) async {
         final description = suggestion['description'] ?? '';
  final placeId = suggestion['place_id'] ?? '';
  widget.controller.value = TextEditingValue(text: description);
  if (placeId.isNotEmpty) {
    await _fetchPlaceDetails(placeId);
  }
        },
      ),
    );
  }
}
