import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:aura_project/fratuers/trends/logic/trends_cubit.dart';
import 'package:aura_project/fratuers/trends/logic/trends_state.dart';

class TrendsScreen extends StatefulWidget {
  const TrendsScreen({super.key});

  @override
  State<TrendsScreen> createState() => _TrendsScreenState();
}

class _TrendsScreenState extends State<TrendsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TrendsCubit>().loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        title: const Text(
          "Health Trends",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: BlocBuilder<TrendsCubit, TrendsState>(
        builder: (context, state) {
          final cubit = context.read<TrendsCubit>();
          Color mainColor = _getMetricColor(cubit.selectedMetric);

          return RefreshIndicator(
            onRefresh: () async => await cubit.loadData(),
            color: mainColor,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Health Progress overview",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    DateFormat('EEEE, MMMM d, y').format(DateTime.now()),
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),

                  const SizedBox(height: 25),

                  _buildTimeSelector(cubit),

                  const SizedBox(height: 25),

                  _buildMetricSwitcher(cubit),

                  const SizedBox(height: 25),

                  state is TrendsLoading
                      ? SizedBox(
                          height: 250,
                          child: Center(
                            child: CircularProgressIndicator(color: mainColor),
                          ),
                        )
                      : _buildChartCard(cubit, mainColor),

                  const SizedBox(height: 30),

                  // 5. Data Summary
                  _buildDataSummary(cubit, mainColor),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeSelector(TrendsCubit cubit) {
    final times = ["Daily", "Weekly", "Monthly", "Yearly"];
    final map = {"Daily": "D", "Weekly": "W", "Monthly": "M", "Yearly": "Y"};

    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: const Color(0xffF2F4F8),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: times.map((t) {
          String key = map[t]!;
          bool isSelected = cubit.selectedRange == key;

          return Expanded(
            child: GestureDetector(
              onTap: () => cubit.changeRange(key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xff1A56DB)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xff1A56DB).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: Text(
                    t,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMetricSwitcher(TrendsCubit cubit) {
    List<String> metrics = ["Heart Rate", "Blood Oxygen", "Steps"];
    int currentIndex = metrics.indexOf(cubit.selectedMetric);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            size: 18,
            color: Colors.grey.shade400,
          ),
          onPressed: () {
            int newIndex = (currentIndex - 1 + metrics.length) % metrics.length;
            cubit.changeMetric(metrics[newIndex]);
          },
        ),
        SizedBox(
          width: 160,
          child: Text(
            cubit.selectedMetric,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.arrow_forward_ios_rounded,
            size: 18,
            color: Colors.grey.shade400,
          ),
          onPressed: () {
            int newIndex = (currentIndex + 1) % metrics.length;
            cubit.changeMetric(metrics[newIndex]);
          },
        ),
      ],
    );
  }

  Widget _buildChartCard(TrendsCubit cubit, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    _getMetricIcon(cubit.selectedMetric),
                    color: color,
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "${cubit.selectedMetric} Trend",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xff1A56DB),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Export PDF",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          SizedBox(
            height: 220,
            child: cubit.chartData.isEmpty
                ? Center(
                    child: Text(
                      "No Data Available",
                      style: TextStyle(color: Colors.grey.shade400),
                    ),
                  )
                : LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 25,
                        getDrawingHorizontalLine: (value) =>
                            FlLine(color: Colors.grey.shade100, strokeWidth: 1),
                      ),
                      titlesData: FlTitlesData(
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            getTitlesWidget: (value, meta) {
                              int idx = value.toInt();
                              if (idx >= 0 && idx < cubit.chartData.length) {
                                if (cubit.chartData.length > 10 && idx % 3 != 0)
                                  return const SizedBox();

                                return Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Text(
                                    cubit.chartData[idx].xLabel,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.shade500,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox();
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 35,
                            interval: 25,
                            getTitlesWidget: (value, meta) => Text(
                              value.toInt().toString(),
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      minY: 0,
                      lineBarsData: [
                        LineChartBarData(
                          spots: List.generate(
                            cubit.chartData.length,
                            (i) =>
                                FlSpot(i.toDouble(), cubit.chartData[i].yValue),
                          ),
                          isCurved: true,
                          curveSmoothness: 0.35,
                          color: color,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              colors: [
                                color.withOpacity(0.2),
                                color.withOpacity(0.0),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ],
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          tooltipBgColor: Colors.black87,
                          getTooltipItems: (touchedSpots) {
                            return touchedSpots.map((spot) {
                              return LineTooltipItem(
                                "${spot.y.toInt()}",
                                const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }).toList();
                          },
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataSummary(TrendsCubit cubit, Color color) {
    String unit = cubit.selectedMetric == "Steps"
        ? "steps"
        : (cubit.selectedMetric == "Blood Oxygen" ? "%" : "BPM");
    String todayValue = cubit.chartData.isNotEmpty
        ? cubit.chartData.last.yValue.toInt().toString()
        : "--";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Data Summary",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 15),

        Row(
          children: [
            Expanded(
              child: _buildSummaryBox(
                "Today",
                todayValue,
                unit,
                const Color(0xffFFF4F4),
                color,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildSummaryBox(
                "Daily Average",
                cubit.average.toStringAsFixed(0),
                unit,
                const Color(0xffF4F8FF),
                const Color(0xff1A56DB),
              ),
            ),
          ],
        ),

        const SizedBox(height: 25),

        _buildStatRow(
          "Highest rate recorded:",
          "${cubit.max.toInt()} $unit",
          color,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Divider(height: 1),
        ),
        _buildStatRow(
          "Lowest rate recorded:",
          "${cubit.min.toInt()} $unit",
          Colors.teal,
        ),

        const SizedBox(height: 25),

        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: const Color(0xffEBF2FF),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.info_outline,
                color: Color(0xff1A56DB),
                size: 22,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Your ${cubit.selectedMetric.toLowerCase()} is stable. Keep monitoring for better insights.",
                  style: const TextStyle(
                    color: Color(0xff1A56DB),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryBox(
    String title,
    String value,
    String unit,
    Color bgColor,
    Color textColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          Text(
            unit,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  Color _getMetricColor(String metric) {
    if (metric == "Heart Rate") return const Color(0xFFFF4B4B);
    if (metric == "Steps") return const Color(0xFF4CAF50);
    return const Color(0xFF1A56DB);
  }

  IconData _getMetricIcon(String metric) {
    if (metric == "Heart Rate") return Icons.favorite_rounded;
    if (metric == "Steps") return Icons.directions_walk_rounded;
    return Icons.water_drop_rounded;
  }
}
