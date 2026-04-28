# Firebase Setup LaporPak

## 1. Aktifkan layanan di Firebase Console

- Authentication
  - Aktifkan `Email/Password`
- Firestore Database
  - Buat database mode production

## 2. Pakai rules yang sudah disiapkan

- Firestore rules:
  - salin isi file `firebase/firestore.rules`
- Firestore index:
  - pakai isi file `firebase/firestore.indexes.json`

## 3. Struktur data Firestore

Collection: `reports`

Contoh dokumen:

```json
{
  "userId": "firebase-auth-uid",
  "name": "Budi",
  "phone": "08123456789",
  "address": "Jl. Sudirman No. 10",
  "city": "Bandung",
  "reportDate": "26/04/2026",
  "violationCategories": ["Tidak Memakai Helm", "Melanggar Lampu Merah"],
  "localImagePath": "/data/user/0/com.example.laporpak/app_flutter/reports/report_uid.jpg",
  "createdAt": "Timestamp"
}
```

## 4. File Firebase yang perlu kamu pasang di Flutter

Android:
- download `google-services.json` dari Firebase Console
- letakkan di `android/app/google-services.json`

iOS:
- download `GoogleService-Info.plist`
- letakkan di `ios/Runner/GoogleService-Info.plist`

## 5. FlutterFire yang perlu dijalankan

Setelah project Firebase sudah kamu buat, jalankan:

```bash
flutter pub get
dart pub global activate flutterfire_cli
flutterfire configure
```

Perintah `flutterfire configure` akan membuat `firebase_options.dart`.

## 6. Kalau mau lebih aman

Tambahkan validasi tambahan di rules jika nanti kamu ingin:
- membatasi ukuran file gambar
- membedakan role admin dan user
