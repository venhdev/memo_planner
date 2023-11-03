import 'dart:io' show Platform;

// const clientId =
//     '157136539902-l1cso3i10ugh92332enftmrj8austujb.apps.googleusercontent.com';
// const clientSecret = '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';
// const accessToken = 'YOUR_ACCESS_TOKEN';

//https://console.cloud.google.com/apis/credentials/oauthclient/

class Secret {
  static const androidClientId =
      '157136539902-j1vequ8k314rp4eo0s3m39losi7rloei.apps.googleusercontent.com';
  static const iosClientId = '';
  static String getId() =>
      Platform.isAndroid ? Secret.androidClientId : Secret.iosClientId;
}
