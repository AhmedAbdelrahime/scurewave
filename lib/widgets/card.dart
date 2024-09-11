import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final String image;
  final String description;
  final VoidCallback onTap;

  const CustomCard({
    super.key,
    required this.title,
    required this.image,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200, // Increased width to provide more space
        height: 150, // Increased height to provide more space
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: const [
            BoxShadow(
              blurRadius: 17.0,
              color: Color(0x6B5ED2B7),
              offset: Offset(0, 6),
            ),
          ],
          gradient: const LinearGradient(
            begin: Alignment(0.51, -0.86),
            end: Alignment(-0.51, 0.86),
            colors: [
              Color.fromARGB(255, 94, 158, 210),
              Color.fromARGB(255, 94, 127, 210)
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 15.0, // Adjusted left position
              top: 112.0, // Adjusted top position to fit within the container
              child: Container(
                width: 170.0, // Adjusted width
                height: 30.0, // Adjusted height
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: const Color(0xFFF5FAF9),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15.0, // Increased font size
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center, // Center the text
                  ),
                ),
              ),
            ),
            Positioned(
              left: 40, // Adjusted left position
              top: 3.0, // Adjusted top position
              child: Container(
                width: 120.0, // Increased width
                height: 120.0, // Increased height
                decoration: ShapeDecoration(
                  color: Colors.white.withOpacity(0.3),
                  shape: const CircleBorder(),
                ),
                child: Center(
                  child: ClipOval(
                    child: Image.asset(
                      image,
                      width: 120, // Increased width
                      height: 120, // Increased height
                      fit: BoxFit
                          .cover, // Ensure the image covers the space properly
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
