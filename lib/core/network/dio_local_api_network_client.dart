import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:portfolio_tracker/core/network/app_network_client.dart';
import 'package:portfolio_tracker/core/errors/app_error.dart';

@LazySingleton(as: AppNetworkClient)
class DioLocalApiNetworkClient implements AppNetworkClient {
  DioLocalApiNetworkClient(this._dio);

  final Dio _dio;

  @override
  Future<TResponse> send<TResponse, TBody>(
    NetworkRequest<TResponse, TBody> request,
  ) async {
    try {
      final response = await _dio.request<Object?>(
        request.path,
        data: request.encodeBody(),
        queryParameters: request.queryParameters,
        options: Options(
          method: _mapRequestType(request.type),
          headers: request.headers,
        ),
      );

      return request.decoder(response.data);
    } on DioException catch (error) {
      throw _mapDioException(error);
    } on FormatException catch (error) {
      throw AppError(type: AppErrorType.parseError, details: error.message);
    } on ArgumentError catch (error) {
      throw AppError(
        type: AppErrorType.parseError,
        details: error.message?.toString(),
      );
    }
  }

  String _mapRequestType(NetworkRequestType type) {
    return switch (type) {
      NetworkRequestType.get => 'GET',
      NetworkRequestType.post => 'POST',
      NetworkRequestType.put => 'PUT',
      NetworkRequestType.patch => 'PATCH',
      NetworkRequestType.delete => 'DELETE',
    };
  }

  AppError _mapDioException(DioException error) {
    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout => AppError(
        type: AppErrorType.networkTimeout,
        details: 'Request to ${error.requestOptions.path} timed out.',
      ),
      DioExceptionType.connectionError => AppError(
        type: AppErrorType.networkConnection,
        details: 'Unable to reach ${error.requestOptions.path}.',
      ),
      DioExceptionType.badResponse => AppError(
        type: AppErrorType.httpError,
        details:
            _responseMessage(error) ??
            'Request failed for ${error.requestOptions.path}.',
        statusCode: error.response?.statusCode,
      ),
      DioExceptionType.cancel => AppError(
        type: AppErrorType.unknown,
        details: 'Request for ${error.requestOptions.path} was cancelled.',
      ),
      DioExceptionType.badCertificate || DioExceptionType.unknown => AppError(
        type: AppErrorType.unknown,
        details: error.message ?? 'Unexpected network failure.',
      ),
    };
  }

  String? _responseMessage(DioException error) {
    final data = error.response?.data;
    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String && message.isNotEmpty) {
        return message;
      }
    }

    return error.message;
  }
}
