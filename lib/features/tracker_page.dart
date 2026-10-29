import 'dart:async';
import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../data/store.dart';

/// Nöroplastisite eşikleri: (gün, başlık, açıklama)
const _milestones = <(int, String, String)>[
  (1, 'İlk Gün', 'En zor adım atıldı.'),
  (3, '3 Gün', 'Akut yoksunluk belirtileri genelde zirveyi geçer.'),
  (7, '1 Hafta', 'Yeni rutinler şekillenmeye başlar.'),
  (21, '21 Gün', 'Eski alışkanlık yolları zayıflamaya başlar.'),
  (66, '66 Gün', 'Araştırmalarda alışkanlık otomatikleşmesinin ortalama süresi.'),
  (90, '90 Gün', 'Yeni nöral yollar belirgin biçimde yerleşir.'),
];

class TrackerPage extends StatefulWidget {
  const TrackerPage({super.key});
  @override
  State<TrackerPage> createState() => _TrackerPageState();
}

class _TrackerPageState extends State<TrackerPage> {
  Timer? _t;
  DateTime? _quit = Store.quitDate;

  @override
  void initState() {
    super.initState();
    // Süre = şimdi - başlangıç; uygulama kapalıyken de doğru kalır.
    _t = Timer.periodic(const Duration(seconds: 1), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _t?.cancel();
    super.dispose();
  }

  Future<void> _start() async {
    final now = DateTime.now();
    await Store.setQuitDate(now);
    setState(() => _quit = now);
  }

  Future<void> _reset() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Yeniden başla?'),
        content: const Text('Düşmek başarısızlık değildir; yeniden başlamak sürecin parçasıdır. Sayaç sıfırlanacak.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Vazgeç')),
          TextButton(onPressed: () => Navigator.pop(c, true), child: const Text('Sıfırla')),
        ],
      ),
    );
    if (ok == true) {
      await Store.setQuitDate(null);
      setState(() => _quit = null);
    }
  }

  Future<void> _rename() async {
    final ctl = TextEditingController(text: Store.habit);
    final v = await showDialog<String>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Neyi bırakıyorsun?'),
        content: TextField(controller: ctl, autofocus: true),
        actions: [TextButton(onPressed: () => Navigator.pop(c, ctl.text), child: const Text('Kaydet'))],
      ),
    );
    if (v != null && v.trim().isNotEmpty) {
      await Store.setHabit(v.trim());
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = _quit;
    final d = q == null ? Duration.zero : DateTime.now().difference(q);
    String two(int n) => n.toString().padLeft(2, '0');

    return ListView(padding: const EdgeInsets.all(20), children: [
      GestureDetector(onTap: _rename, child: Text(Store.habit, style: const TextStyle(color: C.muted, fontSize: 16))),
      const SizedBox(height: 4),
      const Text('Özgür geçen süre', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w300)),
      const SizedBox(height: 20),
      Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 12),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            _unit('${d.inDays}', 'GÜN'),
            _unit(two(d.inHours % 24), 'SAAT'),
            _unit(two(d.inMinutes % 60), 'DAK'),
            _unit(two(d.inSeconds % 60), 'SN'),
          ]),
        ),
      ),
      const SizedBox(height: 16),
      if (q == null)
        FilledButton(onPressed: _start, child: const Padding(padding: EdgeInsets.all(14), child: Text('Yolculuğu başlat')))
      else
        OutlinedButton(onPressed: _reset, child: const Text('Yeniden başla')),
      const SizedBox(height: 28),
      const Text('Kilometre taşları', style: TextStyle(fontSize: 18)),
      const SizedBox(height: 12),
      ..._milestones.map((m) => _badge(m, d.inDays, q != null)),
    ]);
  }

  Widget _unit(String v, String l) => Column(children: [
        Text(v, style: const TextStyle(fontSize: 38, fontWeight: FontWeight.w200, color: C.accent)),
        Text(l, style: const TextStyle(fontSize: 11, color: C.muted, letterSpacing: 1.5)),
      ]);

  Widget _badge((int, String, String) m, int days, bool active) {
    final done = active && days >= m.$1;
    final progress = active ? (days / m.$1).clamp(0.0, 1.0) : 0.0;
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: done ? C.accent : C.bg,
          child: Icon(done ? Icons.check : Icons.lock_outline, color: done ? C.bg : C.muted),
        ),
        title: Text(m.$2),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(m.$3, style: const TextStyle(color: C.muted, fontSize: 12)),
            const SizedBox(height: 6),
            LinearProgressIndicator(value: progress, color: C.accent2, backgroundColor: C.bg, minHeight: 3),
          ]),
        ),
      ),
    );
  }
}
