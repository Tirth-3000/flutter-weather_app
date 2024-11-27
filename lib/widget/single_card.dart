import 'package:drop_shadow_image/drop_shadow_image.dart';
import 'package:flutter/material.dart';

class SingleCard extends StatelessWidget {
  const SingleCard({
    super.key,
    required this.title,
    required this.description,
    required this.iconUrl,
  });

  final String title;
  final String description;
  final String iconUrl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 200,
      child: Card(
        color: const Color.fromARGB(172, 37, 37, 37),
        margin: const EdgeInsets.all(8),
        elevation: 5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: ClipRRect(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: DropShadowImage(
                  image: Image.network(iconUrl),
                  blurRadius: 2,
                  borderRadius: 2,
                  offset: const Offset(0, 0),
                  scale: 1.05,
                ),
              ),
              const SizedBox(height: 8), // Space between image and text
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4), // Space between title and description
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
