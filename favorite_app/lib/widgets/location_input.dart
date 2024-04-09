import 'dart:convert';

import 'package:favorite_app/models/place_location.dart';
import 'package:favorite_app/screen/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSelectedLocation});

  final void Function(PlaceLocation placeLocation) onSelectedLocation;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  var _isGettingLocation = false;

  String get locationImage {
    if (_pickedLocation == null) {
      return '';
    }
    final lat = _pickedLocation!.latitude;
    final long = _pickedLocation!.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$long&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$long&key=ATzaSyDLcWXUggpPZo8lcbH8TB4Crq5SJjtj4ag';
  }

  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    setState(() {
      _isGettingLocation = true;
    });

    locationData = await location.getLocation();
    if (locationData.latitude == null || locationData.longitude == null) {
      return;
    }
    print(locationData.latitude);
    print(locationData.longitude);
    _savePlace(locationData.latitude!, locationData.longitude!);
  }

  Future<void> _savePlace(double lat, double long) async {
    /*final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=ATzaSyDLcWXUggpPZo8lcbH8TB4Crq5SJjtj4ag');
    final response = await http.get(url);
    print(response);
    final data = json.decode(response.body);
    final address = data['results'][0]['formatted_address'];*/
    final address = 'I will be you address';
    setState(() {
      _pickedLocation = PlaceLocation(
          latitude: lat,
          longitude: long,
          address: address);
      _isGettingLocation = false;
    });
    widget.onSelectedLocation(_pickedLocation!);
  }

  void _selectOnMap() async {
    final pickLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (ctx) {
          return const MapScreen();
        },
      ),
    );

    if (pickLocation == null) {
      return;
    }
    _savePlace(pickLocation.latitude, pickLocation.longitude);

  }

  @override
  Widget build(BuildContext context) {
    Widget content = Text(
      'No location',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
          ),
    );

    if (_pickedLocation != null) {
      content = Image.network(
        locationImage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    if (_isGettingLocation) {
      content = Center(
        child: CircularProgressIndicator(),
      );
    }
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 170,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.onBackground.withOpacity(.2),
            ),
          ),
          child: content,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _getCurrentLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Get your current location'),
            ),
            TextButton.icon(
              onPressed: _selectOnMap,
              icon: const Icon(Icons.map),
              label: const Text('Select on map'),
            )
          ],
        )
      ],
    );
  }
}
