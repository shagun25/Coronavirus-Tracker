import 'package:coronavirus_restapi_tracker_app/app/services/api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class EndpointCardData {
  EndpointCardData(this.title, this.assetName, this.color);
  final String title;
  final String assetName;
  final Color color;
}

class EndpointCard extends StatelessWidget {
  const EndpointCard({Key key, this.endpoint, this.value});
  final Endpoint endpoint;
  final int value;

  static Map<Endpoint, EndpointCardData> _cardsData = {
    Endpoint.cases:
        EndpointCardData('Cases', 'assets/count.png', Color(0xFFFFF492)),
    Endpoint.casesSuspected: EndpointCardData(
        'Suspected cases', 'assets/suspect.png', Color(0xFFEEDA28)),
    Endpoint.casesConfirmed: EndpointCardData(
        'Confirmed cases', 'assets/fever.png', Color(0xFFE99600)),
    Endpoint.deaths:
        EndpointCardData('Deaths', 'assets/death.png', Color(0xFFE40000)),
    Endpoint.recovered:
        EndpointCardData('Recovered', 'assets/patient.png', Color(0xFF70A901)),
  };

  String get formattedValue {
    if(value == null){
      return '';
    }
    return NumberFormat('#,###,###,###').format(value);
  }
  @override
  Widget build(BuildContext context) {
    final cardData = _cardsData[endpoint];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text(
              cardData.title,
              // ignore: deprecated_member_use
              style: Theme.of(context).textTheme.headline.copyWith(color:cardData.color),
            ),
            SizedBox(
              height:4.0,
            ),
            SizedBox(
              height:52.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    cardData.assetName,
                    color:cardData.color,
                    ),
                  Text(
                    formattedValue,
                    // ignore: deprecated_member_use
                    style: Theme.of(context).textTheme.display1.copyWith(color:cardData.color),
                  )
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
