import 'package:flutter/material.dart';

import '../../controllers/player_controller.dart';

Future<double?> showPlaybackSpeedSheet({
  required BuildContext context,
  required PlayerController player,
}) {
  return showModalBottomSheet<double>(
    context: context,
    showDragHandle: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    builder: (sheetContext) {
      return _PlaybackSpeedSheet(player: player);
    },
  );
}

class _PlaybackSpeedSheet extends StatelessWidget {
  const _PlaybackSpeedSheet({required this.player});

  final PlayerController player;

  static const _speeds = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0, 3.0];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '倍速播放',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 4),
            Text(
              '调整音乐播放速度',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Material(
              color: colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  for (var i = 0; i < _speeds.length; i++) ...[
                    _SpeedTile(
                      speed: _speeds[i],
                      selected: (player.playbackSpeed - _speeds[i]).abs() < 0.001,
                      onTap: () {
                        player.setPlaybackSpeed(_speeds[i]);
                        Navigator.of(context).pop(_speeds[i]);
                      },
                    ),
                    if (i < _speeds.length - 1)
                      const Divider(height: 1, indent: 58),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SpeedTile extends StatelessWidget {
  const _SpeedTile({
    required this.speed,
    required this.selected,
    required this.onTap,
  });

  final double speed;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final label = speed == speed.roundToDouble()
        ? '${speed.round()}x'
        : '${speed}x';

    return ListTile(
      onTap: onTap,
      leading: Icon(
        selected ? Icons.speed_rounded : Icons.speed_outlined,
        color: selected ? colorScheme.primary : colorScheme.onSurfaceVariant,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: selected ? FontWeight.w900 : FontWeight.w600,
          color: selected ? colorScheme.primary : colorScheme.onSurface,
        ),
      ),
      subtitle: speed == 1.0 ? const Text('正常速度') : null,
      trailing: selected
          ? Icon(Icons.check_rounded, color: colorScheme.primary)
          : null,
    );
  }
}
