import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers.dart';
import '../../models/food.dart';

class AddFoodScreen extends ConsumerStatefulWidget {
  @override
  _AddFoodScreenState createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends ConsumerState<AddFoodScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameCtl = TextEditingController();
  final descCtl = TextEditingController();
  final priceCtl = TextEditingController();
  String category = 'General';
  File? picked;

  Future pickImage() async {
    final p = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (p != null) setState(() => picked = File(p.path));
  }

  @override
  Widget build(BuildContext context) {
    final svc = ref.read(firebaseServiceProvider);
    return Padding(
      padding: EdgeInsets.all(12),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(controller: nameCtl, decoration: InputDecoration(labelText: 'Name'), validator: (v) => v == null || v.isEmpty ? 'Required' : null),
            TextFormField(controller: descCtl, decoration: InputDecoration(labelText: 'Description')),
            TextFormField(controller: priceCtl, decoration: InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
            DropdownButtonFormField(value: category, items: ['General','Starters','Main Course','Beverages'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(), onChanged: (p) => setState(() => category = p as String)),
            SizedBox(height: 12),
            GestureDetector(onTap: pickImage, child: Container(height: 150, color: Colors.grey[200], child: Center(child: picked == null ? Text('Tap to pick image') : Image.file(picked!, fit: BoxFit.cover)))),
            SizedBox(height: 12),
            ElevatedButton(onPressed: () async {
              if (!_formKey.currentState!.validate()) return;
              String imageUrl = '';
              if (picked != null) {
                final path = 'foods/${DateTime.now().millisecondsSinceEpoch}.jpg';
                imageUrl = await svc.uploadImage(picked!, path);
              }
              final f = Food(id: '', name: nameCtl.text.trim(), description: descCtl.text.trim(), price: double.tryParse(priceCtl.text.trim()) ?? 0.0, imageUrl: imageUrl, category: category);
              await svc.addFood(f);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Food added')));
              nameCtl.clear(); descCtl.clear(); priceCtl.clear(); setState(() => picked = null);
            }, child: Text('Add Food'))
          ],
        ),
      ),
    );
  }
}
