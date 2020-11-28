import 'package:coronavirus_restapi_tracker_app/app/repositories/endpoints_data.dart';
import 'package:coronavirus_restapi_tracker_app/app/services/api.dart';
import 'package:coronavirus_restapi_tracker_app/app/services/api_service.dart';
import 'package:coronavirus_restapi_tracker_app/app/services/data_cache_services.dart';
import 'package:coronavirus_restapi_tracker_app/app/services/endpoint_data.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class DataRepository{
    DataRepository({@required this.apiService,@required this.dataCacheService});
    final APIService apiService;
    final DataCacheService dataCacheService;
    String _accessToken;

    Future<EndpointData> getEndpointData(Endpoint endpoint) async => 
    await _getDataRefreshingToken<EndpointData>(
      onGetData: () => apiService.getEndpointData(
        accessToken: _accessToken, endpoint:endpoint),
    );
   
    // ignore: non_constant_identifier_names
    EndpointsData getAllEndpointDataCacheData() => dataCacheService.getData();

    Future<EndpointsData> getAllEndpointsData() async {
    final endpointData = await _getDataRefreshingToken<EndpointsData>(
      onGetData: () => _getAllEndpointsData(),
    );

    await dataCacheService.setData(endpointData);
    return endpointData;
    }
    Future<T> _getDataRefreshingToken<T>({Future<T> Function() onGetData}) async{
      try{
      if(_accessToken == null){
      _accessToken = await apiService.getAccessToken();
      }
      return await onGetData();
      } on Response catch (response){
        if(response.statusCode == 401){
      _accessToken = await apiService.getAccessToken();
       return await onGetData();
      }
      rethrow;
      }
    }
    Future<EndpointsData> _getAllEndpointsData() async{
      // final cases = await apiService.getEndpointData(
      //   accessToken: _accessToken, endpoint: Endpoint.cases);
      // final casesSuspected = await apiService.getEndpointData(
      //   accessToken: _accessToken, endpoint: Endpoint.casesSuspected);
      // final casesConfirmed = await apiService.getEndpointData(
      //   accessToken: _accessToken, endpoint: Endpoint.casesConfirmed);
      // final deaths = await apiService.getEndpointData(
      //   accessToken: _accessToken, endpoint: Endpoint.deaths);   
      // final recovered = await apiService.getEndpointData(
      //   accessToken: _accessToken, endpoint: Endpoint.recovered);
      final values = await Future.wait([
        apiService.getEndpointData(
        accessToken: _accessToken, endpoint: Endpoint.cases),
     apiService.getEndpointData(
        accessToken: _accessToken, endpoint: Endpoint.casesSuspected),
      apiService.getEndpointData(
        accessToken: _accessToken, endpoint: Endpoint.casesConfirmed),
      apiService.getEndpointData(
        accessToken: _accessToken, endpoint: Endpoint.deaths),
      apiService.getEndpointData(
        accessToken: _accessToken, endpoint: Endpoint.recovered),
      ]);
      return EndpointsData(
        values: {
         Endpoint.cases: values[0],
         Endpoint.casesSuspected: values[1],
         Endpoint.casesConfirmed: values[2],
         Endpoint.deaths: values[3],
         Endpoint.recovered: values[4],
        }
      );
    }
}