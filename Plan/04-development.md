# 🚀 Part 4 — Development

> Sprint plan, task breakdown, Definition of Done, dan testing strategy

---

## 4.1 Sprint Overview

| Sprint | Tema | Hari | Output |
|--------|------|------|--------|
| Sprint 1 | Foundation & Auth | 1–7 | Project setup, arch scaffold, auth flow berjalan |
| Sprint 2 | Core Features | 8–14 | Grup, expense, OCR scan, balance calculation |
| Sprint 3 | Polish & AI | 15–21 | Settlement, analytics, AI insight, UI polish |

---

## 4.2 Sprint 1 — Foundation & Auth (Hari 1–7)

**Goal:** Project siap dengan arsitektur yang benar, auth flow berjalan end-to-end.

### Tasks

- [ ] Setup Flutter project dengan feature-first folder structure
- [x] Removed: Konfigurasi Firebase (Auth, Firestore, Storage) — Menggunakan Mock Data & Local Storage
- [ ] Setup GetIt + semua injection container skeleton
- [ ] Implementasi `core/error/`: `Failure` base class, `Either` pattern (dartz)
- [ ] Setup Isar local database + schema awal (User, Group, Expense)
- [ ] Setup GoRouter dengan route guards (auth check middleware)
- [ ] Buat `AppTheme`: colors, typography, spacing tokens
- [ ] Auth feature lengkap:
  - [ ] `SignInWithGoogleUseCase`
  - [ ] `SignInWithEmailUseCase`
  - [ ] Login page + Google button
  - [ ] Register page
  - [ ] Profile page (nama, foto, bank info opsional)
- [ ] Unit test auth use cases (mock repository)

### Deliverable
App bisa login Google → redirect ke home page → logout berfungsi.

---

## 4.3 Sprint 2 — Core Features (Hari 8–14)

**Goal:** Fitur utama berjalan: buat grup, tambah expense, scan struk, lihat balance.

### Tasks

- [ ] **Group feature:**
  - [ ] Create group (nama + foto)
  - [ ] Generate & share invite link (deep link via Firebase Dynamic Links)
  - [ ] Join grup via kode/link
  - [ ] Member list page

- [ ] **Expense Manual Entry:**
  - [ ] Form tambah expense: judul, total, payer, item list
  - [ ] Split mode selector: Equal / By Item / Percentage / Custom
  - [ ] `CreateExpenseUseCase` + `CalculateSplitUseCase`
  - [ ] Unit test split calculation semua mode (edge cases: 1 orang, item tidak rata, dll)

- [ ] **Receipt Scan feature:**
  - [ ] Camera capture page (image_picker)
  - [ ] ML Kit OCR integration → raw text
  - [ ] `ParseReceiptUseCase` dengan regex parser
  - [ ] Review UI: user bisa edit hasil parse, assign item ke member
  - [ ] Unit test parser dengan berbagai format struk

- [ ] **Balance & Listing:**
  - [ ] Stream listener ke Isar database (pengganti Firestore)
  - [ ] `SimplifyDebtsUseCase` dengan min-cash-flow algorithm
  - [ ] Balance summary page (who owes whom, simplified)
  - [ ] Expense detail page

- [ ] **Mock Sync (Portfolio effect):**
  - [ ] Tambahkan loading delay 500ms simulasi network request

### Deliverable
Flow lengkap: scan struk → assign items → lihat balance → balance akurat.

---

## 4.4 Sprint 3 — Polish & AI (Hari 15–21)

**Goal:** App siap dipresentasikan: settlement, notifikasi, AI insight, UI sempurna.

### Tasks

- [ ] **Settlement flow:**
  - [ ] Settle up page (pilih amount, upload bukti)
  - [ ] Confirm settlement oleh penerima
  - [ ] Balance update setelah konfirmasi

- [ ] **Notifications:**
  - [ ] FCM setup untuk remote push
  - [ ] Reminder hutang: 1 hari, 3 hari, 7 hari setelah expense dibuat
  - [ ] Notifikasi saat ada expense baru di grup
  - [ ] Notifikasi saat hutang dikonfirmasi lunas

- [ ] **Analytics page:**
  - [ ] Pie chart spending per kategori (fl_chart)
  - [ ] Bar chart spending per bulan
  - [ ] "Who treats the most" leaderboard

- [ ] **Gemini AI integration:**
  - [ ] `GetAIInsightUseCase` → call Gemini API
  - [ ] Weekly insight: "Minggu ini grupmu paling banyak spend di makanan (65%)"
  - [ ] Natural language summary spending pattern

- [ ] **Export PDF:**
  - [ ] Generate rekap grup bulanan sebagai PDF

- [ ] **UI Polish:**
  - [ ] Lottie animation: empty states, success state, loading
  - [ ] Shimmer loading untuk semua list
  - [ ] Error state handling di semua page
  - [ ] Haptic feedback pada aksi penting

- [ ] **Final QA:**
  - [ ] Test di iOS simulator + Android emulator
  - [ ] Test offline scenario end-to-end
  - [ ] Performance check (scroll 100+ expense items)

- [ ] **Documentation:**
  - [ ] README lengkap dengan screenshot
  - [ ] Architecture diagram (draw.io / Excalidraw)
  - [ ] Setup guide untuk reviewer

### Deliverable
App production-ready, siap masuk portofolio.

---

## 4.5 Definition of Done

Setiap task dianggap ✅ DONE jika memenuhi **semua** kriteria ini:

```
□ Tidak ada business logic di widget atau Riverpod provider
□ Repository interface ada di domain layer, implementasi di data layer  
□ Semua async operation return Either<Failure, T>
□ Tidak ada direct Isar call dari presentation layer
□ Unit test coverage domain layer minimal 80%
□ Terdapat simulasi loading network untuk UX yang realistis
□ Loading state, error state, dan empty state semua di-handle
□ UI menggunakan AppTheme (tidak ada hardcoded color/font size)
□ Tidak ada print() — gunakan logger package
□ Kode sudah di-review sendiri (baca ulang sebelum commit)
```

---

## 4.6 Testing Strategy

| Layer | Tipe Test | Tools | Target Coverage |
|-------|-----------|-------|-----------------|
| Domain (Use Cases) | Unit Test | `flutter_test`, `mockito` | 90%+ |
| Data (Repositories) | Unit Test + Mock | `mockito`, `fake_cloud_firestore` | 80%+ |
| Presentation | Widget Test | `flutter_test`, `golden_toolkit` | Key flows |
| Integration | Integration Test | `patrol` | Critical paths |

### Test Cases Wajib

```
CalculateSplitUseCase:
  ✓ Equal split 3 orang, total bisa dibagi rata
  ✓ Equal split 3 orang, total TIDAK bisa dibagi rata (rounding)
  ✓ By-item split, satu item di-assign ke multiple orang
  ✓ Custom amount, total tidak sama dengan sum splits → return Failure
  ✓ Payer ikut dalam split

SimplifyDebtsUseCase:
  ✓ A→B 50k, B→C 50k → A→C 50k (chain simplification)
  ✓ A→B 50k, B→A 30k → A→B 20k (netted)
  ✓ Circular: A→B 30k, B→C 20k, C→A 10k → minimal transactions
  ✓ Semua sudah lunas → return empty list

ParseReceiptUseCase:
  ✓ Format Indomaret (nama + harga di baris sama)
  ✓ Format resto (nama satu baris, harga baris berikutnya)
  ✓ Ada noise (header, footer, subtotal) → noise di-filter
  ✓ Harga ribuan dengan titik: "12.000" → 12000.0
```

---

## 4.7 Portfolio Presentation Guide

Saat presentasi ke recruiter atau technical interview, highlight poin ini:

### 1. Clean Architecture
> *"Kalau saya ganti Firebase ke Supabase, saya hanya perlu ubah di data layer. Presentation dan domain layer tidak perlu disentuh sama sekali."*

### 2. OCR Pipeline
> *"Flow dari foto struk: ML Kit extract teks → ParseReceiptUseCase → confidence scoring → review UI. On-device, jadi tidak ada data sensitif yang dikirim ke server."*

### 3. Debt Simplification Algorithm
> *"Ini yang paling complex. Saya implementasi min-cash-flow algorithm — problem graph theory. Hasilnya: 10 hutang dalam grup bisa disederhanakan jadi 3-4 transaksi saja."*

### 4. Offline-First
> *"App tetap fully functional tanpa internet. Semua write operations ke Isar dulu, background sync ke Firestore. Ada sync queue untuk retry otomatis."*

### 5. Test Coverage
> *"Domain layer saya test 90%+. Termasuk edge cases split calculation: rounding, circular debts, payer yang juga di-split."*

---

## 4.8 Pre-Development Checklist

Sebelum mulai coding:

- [ ] Flutter SDK 3.x sudah terpasang, `flutter doctor` clean
- [ ] Firebase project dibuat, `google-services.json` & `GoogleService-Info.plist` ready
- [ ] Gemini API key dari [Google AI Studio](https://aistudio.google.com)
- [ ] Wireframe kasar di Figma / Excalidraw (tidak perlu detail, cukup flow)
- [ ] Git repo dibuat dengan branch strategy:
  - `main` — stable, production-ready
  - `develop` — integration branch
  - `feature/xxx` — per fitur
- [ ] `pubspec.yaml` sudah diisi semua dependency Sprint 1
- [ ] Baca dokumentasi: [Riverpod](https://riverpod.dev), [Isar](https://isar.dev), [GoRouter](https://pub.dev/packages/go_router)
