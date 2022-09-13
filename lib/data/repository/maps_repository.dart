import 'package:google_maps/data/models/place_model.dart';
import 'package:google_maps/data/webservices/place_webservices.dart';

import '../models/places_suggestion_model.dart';

class MapsRepository{
  final PlacesWebServices placesWebServices;

  MapsRepository(this.placesWebServices);
  Future<List<PlacesSuggestionModel>> getSuggestionPlacesList(
      String place, String sessionToke) async {
    final suggestions = await placesWebServices.getSuggestionPlacesList(place, sessionToke);
    return suggestions.map((suggestion) => PlacesSuggestionModel.fromJso(suggestion)).toList();
  }

  Future<Place> getPlaceLocation(
      String placeId, String sessionToken) async {
    final place = await placesWebServices.getPlaceLocation(placeId, sessionToken);
    return Place.fromJson(place);
  }

}