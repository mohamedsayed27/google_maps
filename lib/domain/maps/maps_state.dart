import 'package:google_maps/data/models/place_model.dart';

import '../../data/models/places_suggestion_model.dart';

abstract class MapsState {}

class MapsInitial extends MapsState {}

class SuggestedLoadedState extends MapsState{
  final List<PlacesSuggestionModel> suggestedPlacesList;
  SuggestedLoadedState(this.suggestedPlacesList);
}

class SuggestedErrorState extends MapsState{
  final String error;

  SuggestedErrorState(this.error);
}

class PlaceLocationLoadedState extends MapsState{
  final Place place;
  PlaceLocationLoadedState(this.place);
}


class PlaceLocationErrorState extends MapsState{
  final String error;

  PlaceLocationErrorState(this.error);
}