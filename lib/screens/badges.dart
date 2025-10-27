import 'package:flutter/material.dart' hide Badge;
import '../state/app_scope.dart';
import '../models/badge.dart';

class BadgesScreen extends StatelessWidget {
  const BadgesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final list = app.badges;

    return Scaffold(
      appBar: AppBar(title: const Text('Badges')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.1),
        itemCount: list.length,
        itemBuilder: (_, i) => _BadgeTile(badge: list[i]),
      ),
    );
  }
}

class _BadgeTile extends StatelessWidget {
  const _BadgeTile({required this.badge});
  final Badge badge;

  @override
  Widget build(BuildContext context) {
    final earned = badge.earned;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: earned
            ? const LinearGradient(colors: [Color(0xFF43CEA2), Color(0xFF185A9D)])
            : const LinearGradient(colors: [Color(0xFF434343), Color(0xFF000000)]),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10, offset: const Offset(0, 6),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Opacity(
          opacity: earned ? 1 : 0.5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(earned ? Icons.emoji_events : Icons.lock_outline, size: 36, color: Colors.white),
              const Spacer(),
              Text(badge.title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text(badge.description, style: const TextStyle(color: Colors.white70, fontSize: 12)),
              if (badge.earnedAt != null) ...[
                const SizedBox(height: 8),
                Text('Earned: ${badge.earnedAt!.toLocal().toString().split(".").first}',
                    style: const TextStyle(color: Colors.white70, fontSize: 10)),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
