import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wellwait_app/admin/widget/app_bar.dart';
import 'package:wellwait_app/utils/colors.dart';

import '../../models/revenue_analysis.dart';
import '../admin_phone_number_login/admin_auth_viewmodel.dart';
import '../utils/admin_ common_variable.dart';
import 'total_panel_payment_viewmodel.dart';

class TotalPanelPaymentPage extends StatefulWidget {
  const TotalPanelPaymentPage({super.key});

  @override
  State<TotalPanelPaymentPage> createState() => _TotalPanelPaymentPageState();
}

class _TotalPanelPaymentPageState extends State<TotalPanelPaymentPage> {
  late AnalysisViewModel _viewModel;
  late AdminAuthViewModel _authViewModel;
  final List<String> filters = ["1W", "1M", "6M", "1Y", "MAX"];
  final List<Color> colors = [
    Color(0xffA89C30),
    Color(0xffBF2424),
    Color(0xffBF2424),
    Color(0xffBF2424),
    Color(0xffBF2424),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _viewModel.fetchRevenuesAnalysis();
    });
  }
  @override
  Widget build(BuildContext context) {
    _viewModel = context.watch<AnalysisViewModel>();
    _authViewModel = context.watch<AdminAuthViewModel>();
    return Scaffold(
      backgroundColor: const Color(0xffECECEC),
      appBar: CustomAppBar(showHomeButton: false),
      body: Column(
        children: [
          Text(
            _authViewModel.serviceProvider.salonName.toString(),
            style: TextStyle(fontSize: 12, color: Colors.grey,fontWeight: FontWeight.w600),
          ),
          Text(
            "Analysis",
            style: TextStyle(
                fontSize: 22,
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
            child: _buildFilterRow(),
          ),
          getPage(_viewModel.selectedIndex),

        ],
      ),
    );
  }

  Widget _buildFilterRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: List.generate(filters.length, (index) {
        return _buildSegment(filters[index], colors[index], index + 1);
      }),
    );
  }

  Widget _buildSegment(String text, Color dotColor, int index) {
    return GestureDetector(
      onTap: () {
        _viewModel.updateSelectedIndex(index);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.horizontal(
            left: index == filters.length - 4 ? Radius.circular(18) : Radius.zero,
            right: index == filters.length - 0 ? Radius.circular(18) : Radius.zero,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            text,
            style: TextStyle(
              fontWeight: _viewModel.selectedIndex == index ? FontWeight.w700 : FontWeight.w600,
              fontSize: 12,
              color: _viewModel.selectedIndex == index ? AppColors.primaryColor : const Color(0xff9EA1AE),
            ),
          ),
        ),
      ),
    );
  }

  Widget getPage(int index) {
    switch (index) {
      case 0:
        return  panelPrice();
      case 1:
        return panelPrice();
      case 2:
        return  panelPrice();
      case 3:
        return  panelPrice();
      case 4:
        return  panelPrice();
      case 5:
        return  panelPrice();
      default:
        return const Center(
            child: Text("Unknown Page", style: TextStyle(fontSize: 18)));
    }
  }

  Widget panelPrice() {
    if (_viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    // Ensure revenueAnalysisData is not null before accessing its properties
    if (_viewModel.revenueAnalysisData == null || _viewModel.revenueAnalysisData!.panels == null) {
      return const Center(child: Text("No data available", style: TextStyle(fontSize: 18)));
    }
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Total Revenue Card
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                elevation: 1.5,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "₹ ${_viewModel.totalEarnings ?? 0}", // Ensure totalEarnings is not null
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "Today's total",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.primaryColor),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 6),
              // Panels List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: (_viewModel.revenueAnalysisData!.panels!.length / 2).ceil(),
                itemBuilder: (context, index) {
                  int firstIndex = index * 2;
                  int secondIndex = firstIndex + 1;
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(child: panelList(_viewModel.revenueAnalysisData!.panels![firstIndex])),
                          const SizedBox(width: 6),
                          if (secondIndex < _viewModel.revenueAnalysisData!.panels!.length)
                            Flexible(child: panelList(_viewModel.revenueAnalysisData!.panels![secondIndex]))
                          else
                            const Spacer(),
                        ],
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
              // Ensure graphData is not null
              graphSection(_viewModel.revenueAnalysisData!.graphData ?? []),
            ],
          ),
        ),
      ),
    );
  }


  Widget panelList(RevenuePanel revenuePanel) {
    return Container(
      width: double.infinity,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 1.5,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                revenuePanel.panelName ?? "",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.primaryColor),
              ),
              Text(
                "₹ ${revenuePanel.earning ?? 0}",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget graphSection(List<GraphDatum> graphData) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 20),
      child: Container(
        height: 180,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Text(
                "Revenue Analysis",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            _formatNumber(value.toDouble()),
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w300),
                          );
                        },
                        reservedSize: 40,
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() < graphData.length) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 12, top: 10),
                              child: Text(
                                graphData[value.toInt()].label ?? "",
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w300),
                              ),
                            );
                          }
                          return Container();
                        },
                        reservedSize: 30,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: graphData.asMap().entries.map((entry) {
                        return FlSpot(entry.key.toDouble(), (entry.value.revenue ?? 0).toDouble());
                      }).toList(),
                      isCurved: false,
                      curveSmoothness: 0.5,
                      color: Colors.cyan,
                      barWidth: 3.0,
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [Colors.cyan.withOpacity(0.3), Colors.transparent],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      dotData: FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatNumber(double value) {
    if (value >= 1000) {
      return "${(value / 1000).toStringAsFixed(1)}k";
    }
    return value.toInt().toString();
  }

}
