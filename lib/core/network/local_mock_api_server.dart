import 'dart:convert';
import 'dart:io';

import 'package:portfolio_tracker/core/network/local_mock_api_payloads.dart';

/// Lightweight localhost mock API used by the MVP runtime.
///
/// It lets Dio exercise a real HTTP path without requiring an external backend.
/// Add new endpoints here when a feature needs to simulate request-aware API
/// behavior beyond static in-memory data.
class LocalMockApiServer {
  HttpServer? _server;

  /// Base URL exposed to Dio after [start] completes.
  String get baseUrl {
    final server = _server;
    if (server == null) {
      throw StateError('Local mock API server has not started.');
    }

    return 'http://${server.address.host}:${server.port}';
  }

  /// Starts the server on an ephemeral loopback port.
  Future<void> start() async {
    if (_server != null) {
      return;
    }

    _server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    _server!.listen(_handleRequest);
  }

  /// Stops the server so tests or app resets can release the bound port.
  Future<void> close() async {
    await _server?.close(force: true);
    _server = null;
  }

  Future<void> _handleRequest(HttpRequest request) async {
    request.response.headers.contentType = ContentType.json;

    if (request.method == 'GET' && request.uri.path == '/portfolio') {
      request.response.statusCode = HttpStatus.ok;
      request.response.write(jsonEncode(portfolioSnapshotPayload));
    } else {
      request.response.statusCode = HttpStatus.notFound;
      request.response.write(
        jsonEncode({'message': 'Route not found', 'path': request.uri.path}),
      );
    }

    await request.response.close();
  }
}
