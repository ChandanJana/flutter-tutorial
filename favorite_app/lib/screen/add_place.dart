import 'dart:io';

import 'package:favorite_app/models/place_location.dart';
import 'package:favorite_app/providers/users_place.dart';
import 'package:favorite_app/widgets/image_input.dart';
import 'package:favorite_app/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() {
    return _AddPlaceScreenState();
  }
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File? _image;
  PlaceLocation? _placeLocation;

  void _savePlace() {
    final title = _titleController.text;

    if (title.isEmpty || _image == null || _placeLocation == null) {
      return;
    }

    ref.read(userPlaceProvider.notifier).addPlace(
          title,
          _image!,
          _placeLocation!,
        );
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Place',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
              style:
                  TextStyle(color: Theme.of(context).colorScheme.onBackground),
              controller: _titleController,
            ),
            const SizedBox(
              height: 16,
            ),
            ImageInput(
              onSelectImage: (file) => _image = file,
            ),
            const SizedBox(
              height: 16,
            ),
            LocationInput(
              onSelectedLocation: (location) {
                _placeLocation = location;
              },
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton.icon(
              onPressed: _savePlace,
              label: const Text(
                'Add',
              ),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
