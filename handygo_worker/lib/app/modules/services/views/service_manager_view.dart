import 'package:flutter/material.dart';

class ServiceManagerView extends StatefulWidget {
  const ServiceManagerView({super.key});

  @override
  State<ServiceManagerView> createState() => _ServiceManagerViewState();
}

class _ServiceManagerViewState extends State<ServiceManagerView> {
  final List<Map<String, dynamic>> categories = [
    {'name': 'Plumbing', 'icon': Icons.water_drop_rounded, 'active': true},
    {'name': 'Electrical', 'icon': Icons.bolt_rounded, 'active': true},
    {'name': 'Cleaning', 'icon': Icons.cleaning_services_rounded, 'active': false},
    {'name': 'AC Repair', 'icon': Icons.ac_unit_rounded, 'active': false},
    {'name': 'Painting', 'icon': Icons.format_paint_rounded, 'active': false},
    {'name': 'Carpentry', 'icon': Icons.handyman_rounded, 'active': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('My Services'),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Manage your expertise',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Select the categories you want to receive jobs for.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                return _buildCategoryItem(cat, index);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomSave(),
    );
  }

  Widget _buildCategoryItem(Map<String, dynamic> cat, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cat['active'] ? const Color(0xFF55B436).withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: cat['active'] ? const Color(0xFF55B436) : const Color(0xFFE0E0E0),
          width: cat['active'] ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: cat['active'] ? const Color(0xFF55B436) : const Color(0xFFF0F0F0),
              shape: BoxShape.circle,
            ),
            child: Icon(cat['icon'], color: cat['active'] ? Colors.white : Colors.grey, size: 20),
          ),
          const SizedBox(width: 16),
          Text(
            cat['name'],
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: cat['active'] ? const Color(0xFF55B436) : Colors.black87,
            ),
          ),
          const Spacer(),
          Switch.adaptive(
            value: cat['active'],
            activeColor: const Color(0xFF55B436),
            onChanged: (val) {
              setState(() {
                categories[index]['active'] = val;
              });
            },
          )
        ],
      ),
    );
  }

  Widget _buildBottomSave() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4))],
      ),
      child: ElevatedButton(
        onPressed: () => Navigator.pop(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF55B436),
          minimumSize: const Size(double.infinity, 55),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: const Text('Save Changes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
