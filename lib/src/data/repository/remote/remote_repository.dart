


import '../../../../services/api_service/api_response.dart';

abstract class RemoteRepository{

  Future<ApiResponse> init();
}