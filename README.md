# NoroFlow (Flutter)

## APK üretme
1. Flutter SDK (>=3.22) + Android SDK kur: https://docs.flutter.dev/get-started/install
2. Bu klasörde Android iskeletini oluştur (mevcut lib/ ve pubspec.yaml korunur):
   flutter create --platforms=android --org com.noroflow .
3. flutter pub get
4. flutter run                      # telefonda/emülatörde dene
5. flutter build apk --release      # çıktı: build/app/outputs/flutter-apk/app-release.apk

## Ses
assets/audio/ içine rain.mp3 ve white.mp3 koy (telifsiz kaynak kullan). Yoksa uygulama sessiz çalışır.

## Mimari
lib/main.dart (Shell + alt gezinme) · core/theme.dart (palet) · data/store.dart (SharedPreferences)
features/{tracker,mind,nutrition,flow}_page.dart

## Sonraki adımlar
Günlük bildirimler (flutter_local_notifications), Room/Drift ile günlük kayıtları, ana ekran widget'ı.
