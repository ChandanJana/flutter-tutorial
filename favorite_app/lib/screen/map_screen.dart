import 'dart:async';

import 'package:favorite_app/models/place_location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key,
    this.placeLocation = const PlaceLocation(
      latitude: 22.5726,
      longitude: 88.3639,
      address: 'Kolkata',
    ),
    this.isSelecting = true});

  final PlaceLocation placeLocation;
  final bool isSelecting;

  @override
  State<MapScreen> createState() => MapSampleState();
}

class MapSampleState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);
  LatLng? _pickedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isSelecting ? 'Your location' : 'Pick your location',
          style: Theme
              .of(context)
              .textTheme
              .titleLarge!
              .copyWith(
            color: Theme
                .of(context)
                .colorScheme
                .onBackground,
          ),
        ),
        actions: [
          if (widget.isSelecting)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                Navigator.of(context).pop(_pickedLocation);
              },
            )
        ],
      ),
      body: GoogleMap(
        onTap: !widget.isSelecting ? null : (position) {
          setState(() {
            _pickedLocation = position;
          });
        },
        mapType: MapType.hybrid,
        initialCameraPosition: CameraPosition(
          target: LatLng(
              widget.placeLocation.latitude, widget.placeLocation.longitude),
          zoom: 16,
        ),
        /*onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },*/
        markers: (_pickedLocation == null && widget.isSelecting == true)
            ? {}
            : {
          Marker(
            markerId: const MarkerId('m1'),
            position: _pickedLocation ??
                LatLng(
                  widget.placeLocation.latitude,
                  widget.placeLocation.longitude,
                ),
          )
        },
      ),
      /*floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('To the lake!'),
        icon: const Icon(Icons.directions_boat),
      ),*/
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
