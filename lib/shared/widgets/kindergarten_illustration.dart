import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class KindergartenIllustration extends StatelessWidget {
  final double height;
  final bool showWelcomeSign;

  const KindergartenIllustration({
    super.key,
    this.height = 200,
    this.showWelcomeSign = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Center(
        child: Container(
          height: height,
          width: height * 1.6, // Пропорции изображения из Figma
          child: Image.asset(
            'assets/images/image216.png',
            height: height,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              // Fallback SVG если PNG не загрузится
              return SvgPicture.asset(
                'assets/images/image216.png',
                height: height,
                fit: BoxFit.contain,
                placeholderBuilder:
                    (context) => Container(
                      height: height,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.family_restroom,
                        size: height * 0.6,
                        color: Colors.grey.shade400,
                      ),
                    ),
              );
            },
          ),
        ),
      ),
    );
  }
}
