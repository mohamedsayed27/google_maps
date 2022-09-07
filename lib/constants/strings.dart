const loginScreen = '/';
const otpScreen = '/otp-screen';
const mapScreen = '/map_screen';
const personalScreen = '/personal_data';
const googleAPIKey = 'AIzaSyDY6ojcfK5MTty0Q68s6Dx6JgYXunZhYIA';
const placesSuggestionBaseUrl = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';


/// Custom Country Flag using regex
String generateCountryFlag() {
  String countryCode = 'eg';
  String flag = countryCode.toUpperCase().replaceAllMapped(RegExp(r'[A-Z]'),
      (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397));
  return flag;
}
