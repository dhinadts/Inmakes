import 'package:flutter/material.dart';

class FollowUpScreen extends StatefulWidget {
  const FollowUpScreen({Key? key}) : super(key: key);

  @override
  State<FollowUpScreen> createState() => _FollowUpScreenState();
}

class _FollowUpScreenState extends State<FollowUpScreen> {
  // Sample data
  final List<Map<String, dynamic>> followups = [
    {
      "name": "Markus Coralo",
      "product": "Product name",
      "date": "18-10-2021",
      "status": "Partially Paid",
      "statusColor": Colors.orange,
    },
    {
      "name": "Markus Coralo",
      "product": "Product name",
      "date": "18-10-2021",
      "status": "Created",
      "statusColor": Colors.green,
    },
    {
      "name": "Markus Coralo",
      "product": "Product name",
      "date": "18-10-2021",
      "status": "Offline Payment",
      "statusColor": Colors.blueGrey,
    },
  ];

  String selectedPaymentType = "All";

  void openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Filter",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // Payment type filter
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Payment Type",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  RadioListTile<String>(
                    title: const Text("All"),
                    value: "All",
                    groupValue: selectedPaymentType,
                    onChanged: (value) {
                      setState(() {
                        selectedPaymentType = value!;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text("Full Payment"),
                    value: "Full Payment",
                    groupValue: selectedPaymentType,
                    onChanged: (value) {
                      setState(() {
                        selectedPaymentType = value!;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text("Partial Payment"),
                    value: "Partially Paid",
                    groupValue: selectedPaymentType,
                    onChanged: (value) {
                      setState(() {
                        selectedPaymentType = value!;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text("Offline Payment"),
                    value: "Offline Payment",
                    groupValue: selectedPaymentType,
                    onChanged: (value) {
                      setState(() {
                        selectedPaymentType = value!;
                      });
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Apply filter
    final filteredFollowups = selectedPaymentType == "All"
        ? followups
        : followups.where((f) => f["status"] == selectedPaymentType).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Follow Up"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.green),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and filter row
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.filter_list, size: 28),
                  onPressed: openFilterSheet,
                ),
              ],
            ),
          ),

          // Followups List
          Expanded(
            child: ListView.builder(
              itemCount: filteredFollowups.length,
              itemBuilder: (context, index) {
                final item = filteredFollowups[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item["name"],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          item["product"],
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 8),
                        // Date and Status Chips
                        Row(
                          children: [
                            Chip(
                              backgroundColor: Colors.grey.shade200,
                              label: Text("Created on ${item["date"]}"),
                            ),
                            const SizedBox(width: 6),
                            Chip(
                              backgroundColor: item["statusColor"].withOpacity(
                                0.2,
                              ),
                              label: Text(
                                item["status"],
                                style: TextStyle(color: item["statusColor"]),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Action buttons
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                icon: const Icon(Icons.whatshot),
                                label: const Text(""),
                                onPressed: () {},
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                icon: const Icon(Icons.phone),
                                label: const Text(""),
                                onPressed: () {},
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                icon: const Icon(Icons.email),
                                label: const Text(""),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
