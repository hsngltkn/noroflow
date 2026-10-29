import 'package:shared_preferences/shared_preferences.dart';

/// Yerel depolama katmanı (SharedPreferences). UI diske yalnızca bu sınıf üzerinden erişir.
class Store {
  static late SharedPreferences _p;
  static Future<void> init() async => _p = await SharedPreferences.getInstance();

  static DateTime? get quitDate {
    final s = _p.getString('quit');
    return s == null ? null : DateTime.tryParse(s);
  }

  static Future<void> setQuitDate(DateTime? d) async =>
      d == null ? _p.remove('quit') : _p.setString('quit', d.toIso8601String());

  static String get habit => _p.getString('habit') ?? 'Alışkanlığım';
  static Future<void> setHabit(String v) => _p.setString('habit', v);

  static int get flowMinutes => _p.getInt('flowMin') ?? 0;
  static Future<void> addFlowMinutes(int m) => _p.setInt('flowMin', flowMinutes + m);
}
