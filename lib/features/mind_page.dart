import 'dart:async';
import 'package:flutter/material.dart';
import '../core/theme.dart';

/// Günlük farkındalık / bilişsel yeniden yapılandırma kartları (güne göre döner).
const _cards = <(String, String, String)>[
  ('DMN · Otomatik pilot', 'Şu an ne düşünüyorum?', 'Zihin dolaşırken fark et, yargılama; dikkatini nefesine geri getir. Fark etmek döngüyü kırar.'),
  ('Bilişsel yeniden çerçeveleme', '"Buna ihtiyacım var" yerine', '"Bu bir istek; gelip geçecek." İstekler dalga gibidir: yükselir, zirve yapar, söner.'),
  ('Tetikleyici farkındalığı', 'Bugünün tetikleyicisi ne olabilir?', 'Saat, mekân, duygu, kişi. Önceden adlandırılan tetikleyici gücünü kaybeder.'),
  ('Beden taraması', 'Dikkatini ayaktan başa gezdir', 'Gerginlik nerede? Duyguyu bedende yerelleştirmek, onu düşünceden ayırır.'),
  ('Değer odağı', 'Neden bırakıyorum?', 'Bir cümleyle yaz. Karar verme ağı (CEN) değerlere bağlandığında seçim kolaylaşır.'),
  ('Alternatif davranış', 'İstek gelince ne yapacağım?', 'Önceden seçilmiş 2 küçük eylem belirle (yürüyüş, su, bir arkadaşı arama). Boşluğu sen doldurmazsan alışkanlık doldurur.'),
  ('Öz-şefkat', 'Kendine bir dostuna konuşur gibi konuş', 'Suçluluk nüksü besler; şefkat sürdürülebilirliği artırır.'),
];

class MindPage extends StatelessWidget {
  const MindPage({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = _cards[now.difference(DateTime(now.year)).inDays % _cards.length];
    return ListView(padding: const EdgeInsets.all(20), children: [
      const Text('Zihin', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w300)),
      const SizedBox(height: 16),
      Card(
        color: C.accent2.withOpacity(.15),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: const Icon(Icons.emergency_outlined, color: C.accent2, size: 32),
          title: const Text('İstek geldi · 90 saniye'),
          subtitle: const Text('Duygusal dalga kabaca 90 sn içinde zirve yapıp söner. Nefesle dalganın geçmesine izin ver.'),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BreathPage())),
        ),
      ),
      const SizedBox(height: 20),
      const Text('Bugünün kartı', style: TextStyle(color: C.muted)),
      const SizedBox(height: 8),
      _card(today),
      const SizedBox(height: 20),
      const Text('Tüm kartlar', style: TextStyle(color: C.muted)),
      const SizedBox(height: 8),
      ..._cards.map(_card),
    ]);
  }

  Widget _card((String, String, String) c) => Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(c.$1, style: const TextStyle(color: C.accent, fontSize: 12, letterSpacing: .8)),
            const SizedBox(height: 6),
            Text(c.$2, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 6),
            Text(c.$3, style: const TextStyle(color: C.muted, height: 1.4)),
          ]),
        ),
      );
}

/// 90 sn nefes ekranı: 4 sn nefes al, 6 sn ver (uzun nefes verme sakinleştirir).
class BreathPage extends StatefulWidget {
  const BreathPage({super.key});
  @override
  State<BreathPage> createState() => _BreathPageState();
}

class _BreathPageState extends State<BreathPage> with SingleTickerProviderStateMixin {
  late final AnimationController _a = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat();
  int _left = 90;
  Timer? _t;

  @override
  void initState() {
    super.initState();
    _t = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_left <= 1) {
        t.cancel();
        _a.stop();
        setState(() => _left = 0);
      } else {
        setState(() => _left--);
      }
    });
  }

  @override
  void dispose() {
    _a.dispose();
    _t?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(backgroundColor: Colors.transparent),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            AnimatedBuilder(
              animation: _a,
              builder: (_, __) {
                final t = _a.value * 10;
                final inhale = t < 4;
                final s = inhale ? t / 4 : 1 - (t - 4) / 6;
                return Column(children: [
                  Container(
                    width: 120 + 120 * s,
                    height: 120 + 120 * s,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: C.accent.withOpacity(.25 + .3 * s)),
                  ),
                  const SizedBox(height: 28),
                  Text(_left == 0 ? 'Dalga geçti.' : (inhale ? 'Nefes al' : 'Yavaşça ver'),
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w300)),
                ]);
              },
            ),
            const SizedBox(height: 12),
            Text(_left == 0 ? 'İstek zayıfladı. Güçlüsün.' : '$_left sn', style: const TextStyle(color: C.muted, fontSize: 18)),
          ]),
        ),
      );
}
