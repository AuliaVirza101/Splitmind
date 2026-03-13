# 🎨 Part 5 — Design System

> Color palette, typography, spacing, border radius, component tokens, dan dark mode strategy

---

## 5.1 Color Palette

Aplikasi pengelola keuangan biasanya butuh warna yang memberi kesan "Aman", "Jelas", dan "Modern". Kita akan menggunakan skema warna yang dinamis tapi tidak terlalu mencolok (agak pastel/soft) agar angka-angka mudah dibaca.

### Primary Colors
*Warna utama aplikasi, branding, tombol aksi utama.*
- **Primary:** `#6366F1` (Indigo Glow) — *Warna utama, modern, trustworthy.*
- **Primary Variant:** `#4F46E5` (Deep Indigo) — *Untuk efek tekan (pressed state) atau teks di atas background light.*
- **On Primary:** `#FFFFFF` — *Warna teks di atas warna primary.*

### Secondary / Accent Colors
*Warna pendukung untuk highlight, badge, atau illustrasi.*
- **Secondary:** `#10B981` (Emerald Green) — *Kesan uang, sukses, balance positif.*
- **Secondary Variant:** `#059669` (Deep Emerald)
- **On Secondary:** `#FFFFFF`

### Semantic / Status Colors
*Warna untuk error, warning, info.*
- **Error (Hutang / Owe / Delete):** `#EF4444` (Red)
- **Success (Lunas / Paid / Settle):** `#10B981` (Green - sama dengan secondary)
- **Warning (Snooze / Reminder):** `#F59E0B` (Amber)
- **Info (Netral):** `#3B82F6` (Blue)

### Neutral & Surface Colors (Light Mode)
*Warna background, card, dialog, teks.*
- **Background:** `#F8FAFC` (Slate 50) — *Off-white agar tidak terlalu silau.*
- **Surface:** `#FFFFFF` — *Untuk Card, Bottom Sheet, Dialog.*
- **Text High Emphasis:** `#0F172A` (Slate 900) — *Heading, angka balance.*
- **Text Medium Emphasis:** `#475569` (Slate 600) — *Body text, subtitle.*
- **Text Low Emphasis / Disabled:** `#94A3B8` (Slate 400) — *Placeholder, disabled button.*
- **Divider / Outlines:** `#E2E8F0` (Slate 200)

### Dark Mode Mapping
*Mapping warna untuk Dark Mode.*
- **Background:** `#0F172A` (Slate 900)
- **Surface:** `#1E293B` (Slate 800)
- **Text High Emphasis:** `#F8FAFC` (Slate 50)
- **Text Medium Emphasis:** `#CBD5E1` (Slate 300)
- **Text Low Emphasis:** `#64748B` (Slate 500)
- **Divider / Outlines:** `#334155` (Slate 700)

---

## 5.2 Typography Scale

Kita akan gunakan font modern sans-serif seperti **Inter** atau **Plus Jakarta Sans** (Google Fonts).

| Kategori | Font Size | Font Weight | Line Height | Penggunaan |
|----------|-----------|-------------|-------------|------------|
| **Display Large** | 32sp | Bold (700) | 1.2 | Total balance utama di halaman depan |
| **Headline Large** | 24sp | Semi-bold (600) | 1.3 | Judul Halaman (Page Title) |
| **Headline Medium** | 20sp | Semi-bold (600) | 1.3 | Judul Bagian (Section Title) |
| **Title Medium** | 16sp | Medium (500) | 1.4 | Judul List Item, Button Teks |
| **Body Large** | 16sp | Regular (400) | 1.5 | Paragraf teks, input field teks |
| **Body Medium** | 14sp | Regular (400) | 1.4 | Teks sekunder, deskripsi list item |
| **Label Small** | 12sp | Medium (500) | 1.3 | Badge teks, caption di bawah icon |

---

## 5.3 Spacing & Sizing Token

Menggunakan sistem grid 4px/8px untuk konsistensi.

- **xxs (4px):** Jarak antar icon kecil dan label.
- **xs (8px):** Jarak standar antar elemen dalam satu card/section.
- **s (12px):** Padding dalam button kecil atau chip.
- **m (16px):** Padding standar container/screen margin pinggir.
- **l (24px):** Margin antar section besar.
- **xl (32px):** Spacing untuk memisahkan area utama.
- **xxl (48px):** Spacing top/bottom halaman.

---

## 5.4 Border Radius

Kita pakai sudut yang membulat (rounded) agar terlihat lebih friendly dan modern (tidak kaku seperti aplikasi corporate).

- **Small (8px):** Checkbox, Tooltip, tag/badge kecil.
- **Medium (12px):** Button standard, TextField input.
- **Large (16px):** Card list expense, Card summary.
- **Extra Large (24px):** Bottom Sheet top corners, Modal Dialog.
- **Full (999px):** Avatar, Floating Action Button (FAB).

---

## 5.5 Elevation & Shadow

Di Flutter modern (Material 3), elevasi lebih banyak dimainkan dengan perbedaan warna surface ketimbang drop shadow hitam yang pekat. Kita pakai shadow sangat tipis.

- **Level 1 (Card biasa):** Flat, border 1px (Divider color), tanpa shadow.
- **Level 2 (Dropdown / Dialog):** Shadow sangat halus, opacity 5%, Y offset 4px, blur 8px.
- **Level 3 (Modal Bottom Sheet):** Sama dengan Level 2, Y offset 8px, blur 16px.

---

## 5.6 Component Styles

### 1. Buttons
- **Primary Button:** Background `Primary`, Text `On Primary`, Radius `Medium` (12px). Height: 48px.
- **Secondary / Outlined Button:** Background transparan, Border 1px `Primary`, Text `Primary`.
- **Destructive Button:** Background `Error`, Text `White`.

### 2. Text Fields (Inputs)
- **Filled Style:** Background light gray (`Slate 100`), tidak ada outline sampai di-focus. Radius 12px.
- **Focus State:** Background `Surface`, Outline 2px `Primary`.
- **Error State:** Outline 2px `Error`, teks keterangan merah di bawah.

### 3. List Item (Expense / Member)
- Padding vertikal 16px.
- Avatar di kiri (Radius Full).
- Title di tengah atas, subtitle/date di bawahnya.
- Amount di kanan (warna hijau kalau piutang, merah kalau hutang, abu-abu kalau netral).

---

## 5.7 Flutter Implementation (ThemeData)

Di Flutter, ini akan di-translate jadi `ThemeData` class.

```dart
// Contoh mapping di app_theme.dart
final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.light(
    primary: const Color(0xFF6366F1),
    secondary: const Color(0xFF10B981),
    surface: const Color(0xFFFFFFFF),
    background: const Color(0xFFF8FAFC),
    error: const Color(0xFFEF4444),
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    // ... mapping lainnya
  ),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(16)), // Default medium-large radius
  ),
);
```
