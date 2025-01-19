import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:permission_handler/permission_handler.dart';

class TextScannerView extends StatefulWidget {
  final Function(String) onTextExtracted;

  const TextScannerView({required this.onTextExtracted, super.key});

  @override
  State<TextScannerView> createState() => _TextScannerViewState();
}

class _TextScannerViewState extends State<TextScannerView> {
  CameraController? _cameraController;
  late Future<void> _initializeControllerFuture;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        final camera = cameras.first;

        _cameraController = CameraController(
          camera,
          ResolutionPreset.medium,
        );
        _initializeControllerFuture = _cameraController!.initialize();
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No cameras found')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera permission denied')),
      );
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _captureAndRecognizeText() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      if (!isProcessing) {
        setState(() {
          isProcessing = true;
        });

        final XFile imageFile = await _cameraController!.takePicture();
        final inputImage = InputImage.fromFile(File(imageFile.path));
        final textRecognizer = GoogleMlKit.vision.textRecognizer();

        final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);

        await textRecognizer.close();

        String extractedText = recognizedText.text;

        setState(() {
          isProcessing = false;
        });

        // Return the extracted text to the previous screen
        Navigator.pop(context, extractedText);
      }
    } catch (e) {
      setState(() {
        isProcessing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ScanText'),centerTitle: true
        ,),
      body: _cameraController == null
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                CameraPreview(_cameraController!),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ElevatedButton(
                      onPressed: _captureAndRecognizeText,
                      child: const Text('Scan Text'),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
