import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app/common/ads/admob_helper.dart';
import 'package:food_app/common/widgets/input_text_form_fied.dart';
// ignore: unused_import
import 'package:food_app/feature/ui/login_screen.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdminDashboardScreen extends StatefulWidget {
  final String role;
  final String? userId;

  const AdminDashboardScreen({super.key, required this.role, this.userId});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  InterstitialAd? _interstitialAd;
  Timer? _adTimer;

  @override
  void initState() {
    _startAdTimer();
    super.initState();
  }

  void _startAdTimer() {
    _adTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _loadInterstitialAd();
    });
  }

  void _loadInterstitialAd() {
    _interstitialAd?.dispose();

    InterstitialAd.load(
      adUnitId: AdmobHelper.getInterstitialAdUnitId(),
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _interstitialAd?.show();
        },
        onAdFailedToLoad: (error) {
          debugPrint('Interstitial Ad failed to load: $error');
        },
      ),
    );
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    _adTimer?.cancel();
    super.dispose();
  }

  Future<void> _addOrUpdateItem({
    required String imageUrl,
    required String title,
    required String description,
    required String category,
    required String subCategory,
    required double price,
    required String rating,
    required String discount,
    String? docId,
  }) async {
    try {
      final collectionRef = FirebaseFirestore.instance
          .collection('app_data')
          .doc('shared_items')
          .collection('food_items');

      final data = {
        'imageUrl': imageUrl,
        'title': title,
        'description': description,
        'category': category,
        'subCategory': subCategory,
        'price': price,
        'rating': rating,
        'discount': discount,
        'timestamp': FieldValue.serverTimestamp(),
      };

      if (docId == null) {
        await collectionRef.add(data);
      } else {
        await collectionRef.doc(docId).update(data);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(docId == null ? 'Item added' : 'Item updated')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _deleteContent(String id) async {
    await FirebaseFirestore.instance
        .collection('app_data')
        .doc('shared_items')
        .collection('food_items')
        .doc(id)
        .delete();
  }

  void _showItemDialog({
    String? docId,
    String? existingTitle,
    String? existingDesc,
    String? existingImageUrl,
    String? category,
    String? subCategory,
    double? price,
    String? rating,
    String? discount,
  }) {
    final formKey = GlobalKey<FormState>();

    final titleController = TextEditingController(text: existingTitle ?? '');
    final descController = TextEditingController(text: existingDesc ?? '');
    final imageUrlController = TextEditingController(
      text: existingImageUrl ?? '',
    );
    final categoryController = TextEditingController(text: category ?? '');
    final subCategoryController = TextEditingController(
      text: subCategory ?? '',
    );
    final priceController = TextEditingController(
      text: price?.toString() ?? '',
    );
    final ratingController = TextEditingController(text: rating ?? '');
    final discountController = TextEditingController(text: discount ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(docId == null ? 'Add Item' : 'Update Item'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InputTextFormField(
                  label: 'Image URL',
                  controller: imageUrlController,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Image URL is required'
                      : null,
                ),
                const SizedBox(height: 12),
                InputTextFormField(
                  label: 'Title',
                  controller: titleController,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Title is required'
                      : null,
                ),
                const SizedBox(height: 12),
                InputTextFormField(
                  label: 'Description',
                  controller: descController,
                  maxLines: 2,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Description is required'
                      : null,
                ),
                const SizedBox(height: 12),
                InputTextFormField(
                  label: 'Category',
                  controller: categoryController,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Category is required'
                      : null,
                ),
                const SizedBox(height: 12),
                InputTextFormField(
                  label: 'Sub-category',
                  controller: subCategoryController,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Sub-category is required'
                      : null,
                ),
                const SizedBox(height: 12),
                InputTextFormField(
                  label: 'Price',
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Price is required';
                    }
                    final parsed = double.tryParse(value);
                    if (parsed == null || parsed < 0) {
                      return 'Enter valid price';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                InputTextFormField(
                  label: 'Rating',
                  controller: ratingController,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Rating is required'
                      : null,
                ),

                const SizedBox(height: 12),
                InputTextFormField(
                  label: 'Discount',
                  controller: discountController,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Discount is required'
                      : null,
                ),

                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                _addOrUpdateItem(
                  docId: docId,
                  imageUrl: imageUrlController.text.trim(),
                  title: titleController.text.trim(),
                  description: descController.text.trim(),
                  category: categoryController.text.trim(),
                  subCategory: subCategoryController.text.trim(),
                  price: double.parse(priceController.text.trim()),
                  rating: ratingController.text.trim(),
                  discount: discountController.text.trim(),
                );
                Navigator.of(context).pop();
              }
            },
            child: Text(docId == null ? 'Add Item' : 'Update Item'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(child: Text('No user logged in.'));
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          if (_interstitialAd != null) {
            _interstitialAd?.fullScreenContentCallback =
                FullScreenContentCallback(
                  onAdDismissedFullScreenContent: (ad) {
                    Navigator.of(context).pop();
                  },
                  onAdFailedToShowFullScreenContent: (ad, error) {
                    Navigator.of(context).pop();
                  },
                );
            _interstitialAd?.show();
          } else {
            Navigator.of(context).pop();
          }
        }
      },
      child: widget.role == 'Admin'
          ? _buildAdminDashboard()
          : _buildUserDashboard(),
    );
  }

  Widget _buildUserDashboard() {
    return Center(child: Text('User Dashboard'));
  }

  Widget _buildAdminDashboard() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/auth');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            _buildCard(context, 'Users', Icons.people, '/users'),
            _buildCard(context, 'Food Menu', Icons.fastfood, '/food-menu'),
            _buildCard(context, 'Orders', Icons.receipt, '/orders'),
            _buildCard(context, 'Bookings', Icons.event_seat, '/bookings'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showItemDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    String label,
    IconData icon,
    String route,
  ) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48, color: Colors.deepPurple),
              const SizedBox(height: 10),
              Text(label, style: const TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}






class AdminDashboardExtended extends StatelessWidget {
  Widget locationBar() => Row(
    children: [
      Text('Greater Kailash, New Delhi', style: TextStyle(fontSize: 16)),
      Spacer(),
      TextButton(onPressed: () {}, child: Text('Change'))
    ],
  );

  Widget searchBar() => TextField(
    decoration: InputDecoration(
      hintText: 'Search Restaurants',
      prefixIcon: Icon(Icons.search),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );

  Widget actionButtons() => Row(
    children: [
      Expanded(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(padding: EdgeInsets.all(12)),
          onPressed: () {},
          child: Column(
            children: [
              Icon(Icons.restaurant),
              SizedBox(height: 5),
              Text('Food Order'),
              Text('Find near by restaurants'),
            ],
          ),
        ),
      ),
      SizedBox(width: 10),
      Expanded(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(padding: EdgeInsets.all(12), backgroundColor: Colors.red),
          onPressed: () {},
          child: Column(
            children: [
              Icon(Icons.table_chart),
              SizedBox(height: 5),
              Text('Book a Table'),
              Text('May take up to 3 mins'),
            ],
          ),
        ),
      ),
    ],
  );

  Widget categorySection(String title, List<Map<String, String>> items) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      SizedBox(height: 10),
      Row(
        children: items.map((item) => Expanded(
          child: Column(
            children: [
              Image.network(item['imageUrl']!, height: 100),
              Text(item['label']!),
              if (item.containsKey('price')) Text('Starts from ${item['price']}'),
            ],
          ),
        )).toList(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final collectionItems = [
      {'imageUrl': 'https://example.com/gym_lover.jpg', 'label': 'Gym Lover', 'price': '@E123'},
      {'imageUrl': 'https://example.com/live_music.jpg', 'label': 'Live Music', 'price': '@E123'},
    ];
    final bakeryItems = [
      {'imageUrl': 'https://example.com/cake.jpg', 'label': 'Cake'},
      {'imageUrl': 'https://example.com/ice_cream.jpg', 'label': 'Ice Cream'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('YumFood'),
        actions: [IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {})],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              locationBar(),
              SizedBox(height: 10),
              searchBar(),
              SizedBox(height: 20),
              actionButtons(),
              SizedBox(height: 20),
              categorySection('GET INSPIRED BY COLLECTIONS', collectionItems),
              SizedBox(height: 20),
              categorySection('CAKE, ICE CREAM AND BAKERY', bakeryItems),
            ],
          ),
        ),
      ),
    );
  }
}
