import 'dart:io';

import 'package:shelf/shelf_io.dart';

import 'revue_newsletter.dart';

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');

  // Defining a custom handler
  final server = await serve(RevueNewsletter().handler, ip, port);
  print('Server listening on port ${server.port}');
}
