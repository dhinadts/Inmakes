import 'package:flutter/material.dart';
import 'package:lead_management/dashboard_view.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample notification list
    final List<Map<String, dynamic>> notifications = [
      {"title": "New Lead", "subtitle": "Jestin Varghese", "isNew": true},
      {"title": "New Lead", "subtitle": "Jestin Varghese", "isNew": true},
      {"title": "New Lead", "subtitle": "Jestin Varghese", "isNew": false},
      {"title": "New Lead", "subtitle": "Jestin Varghese", "isNew": false},
      {"title": "New Lead", "subtitle": "Jestin Varghese", "isNew": false},
      {"title": "New Lead", "subtitle": "Jestin Varghese", "isNew": false},
      {"title": "New Lead", "subtitle": "Jestin Varghese", "isNew": false},
      {"title": "New Lead", "subtitle": "Jestin Varghese", "isNew": false},
      {"title": "New Lead", "subtitle": "Jestin Varghese", "isNew": false},
      {"title": "New Lead", "subtitle": "Jestin Varghese", "isNew": false},
      {"title": "New Lead", "subtitle": "Jestin Varghese", "isNew": false},
      {"title": "New Lead", "subtitle": "Jestin Varghese", "isNew": false},
      {"title": "New Lead", "subtitle": "Jestin Varghese", "isNew": false},
      {"title": "New Lead", "subtitle": "Jestin Varghese", "isNew": false},
      {"title": "New Lead", "subtitle": "Jestin Varghese", "isNew": false},

    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, size: 28),
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DashboardView(),
                      ), // your main dashboard
                    ),
                  ),
                  const Text(
                    "Notifications",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Stack(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.notifications_outlined,
                          size: 28,
                        ),
                        onPressed: () {},
                      ),
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            "${notifications.where((n) => n["isNew"]).length}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Notifications list using ListView.builder
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final item = notifications[index];
                  return _buildNotificationCard(
                    title: item["title"],
                    subtitle: item["subtitle"],
                    isNew: item["isNew"],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard({
    required String title,
    required String subtitle,
    bool isNew = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Texts
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    if (isNew) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          "New",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Arrow
          const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black38),
        ],
      ),
    );
  }
}
