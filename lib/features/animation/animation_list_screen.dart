import 'package:flutter/material.dart';
import 'package:twinkly_flutter/features/animation/character_intro/character_intro.dart';
import 'package:twinkly_flutter/features/animation/productivity/productivity.dart';
import 'package:twinkly_flutter/features/animation/globe_express/screens/home_screen.dart' as globe;

class AnimationListScreen extends StatelessWidget {
  const AnimationListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = <_AnimationItem>[
      _AnimationItem(
        title: 'Character Intro',
        subtitle: 'Playful hero-style onboarding',
        builder: (context) => const CharacterIntro(),
      ),
      _AnimationItem(
        title: 'Productivity',
        subtitle: 'Animated focus and workflow scene',
        builder: (context) => const Productivity(),
      ),
      _AnimationItem(
        title: 'Globe Express (Web)',
        subtitle: 'Card-to-background morph carousel',
        builder: (context) => globe.HomeScreen(),
      ),
    ];

    final theme = Theme.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Animation Demos',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            letterSpacing: .5,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1F2330), Color(0xFF151924)],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 980),
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 100, 20, 40),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 18),
              itemBuilder: (context, index) {
                final item = items[index];
                return _DemoCard(item: item);
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimationItem {
  final String title;
  final String subtitle;
  final WidgetBuilder builder;
  _AnimationItem({
    required this.title,
    required this.subtitle,
    required this.builder,
  });
}

class _DemoCard extends StatefulWidget {
  final _AnimationItem item;
  const _DemoCard({Key? key, required this.item}) : super(key: key);

  @override
  State<_DemoCard> createState() => _DemoCardState();
}

class _DemoCardState extends State<_DemoCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 180),
        scale: _hovering ? 1.02 : 1.0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(_hovering ? 0.10 : 0.07),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
            boxShadow: _hovering
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.35),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : [],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: widget.item.builder),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              child: Row(
                children: [
                  _PlayBadge(hovering: _hovering),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.item.title,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.item.subtitle,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white70,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.white60),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PlayBadge extends StatelessWidget {
  final bool hovering;
  const _PlayBadge({Key? key, required this.hovering}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: hovering
              ? const [Color(0xFFFFE29F), Color(0xFFFF719A)]
              : const [Color(0xFFB2F5EA), Color(0xFF7DD3FC)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: hovering ? 16 : 8,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: const Icon(Icons.play_arrow_rounded, color: Colors.black87),
    );
  }
}


