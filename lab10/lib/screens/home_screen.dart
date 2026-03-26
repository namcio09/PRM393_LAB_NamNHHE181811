import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_controller.dart';
import '../models/user_session.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AuthController>();
    final session = controller.session;
    if (session == null) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final tokenPreview = session.token.length > 18
        ? '${session.token.substring(0, 18)}...'
        : session.token;

    return Scaffold(
      appBar: AppBar(
        title: Text('Hi, ${session.displayName.split(' ').first}'),
        actions: [
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout_rounded),
            onPressed: controller.isBusy
                ? null
                : () async {
                    await controller.logout();
                  },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF6F7FB), Color(0xFFE7EEF7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'You are securely signed in.',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                _InfoCard(session: session, tokenPreview: tokenPreview),
                const SizedBox(height: 24),
                if (controller.notificationsEnabled)
                  FilledButton.icon(
                    onPressed: controller.isBusy
                        ? null
                        : () async {
                            await controller.replayNotification();
                          },
                    icon: const Icon(Icons.notifications_active_outlined),
                    label: const Text('Replay Login Notification'),
                  ),
                const Spacer(),
                FilledButton.tonalIcon(
                  onPressed: controller.isBusy
                      ? null
                      : () async {
                          await controller.logout();
                        },
                  icon: const Icon(Icons.lock_reset_rounded),
                  label: const Text('Logout & Reset Session'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.session, required this.tokenPreview});

  final UserSession session;
  final String tokenPreview;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initials = session.displayName.isNotEmpty
        ? session.displayName.characters.first.toUpperCase()
        : '?';
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  backgroundImage:
                      session.avatarUrl != null ? NetworkImage(session.avatarUrl!) : null,
                  child: session.avatarUrl == null
                      ? Text(
                          initials,
                          style: theme.textTheme.headlineSmall,
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        session.displayName,
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        children: [
                          Chip(
                            avatar: const Icon(Icons.verified_user, size: 18),
                            label: Text(session.provider.label),
                          ),
                          if (session.email != null)
                            Chip(
                              avatar: const Icon(Icons.mail_outline, size: 18),
                              label: Text(session.email!),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Secure Token',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            SelectableText(tokenPreview, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 16),
            Text(
              'Session ID: ${session.id ?? 'N/A'}',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
