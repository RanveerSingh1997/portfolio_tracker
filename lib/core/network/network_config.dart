class NetworkConfig {
  const NetworkConfig({
    this.connectTimeout = const Duration(seconds: 5),
    this.receiveTimeout = const Duration(seconds: 5),
    this.serverStartTimeout = const Duration(seconds: 5),
    this.serverStartRetryCount = 3,
  });

  final Duration connectTimeout;
  final Duration receiveTimeout;
  final Duration serverStartTimeout;
  final int serverStartRetryCount;
}
