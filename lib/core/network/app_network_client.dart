enum NetworkRequestType { get, post, put, patch, delete }

/// Converts a feature-level request body into a transport payload.
typedef NetworkRequestEncoder<TBody> = Object? Function(TBody body);

/// Converts raw transport data into a typed result returned from `send()`.
typedef NetworkResponseDecoder<TResponse> = TResponse Function(Object? data);

/// Describes one API call without leaking Dio or JSON concerns into features.
///
/// The request owns both ends of the transport contract:
/// - [encoder] turns a typed body into a payload Dio can send.
/// - [decoder] turns the raw response into the typed value the caller wants.
///
/// Example:
///
/// ```dart
/// NetworkRequest<PortfolioSnapshotDto, Never>(
///   path: '/portfolio',
///   type: NetworkRequestType.get,
///   decoder: PortfolioSnapshotDto.fromResponse,
/// )
/// ```
class NetworkRequest<TResponse, TBody> {
  const NetworkRequest({
    required this.path,
    required this.type,
    required this.decoder,
    this.body,
    this.encoder,
    this.queryParameters,
    this.headers,
  });

  final String path;
  final NetworkRequestType type;
  final TBody? body;
  final NetworkRequestEncoder<TBody>? encoder;
  final NetworkResponseDecoder<TResponse> decoder;
  final Map<String, dynamic>? queryParameters;
  final Map<String, dynamic>? headers;

  Object? encodeBody() {
    final body = this.body;
    if (body == null) {
      return null;
    }

    final encoder = this.encoder;
    if (encoder != null) {
      return encoder(body);
    }

    return body;
  }
}

/// Shared network client contract for the app.
///
/// Features depend on this interface instead of Dio directly, so transport
/// encoding and decoding stay centralized inside the client implementation.
abstract class AppNetworkClient {
  /// Sends a typed request and returns the decoded response value.
  Future<TResponse> send<TResponse, TBody>(
    NetworkRequest<TResponse, TBody> request,
  );
}
