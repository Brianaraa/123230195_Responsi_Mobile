# 🎬 StreamVault

Aplikasi streaming TV show bergaya Netflix, menggunakan data dari **TVMaze Public API**.

---

## 📋 Fitur

| Fitur | Status | Kriteria |
|-------|--------|----------|
| Login dengan SharedPreferences | ✅ | A |
| BottomNavigationBar (Home, Favorit, Profil) | ✅ | B.i |
| Fetch data TVMaze API | ✅ | B.ii |
| Grid list dengan Gambar, Judul, Rating | ✅ | B.iii |
| Loading indicator (Shimmer) | ✅ | B.iv |
| Service API dipisah dari UI | ✅ | B.v |
| Navigasi ke Detail Page | ✅ | B.vii |
| Detail Page dengan endpoint /shows/{id} | ✅ | C.i |
| Detail: Gambar, Judul, Rating, Genre, Summary | ✅ | C.ii |
| Tombol Favorit di Detail | ✅ | C.iii |
| Kembali ke page sebelumnya | ✅ | C.iv |
| Daftar Favorit (Hive) | ✅ | D.i-ii |
| Hapus Favorit | ✅ | D.iii |
| Klik favorit → Detail | ✅ | D.iv |
| Profil: username dari SharedPreferences | ✅ | E.i |
| Kesan & Pesan | ✅ | E.ii |
| Tombol Logout fungsional | ✅ | E.iii |
| **GetX** State Management + DI + Routing | ✅ | Bonus |

---

## 🗂 Struktur Proyek

```
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart       # Konstanta global (routes, keys, URL)
│   ├── theme/
│   │   └── app_theme.dart           # Theme Netflix-style (warna, font, dll)
│   └── utils/
│       └── app_pages.dart           # GetX route definitions & bindings
│
├── data/
│   ├── models/
│   │   ├── tv_show_model.dart       # Model TvShow + Hive annotations
│   │   └── tv_show_model.g.dart     # Generated Hive adapter
│   └── services/
│       ├── tvmaze_service.dart      # HTTP calls ke TVMaze API (DIPISAH DARI UI)
│       ├── auth_service.dart        # Login/logout via SharedPreferences
│       └── favorite_service.dart   # CRUD favorit via Hive
│
├── presentation/
│   ├── controllers/
│   │   ├── auth_controller.dart     # GetX: state login/logout
│   │   ├── home_controller.dart     # GetX: fetch shows, search, pagination
│   │   ├── detail_controller.dart   # GetX: fetch detail, toggle favorit
│   │   ├── favorite_controller.dart # GetX: watch & manage favorites
│   │   └── navigation_controller.dart # GetX: bottom nav index
│   │
│   └── pages/
│       ├── auth/
│       │   └── login_page.dart      # Halaman login
│       ├── home/
│       │   ├── main_page.dart       # Wrapper BottomNavigationBar
│       │   └── home_page.dart       # Daftar shows + hero featured
│       ├── detail/
│       │   └── detail_page.dart     # Detail show
│       ├── favorite/
│       │   └── favorite_page.dart   # Daftar favorit
│       └── profile/
│           └── profile_page.dart    # Profil user
│
└── main.dart                        # Entry point, Hive init, route guard
```

---

## 📦 Dependencies

```yaml
# State management, routing, DI
get: ^4.6.6

# HTTP
http: ^1.2.1

# Local storage
shared_preferences: ^2.2.3
hive: ^2.2.3
hive_flutter: ^1.1.0

# UI
cached_network_image: ^3.3.1
flutter_html: ^3.0.0-beta.2
shimmer: ^3.0.0
google_fonts: ^6.2.1
```

---

## 🚀 Cara Setup

```bash
# 1. Install dependencies
flutter pub get

# 2. (Opsional) Regenerate Hive adapter jika model berubah
flutter pub run build_runner build --delete-conflicting-outputs

# 3. Jalankan
flutter run
```

> **Note:** File `tv_show_model.g.dart` sudah tersedia di repo, tidak perlu regenerate kecuali model berubah.

---

## 🔑 Login

Gunakan username & password **bebas**:
- Username: minimal **3 karakter**
- Password: minimal **4 karakter**

Session disimpan di `SharedPreferences`. Logout menghapus session dan redirect ke halaman login.

---

## 🎨 Design System

Terinspirasi Netflix:
- **Background:** `#141414`
- **Primary/Aksen:** `#E50914` (Netflix Red)
- **Font Display:** Bebas Neue
- **Font Body:** Inter
- **Efek:** Shimmer loading, gradient overlay pada poster, hero featured show

---

## ⚡ GetX Implementation

| Fitur GetX | File |
|------------|------|
| **State Management** (`.obs`, `Obx()`) | Semua controller |
| **Dependency Injection** (`Get.put`, `Get.find`, `Get.lazyPut`) | `app_pages.dart`, semua page |
| **Routing** (`Get.toNamed`, `Get.offAllNamed`, `Get.back`) | Navigasi antar page |
| **Snackbar** (`Get.snackbar`) | Detail & Favorite controller |
