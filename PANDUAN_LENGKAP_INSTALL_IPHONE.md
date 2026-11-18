# PANDUAN LENGKAP: INSTALASI T9 KEYBOARD DI IPHONE 14 PLUS (iOS TERBARU)

Proyek ini adalah aplikasi **Custom Keyboard T9** resmi untuk iOS (seperti *Type Nine*), lengkap dengan ekstensi sistem keyboard (`UIInputViewController`), kamus prediktif Bahasa Indonesia & Inggris, mode Multi-tap (gaya Nokia 3310), haptic feedback, dan tema otomatis (Dark/Light).

---

## ❓ Apakah Bisa Berfungsi untuk Chat WhatsApp dan Aplikasi Lain?

**YA, 100% BISA DAN BERFUNGSI PENUH!**

Di sistem operasi iOS (iPhone):
- Apple menyediakan arsitektur resmi bernama **System Keyboard Extension**.
- Begitu diaktifkan di menu *Settings (Pengaturan)* iPhone Anda, keyboard T9 ini otomatis menjadi keyboard sistemik yang **langsung bisa dipakai di:**
  - ✅ **WhatsApp (WA)**
  - ✅ **Telegram**
  - ✅ **Instagram / TikTok DM**
  - ✅ **iMessage / SMS**
  - ✅ **Catatan (Notes), Safari, Browser, dll.**
- Anda bisa berganti antara keyboard T9 dan keyboard bawaan iPhone kapan saja hanya dengan menekan tombol **Bola Dunia (🌐)** di pojok kiri bawah.

---

## 📲 Cara Instalasi Sendiri ke iPhone 14 Plus (Dari PC Windows)

Karena Anda menggunakan PC Windows dan ingin menginstalnya sendiri secara gratis tanpa App Store, metode termudah dan terstandar di dunia iOS saat ini adalah menggunakan **Sideloadly** (Metode resmi Developer Sideloading Apple).

### Langkah 1: Buat File `.ipa` Menggunakan GitHub Actions (Gratis 100%)
Apple mewajibkan kompilasi kode Swift dilakukan di sistem macOS. Anda tidak perlu membeli Mac! Kita sudah menyiapkan file otomatisasi `.github/workflows/build-ipa.yml` di folder ini:

1. Buat repositori baru di akun [GitHub](https://github.com) Anda (bisa diset Private).
2. Unggah seluruh isi folder `T9Keyboard-iOS` ini ke repositori GitHub Anda.
3. Buka tab **Actions** di repositori GitHub Anda.
4. Klik workflow **"Build iOS T9 Keyboard IPA"** lalu klik **Run workflow**.
5. Tunggu sekitar 2–3 menit, sistem cloud Apple (macOS) milik GitHub akan otomatis meng-compile aplikasi Anda dan menghasilkan file **`T9Keyboard.ipa`**.
6. Unduh file `T9Keyboard.ipa` tersebut ke PC Windows Anda.

*(Catatan: Jika Anda atau rekan Anda memiliki komputer Mac, Anda cukup klik 2x file `T9Keyboard.xcodeproj`, colokkan iPhone 14 Plus, lalu tekan tombol ▶ **Run** di Xcode).*

---

### Langkah 2: Pasang ke iPhone 14 Plus Menggunakan Sideloadly (Windows)
1. Unduh dan install software gratis **Sideloadly** di PC Windows Anda dari situs resminya: [https://sideloadly.io](https://sideloadly.io).
2. Hubungkan iPhone 14 Plus Anda ke laptop/PC menggunakan kabel data (USB-C/Lightning). Jika di layar iPhone muncul pop-up *"Trust this Computer?"*, pilih **Trust** dan masukkan passcode iPhone Anda.
3. Buka Sideloadly di PC:
   - Tarik (drag & drop) file **`T9Keyboard.ipa`** ke dalam kotak IPA di Sideloadly.
   - Pada kolom **Apple ID**, masukkan email Apple ID biasa Anda (gratis, tidak perlu berbayar).
   - Klik tombol **Start**.
4. Tunggu hingga proses instalasi selesai (status berubah menjadi *Done*).
5. Aplikasi **T9 Keyboard** kini telah terpasang di layar utama iPhone 14 Plus Anda!

---

### Langkah 3: Izinkan Aplikasi di iPhone (Hanya Sekali)
Pada iOS 16, 17, dan 18 terbaru, Apple meminta konfirmasi keamanan untuk aplikasi yang diinstal sendiri:
1. **Developer Mode** (iOS 16/17/18):
   - Di iPhone, buka **Pengaturan (Settings)** ➔ **Privasi & Keamanan (Privacy & Security)**.
   - Scroll paling bawah, pilih **Mode Pengembang (Developer Mode)** ➔ geser ke **Aktif (ON)**.
   - iPhone akan meminta restart otomatis. Setelah menyala, pilih *Turn On* dan masukkan passcode.
2. **Trust Certificate**:
   - Buka **Pengaturan (Settings)** ➔ **Umum (General)** ➔ **VPN & Manajemen Perangkat (VPN & Device Management)**.
   - Di bawah *Developer App*, ketuk nama Apple ID Anda, lalu pilih **Percayai / Trust**.

---

### Langkah 4: Aktifkan Keyboard T9 untuk WhatsApp
1. Buka **Pengaturan (Settings)** iPhone.
2. Masuk ke **Umum (General)** ➔ **Papan Ketik (Keyboard)**.
3. Ketuk menu **Papan Ketik (Keyboards)** di bagian atas.
4. Ketuk **Tambah Papan Ketik Baru... (Add New Keyboard...)**.
5. Di bagian *Papan Ketik Pihak Ketiga (Third-Party Keyboards)*, ketuk **T9 Keyboard**.
6. (Opsional) Ketuk nama *T9 Keyboard* lalu aktifkan *Izinkan Akses Penuh (Allow Full Access)* jika Anda ingin getaran haptik dan suara klik tombol bekerja maksimal.

---

### 🎉 Selesai! Cara Menggunakan di WhatsApp:
1. Buka aplikasi **WhatsApp**.
2. Buka salah satu ruang obrolan / chat, lalu ketuk kolom ketik pesan.
3. Jika keyboard bawaan Apple yang muncul, **tekan atau tahan ikon Bola Dunia (🌐)** di pojok kiri bawah keyboard, lalu pilih **T9 Keyboard**.
4. Keyboard T9 akan langsung tampil:
   - **Prediktif T9**: Cukup ketuk angka 1x per huruf. Contoh: tekan `4 - 2 - 5 - 6`, di bar atas akan otomatis muncul saran kata **"halo"**. Tekan spasi atau ketuk kata tersebut untuk mengirim.
   - **Mode Nokia (Multi-tap)**: Tekan tombol **T9** di pojok kiri bawah untuk mengubahnya menjadi mode **ABC** (tekan tombol 2 berulang untuk huruf a, b, c).
   - **Simbol & Angka**: Tekan tombol **123** untuk mengetik angka dan simbol.
