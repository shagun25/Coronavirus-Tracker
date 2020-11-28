import 'package:coronavirus_restapi_tracker_app/app/services/api.dart';
import 'package:coronavirus_restapi_tracker_app/app/services/endpoint_data.dart';
import 'package:flutter/foundation.dart';

class EndpointsData{
  // final int cases;
  // final int casesSuspected;
  // final int casesConfirmed;
  // final int deaths;
  // final int recovered;
  EndpointsData({@required this.values});
 final Map<Endpoint,EndpointData> values;
 EndpointData get cases => values[Endpoint.cases];
 EndpointData get casesSuspected => values[Endpoint.casesSuspected];
 EndpointData get casesConfirmed => values[Endpoint.casesConfirmed];
 EndpointData get deaths => values[Endpoint.deaths];
 EndpointData get recovered => values[Endpoint.recovered];
 @override toString() =>
      'cases: $cases, suspected: $casesSuspected, confirmed: $casesConfirmed, deaths: $deaths, recovered: $recovered';
}