import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../data/store.dart';

class FlowPage extends StatefulWidget {
  const FlowPage({super.key});
  @override
  State<FlowPage> createState() => _FlowPageState();
}

class _FlowPageState extends State<FlowPage> {
  final _player = AudioPlayer();
  Timer? _t;
  int _minutes = 25;
  int _left = 0;
  bool _running = false;
  String _sound = 'Sessiz';
  // Dosyaları assets/audio/ içine ekle (README'ye bak).
  static const _sounds = <String, String?>{'Sessiz': null, 'Yağmur': 'audio/rain.mp3', 'Beyaz gürültü': 'audio/white.mp3'};

  Future<void> _play() async {
    final path = _sounds[_sound];
    try {
      await _player.stop();
      if (path != null) {
        await _player.setReleaseMode(ReleaseMode.loop);
        await _player.play(AssetSource(path));
      }
    } catch (_) {/* dosya yoksa sessiz devam */}
  }

  void _start() {
    setState(() {
      _left = _minutes * 60;
      _running = true;
    });
    _play();
    _t = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_left <= 1) {
        _finish(completed: true);
      } else {
        setState(() => _left--);
      }
    });
  }

  Future<void> _finish({required bool completed}) async {
    _t?.cancel();
    await _player.stop();
    if (completed) await Store.addFlowMinutes(_minutes);
    if (mounted) setState(() {
      _running = false;
      _left = 0;
    });
  }

  @override
  void dispose() {
    _t?.cancel();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mm = (_left ~/ 60).toString().padLeft(2, '0');
    final ss = (_left % 60).toString().padLeft(2, '0');
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          if (_running) ...[
            // Minimalist mod: yalnızca süre.
            Text('$mm:$ss', style: const TextStyle(fontSize: 72, fontWeight: FontWeight.w100, color: C.accent)),
            const SizedBox(height: 32),
            TextButton(onPressed: () => _finish(completed: false), child: const Text('Bitir', style: TextStyle(color: C.muted))),
          ] else ...[
            const Text('Flow', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w300)),
            const SizedBox(height: 6),
            Text('Toplam derin odak: ${Store.flowMinutes} dk', style: const TextStyle(color: C.muted)),
            const SizedBox(height: 24),
            Wrap(spacing: 8, children: [
              for (final m in [25, 50, 90])
                ChoiceChip(label: Text('$m dk'), selected: _minutes == m, onSelected: (_) => setState(() => _minutes = m)),
            ]),
            const SizedBox(height: 12),
            Wrap(spacing: 8, children: [
              for (final s in _sounds.keys)
                ChoiceChip(label: Text(s), selected: _sound == s, onSelected: (_) => setState(() => _sound = s)),
            ]),
            const SizedBox(height: 28),
            FilledButton(onPressed: _start, child: const Padding(padding: EdgeInsets.all(14), child: Text('Seansı başlat'))),
            const SizedBox(height: 16),
            const Text('Bildirimleri kapat, tek bir hedef seç, başla.', style: TextStyle(color: C.muted, fontSize: 12)),
          ],
        ]),
      ),
    );
  }
}
