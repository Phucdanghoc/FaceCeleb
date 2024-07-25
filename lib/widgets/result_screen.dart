import 'dart:io';
import 'package:face_celeb/models/ImageResponse.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

class ResultScreen extends StatefulWidget {
  final File? yourImage;
  final List<ImageUploadResponse> listImage;

  const ResultScreen({
    super.key,
    required this.yourImage,
    required this.listImage,
  });

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final ScreenshotController screenshotController = ScreenshotController();
  int _selectedImageCount = 4; // Default number of images to display

  Future<void> _captureScreenshot() async {
    try {
      Directory directory;
      if (Platform.isAndroid) {
        directory = Directory("/storage/emulated/0/Download");
      } else {
        directory = await getApplicationDocumentsDirectory();
      }
      String appDocumentsPath = directory.path;

      String screenshotPath = '$appDocumentsPath/face';
      Directory screenshotDirectory = Directory(screenshotPath);
      if (!(await screenshotDirectory.exists())) {
        await screenshotDirectory.create(recursive: true);
      }
      final path = '$screenshotPath/screenshot';

      await screenshotController.captureAndSave(path, fileName: 'screenshot.png');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Screenshot saved to $path',
            style: const TextStyle(fontSize: 18),
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to capture screenshot: $e',
            style: const TextStyle(fontSize: 18),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(197, 144, 219, 254),
              Color.fromARGB(255, 197, 244, 251),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Screenshot(
                controller: screenshotController,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          colors: [Color.fromARGB(255, 96, 204, 253), Colors.blue],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildYourImagePreview(widget.yourImage, 'Your photograph closely resembles'),
                          DropdownButton<int>(
                            dropdownColor: const Color.fromARGB(255, 108, 182, 242),
                            value: _selectedImageCount,
                            iconEnabledColor: Colors.white,
                            iconDisabledColor: Colors.white,
                            items: [2, 4, 6, 8, 10, 20]
                                .map((e) => DropdownMenuItem<int>(
                                      value: e,
                                      child: Text('Top $e images',                            
                                      style: TextStyle(color: Colors.white),),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedImageCount = value ?? 4;
                              });
                            },
                          ),
                          Container(
                            height: 400,
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 15.0,
                                mainAxisSpacing: 15.0,
                              ),
                              itemCount: _selectedImageCount,
                              itemBuilder: (context, index) {
                                if (index >= widget.listImage.length) {
                                  return Container(); // Return an empty container if the index exceeds the list length
                                }
                                return _buildImagePreview(
                                  widget.listImage[index].url_image,
                                  widget.listImage[index].label,
                                  widget.listImage[index].confidence,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: IconButton(
                    padding: const EdgeInsets.all(5),
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.download, color: Colors.white),
                    onPressed: _captureScreenshot,
                    iconSize: 30,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview(String? imageUrl, String label, double confidence) {
    return Column(
      children: [
        Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 4),
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey.shade200,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: imageUrl != null
                ? Image.network(
                    "https://148d-2405-4802-9382-1263-54b1-1322-b3c4-decc.ngrok-free.app/static/images/${imageUrl.replaceAll('//', '/')}",
                    fit: BoxFit.cover,
                  )
                : const Center(
                    child: Text(
                      "Image !",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          confidence.toString(),
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          extractName(label),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildYourImagePreview(File? image, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.only(bottom: 10),
          height: 160,
          width: 160,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 4),
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey.shade200,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: image != null
                ? Image.file(
                    image,
                    fit: BoxFit.cover,
                  )
                : Center(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  String extractName(String input) {
    List<String> parts = input.split('_');
    if (parts.length >= 3) {
      String name = '${parts[1]} ${parts[2]}';
      print(name);
      return name;
    } else {
      return "Name";
    }
  }
}
