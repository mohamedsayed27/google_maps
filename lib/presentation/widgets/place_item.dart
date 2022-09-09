import 'package:flutter/material.dart';
import 'package:google_maps/constants/colors.dart';
import 'package:google_maps/data/models/places_suggestion_model.dart';

class PlaceItem extends StatelessWidget {
  final PlacesSuggestionModel placesSuggestionModel;

  const PlaceItem({Key? key, required this.placesSuggestionModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var subTitle = placesSuggestionModel.placeDescription!
        .replaceAll(placesSuggestionModel.placeDescription!.split(',')[0], '');
    return Container(
      width: double.infinity,
      margin: const EdgeInsetsDirectional.all(8),
      padding: const EdgeInsetsDirectional.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: AppColors.lightBlue),
              child: const Icon(
                Icons.place,
                color: AppColors.blue,
              ),
            ),
            title: RichText(
                text: TextSpan(
              children: [
                TextSpan(
                  text:
                      '${placesSuggestionModel.placeDescription!.split(',')[0]}\n',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text:
                  subTitle,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ],
            )),
          )
        ],
      ),
    );
  }
}
