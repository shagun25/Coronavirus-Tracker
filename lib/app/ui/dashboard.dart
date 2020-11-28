import 'dart:io';

import 'package:coronavirus_restapi_tracker_app/app/repositories/data_repositories.dart';
import 'package:coronavirus_restapi_tracker_app/app/repositories/endpoints_data.dart';
import 'package:coronavirus_restapi_tracker_app/app/services/api.dart';
import 'package:coronavirus_restapi_tracker_app/app/ui/endpoint_card.dart';
import 'package:coronavirus_restapi_tracker_app/app/ui/last_updated_status_text.dart';
import 'package:coronavirus_restapi_tracker_app/app/ui/show_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({ Key key }) : super(key: key);
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  EndpointsData _endpointsData;
  @override
  void initState(){
    super.initState();
    final dataRepository = Provider.of<DataRepository>(context,listen: false);
    _endpointsData = dataRepository.getAllEndpointDataCacheData();
    _updateData();
  }
  Future<void> _updateData() async{
    try{
    final dataRepository = Provider.of<DataRepository>(context, listen: false);
    final endpointsData = await dataRepository.getAllEndpointsData();
    setState(() {
      _endpointsData = endpointsData;
    });
    } on SocketException catch (_) {
      showAlertDialog(
        context: context,
        title: 'Connection Error',
        content: 'Could not retrieve data. Please try again later.',
        defaultActionText: 'OK',
      );
    }catch(_){
       showAlertDialog(
        context: context,
        title: 'unlnown Error',
        content: 'Please contact support or try again later.',
        defaultActionText: 'OK',
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    final formatter = LastUpdatedDateFormatter(
      lastUpdated: _endpointsData != null
      ?_endpointsData.values[Endpoint.cases]?.date:null,);
    return Scaffold(appBar: AppBar(
        title: Text('Coronavirus Tracker'),
        centerTitle: true,
      ),
      body:RefreshIndicator(
        onRefresh: _updateData,
        child: ListView(
    children: [
      LastUpdatedStatusText(
        text: formatter.lastUpdatedStatusText(),
      ),
      for(var endpoint in Endpoint.values)
      EndpointCard(
        endpoint: endpoint,
      value: _endpointsData != null?_endpointsData.values[endpoint]?.value:null,
      ),
    ],
        ),
      ),
      );
  }
}