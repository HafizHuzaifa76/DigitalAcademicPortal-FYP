import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;
import 'package:googleapis_auth/auth_io.dart' as auth;

Future<void> sendNotificationToToken(
    String token, String title, String body) async {
  const serverKey =
      'YOUR_FIREBASE_SERVER_KEY'; // Replace with actual server key

  await http.post(
    Uri.parse('https://fcm.googleapis.com/fcm/send'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey',
    },
    body: jsonEncode({
      'to': token,
      'notification': {
        'title': title,
        'body': body,
      },
      'priority': 'high',
    }),
  );
}

Future<void> sendNotificationToChannel(
    String topic, String title, String body) async {
  const serverKey = 'YOUR_FIREBASE_SERVER_KEY';

  await http.post(
    Uri.parse('https://fcm.googleapis.com/fcm/send'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey',
    },
    body: jsonEncode({
      'to': '/topics/$topic',
      'notification': {
        'title': title,
        'body': body,
      },
      'priority': 'high',
    }),
  );
}

Future<String> getAccessToken() async {
  final serviceAccountJson = {
    "type": "service_account",
    "project_id": "digital-academic-portal",
    "private_key_id": "3626059b7d9de28c4bacbbcf501b2495c0d892eb",
    "private_key":
        "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDpgjHcd+3qCTFm\nDqRSZPkA7v6r/tfc5diFYglbiumUWRaXvJBcbZ6EdyJ3DVCKf045jiQ5JR8R5Yr+\nOXPD9YneVL2+OiNR23+u8sW7+w0N1iZGGNEvbPZOE3w2/4g65gGbRmkZC47koO+c\nNlWQkfzyUaUKFoosAFYp74VufAHS+1BVuSmhVdrFtGiXDUIoW4PrTRMPovVnibTR\nr+OT4uXY1Kqp4KtbZdrUeQK9XU97xhvCNYCm+oV7EucUbtzgaYGyjM2+C9ZV1ucT\nnIYMxPo2iM7OED/YGiT4Rzqu33v3kDHOl08uKdCbHG+Km6ZfBB1vh+XKIIaNb+J4\nyfJZOActAgMBAAECggEAFnrZfIFSNvH4HrxhnuoIG8omW94On35ELEEeKAE1T/oM\npgJ5/l/yPwvuFjqCqrarS/iubY7wkQtBaIyU48RfZ7dORgI4VMDWJ7xJA3odjVu0\ntxJcDx4FD0qqbmwGzC7I8E8kvovBj6qbrrT/Y0neqWBpTFGTrz1ADkz4EkUfctVe\nWIiIb3m5a9xNsIS/Ed0SVzwlLjcLs6LWVLb3c30mJFvnyh2b409TGJ/tV3gfl75p\n0A1AjFNIGXIOjDfzykFwZZtYB4LGnJ4Q5sbYjfKDWG4zILPWyi3UdsPLAIzpF6EM\nQ7iZHAD/hQ61sziGZ1PjkqmsYXd0ABM+7/AjMzZFaQKBgQD2NqLw7yve9OApQ524\nDYdRoKoec1yGxnTjBNzBlZrOBv2sJkQ2hMtoixWntY353Cnzlhli7dJd9TBPpGxi\nuPVlPZ04bE43Fe0fY5jyuAVaBd1KtVhNch9QcKltX7C5xSNwGUxSyHEOfz+Sg+Cs\nBgSFZjnsrxdIPxSShRKNoVpeSQKBgQDyykdzZeLRlWCI2w0e0bI8mwRRyYmzBZCI\n/EvERrRc8ICxzjkjUMmO54zDm4ae9WqctMPUiuCfg+5hA8uUECyfESQkoyckt2kY\nNJ/budGo5VRy97Oi1FHRZDbSMeFyVTuYBCgbr9vQevt6KDnxek8djrycMUnM02ne\nQziCO5WxxQKBgQCZ+Zcy58/e0fMxuxhyVvuOP9TD0E9H9ep5YrwP0FiMifCwbQnx\nsmBm07xKMo9Ed7xAmljr9mC9460/0Ur6/kJw+vRMqebMKkktfSLUf+LQ5qP6qag8\nXqdYrew2+0XRF4lO/HMvvix97XQ7U3/49JZ1OnX1H5aG1vQtoUz2B7c1CQKBgFJ2\nF4x/N2l9tbrlw3ALQuFIuU/aBrXSFwQfxNAWP54tZVh+tXNkNgEebfXl9fQ5YIt2\n7ehbfu1OzwEOW++fCrjABqmW7G2RCdXZ0c28MBSQR32A2fdc66kVw3Ti0jKV9las\nWr8EnMETdCRKU1vL8eEVIMRgDTPPPm7qH+BDwpUNAoGBAI8nBwwFA85+vv3ePAMg\n4AIdqOl2G8Mm3l8CXD/xEDloMN5QvPtQKeTS3PB068229kECOtuM9TbjrR2/DRVx\nZRr4JPTq6Q4jAjq+LocuH5z5EWxQnZzPaJGSHj5UWrDXkuvAJQrd7/I6oa0Dm9zs\n6WEf/2d6/khF1EDEoCNGuxon\n-----END PRIVATE KEY-----\n",
    "client_email":
        "firebase-adminsdk-laq6x@digital-academic-portal.iam.gserviceaccount.com",
    "client_id": "107994092523819875118",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url":
        "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-laq6x%40digital-academic-portal.iam.gserviceaccount.com",
    "universe_domain": "googleapis.com"
  };

  List<String> scopes = [
    "https://www.googleapis.com/auth/userinfo.email",
    "https://www.googleapis.com/auth/firebase.database",
    "https://www.googleapis.com/auth/firebase.messaging"
  ];
  http.Client client = await auth.clientViaServiceAccount(
    auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
    scopes,
  );

  //Obtain the access token
  auth.AccessCredentials credentials =
      await auth.obtainAccessCredentialsViaServiceAccount(
          auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
          scopes,
          client);
  // Close the HTTP client
  client.close();

  return credentials.accessToken.data;
}

Future<void> sendFCMMessage() async {
  final String serverKey = await getAccessToken(); // Your FCM server key
  final String fcmEndpoint =
      'https://fcm.googleapis.com/v1/projects/digital-academic-portal/messages:send';
  final String? currentFCMToken = await FirebaseMessaging.instance.getToken();

  final Map<String, dynamic> message = {
    'message': {
      "token":
          currentFCMToken, // Token of the device you want to send the message to
      'notification': {
        'body': 'This is an FCM notification message!',
        'title': 'FCM Message'
      },
      'data': {
        'current_user_fcm_token':
            currentFCMToken, // Include the current user's FCM token in data payload
      }
    }
  };

  final http.Response response = await http.post(
    Uri.parse(fcmEndpoint),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $serverKey',
    },
    body: jsonEncode(message),
  );

  if (response.statusCode == 200) {
    print("FCM message sent successfully");
  } else {
    print("Failed to send FCM message: ${response.statusCode}");
  }
}
