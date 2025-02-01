import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../services/barber_service.dart';
import '../colors.dart';
import '../../models/stats.dart';

class Statistics extends StatefulWidget {
  const Statistics({super.key});

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  final BarberService _barberService = BarberService();
  final List<Color> _serviceColors = [
    const Color(0xFF4CAF9A),
    const Color(0xFF5C89A6),
    const Color(0xFFEB8467),
    const Color(0xFFF0CE81),
    const Color(0xFFA678E8)
  ];

  Future<List<dynamic>> _loadStatistics() async {
    return Future.wait([
      _barberService.getServiceStats(),
      _barberService.getCustomerStats(),
    ]);
  }

  List<PieChartSectionData> _buildPieSections(List<ServiceStat> stats) {
    return stats.asMap().entries.map((entry) {
      final int index = entry.key;
      final ServiceStat stat = entry.value;
      return PieChartSectionData(
        color: _serviceColors[index % _serviceColors.length],
        value: stat.percentage,
        title: '${stat.percentage.toStringAsFixed(1)}%',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  List<Widget> _buildLegend(List<ServiceStat> stats) {
    return stats.asMap().entries.map((entry) {
      final int index = entry.key;
      final ServiceStat stat = entry.value;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              width: 16,
              height: 16,
              color: _serviceColors[index % _serviceColors.length],
            ),
            const SizedBox(width: 8),
            Text(
              stat.serviceName,
              style: const TextStyle(color: Colors.white),
            ),
            const Spacer(),
            Text(
              '${stat.appointmentCount}',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Статистика',
          style: TextStyle(color: textPrimary),
        ),
        centerTitle: false,
        backgroundColor: background,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      backgroundColor: background,
      body: FutureBuilder<List<dynamic>>(
        future: _loadStatistics(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: orange));
          }

          if (snapshot.hasError) {
            return Center(child: Text('Грешка: ${snapshot.error}'));
          }

          final serviceStats = snapshot.data![0] as List<ServiceStat>;
          final customerStats = snapshot.data![1] as CustomerStats;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildCustomerCard(
                        title: 'Клиенти',
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildStatItem('Вкупно:',
                                customerStats.totalCustomersCount.toString()),
                            _buildStatItem('Нови:',
                                customerStats.newCustomersCount.toString()),
                            _buildStatItem(
                                'Постојани:',
                                customerStats.returningCustomersCount
                                    .toString()),
                          ],
                        ),
                        color: navy,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildReturnRateCard(customerStats),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildServiceStatsCard(serviceStats),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCustomerCard(
      {required String title, required Widget content, required Color color}) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReturnRateCard(CustomerStats stats) {
    return Card(
      color: navy,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Стапка на враќање',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    value: stats.returnRate / 100,
                    backgroundColor: background,
                    valueColor: const AlwaysStoppedAnimation<Color>(orange),
                    strokeWidth: 8,
                  ),
                ),
                Text(
                  '${stats.returnRate.toStringAsFixed(1)}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceStatsCard(List<ServiceStat> stats) {
    return Card(
      color: navy,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Популарни Услуги',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: _buildPieSections(stats),
                  centerSpaceRadius: 40,
                  sectionsSpace: 4,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ..._buildLegend(stats),
          ],
        ),
      ),
    );
  }
}
