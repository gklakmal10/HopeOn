import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hopeon_app/services/driver_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class EditDriverScreen extends StatefulWidget {
  final String id;

  const EditDriverScreen({super.key, required this.id});

  @override
  _EditDriverScreenState createState() => _EditDriverScreenState();
}

class _EditDriverScreenState extends State<EditDriverScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController nicNumberController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  File? _image;
  String? _imageUrl;

  final DriverService _driverService = DriverService();
  late Map<String, dynamic>? driver;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadDriverData();
  }

  void _loadDriverData() async {
    setState(() => _isLoading = true);
    Map<String, dynamic>? fetchUser = await _driverService.getDriver(widget.id);
    if (fetchUser != null) {
      setState(() {
        driver = fetchUser;
        nameController.text = fetchUser["fullName"];
        contactController.text = fetchUser["contactNo"];
        experienceController.text = fetchUser["experience"];
        nicNumberController.text = fetchUser["nicNo"];
        ageController.text = fetchUser["age"];
        _imageUrl = fetchUser["imageUrl"];
      });
    }
    setState(() => _isLoading = false);
  }

  Future<void> _pickImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
      await _uploadImageToCloudinary(_image!);
    }
  }


  bool _isUploading = false;

  Future<void> _uploadImageToCloudinary(File imageFile) async {
    setState(() {
      _isUploading = true;
    });
    const String cloudinaryUrl =
        "https://api.cloudinary.com/v1_1/dxhudoopp/image/upload";
    const String uploadPreset = "hopeOn"; // Set up in Cloudinary

    var request = http.MultipartRequest('POST', Uri.parse(cloudinaryUrl));
    request.fields['upload_preset'] = uploadPreset;
    request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        setState(() {
          _imageUrl = responseData['secure_url'];
          _isUploading = false;
        });
      } else {
        print("Failed to upload image");
        setState(() {
          _isUploading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      print("Error uploading image: $e");
    }
  }

  void _saveChanges() async {
    setState(() {
      _isLoading = true;
    });
    if (driver == null) {
      print("Driver data not loaded yet!");
      return;
    }

    Map<String, dynamic>? updatedDriverData = driver;

    updatedDriverData?["fullName"] = nameController.text;
    updatedDriverData?["contactNo"] = contactController.text;
    updatedDriverData?["experience"] = experienceController.text;
    updatedDriverData?["nicNo"] = nicNumberController.text;
    updatedDriverData?["age"] = ageController.text;
    updatedDriverData?["imageUrl"] = _imageUrl;

    if (updatedDriverData!.isEmpty) {
      print("No changes detected.");
      return;
    }

    Map<String, dynamic> res = await _driverService.updateDriver(updatedDriverData);

    if (res['success']) {
      _loadDriverData();
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res["message"])),
      );
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res["message"])),
      );
    }

    print("Driver details updated:");
    print(updatedDriverData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Driver Details"),
        backgroundColor: Colors.blue,
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(
          color: Colors.blue,
        ),
      )
          : Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _imageUrl != null
                        ? NetworkImage(_imageUrl!)
                        : AssetImage("assets/images/profile-driver.png")
                    as ImageProvider,
                    child:_isUploading? const CircularProgressIndicator(color: Colors.white): const Icon(Icons.camera_alt,
                        size: 30, color: Colors.black54),
                  ),
                ),
              ),
              SizedBox(height: 20),
              _buildTextField("Driver Name", nameController),
              _buildTextField("Contact Number", contactController),
              _buildTextField("NIC Number", nicNumberController),
              _buildTextField("Experience", experienceController),
              _buildTextField("Age", ageController),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding:
                  EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: Text("Update",
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.blue.shade50,
        ),
      ),
    );
  }
}
