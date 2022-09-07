abstract class MapsState {}

class MapsInitial extends MapsState {}

class SuggestedLoadedState extends MapsState{
  final List<dynamic> suggestedPlacesList;
  SuggestedLoadedState(this.suggestedPlacesList);
}

class SuggestedErrorState extends MapsState{
  final String error;

  SuggestedErrorState(this.error);
}
