import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  final List<Widget>? children;

  const Home({this.children, super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Stack(
        children: [
          SizedBox(height: height),
          Positioned(
            top: 0,
            height: height - 350 + 40,
            width: MediaQuery.of(context).size.width,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  opacity: 0.8,
                  image: AssetImage('assets/bg.png'),
                ),
              ),
            ),
          ),
          Positioned(
            top: height - 350,
            height: 350,
            width: MediaQuery.of(context).size.width,
            child: RotationTransition(
              turns: const AlwaysStoppedAnimation(180 / 360),
              child: ClipPath(
                clipper: Clipper(),
                child: Container(
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.tertiary),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width / 1.1,
                margin: const EdgeInsets.symmetric(vertical: 30),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SingleChildScrollView(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children ?? []),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Clipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(size.width / 4, size.height - 40, size.width / 2, size.height - 20);
    path.quadraticBezierTo(3 / 4 * size.width, size.height, size.width, size.height - 30);
    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(Clipper oldClipper) => false;
}
