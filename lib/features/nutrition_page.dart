import 'package:flutter/material.dart';
import '../core/theme.dart';

class _Cat {
  final String title, role;
  final IconData icon;
  final List<String> items;
  const _Cat(this.title, this.role, this.icon, this.items);
}

const _cats = [
  _Cat('Dopamin', 'Motivasyon ve ödül sistemi. Öncül: L-tirozin.', Icons.rocket_launch_outlined,
      ['Yumurta, tavuk, hindi', 'Badem, kabak çekirdeği', 'Yeşil çay', 'Düzenli egzersiz ve gün ışığı']),
  _Cat('Serotonin', 'Ruh hali ve dürtü kontrolü. Öncül: triptofan.', Icons.wb_sunny_outlined,
      ['Hindi, yoğurt, peynir', 'Yulaf, muz, baklagiller', 'Omega-3 (somon, ceviz, keten tohumu)', 'Sabah gün ışığı']),
  _Cat('GABA', 'Sakinleşme ve gerginliği azaltma.', Icons.spa_outlined,
      ['Papatya, melisa, lavanta çayı', 'L-theanine (yeşil çay)', 'Magnezyum (ıspanak, kabak çekirdeği)', 'Fermente gıdalar']),
  _Cat('Takviyeler', 'Eksiklik varsa, hekim önerisiyle düşünülebilir.', Icons.medication_liquid_outlined,
      ['Magnezyum (glisinat/sitrat)', 'L-theanine', 'Omega-3 (EPA/DHA)', 'B ve D vitamini (kan değerine göre)']),
];

class NutritionPage extends StatelessWidget {
  const NutritionPage({super.key});

  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(20), children: [
        const Text('Nörokimyasal destek', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w300)),
        const SizedBox(height: 16),
        ..._cats.map((c) => Card(
              child: ExpansionTile(
                shape: const Border(),
                collapsedShape: const Border(),
                leading: Icon(c.icon, color: C.accent),
                title: Text(c.title),
                subtitle: Text(c.role, style: const TextStyle(color: C.muted, fontSize: 12)),
                children: c.items
                    .map((i) => ListTile(dense: true, leading: const Icon(Icons.circle, size: 6, color: C.accent2), title: Text(i)))
                    .toList(),
              ),
            )),
        const SizedBox(height: 12),
        const Text(
          'Önemli: Bu içerik genel bilgidir, tıbbi tavsiye değildir. Takviyeler ilaçlarla etkileşebilir. '
          'Alkol, benzodiazepin gibi maddelerin ani bırakılması tıbbi açıdan tehlikeli olabilir; '
          'bu durumlarda mutlaka bir hekime danış.',
          style: TextStyle(color: C.muted, fontSize: 12, height: 1.4),
        ),
      ]);
}
