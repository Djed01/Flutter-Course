
import 'package:favorite_places/providers/user_places.dart';
import 'package:favorite_places/screens/add_place.dart';
import 'package:favorite_places/widgets/places_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesSreen extends ConsumerStatefulWidget{
  const PlacesSreen({super.key});

  @override
  ConsumerState<PlacesSreen> createState() => _PlacesSreenState();

}

class _PlacesSreenState extends ConsumerState<PlacesSreen>{
  late Future<void> _placesFuture;

  @override
  void initState() {
    super.initState();
    _placesFuture = ref.read(userPlacesProvider.notifier).loadPlaces();
  }

  @override
  Widget build(BuildContext context) {
    final userPlaces = ref.watch(userPlacesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const AddPlaceScreen(),
              ));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: FutureBuilder(future: _placesFuture,builder: (context, snapshot) => snapshot.connectionState ==
        ConnectionState.waiting ?
        const Center(child: CircularProgressIndicator(),)
        : 
        PlacesList(places: userPlaces,)) ),
    );
  }
}