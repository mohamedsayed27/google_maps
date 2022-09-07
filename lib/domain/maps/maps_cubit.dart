import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repository/maps_repository.dart';
import 'maps_state.dart';

class MapsCubit extends Cubit<MapsState> {
  final MapsRepository mapsRepository;

  MapsCubit(this.mapsRepository) : super(MapsInitial());

  void getSuggestedPlaces(String place, String sessionToke) {
    mapsRepository.getSuggestionPlacesList(place, sessionToke).then((value) {
      emit(SuggestedLoadedState(value));
    }).catchError((error) {
      emit(SuggestedErrorState(error.toString()));
    });
  }
}
