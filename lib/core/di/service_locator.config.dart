// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:go_router/go_router.dart' as _i583;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/portfolio/data/datasources/portfolio_api_data_source.dart'
    as _i461;
import '../../features/portfolio/data/datasources/portfolio_cache_data_source.dart'
    as _i156;
import '../../features/portfolio/data/repositories/portfolio_repository_impl.dart'
    as _i452;
import '../../features/portfolio/domain/repositories/portfolio_repository.dart'
    as _i965;
import '../errors/app_error_handler.dart' as _i695;
import '../network/app_network_client.dart' as _i846;
import '../network/dio_local_api_network_client.dart' as _i914;
import '../network/local_mock_api_server.dart' as _i43;
import '../network/network_config.dart' as _i367;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i367.NetworkConfig>(() => registerModule.networkConfig());
    gh.lazySingleton<_i695.AppErrorHandler>(
      () => registerModule.appErrorHandler(),
    );
    gh.lazySingleton<_i583.GoRouter>(
      () => registerModule.goRouter(gh<_i695.AppErrorHandler>()),
    );
    gh.lazySingleton<_i156.PortfolioCacheDataSource>(
      () => _i156.SharedPrefsPortfolioCacheDataSource(),
    );
    await gh.factoryAsync<_i43.LocalMockApiServer>(
      () => registerModule.localMockApiServer(gh<_i367.NetworkConfig>()),
      preResolve: true,
    );
    gh.lazySingleton<_i361.Dio>(
      () => registerModule.dio(
        gh<_i43.LocalMockApiServer>(),
        gh<_i367.NetworkConfig>(),
      ),
    );
    gh.lazySingleton<_i846.AppNetworkClient>(
      () => _i914.DioLocalApiNetworkClient(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i461.PortfolioApiDataSource>(
      () => _i461.AssetPortfolioApiDataSource(gh<_i846.AppNetworkClient>()),
    );
    gh.lazySingleton<_i965.PortfolioRepository>(
      () => _i452.PortfolioRepositoryImpl(
        gh<_i461.PortfolioApiDataSource>(),
        gh<_i156.PortfolioCacheDataSource>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
