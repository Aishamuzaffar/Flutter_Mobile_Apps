import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class HealthInsightsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Sample data for blood sugar
    final List<TimeSeriesHealth> bloodSugarData = [
      TimeSeriesHealth(DateTime(2024, 10, 1), 120),
      TimeSeriesHealth(DateTime(2024, 10, 2), 110),
      TimeSeriesHealth(DateTime(2024, 10, 3), 150),
      TimeSeriesHealth(DateTime(2024, 10, 4), 130),
    ];

    // Sample data for blood pressure
    final List<TimeSeriesHealth> bloodPressureData = [
      TimeSeriesHealth(DateTime(2024, 10, 1), 130),
      TimeSeriesHealth(DateTime(2024, 10, 2), 135),
      TimeSeriesHealth(DateTime(2024, 10, 3), 140),
      TimeSeriesHealth(DateTime(2024, 10, 4), 120),
    ];

    // Sample data for heart rate
    final List<TimeSeriesHealth> heartRateData = [
      TimeSeriesHealth(DateTime(2024, 10, 1), 72),
      TimeSeriesHealth(DateTime(2024, 10, 2), 75),
      TimeSeriesHealth(DateTime(2024, 10, 3), 70),
      TimeSeriesHealth(DateTime(2024, 10, 4), 68),
    ];

    // Sample data for oxygen level
    final List<TimeSeriesHealth> oxygenLevelData = [
      TimeSeriesHealth(DateTime(2024, 10, 1), 98),
      TimeSeriesHealth(DateTime(2024, 10, 2), 97),
      TimeSeriesHealth(DateTime(2024, 10, 3), 96),
      TimeSeriesHealth(DateTime(2024, 10, 4), 95),
    ];

    // Convert the data to charts format
    List<charts.Series<TimeSeriesHealth, DateTime>> seriesList = [
      charts.Series<TimeSeriesHealth, DateTime>(
        id: 'Blood Sugar',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (TimeSeriesHealth data, _) => data.time,
        measureFn: (TimeSeriesHealth data, _) => data.value,
        data: bloodSugarData,
      ),
      charts.Series<TimeSeriesHealth, DateTime>(
        id: 'Blood Pressure',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesHealth data, _) => data.time,
        measureFn: (TimeSeriesHealth data, _) => data.value,
        data: bloodPressureData,
      ),
      charts.Series<TimeSeriesHealth, DateTime>(
        id: 'Heart Rate',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (TimeSeriesHealth data, _) => data.time,
        measureFn: (TimeSeriesHealth data, _) => data.value,
        data: heartRateData,
      ),
      charts.Series<TimeSeriesHealth, DateTime>(
        id: 'Oxygen Level',
        colorFn: (_, __) => charts.MaterialPalette.purple.shadeDefault,
        domainFn: (TimeSeriesHealth data, _) => data.time,
        measureFn: (TimeSeriesHealth data, _) => data.value,
        data: oxygenLevelData,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Health Insights"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Health Metrics Over Time",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: charts.TimeSeriesChart(
                seriesList,
                animate: true,
                dateTimeFactory: const charts.LocalDateTimeFactory(),
                behaviors: [
                  // Add the legend to indicate which line represents what
                  charts.SeriesLegend(
                    position: charts.BehaviorPosition.top,
                    outsideJustification:
                        charts.OutsideJustification.endDrawArea,
                    horizontalFirst: false,
                    desiredMaxColumns: 1,
                    cellPadding: EdgeInsets.only(right: 4.0, bottom: 4.0),
                    entryTextStyle: charts.TextStyleSpec(
                      color: charts.MaterialPalette.black,
                      fontSize: 12,
                    ),
                  ),
                  // Add chart title and axis labels
                  charts.ChartTitle(
                    'Date',
                    behaviorPosition: charts.BehaviorPosition.bottom,
                    titleOutsideJustification:
                        charts.OutsideJustification.middleDrawArea,
                  ),
                  charts.ChartTitle(
                    'Measurement',
                    behaviorPosition: charts.BehaviorPosition.start,
                    titleOutsideJustification:
                        charts.OutsideJustification.middleDrawArea,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Data model for the chart
class TimeSeriesHealth {
  final DateTime time;
  final int value;

  TimeSeriesHealth(this.time, this.value);
}
