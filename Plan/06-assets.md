# 🖼️ Part 6 — Asset Strategy

> Rencana kebutuhan asset desain (icon, gambar, animasi) dan strategi generasinya pakai Nano Banana AI.

---

## 6.1 Art Style Direction

Karena aplikasi ini tentang mengelola pembagian uang secara "fair" dan "smart" (ada AI), aset visual kita butuh art style yang konsisten.

**Arahan Style untuk Generasi (Prompting Style):**
- **Vibe:** Modern, playful, clean, minimalis.
- **Style:** 3D isometrik bergaya claymorphism (seperti Spline 3D) ATAU vector flat design pastel. *(Pilih salah satu, misal: 3D playful clean).*
- **Color Emphasis:** Fokus pada warna palette kita (Indigo & Emerald Green) dipadu dengan abu-abu netral.
- **Lighting:** Soft lighting, tanpa bayangan keras.

---

## 6.2 Daftar Kebutuhan Asset

### A. App Icon & Logo
- **Logo:** Ikon otak minimalis (pikiran/mind) dengan elemen struk/uang/split.
- **Warna latar:** Gradient Indigo.
- **Format:** PNG / SVG resolusi tinggi (1024x1024) untuk `flutter_launcher_icons`.

### B. Onboarding Illustrations
Gambar ukuran sedang untuk layar pertama kali buka aplikasi.
1. **Welcome/Problem:** Teman-teman makan bareng dan pusing lihat tagihan.
2. **Feature OCR:** Smartphone menscan struk resto dengan efek *scanning laser*.
3. **Feature Split:** Kalkulator pintar yang membagi item ke beberapa avatar.
4. **Feature Settlement:** Tangan bersalaman atau koin emas ditransfer otomatis.

### C. Empty States (Bila data kosong)
Gambar kecil / ikonik di tengah layar saat tidak ada data.
1. **No Groups:** Ikon ruang tamu kosong atau kursi kosong.
2. **No Expenses:** Dompet kosong tapi tersenyum (atau struk bersih).
3. **No Debts / All Settled:** Pesta konfeti atau ikon checklist hijau besar. "Hooray, semua lunas!".
4. **No Notification:** Bel tidur (dengan ikon zZZ).

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
> *A modern smartphone scanning a long restaurant receipt, glowing laser scanning effect. 3D claymorphism style, minimalist, playful, smooth textures. Color palette dominant indigo blue and emerald green with soft gray. Soft studio lighting, clean white background, high resolution, 8k, dribbble.*

**Contoh Prompt 2 (Empty Debts):**
> *A smiling cute wallet character resting on a beach chair, completely relaxed, no money worries. 3D isometric claymorphism style, minimalist, playful. Indigo and emerald green accents. Soft studio lighting, pure white background, ui design asset.*

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
