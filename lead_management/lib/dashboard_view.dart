import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lead_management/common_ui/text_styles.dart';
import 'package:lead_management/followups.dart';
import 'package:lead_management/new_leads.dart';
import 'package:lead_management/notifications.dart';
import 'package:lead_management/profile.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final String userName = "User";
  int _selectedIndex = 0;
  bool? _selectedBool = true;

  @override
  void initState() {
    super.initState();
  }

  Widget dashBoard() {
    return Scaffold(
      body: Container(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],

            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              left: 8,
              right: 8,
              bottom: 0,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 60,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Text("New Leads", style: TextStyles.heading2),
                        Switch(
                          trackColor: MaterialStateProperty.all(Colors.green),
                          value: _selectedBool ?? false,
                          onChanged: (bool value) {
                            setState(() {
                              _selectedBool = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    child: _selectedBool == true
                        ? Container(
                            key: const ValueKey('expanded'),
                            padding: const EdgeInsets.only(
                              top: 16.0,
                              left: 16,
                              right: 16,
                              bottom: 4,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25.0),
                                topRight: Radius.circular(25.0),
                              ),
                              color: Colors.white,
                            ),
                            child: PerformanceDashboard(),
                          )
                        : const SizedBox.shrink(key: ValueKey('collapsed')),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> get _widgetOptions => <Widget>[
    dashBoard(),
    const LeadsPage(),
    const FollowUpScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Hi $userName"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => NotificationsPage()),
              );
            },
            icon: const Icon(Icons.notifications),
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,

        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontSize: 12, color: Colors.black),
        unselectedLabelStyle: const TextStyle(fontSize: 12),

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Leads',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            label: 'Status',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

final List<Map<String, dynamic>> _metrics = [
  {
    'title': 'Sales closed today',
    'value': '14',
    'color': Colors.green,
    'index': 0,
  },
  {'title': 'Cold leads', 'value': '2', 'color': Colors.orange, 'index': 1},
  {'title': 'Payment links', 'value': '14', 'color': Colors.pink, 'index': 2},
  {'title': 'Partial Payment', 'value': '4', 'color': Colors.red, 'index': 3},
  {
    'title': 'Expected sale',
    'value': '₹1,10,000',
    'color': Colors.green,
    'index': 4,
  },
  {
    'title': 'Actual Sale',
    'value': '₹80,000',
    'color': Colors.blue,
    'index': 5,
  },
  {
    'title': 'Pending target',
    'value': '₹1,10,000',
    'color': Colors.orange,
    'index': 6,
  },
  {'title': 'Performance', 'value': '80%', 'color': Colors.yellow, 'index': 7},
];

class SalesDashboard extends StatelessWidget {
  const SalesDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // First two cards in Row
        Row(
          children: [
            Expanded(child: _MetricCard(metric: _metrics[0])),
            const SizedBox(width: 12),
            Expanded(child: _MetricCard(metric: _metrics[1])),
          ],
        ),
        const SizedBox(height: 12),
        // Remaining rows as side-by-side (ListTile style)
        for (int i = 2; i < _metrics.length; i += 2)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              height: 90,
              child: Row(
                children: [
                  Expanded(child: _MetricCard(metric: _metrics[i])),
                  const SizedBox(width: 12),
                  if (i + 1 < _metrics.length)
                    Expanded(child: _MetricCard(metric: _metrics[i + 1])),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final Map<String, dynamic> metric;

  const _MetricCard({required this.metric});

  @override
  Widget build(BuildContext context) {
    final title = metric['title'] as String;
    final value = metric['value'] as String;
    final color = metric['color'] as Color;
    final index = metric['index'] as int;
    final backColor = metric['backColor'] as Color?;
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(
        vertical: 6,
      ), // equal spacing between rows
      decoration: BoxDecoration(
        color: (index == 0 || index == 1) ? color : Colors.white,
        borderRadius: BorderRadius.circular(12),
        // border: Border.all(color: color, width: 1.5), // ✅ uniform border
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: (index == 0 || index == 1)
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: Icon(
                    index == 1 ? Icons.arrow_downward : Icons.arrow_upward,
                    size: 16,
                    color: index == 1 ? Colors.red : Colors.green,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: color,
                  child: Icon(
                    Icons.trending_up,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        value,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class PerformanceDashboard extends StatelessWidget {
  const PerformanceDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ], // r
          ),
          child: SalesDashboard(),
        ),
        const SizedBox(height: 16),

        _buildChartCard(
          title: "Performance",
          value: "90%",
          subtitle: "March",
          color: Colors.green,
        ),
        const SizedBox(height: 16),

        _buildChartCard(
          title: "This Month",
          value: "₹36,000",
          subtitle: "March",
          color: Colors.green,
        ),
      ],
    );
  }

  Widget _buildChartCard({
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 16),

          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        switch (value.toInt()) {
                          case 0:
                            return const Text('Jan');
                          case 1:
                            return const Text('Feb');
                          case 2:
                            return const Text('Mar');
                          case 3:
                            return const Text('Apr');
                          case 4:
                            return const Text('May');
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.black26),
                ),
                minX: 0,
                maxX: 4,
                minY: 0,
                maxY: 100,
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    spots: const [
                      FlSpot(0, 20),
                      FlSpot(1, 40),
                      FlSpot(2, 60),
                      FlSpot(3, 80),
                      FlSpot(4, 90),
                    ],
                    barWidth: 3,
                    color: Colors.green,
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.greenAccent.withOpacity(0.2),
                    ),
                    dotData: FlDotData(show: true),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PerformanceCard extends StatelessWidget {
  const PerformanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: const [
              Expanded(
                child: Card(
                  color: Colors.blue,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Card 1",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Card(
                  color: Colors.blue,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Card 2",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTileRow(),
          const SizedBox(height: 16),
          _buildTileRow(),
          const SizedBox(height: 16),
          _buildTileRow(),
        ],
      ),
    );
  }

  Widget _buildTileRow() {
    return Row(
      children: const [
        Expanded(
          child: ListTile(title: Text("Title 1"), subtitle: Text("Subtitle 1")),
        ),
        SizedBox(width: 8),
        Expanded(
          child: ListTile(title: Text("Title 2"), subtitle: Text("Subtitle 2")),
        ),
      ],
    );
  }
}
