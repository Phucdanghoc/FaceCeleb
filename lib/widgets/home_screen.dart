import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:face_celeb/repositories/images_repo.dart';
import 'package:face_celeb/widgets/result_screen.dart';

class ImageSelectionScreen extends StatefulWidget {
  const ImageSelectionScreen({super.key});

  @override
  _ImageSelectionScreenState createState() => _ImageSelectionScreenState();
}

class _ImageSelectionScreenState extends State<ImageSelectionScreen> {
  File? _selectedImage;
  bool _isLoading = false;
  final ImageRepository _repository =
      ImageRepository('https://3f4d-42-118-228-33.ngrok-free.app/api');

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) {
      _showMessage('No image selected');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _repository.uploadImage(_selectedImage!);
      if (response != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ResultScreen(
              yourImage: _selectedImage,
              listImage: response,
            ),
          ),
        );
      } else {
        _showMessage('Failed to upload image');
      }
    } catch (e) {
      print(e);
      _showMessage('Error uploading image: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 91, 188, 230),
              Color.fromARGB(255, 197, 244, 251),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Select your image',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 366,
                      width: 366,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 4),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: _selectedImage != null
                            ? Image.file(
                                _selectedImage!,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/images/bg_intro.png',
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.camera_alt,
                              color: Colors.blue, size: 40),
                          onPressed: () => _pickImage(ImageSource.camera),
                        ),
                        IconButton(
                          icon: const Icon(Icons.folder_open,
                              color: Colors.blue, size: 40),
                          onPressed: () => _pickImage(ImageSource.gallery),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _uploadImage,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 20,
                          shadowColor: Colors.black26),
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
