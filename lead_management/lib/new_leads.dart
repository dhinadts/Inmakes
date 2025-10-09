import 'package:flutter/material.dart';
import 'package:lead_management/leads_details.dart';

class LeadsPage extends StatefulWidget {
  const LeadsPage({super.key});

  @override
  State<LeadsPage> createState() => _LeadsPageState();
}

class _LeadsPageState extends State<LeadsPage> {
  final TextEditingController searchController = TextEditingController();

  final List<Map<String, dynamic>> leads = [
    {
      "name": "Jestin Varghese",
      "date": "18-10-2021",
      "isNew": true,
      "social": Icons.facebook,
      "email": "jestin@example.com",
      "phone": "+91 9874562310",
      "qualification": "Bcom",
      "place": "Kollam",
      "source": "Instagram",
      "status": "Phone Switched Off",
      "program": "Python",
      "paymentType": "Partial Payment",
      "paymentDate": "22.02.2022",
      "notes": [
        {
          "icon": Icons.email,
          "iconColor": Colors.red,
          "heading": "Note heading",
          "date": "18-10-2021",
          "description":
              "Lorem ipsum dolor sit amet bir calamq toche amir sans. Lorem ipsum dolor sit amet.",
        },
        {
          "icon": Icons.chat,
          "iconColor": Colors.green,
          "heading": "Note heading",
          "date": "18-10-2021",
          "description":
              "Another note content. Lorem ipsum dolor sit amet bir calamq toche amir sans.",
        },
      ],
    },
    {
      "name": "Arun Kumar",
      "date": "20-11-2021",
      "isNew": false,
      "social": Icons.camera_alt,
      "email": "arun@example.com",
      "phone": "+91 9123456789",
      "qualification": "BSc",
      "place": "Chennai",
      "source": "Facebook",
      "status": "Interested",
      "program": "Dart",
      "paymentType": "Full Payment",
      "paymentDate": "01.01.2022",
      "notes": [],
    },
    {
      "name": "Sita Ram",
      "date": "25-12-2021",
      "isNew": false,
      "social": Icons.chat, // Telegram
      "email": "sita@example.com",
      "phone": "+91 9876543210",
      "qualification": "MSc",
      "place": "Mumbai",
      "source": "LinkedIn",
      "status": "Not Responding",
      "program": "Java",
      "paymentType": "No Payment",
      "paymentDate": "",
      "notes": [],
    },
    {
      "name": "Jestin Varghese",
      "date": "18-10-2021",
      "isNew": true,
      "social": Icons.camera_alt, // Instagram
    },
    {
      "name": "Jestin Varghese",
      "date": "18-10-2021",
      "isNew": false,
      "social": Icons.chat, // Telegram
    },
    {
      "name": "Jestin Varghese",
      "date": "18-10-2021",
      "isNew": false,
      "social": null,
    },
  ];

  String? selectedStatus;

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Filter",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.calendar_today),
                  hintText: "Start Date",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.calendar_today),
                  hintText: "End Date",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: selectedStatus,
                hint: const Text("Lead Status"),
                items: ["New Lead", "In Progress", "Closed"]
                    .map(
                      (status) =>
                          DropdownMenuItem(value: status, child: Text(status)),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() => selectedStatus = value);
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          selectedStatus = null;
                        });
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Reset"),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Search"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Leads"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.green),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Search + Filter row
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "Search",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.filter_list, color: Colors.grey),
                  onPressed: _openFilterSheet,
                ),
              ],
            ),
          ),

          // Leads list
          Expanded(
            child: ListView.builder(
              itemCount: leads.length,
              itemBuilder: (context, index) {
                final lead = leads[index];
                return GestureDetector(
                  onTap: () {
                    // Navigate to lead
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LeadDetailsPage(lead: lead),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top Row: Name + arrow
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                lead["name"],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),

                          // Date + New Lead badge + Social Icon
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "Created on ${lead["date"]}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (lead["isNew"])
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
                                    "New Lead",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              const SizedBox(width: 8),
                              if (lead["social"] != null)
                                Icon(lead["social"], color: Colors.blue),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Action buttons row
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.whatshot,
                                    color: Colors.white,
                                  ),
                                  label: const Text(""),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.call,
                                    color: Colors.white,
                                  ),
                                  label: const Text(""),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.email,
                                    color: Colors.white,
                                  ),
                                  label: const Text(""),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
