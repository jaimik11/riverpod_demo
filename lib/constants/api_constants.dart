class ApiConstants {
  static const String basURL = 'https://c2c.sa/api';
  static const String socketURL = 'https://socket.c2c.sa/';

  // static const String basURL = 'https://dev.c2c.sa/api';
  // static const String socketURL = 'http://13.200.164.126:3000/';
  static const String appId = 'd8053b39af7e4b719d0c95bd1e7cc7d4';
  static const mapApiBaseUrl = 'https://maps.googleapis.com/maps/api';

  static const String init = '/init';
  static const String myDeals = '/deal';
  static const String aboutUs = '/deal';
  static const String terms = '/deal';
  static const String privacyPolicy = '/deal';
}

bool isDevMode = false;
bool isDevUrl = ApiConstants.basURL == 'https://dev.c2c.sa/api' ? true : false;
