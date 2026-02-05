import 'package:aura_project/core/helpers/storage/local_storage.dart';
import 'package:aura_project/core/networking/api_constants.dart';
import 'package:aura_project/core/networking/dio_factory.dart';
import 'package:aura_project/fratuers/trends/model/hive_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'trends_state.dart';

class ChartDataPoint {
  final String xLabel;
  final double yValue;
  ChartDataPoint(this.xLabel, this.yValue);
}

class TrendsCubit extends Cubit<TrendsState> {
  TrendsCubit() : super(TrendsInitial());

  String selectedMetric = 'Heart Rate';
  String selectedRange = 'D';

  List<ChartDataPoint> chartData = [];
  double average = 0;
  double min = 0;
  double max = 0;

  Future<void> loadData() async {
    emit(TrendsLoading());
    try {
      if (selectedRange == 'D') {
        await _getDailyFromApi();
      } else {
        await _getHistoryFromHive();
      }

      _calculateStats();
      emit(TrendsLoaded());
    } catch (e) {
      print("❌ Trends Error: $e");
      emit(TrendsError(e.toString()));
    }
  }

  Future<void> _getDailyFromApi() async {
    final response = await DioFactory.getData(
      path: ApiConstants.getHealthData,
      token: LocalStorage.token,
    );

    if (response.statusCode == 200) {
      List<dynamic> apiList = [];
      if (response.data is List) {
        apiList = response.data;
      } else if (response.data['data'] is List) {
        apiList = response.data['data'];
      }

      chartData = [];

      for (var item in apiList) {
        if (item['data'] == null) continue;
        var innerData = item['data'];
        double value = 0.0;

        if (selectedMetric == 'Heart Rate') {
          value = (innerData['heartRate'] ?? 0).toDouble();
        } else if (selectedMetric == 'Blood Oxygen') {
          value = (innerData['sp02'] ?? 0).toDouble();
        } else if (selectedMetric == 'Steps') {
          value = (innerData['steps'] ?? 0).toDouble();
        }

        String timeStr = item['timestamp'] ?? DateTime.now().toIso8601String();
        DateTime date = DateTime.parse(timeStr).toLocal();
        String label = DateFormat('HH:mm').format(date);

        if (value > 0) chartData.add(ChartDataPoint(label, value));
      }

      chartData.sort((a, b) => a.xLabel.compareTo(b.xLabel));

      if (chartData.isNotEmpty) {
        double avg =
            chartData.fold(0.0, (p, e) => p + e.yValue) / chartData.length;
        String todayDate = DateTime.now().toIso8601String().substring(0, 10);
        await HiveHelper.saveDailyAverage(todayDate, selectedMetric, avg);
      }
    }
  }

  Future<void> _getHistoryFromHive() async {
    int days = 7;

    if (selectedRange == 'W') {
      days = 7;
    } else if (selectedRange == 'M') {
      days = 30;
    } else if (selectedRange == 'Y') {
      days = 365;
    }

    final historyItems = HiveHelper.getHistory(selectedMetric, days);

    historyItems.sort((a, b) => a.date.compareTo(b.date));

    chartData = historyItems.map((e) {
      DateTime date = DateTime.parse(e.date);
      String label;

      if (selectedRange == 'Y') {
        label = DateFormat('MMM').format(date);
      } else if (selectedRange == 'M') {
        label = DateFormat('d').format(date);
      } else {
        label = DateFormat('E').format(date);
      }

      return ChartDataPoint(label, e.value);
    }).toList();
  }

  void _calculateStats() {
    if (chartData.isNotEmpty) {
      double sum = chartData.fold(0, (p, e) => p + e.yValue);
      average = sum / chartData.length;
      max = chartData.map((e) => e.yValue).reduce((a, b) => a > b ? a : b);
      min = chartData.map((e) => e.yValue).reduce((a, b) => a < b ? a : b);
    } else {
      average = 0;
      max = 0;
      min = 0;
    }
  }

  void changeMetric(String metric) {
    selectedMetric = metric;
    loadData();
  }

  void changeRange(String range) {
    selectedRange = range;
    loadData();
  }
}
