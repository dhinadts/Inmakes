import 'package:flutter/material.dart';

class LeadDetailsPage extends StatefulWidget {
  final Map<String, dynamic> lead;

  const LeadDetailsPage({super.key, required this.lead});

  @override
  State<LeadDetailsPage> createState() => _LeadDetailsPageState();
}

class _LeadDetailsPageState extends State<LeadDetailsPage> {
  late String selectedStatus;

  final List<String> statusOptions = [
    "Phone Switched Off",
    "Interested",
    "Not Interested",
    "Follow Up",
    "Closed",
  ];

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.lead['status'] ?? statusOptions.first;
  }

  void _onAddNote() {
    // placeholder: open a simple dialog to add a note (UI only)
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController noteCtrl = TextEditingController();
        return AlertDialog(
          title: const Text('Add Note'),
          content: TextField(
            controller: noteCtrl,
            maxLines: 4,
            decoration: const InputDecoration(hintText: 'Enter note...'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (noteCtrl.text.trim().isNotEmpty) {
                  setState(() {
                    final notes = widget.lead['notes'] as List<dynamic>;
                    notes.insert(0, {
                      "icon": Icons.note,
                      "iconColor": Colors.green,
                      "heading": "Quick note",
                      "date": DateTime.now().toIso8601String().substring(
                        0,
                        10,
                      ), // yyyy-mm-dd
                      "description": noteCtrl.text.trim(),
                    });
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Widget _infoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteItem(BuildContext context, int index, List notes) {
    final note = notes[index] as Map<String, dynamic>;
    final isLast = index == notes.length - 1;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // left timeline: icon + vertical line
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (note['iconColor'] as Color).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  note['icon'] as IconData,
                  color: note['iconColor'] as Color,
                ),
              ),
              if (!isLast)
                Container(width: 2, height: 80, color: Colors.grey[300]),
            ],
          ),

          const SizedBox(width: 12),

          // note card
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // heading + date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        note['heading'] ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          note['date'] ?? '',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    note['description'] ?? '',
                    style: TextStyle(color: Colors.grey[700], fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lead = widget.lead;
    final notes = (lead['notes'] as List<dynamic>?) ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close, color: Colors.black),
        ),
        title: const Text(
          'Lead Details',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit, color: Colors.black),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // top rounded white card area with avatar overlapping
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 24.0,
                horizontal: 16,
              ),
              child: Column(
                children: [
                  // avatar overlap style
                  CircleAvatar(
                    radius: 44,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[300],
                      child: const Icon(
                        Icons.person,
                        size: 48,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    lead['name'] ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // action buttons row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _actionButton(Icons.whatshot, Colors.teal, onTap: () {}),
                      const SizedBox(width: 12),
                      _actionButton(Icons.call, Colors.orange, onTap: () {}),
                      const SizedBox(width: 12),
                      _actionButton(Icons.email, Colors.blue, onTap: () {}),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Add Note (green)
                  GestureDetector(
                    onTap: _onAddNote,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Expanded(
                            child: Text(
                              'Add Note\nCreate a quick note',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Icon(Icons.arrow_forward, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Status dropdown card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.06),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Change Lead Status',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: selectedStatus,
                      onChanged: (v) {
                        if (v != null) {
                          setState(() {
                            selectedStatus = v;
                            widget.lead['status'] = v;
                          });
                        }
                      },
                      items: statusOptions
                          .map(
                            (s) => DropdownMenuItem(value: s, child: Text(s)),
                          )
                          .toList(),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Details grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _infoTile('Email', lead['email'] ?? '-')),
                      const SizedBox(width: 12),
                      Expanded(child: _infoTile('Phone', lead['phone'] ?? '-')),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _infoTile(
                          'Qualification',
                          lead['qualification'] ?? '-',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: _infoTile('Place', lead['place'] ?? '-')),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _infoTile('Source', lead['source'] ?? '-'),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _infoTile('Status', lead['status'] ?? '-'),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _infoTile('Program', lead['program'] ?? '-'),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _infoTile(
                          'Payment Type',
                          lead['paymentType'] ?? '-',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _infoTile(
                          'Payment Date',
                          lead['paymentDate'] ?? '-',
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Notes header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Notes',
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Notes list (timeline)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: List.generate(
                  notes.length,
                  (i) => _buildNoteItem(context, i, notes),
                ),
              ),
            ),
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }
}

/// small reusable action button (used in both pages)
Widget _actionButton(
  IconData icon,
  Color color, {
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: Colors.white),
    ),
  );
}
