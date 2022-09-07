class PlacesSuggestionModel{
  String? placeId;
  String? placeDescription;
  PlacesSuggestionModel.fromJso(Map<String, dynamic> json){
    placeId = json['place_id'];
    placeDescription = json['description'];
  }
}