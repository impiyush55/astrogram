import 'package:flutter/material.dart';
import '../models/popup_model.dart';

class PremiumAIPopup extends StatelessWidget {
  final PopupModel data;

  const PremiumAIPopup({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          // Main Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E), // Dark background
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: const Color(0xFFFFD700).withOpacity(0.5),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image Section
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Radial Gradient Background to simulate glow/zodiac feel
                      Container(
                        height: 380,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: [
                              const Color(0xFFFFD700).withOpacity(0.1),
                              Colors.black,
                            ],
                            center: Alignment.center,
                            radius: 1.0,
                          ),
                        ),
                        // Attempt to show a zodiac circle if possible, otherwise just gradient
                        child: Opacity(
                          opacity: 0.1,
                          child: Image.network(
                            // Fallback to a generic pattern if possible, else just keep empty/gradient
                            data.imageUrl,
                            fit: BoxFit.cover,
                            color: Colors.white,
                            colorBlendMode: BlendMode.modulate,
                            errorBuilder: (context, error, stackTrace) =>
                                const SizedBox(),
                          ),
                        ),
                      ),
                      // The Main Character Image
                      // Use Image.network since we expect a URL from the API simulation (even if it's local path string, network is better for real API)
                      // Ideally if the string is a local path (lib/...), use AssetImage. If http, use NetworkImage.
                      // For this dummy implementation, since the dummy JSON returns 'lib/assets...', we will use AssetImage if it starts with lib, else NetworkImage.
                      _buildImage(data.imageUrl),

                      // Overlay gradient at bottom of image for text readability
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 100,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                const Color(0xFF1E1E1E),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Text Content
                Transform.translate(
                  offset: const Offset(0, -20),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          data.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            height: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          data.subTitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // CTA Button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              // Add navigation logic here if needed
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFD700),
                              foregroundColor: Colors.black,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              data.buttonText,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Close Button (Floating)
          Positioned(
            top: 16,
            right: 16,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white24),
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String path) {
    if (path.startsWith('http')) {
      return Image.network(
        path,
        height: 380,
        width: double.infinity,
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 380,
            color: Colors.grey[900],
            child: const Icon(Icons.person, size: 100, color: Colors.white54),
          );
        },
      );
    } else {
      return Image.asset(
        path,
        height: 380,
        width: double.infinity,
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 380,
            color: Colors.grey[900],
            child: const Icon(Icons.person, size: 100, color: Colors.white54),
          );
        },
      );
    }
  }
}
