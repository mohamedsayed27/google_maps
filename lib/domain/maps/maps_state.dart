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
