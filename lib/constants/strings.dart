const loginScreen = '/';
const otpScreen = '/otp-screen';
const mapScreen = '/map_screen';
const personalScreen = '/personal_data';
const googleAPIKey = 'AIzaSyBeF2eEvK01be7gKNgmp0WDKCjH4mC5YSA';
const placesSuggestionBaseUrl = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
const getPlaceLocationBaseUrl = 'https://maps.googleapis.com/maps/api/place/details/json';


/// Custom Country Flag using regex
String generateCountryFlag() {
  String countryCode = 'eg';
  String flag = countryCode.toUpperCase().replaceAllMapped(RegExp(r'[A-Z]'),
      (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397));
  return flag;
}
