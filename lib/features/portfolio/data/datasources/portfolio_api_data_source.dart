import 'package:injectable/injectable.dart';
import 'package:portfolio_tracker/core/network/app_network_client.dart';
import 'package:portfolio_tracker/features/portfolio/data/models/portfolio_snapshot_dto.dart';

/// Low-level contract responsible for talking to the portfolio API endpoint.
///
/// This layer still belongs to the feature, but it is closer to transport than
/// the repository. It knows *which* endpoint to call, while the network client
/// knows *how* to perform the HTTP request.
abstract class PortfolioApiDataSource {
  Future<PortfolioSnapshotDto> fetchPortfolio();
}

@LazySingleton(as: PortfolioApiDataSource)
class AssetPortfolioApiDataSource implements PortfolioApiDataSource {
  AssetPortfolioApiDataSource(this._networkClient);

  final AppNetworkClient _networkClient;

  @override
  Future<PortfolioSnapshotDto> fetchPortfolio() {
    // Ask the shared network client for a typed portfolio DTO.
    //
    // Important:
    // - this file chooses the endpoint (`/portfolio`)
    // - the network client handles transport details
    // - the decoder turns raw response data into a DTO before it comes back
    return _networkClient.send(
      NetworkRequest<PortfolioSnapshotDto, Never>(
        path: '/portfolio',
        type: NetworkRequestType.get,
        decoder: PortfolioSnapshotDto.fromResponse,
      ),
    );
  }
}
