import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyPocketApp());
}

class MyPocketApp extends StatelessWidget {
  const MyPocketApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Pocket',
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFF3F4F6),
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String userName = "Manish Sharma";
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  Map<String, Map<String, dynamic>> documents = {
    'Citizenship': {'icon': Icons.badge_outlined, 'file': null, 'color': Colors.green},
    'Passport': {'icon': Icons.public_outlined, 'file': null, 'color': Colors.blue},
    'Driving License': {'icon': Icons.credit_card_outlined, 'file': null, 'color': Colors.orange},
  };

  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = userName;
  }

  Future<void> _pickProfilePhoto() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _editNameDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Profile Name'),
        content: TextField(
          controller: _nameController,
          decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "Enter name"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              setState(() { userName = _nameController.text; });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF162A4A)),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDocumentImage(String docName) async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        documents[docName]?['file'] = File(pickedFile.path);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$docName Saved!'), backgroundColor: Colors.green),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('MY POCKET', style: TextStyle(color: Color(0xFF162A4A), fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 15),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: _pickProfilePhoto,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey.shade200,
                            backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                            child: _profileImage == null ? Icon(Icons.person, size: 60, color: Colors.grey.shade400) : null,
                          ),
                        ),
                        Positioned(
                          bottom: 0, right: 4,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                            child: const Icon(Icons.camera_alt, size: 16, color: Color(0xFF162A4A)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: _editNameDialog,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(userName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF162A4A))),
                          const SizedBox(width: 6),
                          const Icon(Icons.edit_square, size: 18, color: Colors.grey),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('DOCUMENT', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF162A4A))),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: documents.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    String key = documents.keys.elementAt(index);
                    var item = documents[key]!;
                    File? docFile = item['file'];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      leading: Container(
                        width: 55, height: 45,
                        decoration: BoxDecoration(color: item['color'].withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                        child: docFile != null 
                            ? ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.file(docFile, fit: BoxFit.cover))
                            : Icon(item['icon'], color: item['color'], size: 26),
                      ),
                      title: Text(key, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                      trailing: docFile != null ? const Icon(Icons.check_circle, color: Colors.green) : const Icon(Icons.add_photo_alternate_outlined, color: Colors.grey),
                      onTap: () => _pickDocumentImage(key),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.home, color: Color(0xFF162A4A), size: 28),
              const Icon(Icons.qr_code_scanner, color: Colors.grey, size: 28),
              const Icon(Icons.person_outline, color: Colors.grey, size: 28),
              ElevatedButton.icon(
                onPressed: () => _pickDocumentImage('Citizenship'),
                icon: const Text('DOCUMENT ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                label: const Icon(Icons.description, color: Colors.white, size: 18),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF162A4A)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
