# PRD EduTrack: Platform Pendamping Belajar

Kelompok 01 | ITC UPNYK Mobile Dev 2026/2027

Anggota: Pande Made Deva Brahmasta, Dimas Haryo Aji Sulistyo, Muhammad Daud Akyaz

## 1. Ringkasan
EduTrack adalah aplikasi pendamping belajar. Pengguna login, menjelajah materi per kategori, mencari materi, membaca detail, dan menyimpan bookmark. Materi diambil dari API. Status login dan bookmark disimpan lokal dengan SharedPreferences.

Pengguna: pelajar atau mahasiswa yang belajar mandiri lewat HP.

Alur utama: Splash → Login → Home → Kategori → Daftar Materi → Detail → Bookmark

## 2. Teknologi yang dipakai

| Kebutuhan | Yang dipakai |
|---|---|
| Framework dan bahasa | Flutter dan Dart (OOP: model, service, provider) |
| State management | `provider` |
| HTTP request | `http` |
| Penyimpanan lokal | `shared_preferences` |
| Navigasi | Named routes (`Navigator`) |
| Version control | Git dan GitHub, satu branch per orang, merge lewat pull request |

Tidak memakai Firebase atau Supabase. Soal tidak mewajibkannya, dan materi yang diminta hanya Dart dan OOP, widget, state management, navigasi, HTTP request atau REST API, JSON parsing, dan SharedPreferences.

### Sumber data materi

Cek ImpactMojo dulu di hari pertama (ketersediaan API dan izin pemakaian). Kalau tidak sesuai, pakai Dev.to API yang gratis dan tanpa API key.

| Kebutuhan | Endpoint |
|---|---|
| Daftar materi per kategori | `GET https://dev.to/api/articles?tag={tag}&per_page=20` |
| Detail materi | `GET https://dev.to/api/articles/{id}` |

Kategori memakai tag Dev.to, contoh: flutter, dart, android, python, webdev. Pencarian dilakukan di sisi aplikasi dengan memfilter daftar yang sudah dimuat.

### Sumber data login

Login memakai REST API DummyJSON supaya tetap sesuai materi HTTP Request.

| Kebutuhan | Endpoint |
|---|---|
| Login | `POST https://dummyjson.com/auth/login` dengan body `username` dan `password` |

Response berisi token dan data user (nama, email, foto). Akun contoh yang dipakai aplikasi saat ini adalah `emilys` / `emilyspass` (DummyJSON); cek lagi bahwa akun ini masih valid sebelum demo. Jika layanan tidak tersedia, login lokal hanya menerima akun demo yang sama, tanpa token, dan menandai sesi sebagai offline. Kredensial lain tetap ditolak.

## 3. Daftar fitur (semua wajib)

| Kode | Fitur | Penjelasan | Pemilik |
|---|---|---|---|
| F1 | Login | Form username dan password dengan validasi input. Panggil API login, lalu simpan status login dan data user ke SharedPreferences. | Deva |
| F2 | Cek sesi dan logout | Splash mengecek status login. Kalau masih login langsung ke Home. Tombol logout menghapus data sesi. | Deva |
| F3 | Home dan kategori | Home menampilkan daftar kategori. Klik kategori membuka daftar materinya. | Dimas |
| F4 | Daftar materi | List kartu materi (judul, thumbnail, penulis, tag) dari API. | Dimas |
| F5 | Pencarian | Kolom cari di Home atau daftar materi. Daftar ikut terfilter sesuai kata kunci. | Dimas |
| F6 | Loading, empty, error state | Spinner saat memuat, pesan kosong kalau tidak ada hasil, pesan error plus tombol "Coba lagi" kalau gagal. Dipasang di semua halaman yang mengambil data. | Dimas |
| F7 | Detail materi | Judul, gambar, penulis, tanggal, tag, dan isi materi (ditampilkan sebagai teks), plus tombol bookmark. | Akyaz |
| F8 | Bookmark | Tombol bookmark di detail dan di kartu. Data tersimpan di SharedPreferences dan tetap ada setelah app ditutup. | Akyaz |
| F9 | Halaman bookmark | Daftar semua materi yang di bookmark, bisa dihapus dari sini, ada empty state kalau kosong. | Akyaz |
| F10 | Profil pengguna | Nama, email, foto, jumlah bookmark, dan tombol logout. Data dari penyimpanan lokal. | Deva |

## 4. Struktur folder dan kepemilikan (Feature-First)

```text
lib/
  main.dart                     (Deva)
  core/                         (Deva)
    routes.dart                 
    theme.dart                  
    storage_service.dart        
    widgets/                    
      app_button.dart           
  features/
    auth/                       (Deva)
      models/user_model.dart             
      services/auth_service.dart           
      providers/auth_provider.dart          
      screens/login_screen.dart           
      screens/profile_screen.dart         
      screens/splash_screen.dart          
    articles/                   (Dimas)
      models/article.dart                
      services/api_service.dart            
      providers/article_provider.dart       
      screens/home_screen.dart            
      screens/article_list_screen.dart    
      widgets/                  
        article_card.dart           
        loading_view.dart           
        empty_view.dart             
        error_view.dart             
    bookmarks/                  (Akyaz)
      providers/bookmark_provider.dart      
      screens/detail_screen.dart          
      screens/bookmark_screen.dart        
```

## 5. Penyimpanan lokal (SharedPreferences)

Semua akses lewat `StorageService` buatan Deva. Anggota lain cukup memanggil service ini dan tidak menulis kode SharedPreferences sendiri.

| Key | Isi | Pemilik |
|---|---|---|
| `is_logged_in` | status login (bool) | Deva |
| `user_data` | nama, email, foto, token (JSON string) | Deva |
| `bookmarks` | daftar materi yang di bookmark, disimpan sebagai list JSON string supaya halaman bookmark bisa tampil tanpa memanggil API lagi | Akyaz |

## 6. Route aplikasi

| Route | Halaman | Pemilik |
|---|---|---|
| `/` | Splash | Deva |
| `/login` | Login | Deva |
| `/home` | Home (kategori dan pencarian) | Dimas |
| `/articles` | Daftar materi per kategori | Dimas |
| `/detail` | Detail materi | Akyaz |
| `/bookmarks` | Daftar bookmark | Akyaz |
| `/profile` | Profil | Deva |

## 7. Pembagian tugas

### Deva: fondasi, login, dan profil
1. Setup repo, struktur folder, dan `pubspec.yaml`
2. Routing semua halaman dan `MultiProvider` di `main.dart`
3. `StorageService` (pembungkus SharedPreferences)
4. Model user, `AuthService`, `AuthProvider`
5. Splash, login, logout, dan profil (F1, F2, F10)
6. Theme dan komponen UI bersama (warna, font, tombol)
7. Merge akhir dan memastikan `pubspec.lock` ikut ke repo

### Dimas: data dan daftar materi
1. Model `Article` dan `ApiService` (GET daftar dan detail, JSON parsing)
2. `ArticleProvider` (kategori terpilih, hasil pencarian, status loading, empty, error)
3. Home, kategori, daftar materi, dan pencarian (F3, F4, F5)
4. Widget `loading_view`, `empty_view`, `error_view` dan memasangnya di semua halaman data (F6)

### Akyaz: detail, bookmark, dan dokumentasi
1. Halaman detail materi (F7)
2. `BookmarkProvider`, tombol bookmark, dan halaman bookmark (F8, F9)
3. README: nama dan NIM, kontribusi tiap anggota, penjelasan app, link video, daftar fitur dengan catatan pengujian, dan screenshot
4. Koordinasi rekaman video presentasi 6 sampai 10 menit

## 8. Kesepakatan antar anggota

Supaya tidak saling menunggu, tiga hal ini disepakati di awal.

1. Model `Article`: `id`, `title`, `description`, `imageUrl`, `author`, `publishedAt`, `tags`, `body`, `toJson()`, dan `fromJson()`. Dimas membuat versi dummy lebih dulu supaya Akyaz bisa langsung mulai.
2. `StorageService`: method `getString`, `setString`, `getStringList`, `setStringList`, `getBool`, `setBool`, dan `remove`. Deva mengerjakan ini paling awal.
3. Nama route mengikuti tabel di bagian 6 dan tidak diganti sepihak.

## 9. Pemetaan ke penilaian

| Aspek (bobot) | Yang harus terlihat di aplikasi |
|---|---|
| Fungsi aplikasi (30%) | F1 sampai F10 jalan, alur Login → Home → Kategori → Materi → Detail → Bookmark lengkap |
| Penerapan Flutter (20%) | Class OOP (model, service, provider), widget yang dipecah rapi, `provider` untuk state, named routes |
| Pengelolaan data dan keandalan (20%) | Integrasi API, JSON parsing, SharedPreferences untuk login dan bookmark, state loading, kosong, dan error |
| UI dan UX (15%) | Theme konsisten, alur mudah dipahami, informasi mudah ditemukan, maksimal 3 ketukan dari Home ke detail |
| Kontribusi tim (10%) | Pembagian tugas jelas, tiap anggota menjelaskan perannya di video |
| Penyampaian hasil (5%) | README lengkap, screenshot, catatan pengujian, video demo |

## 10. Kriteria selesai

1. Semua fitur wajib (F1 sampai F10) jalan di HP asli atau emulator.
2. Setiap fitur punya catatan pengujian: berhasil, belum berhasil, atau perlu diperbaiki.
3. Repo berisi `pubspec.yaml` dan `pubspec.lock`, tanpa folder `.dart_tool/` dan `build/`.
4. README berisi semua poin pengumpulan: nama dan NIM, kontribusi, penjelasan app, link video 6 sampai 10 menit, daftar fitur dengan hasil uji, dan screenshot.
5. Tiap anggota bisa menjelaskan bagiannya sendiri di video.