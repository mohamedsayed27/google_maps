const loginScreen = '/';
const otpScreen = '/otp-screen';
const mapScreen = '/map_screen';
const googleAPIKey = 'AIzaSyDY6ojcfK5MTty0Q68s6Dx6JgYXunZhYIA';

/// Custom Country Flag using regex
String generateCountryFlag() {
  String countryCode = 'eg';
  String flag = countryCode.toUpperCase().replaceAllMapped(RegExp(r'[A-Z]'),
      (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397));
  return flag;
}
