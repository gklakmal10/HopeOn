import 'package:flutter/material.dart';
import 'package:hopeon_app/services/auth_service.dart';
import 'package:hopeon_app/services/parent_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditStudentScreen extends StatefulWidget {
  final String id;

  const EditStudentScreen({super.key, required this.id});
  @override
  _EditStudentScreenState createState() => _EditStudentScreenState();
}

class _EditStudentScreenState extends State<EditStudentScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _parentNameController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  File? _image;
  String? _imageUrl;

  final ParentService _parentService = ParentService();
  late Map<String, dynamic> user;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadStudentData();
  }

  void _loadStudentData() async{
    setState(() => _isLoading = true);
    Map<String, dynamic>? fetchUser = await _parentService.getStudent(widget.id);

    if(fetchUser != null){
      setState(() {
        user = fetchUser;
        _fullNameController.text = fetchUser['fullName'];
        _parentNameController.text = fetchUser['parentName'];
        _contactNumberController.text = fetchUser['contactNo'];
        _gradeController.text = fetchUser['grade'] + " - "+fetchUser['studentClass'] ;
        _ageController.text = "${fetchUser['age']}";
        _locationController.text = fetchUser['location'];
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
  // void _updateStudentDetails() {
  //   // Here you would usually send the updated data to a backend or database
  //   print("Updated Details:");
  //   print("Parent Name: ${_parentNameController.text}");
  //   print("Contact Number: ${_contactNumberController.text}");
  //   print("Grade: ${_gradeController.text}");
  //   print("Age: ${_ageController.text}");
  //   print("Location: ${_locationController.text}");
  //
  //   ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Student details updated successfully!"))
  //   );
  // }

  void _saveChanges() async {
    setState(() {
      _isLoading = true;
    });
    if (user == null) {
      print("Driver data not loaded yet!");
      return;
    }

    Map<String, dynamic>? updatedStudentData = user;

    updatedStudentData["fullName"] = _fullNameController.text;
    updatedStudentData["parentName"] = _parentNameController.text;
    updatedStudentData["contactNo"] = _contactNumberController.text;
    updatedStudentData["age"] = _ageController.text;
    updatedStudentData["location"] = _locationController.text;
    updatedStudentData["imageUrl"] = _imageUrl;

    if (updatedStudentData.isEmpty) {
      print("No changes detected.");
      return;
    }

    Map<String, dynamic> res = await _parentService.updateStudent(updatedStudentData);

    if (res['success']) {
      _loadStudentData();
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
    print(updatedStudentData);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Student details"),
        backgroundColor: Colors.blue,
      ),
      body:_isLoading
          ? const Center(
        child: CircularProgressIndicator(
          color: Colors.blue,
        ),
      )
          : Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _imageUrl != null
                        ? NetworkImage(_imageUrl!)
                        : AssetImage("assets/images/profile-parent.png")
                    as ImageProvider,
                    child:_isUploading? const CircularProgressIndicator(color: Colors.white): const Icon(Icons.camera_alt,
                        size: 30, color: Colors.black54),
                  ),
                ),
              ),
              SizedBox(height: 20),
              _buildTextField("Full Name", _fullNameController),
              _buildTextField("Parent Name", _parentNameController),
              _buildTextField("Contact Number", _contactNumberController),
              _buildTextField("Age", _ageController),
              _buildTextField("Location", _locationController),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _saveChanges,
                  child: Text("Update"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Color.fromRGBO(227, 240, 255,1),
          ),
        ),
        SizedBox(height: 15),
      ],
    );
  }
}
