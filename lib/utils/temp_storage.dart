import 'dart:io';
import 'dart:convert';

import 'package:firebase_admin/firebase_admin.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:path_provider/path_provider.dart';

class TemporaryStorage {
  // This creates a temporary directory in the user's device for storing Firebase Credentials.
  static void service() async {
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/service-account.json');
    final data = json.encode({
      "type": FlutterConfig.get('type'),
      "project_id": FlutterConfig.get('project_id'),
      "private_key_id": FlutterConfig.get('private_key_id'),
      "private_key": FlutterConfig.get('private_key'),
      "client_email": FlutterConfig.get('client_email'),
      "client_id": FlutterConfig.get('client_id'),
      "auth_uri": FlutterConfig.get('auth_uri'),
      "token_uri": FlutterConfig.get('token_uri'),
      "auth_provider_x509_cert_url":
          FlutterConfig.get('auth_provider_x509_cert_url'),
      "client_x509_cert_url": FlutterConfig.get('client_x509_cert_url'),
    });
    await file.writeAsString(data);

    // Initializing Firebase Admin to allow me to do CRUD operations to user data
    FirebaseAdmin.instance.initializeApp(
      AppOptions(
        credential: FirebaseAdmin.instance.certFromPath(file.path),
      ),
    );
  }
}
