import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps/constants/colors.dart';
import 'package:google_maps/data/models/place_model.dart';
import 'package:google_maps/data/models/places_suggestion_model.dart';
import 'package:google_maps/domain/maps/maps_cubit.dart';
import 'package:google_maps/domain/maps/maps_state.dart';
import 'package:google_maps/helpers/locaton_helper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:uuid/uuid.dart';
import '../widgets/my_drawer.dart';
import '../widgets/place_item.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  void initState() {
    super.initState();
    getMyCurrentPosition();
  }

  List<PlacesSuggestionModel> suggestedPlacesList = [];

  FloatingSearchBarController searchController = FloatingSearchBarController();

  Completer<GoogleMapController> mapController = Completer();

  static Position? position;

  static final CameraPosition currentCameraPosition = CameraPosition(
    bearing: 0.0,
    target: LatLng(position!.latitude, position!.longitude),
    tilt: 0.0,
    zoom: 17.0,
  );

  Set<Marker> markers = {};

  late PlacesSuggestionModel placesSuggestionModel;
  late Place place;
  late Marker marker;
  late Marker currentLocationMarker;
  late CameraPosition gotToSearchedPlace;

  void goToSearchedPlace() {
    gotToSearchedPlace = CameraPosition(
      bearing: 0.0,
      tilt: 0.0,
      target: LatLng(
        place.result.geometry.location.lat,
        place.result.geometry.location.lng,
      ),
      zoom: 17.0,
    );
  }

  Future<void> getMyCurrentPosition() async {
    await LocationHelper.getCurrentLocation();
    position = await Geolocator.getLastKnownPosition().whenComplete(() {
      setState(() {});
    });
  }

  Future<void> _goToCurrentLocation() async {
    final GoogleMapController controller = await mapController.future;
    controller
        .animateCamera(CameraUpdate.newCameraPosition(currentCameraPosition));
  }

  Widget buildGoogleMaps() {
    return GoogleMap(
      initialCameraPosition: currentCameraPosition,
      mapType: MapType.normal,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      onMapCreated: (GoogleMapController controller) {
        mapController.complete(controller);
      },
    );
  }

  Widget buildSuggestionBloc() {
    return BlocBuilder<MapsCubit, MapsState>(builder: (context, state) {
      if (state is SuggestedLoadedState) {
        suggestedPlacesList = (state).suggestedPlacesList;
        if (suggestedPlacesList.isNotEmpty) {
          return buildSuggestionPlacesList();
        } else {
          return Container();
        }
      } else {
        return Container();
      }
    });
  }

  Widget buildSuggestionPlacesList() {
    return ListView.builder(
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () async {
            placesSuggestionModel = suggestedPlacesList[index];
            searchController.close();
            getSelectedPlaceLocation();
          },
          child: PlaceItem(
            placesSuggestionModel: suggestedPlacesList[index],
          ),
        );
      },
      itemCount: suggestedPlacesList.length,
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
    );
  }

  void getSelectedPlaceLocation() {
    final sessionToken = const Uuid().v4();
    BlocProvider.of<MapsCubit>(context).getPlaceLocation(placesSuggestionModel.placeId!, sessionToken);
  }

  Widget buildPlaceDetailsBloc() {
    return BlocListener<MapsCubit, MapsState>(
      listener: (context, state) async{
        if (state is PlaceLocationLoadedState) {
          place = (state).place;

           goToSelectedPlaceLocation();
        }
      },
      child: Container(),
    );
  }

  Future<void> goToSelectedPlaceLocation() async {
    goToSearchedPlace();
    final GoogleMapController controller = await mapController.future;
    controller
        .animateCamera(CameraUpdate.newCameraPosition(gotToSearchedPlace));
    buildSearchedPlaceMarker();
  }

  void buildSearchedPlaceMarker() {
    marker = Marker(
      markerId:  MarkerId('1'),
      position: gotToSearchedPlace.target,
      onTap: () {
        buildCurrentLocationMarker();
      },
      infoWindow: InfoWindow(
        title: placesSuggestionModel.placeDescription,
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    addMarkerToMarkersAndUpdateUi(marker);
  }
  void addMarkerToMarkersAndUpdateUi(Marker marker){
    setState(() {
      markers.add(marker);
    });
  }
  void buildCurrentLocationMarker(){
    currentLocationMarker = Marker(
      markerId:  const MarkerId('5'),
      position: LatLng(position!.latitude, position!.longitude),
      infoWindow: const InfoWindow(
        title: 'your current location',
      ),
       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
    addMarkerToMarkersAndUpdateUi(currentLocationMarker);
  }

  Widget buildFloatingSearchBar() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return FloatingSearchBar(
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              buildSuggestionBloc(),
              buildPlaceDetailsBloc(),
            ],
          ),
        );
      },
      controller: searchController,
      elevation: 6,
      hintStyle: const TextStyle(fontSize: 16),
      queryStyle: const TextStyle(fontSize: 16),
      hint: 'Find a place ...',
      border: const BorderSide(style: BorderStyle.none),
      margins: const EdgeInsets.fromLTRB(20, 45, 20, 0),
      padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
      height: 52,
      borderRadius: BorderRadius.circular(11),
      iconColor: AppColors.blue,
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 54),
      transitionDuration: const Duration(milliseconds: 600),
      transitionCurve: Curves.easeInSine,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0 : -1,
      openAxisAlignment: 0,
      width: isPortrait ? double.infinity : 500,
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (query) {
        getChangeSuggestedPlaces(query);
      },
      onFocusChanged: (_) {},
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
              icon: Icon(
                Icons.place,
                color: Colors.black.withOpacity(0.6),
              ),
              onPressed: () {}),
        )
      ],
      leadingActions: const [],
    );
  }

  void getChangeSuggestedPlaces(String query) {
    var sessionToken = const Uuid().v4();
    BlocProvider.of<MapsCubit>(context).getSuggestedPlaces(query, sessionToken);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: MyDrawer(),
        body: Stack(
          fit: StackFit.expand,
          children: [
            position != null
                ? buildGoogleMaps()
                : const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.blue,
                    ),
                  ),
            buildFloatingSearchBar(),
          ],
        ),
        floatingActionButton: Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 8, 30),
          child: FloatingActionButton(
            onPressed: _goToCurrentLocation,
            child: const Icon(Icons.place_sharp),
          ),
        ),
      ),
    );
  }
}
