import 'dart:io';
import 'package:face_celeb/models/ImageResponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

  Future<void> _captureScreenshot() async {
    try {
      Directory directory;
      if (Platform.isAndroid) {
        directory = Directory("/storage/emulated/0/Download");
      } else {
        directory = await getApplicationDocumentsDirectory();
      }
      String appDocumentsPath = directory.path;

      String orangecardPath = '$appDocumentsPath/face';
      Directory orangecardDirectory = Directory(orangecardPath);
      if (!(await orangecardDirectory.exists())) {
        await orangecardDirectory.create(recursive: true);
      }
      final path = '$orangecardPath/screenshot';

      await screenshotController.captureAndSave(path,
          fileName: 'screenshot.png');
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 96, 204, 253),
                            Colors.blue
                          ],
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
                          _buildYourImagePreview(
                              widget.yourImage, 'Your photograph closely resembles'),
                          _buildImagePreview(
                                    widget.listImage[0].url_image, widget.listImage[0].label),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildImagePreview(
                                    widget.listImage[1].url_image, widget.listImage[0].label),
                                _buildImagePreview(
                                    widget.listImage[2].url_image, widget.listImage[0].label),
                              ],
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
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: IconButton(
                    padding: const EdgeInsets.all(5),
                    icon: const Icon(Icons.arrow_back,
                        color: Colors.white, size: 30),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: IconButton(
                    icon: const Icon(Icons.download, color: Colors.white),
                    onPressed: _captureScreenshot,
                    iconSize: 30,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview(String? image, String label) {
    image?.replaceAll("//","/");
    return Column(
      children: [
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 4),
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey.shade200,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: image != null
                ? Image.network(
                    "https://3f4d-42-118-228-33.ngrok-free.app/static/images/$image",
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
          margin: EdgeInsets.only(bottom: 10),
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
