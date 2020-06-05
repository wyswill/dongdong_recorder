import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:flutterapp/canvasData.dart';
import 'package:provider/provider.dart';

class ChartPage extends StatefulWidget {
  ChartPage({this.key}) : super(key: key);
  final key;

  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  num get windowwidth => MediaQuery.of(context).size.width;

  @override
  Widget build(BuildContext context) {
    return Consumer<canvasData>(builder: (context, conter, child) {
      return Container(
        child: Echarts(
          option: '''
    {
      xAxis: {
        type:'time',
        show:false
      },
      yAxis: { 
        type:'time',
      },
      series: [{
        data: ${conter.data},
        type: 'bar',
      }]
    }
  ''',
//        extraScript: '''
//        chart.resize({
//         width: $windowwidth,
//         height: 220
//        });
//         ''',
        ),
        width: windowwidth,
        height: 400,
      );
    });
  }
}
