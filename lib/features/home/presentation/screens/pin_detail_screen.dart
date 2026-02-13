import 'package:flutter/material.dart';

class PinDetailScreen extends StatelessWidget {
  final String imageUrl;
  final int id;

  const PinDetailScreen({super.key, required this.imageUrl, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Center(
          child: Hero(
            tag: id,
            child: InteractiveViewer(
              minScale: 1,
              maxScale: 4,
              child: Image.network(imageUrl, fit: BoxFit.contain),
            ),
          ),
        ),
      ),
    );
  }
}
