import 'package:flutter/material.dart';

class CharacterIntro extends StatefulWidget {
  const CharacterIntro({super.key});

  @override
  State<CharacterIntro> createState() => _CharacterIntroState();
}

class _CharacterIntroState extends State<CharacterIntro>
    with SingleTickerProviderStateMixin {
  int activePage = 0;
  late final AnimationController _controller;
  late final Animation<double> scaleAnimation;
  final Duration duration = const Duration(milliseconds: 600);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: duration);
    scaleAnimation = Tween<double>(begin: 0, end: 2).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onPageChanged(index) {
    setState(() {
      _controller
        ..reset()
        ..forward();
      activePage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;
    final circleWidth = screenWidth * 1.4;
    final activeColor = characters[activePage]['color'] as Color;

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/characters/game-bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedContainer(
              duration: duration,
              color: activeColor,
            ),
          ),
          Positioned(
            top: screenHeight * .25,
            left: -screenWidth * .25,
            height: screenWidth,
            width: screenWidth,
            child: ScaleTransition(
              alignment: Alignment.centerLeft,
              scale: scaleAnimation,
              child: Container(
                decoration: BoxDecoration(
                  color: activeColor,
                  borderRadius: BorderRadius.circular(screenWidth),
                ),
              ),
            ),
          ),
          PageView.builder(
            itemCount: characters.length,
            physics: const ClampingScrollPhysics(),
            onPageChanged: onPageChanged,
            itemBuilder: (context, index) {
              final character = characters[index];
              final titleParts = _splitTitle(character['title'] ?? '');

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${titleParts.first}\n',
                          style: const TextStyle(
                            fontSize: 60,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            height: .8,
                          ),
                        ),
                        TextSpan(
                          text: titleParts.last,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            letterSpacing: 4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 300,
                    child: Image.asset(character['image'] ?? ''),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    (character['name'] ?? '').toUpperCase(),
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      letterSpacing: .6,
                      color: Colors.white,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              );
            },
          ),
          Positioned(
            bottom: -circleWidth * .75,
            left: -screenWidth * .2,
            child: Container(
              height: circleWidth,
              width: circleWidth,
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(circleWidth),
              ),
              child: AnimatedContainer(
                duration: duration,
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    const BoxShadow(
                      spreadRadius: 21,
                      color: Colors.black,
                      blurRadius: 100,
                    ),
                    BoxShadow(
                      spreadRadius: 20,
                      color: activeColor,
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<String> _splitTitle(String title) {
    final words = title.split(' ');
    final first = words.isNotEmpty ? words.first.toUpperCase() : '';
    final rest = words.length > 1 ? words.sublist(1).join(' ') : '';
    return [first, rest];
  }
}

final List<Map<String, dynamic>> characters = [
  {
    'name': 'Oscar',
    'title': 'Tech Musicdown',
    'image': 'assets/images/characters/Oscar.png',
    'color': Color.fromRGBO(242, 91, 1, 1),
  },
  {
    'name': 'Bruno',
    'title': 'Street Underhood',
    'image': 'assets/images/characters/Bruno.png',
    'color': Color.fromRGBO(225, 22, 40, 1),
  },
  {
    'name': 'Steven',
    'title': 'Fight Street Warrior',
    'image': 'assets/images/characters/Steven.png',
    'color': Color.fromRGBO(0, 167, 44, 1),
  },
  {
    'name': 'Diana',
    'title': 'Candy Sweet Team',
    'image': 'assets/images/characters/Diana.png',
    'color': Color.fromRGBO(0, 175, 187, 1),
  },
  {
    'name': 'Jeremy',
    'title': 'Urban Ninja',
    'image': 'assets/images/characters/Jeremy.png',
    'color': Color.fromRGBO(0, 91, 214, 1),
  },
];
