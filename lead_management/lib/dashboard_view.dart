import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lead_management/common_ui/text_styles.dart';
import 'package:lead_management/new_leads.dart';
import 'package:lead_management/notifications.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final String userName = "User";
  int _selectedIndex = 0;
  bool? _selectedBool;

  @override
  void initState() {
    super.initState();
  }

  Widget dashBoard() {
    return Container(
      color: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
          color: Colors.grey,
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
                            color: Colors.grey,
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
    );
  }

  List<Widget> get _widgetOptions => <Widget>[
    dashBoard(),
    const LeadsPage(),
    const Text('Status Page'),
    const Text('Profile Page'),
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
        currentIndex: 0, // Leads tab selected
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

class PerformanceDashboard extends StatelessWidget {
  const PerformanceDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16),
      child: Column(
        children: [
          PerformanceCard(),
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
      ),
    );
  }

  Widget _buildChartCard({
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
                      color: Colors.green.withOpacity(0.2),
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
      padding: const EdgeInsets.all(16),
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
