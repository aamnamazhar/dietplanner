import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CreateLogScreen extends StatefulWidget {
  const CreateLogScreen({super.key});

  @override
  State<CreateLogScreen> createState() => _CreateLogScreenState();
}

class _CreateLogScreenState extends State<CreateLogScreen> {
  File? _image;
  final _mealController = TextEditingController();
  final _priceController = TextEditingController();
  final _tagsController = TextEditingController();

  // Predefined tags
  final List<String> predefinedTags = [
    "Healthy",
    "HomeMade",
    "QuickLunch",
    "CheatDay"
  ];

  // Selected tags
  List<String> selectedTags = [];

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  void _toggleTag(String tag) {
    setState(() {
      if (selectedTags.contains(tag)) {
        selectedTags.remove(tag);
      } else {
        selectedTags.add(tag);
      }
    });
  }

  void _saveLog() {
    final mealName = _mealController.text.trim();
    final price = _priceController.text.trim();
    final tags = selectedTags;

    if (mealName.isEmpty || price.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    debugPrint("Meal: $mealName");
    debugPrint("Price: $price");
    debugPrint("Tags: $tags");
    debugPrint("Image: ${_image?.path}");

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Create Log",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Upload Image
            Center(
              child: InkWell(
                onTap: _pickImage,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: _image != null ? FileImage(_image!) : null,
                      child: _image == null
                          ? const Icon(Icons.add_a_photo,
                              size: 30, color: Colors.grey)
                          : null,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Upload receipt photo",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Meal Name
            const Text("Meal Name"),
            const SizedBox(height: 6),
            TextField(
              controller: _mealController,
              decoration: InputDecoration(
                hintText: "Enter meal name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Add Tags
            const Text("Add Tags"),
            const SizedBox(height: 6),
            TextField(
              controller: _tagsController,
              decoration: InputDecoration(
                hintText: "#CheatDay, Office...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  setState(() {
                    selectedTags.add(value);
                    _tagsController.clear();
                  });
                }
              },
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              children: predefinedTags.map((tag) {
                final isSelected = selectedTags.contains(tag);
                return ChoiceChip(
                  label: Text(tag),
                  selected: isSelected,
                  selectedColor: Colors.deepOrange,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                  onSelected: (_) => _toggleTag(tag),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // Actual Price
            const Text("Actual Price"),
            const SizedBox(height: 6),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter actual price",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: _saveLog,
                child: const Text(
                  "Save",
                  
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
