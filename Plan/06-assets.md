# 🖼️ Part 6 — Asset Strategy

> Rencana kebutuhan asset desain (icon, gambar, animasi) dan strategi generasinya pakai Nano Banana AI.

---

## 6.1 Art Style Direction

Karena aplikasi ini tentang mengelola pembagian uang secara "fair" dan "smart" (ada AI), aset visual kita butuh art style yang konsisten.

**Arahan Style untuk Generasi (Prompting Style):**
- **Vibe:** Cute, friendly, safe, minimalis.
- **Style:** 3D soft claymorphism dengan **Mascot Chibi Lucu** sebagai karakter utama (misal: robot kecil bulat atau hewan peliharaan pintar). 
- **Color Emphasis:** Fokus pada warna palette kita (Light Trust Blue & Soft Teal) dipadu dengan pastel terang.
- **Lighting:** Soft studio lighting, bright and airy.

---

## 6.2 Daftar Kebutuhan Asset

### A. App Icon & Logo
- **Logo:** Kepala Mascot Chibi pintar (lucu & bulat) dengan elemen koin/kalkulator kecil.
- **Warna latar:** Gradient Trust Blue.
- **Format:** PNG / SVG resolusi tinggi (1024x1024) untuk `flutter_launcher_icons`.

### B. Onboarding Illustrations & Mascot
Gambar ukuran sedang untuk layar pertama kali buka aplikasi, diperankan oleh **Sang Mascot**.
1. **Welcome/Problem:** Mascot melihat tumpukan struk dengan ekspresi bingung lucu.
2. **Feature OCR:** Mascot terbang memegang kaca pembesar bercahaya biru untuk men-scan struk.
3. **Feature Split:** Mascot membagikan koin secara adil ke teman-teman chibi lainnya.
4. **Feature Settlement:** Mascot tersenyum lebar dengan tas koin yang rapi.

### C. Empty States (Bila data kosong)
Gambar kecil Sang Mascot di tengah layar saat tidak ada data.
1. **No Groups:** Mascot duduk sendirian menunggu teman (tapi tetap tersenyum).
2. **No Expenses:** Mascot membalik dompetnya yang bersih dan tersenyum.
3. **No Debts / All Settled:** Mascot rebahan di atas awan, "Hooray, semua lunas!".
4. **No Notification:** Mascot tertidur pakai piyama (zZZ).

### D. Lottie Animations
Untuk animasi micro-interactions (kita ambil gratis dari LottieFiles, nggak usah digenerate AI karena AI gambar biasanya statis).
- **Loading State:** Titik-titik bergelombang warna primary.
- **OCR Scanning:** Efek garis scan berjalan naik-turun.
- **Success / Check:** Ceklis yang muncul dengan animasi memantul saat pembayaran dikonfirmasi lunas.

### E. Category Icons
Ikon-ikon kategori pengeluaran (SVG kecil, lebih baik pakai pack ikon gratis seperti Phosphor Icons atau Feather Icons).
- 🍔 Makanan / Resto
- 🚗 Transport / Bensin
- 🛍️ Belanja / Groceries
- 🏠 Kebutuhan Kos / Listrik
- 🍿 Hiburan / Tiket Bioskop

---

## 6.3 Workflow Generasi Menggunakan Nano Banana

Kalau kamu mau generate ilustrasi di Nano Banana (atau Midjourney/Dall-E), gunakan format *prompt* berikut ini agar hasilnya konsisten:

**Format Prompt Standar:**
```text
[Subjek / Adegan], [Art Style], [Palet Warna], [Pencahayaan], [Latar Belakang]
```

**Contoh Prompt 1 (OCR Scan Feature):**
> *A cute round chibi mascot robot happily scanning a long restaurant receipt with a glowing magnifying glass. 3D soft claymorphism style, safe, friendly, cute. Color palette dominant light trust blue and soft teal with bright pastel accents. Soft bright studio lighting, clean white background, high resolution, 8k, dribbble.*

**Contoh Prompt 2 (Empty Debts):**
> *A cute round chibi mascot resting on a fluffy white cloud, completely relaxed, no money worries. 3D soft claymorphism style, minimalist, playful, friendly. Light blue and soft teal accents. Soft bright studio lighting, pure white background, ui design asset.*

---

## 6.4 Implementasi di Flutter

Semua asset akan disimpan di folder `assets/` dan diregistrasikan di `pubspec.yaml`.

```yaml
flutter:
  assets:
    - assets/images/
    - assets/icons/
    - assets/lottie/
```

- Untuk gambar statis (hasil AI Nano Banana): Simpan sebagai `.png` atau `.webp` untuk kompresi lebih baik.
- Gunakan `flutter_svg` untuk ikon kategori statis.
- Gunakan `lottie` untuk animasi loading/success.
