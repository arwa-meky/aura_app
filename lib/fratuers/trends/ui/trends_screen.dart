import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      backgroundColor: const Color(0xffF8F9FD),
      body: BlocBuilder<TrendsCubit, TrendsState>(
        builder: (context, state) {
          final cubit = context.read<TrendsCubit>();

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 25),

                  // 1. Selector (Daily, Weekly, Monthly, Yearly)
                  _buildTimeSelector(cubit),
                  const SizedBox(height: 25),

                  // 2. Metric Switcher (Heart Rate, Blood Oxygen, Steps)
                  _buildMetricSwitcher(cubit),
                  const SizedBox(height: 20),

                  // 3. Main Content (Loading, Empty, or Data)
                  _buildMainContent(state, cubit, Color(0xff194B96)),

                  const SizedBox(height: 15),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainContent(
    TrendsState state,
    TrendsCubit cubit,
    Color mainColor,
  ) {
    if (state is TrendsLoading) {
      return const SizedBox(
        height: 300,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (cubit.chartData.isEmpty) {
      return _buildEmptyState(
        image: 'assets/images/trends/folder.png',
        title: "No Data Available",
        subtitle:
            "No data available for this period. Start tracking to see your health trends.",
      );
    }

    if (cubit.chartData.length < 3) {
      return _buildEmptyState(
        image: 'assets/images/trends/watch.png',
        title: "Wear your watch regularly to see trends.",
        subtitle:
            "Not enough data yet. Wear your watch throughout the day to track your health trends.",
      );
    }

    return Column(
      children: [
        _buildChartCard(cubit, mainColor),
        const SizedBox(height: 25),
        _buildDataSummary(cubit, mainColor),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: const Text(
            "Health Trends",
            style: TextStyle(
              color: Color(0xff212121),
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Health Progress overview",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Color(0xff212121),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Track how your health changes over time.",
                  style: TextStyle(color: Color(0xff616161), fontSize: 10),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff194B96),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                minimumSize: const Size(0, 26),
                elevation: 0,
              ),
              child: const Text(
                "Export PDF",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmptyState({
    required String image,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60),
      width: double.infinity,
      child: Column(
        children: [
          Image.asset(image, scale: 1.6),
          const SizedBox(height: 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xff212121),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xff616161),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSelector(TrendsCubit cubit) {
    final times = ["Daily", "Weekly", "Monthly", "Yearly"];
    final map = {"Daily": "D", "Weekly": "W", "Monthly": "M", "Yearly": "Y"};

    return Container(
      height: 42,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: times.map((t) {
          String key = map[t]!;
          bool isSelected = cubit.selectedRange == key;
          return Expanded(
            child: GestureDetector(
              onTap: () => cubit.changeRange(key),
              child: Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xff194B96) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Color(0xffE0E0E0)),
                ),
                child: Center(
                  child: Text(
                    t,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : const Color(0xff212121),
                      fontWeight: FontWeight.w500,
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
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 18,
            color: Color(0xffACACAC),
            fontWeight: FontWeight.bold,
          ),
          onPressed: () => cubit.changeMetric(
            metrics[(currentIndex - 1 + metrics.length) % metrics.length],
          ),
        ),
        SizedBox(
          width: 150,
          child: Text(
            cubit.selectedMetric,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Color(0xff212121),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.arrow_forward_ios,
            size: 18,
            color: Color(0xffACACAC),
            fontWeight: FontWeight.bold,
          ),
          onPressed: () =>
              cubit.changeMetric(metrics[(currentIndex + 1) % metrics.length]),
        ),
      ],
    );
  }

  Widget _buildChartCard(TrendsCubit cubit, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xffE0E0E0)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(_getMetricIcon(cubit.selectedMetric), scale: 1.8),
              const SizedBox(width: 8),
              Text(
                "${cubit.selectedMetric} Trend",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Color(0xff194B96),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          SizedBox(height: 180, child: LineChart(_getChartData(cubit, color))),
        ],
      ),
    );
  }

  Widget _buildDataSummary(TrendsCubit cubit, Color color) {
    String unit = cubit.selectedMetric == "Steps"
        ? "steps"
        : (cubit.selectedMetric == "Blood Oxygen" ? "%" : "BPM");

    bool isDaily = cubit.selectedRange == "D";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isDaily)
          _buildDailyLayout(cubit, unit)
        else
          _buildExtendedLayout(cubit, unit),
      ],
    );
  }

  Widget _buildDailyLayout(TrendsCubit cubit, String unit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Data Summary",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xff212121),
          ),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(child: _buildSummaryBox("Today", "99", unit)),
            const SizedBox(width: 15),
            Expanded(child: _buildSummaryBox("Daily Average", "97", unit)),
          ],
        ),
        const SizedBox(height: 15),
        _buildInfoBox(cubit.selectedMetric),
      ],
    );
  }

  Widget _buildExtendedLayout(TrendsCubit cubit, String unit) {
    String period = cubit.selectedRange == "W"
        ? "this Week"
        : (cubit.selectedRange == "M" ? "this Month" : "this Year");

    return Column(
      children: [
        _buildStatLine("Average results $period:", "98 %"),
        SizedBox(height: 12),
        _buildStatLine("Highest rate recorded:", "99.5 %"),
        SizedBox(height: 12),

        _buildStatLine("Lowest rate recorded:", "96.5 %"),
      ],
    );
  }

  Widget _buildSummaryBox(String title, String value, String unit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xff616161),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xffEEEEEE),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xffE0E0E0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff212121),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    unit,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xff212121),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatLine(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xff616161),
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(width: 8),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Color(0xff194B96),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoBox(String metric) {
    return Row(
      children: [
        Expanded(
          child: Text(
            "Your ${metric.toLowerCase()} has been within normal limits today. Keep it up!",
            style: const TextStyle(
              color: Color(0xff194B96),
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  LineChartData _getChartData(TrendsCubit cubit, Color color) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (value) =>
            FlLine(color: Colors.grey.shade100, strokeWidth: 1),
      ),
      titlesData: FlTitlesData(
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (v, m) => Text(
              "${v.toInt()}",
              style: const TextStyle(color: Colors.grey, fontSize: 10),
            ),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              const labels = ['12 AM', '4 AM', '8 AM', '12 PM', '4 PM', '8 PM'];
              if (value.toInt() >= 0 && value.toInt() < labels.length) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    labels[value.toInt()],
                    style: const TextStyle(color: Colors.grey, fontSize: 9),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: cubit.chartData
              .asMap()
              .entries
              .map((e) => FlSpot(e.key.toDouble(), e.value.yValue))
              .toList(),
          isCurved: true,
          color: color,
          barWidth: 3,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [color.withOpacity(0.2), color.withOpacity(0.0)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    );
  }

  String _getMetricIcon(String metric) {
    if (metric == "Heart Rate") return 'assets/images/watch_icon/heart.png';
    if (metric == "Steps") return 'assets/images/home/steps_active.png';
    return 'assets/images/watch_icon/blood.png';
  }
}
