# 🏗️ Part 3 — Architecture

> Clean Architecture, folder structure, domain entities, use cases, dan tech stack

---

## 3.1 Architecture Overview

SplitMind menggunakan **Clean Architecture** dengan **Feature-First** folder structure.

```
┌─────────────────────────────────────────────┐
│           PRESENTATION LAYER                │
│   Widgets · Pages · Riverpod Providers      │
│   (tahu tentang UI, tidak tahu Firebase)    │
└─────────────────┬───────────────────────────┘
                  │ calls
┌─────────────────▼───────────────────────────┐
│              DOMAIN LAYER                   │
│   Entities · Use Cases · Repo Interfaces    │
│   (pure Dart, zero dependencies luar)       │
└─────────────────┬───────────────────────────┘
                  │ implements
┌─────────────────▼───────────────────────────┐
│               DATA LAYER                    │
│   Repo Impl · Data Sources · Models         │
│   (Isar, Mock Data, ML Kit, Gemini API)     │
└─────────────────────────────────────────────┘
```

**Aturan ketergantungan:** Data & Presentation boleh bergantung ke Domain, tapi Domain tidak boleh tahu apa-apa tentang layer lain.

---

## 3.2 Folder Structure

```
lib/
├── core/
│   ├── error/
│   │   ├── failures.dart           # Failure base class & subclasses
│   │   └── exceptions.dart         # Exception classes
│   ├── network/
│   │   └── network_info.dart       # Connectivity check
│   ├── theme/
│   │   ├── app_theme.dart
│   │   ├── app_colors.dart
│   │   └── app_typography.dart
│   ├── utils/
│   │   ├── extensions/             # String, DateTime, num extensions
│   │   ├── validators.dart
│   │   └── formatters.dart         # Currency, date formatters
│   └── usecase/
│       └── usecase.dart            # Abstract UseCase<Type, Params>
│
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── auth_local_datasource.dart       # Mock login / Isar
│   │   │   ├── models/
│   │   │   │   └── user_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart       # abstract
│   │   │   └── usecases/
│   │   │       ├── sign_in_with_google.dart
│   │   │       ├── sign_in_with_email.dart
│   │   │       └── sign_out.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── login_page.dart
│   │       │   └── profile_page.dart
│   │       ├── widgets/
│   │       └── providers/
│   │           └── auth_provider.dart
│   │
│   ├── group/
│   │   ├── data/
│   │   ├── domain/
│   │   │   ├── entities/           group.dart, member.dart
│   │   │   ├── repositories/       group_repository.dart
│   │   │   └── usecases/           create_group.dart, join_group.dart, get_groups.dart
│   │   └── presentation/
│   │
│   ├── expense/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── expense_local_datasource.dart    # Isar / Mock data
│   │   │   ├── models/
│   │   │   │   ├── expense_model.dart
│   │   │   │   ├── item_model.dart
│   │   │   │   └── split_model.dart
│   │   │   └── repositories/
│   │   │       └── expense_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── expense.dart
│   │   │   │   ├── item.dart
│   │   │   │   └── split_result.dart
│   │   │   ├── repositories/
│   │   │   │   └── expense_repository.dart
│   │   │   └── usecases/
│   │   │       ├── create_expense.dart
│   │   │       ├── calculate_split.dart        # ⭐ core algorithm
│   │   │       ├── get_group_expenses.dart
│   │   │       └── delete_expense.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── expense_list_page.dart
│   │       │   ├── add_expense_page.dart
│   │       │   └── expense_detail_page.dart
│   │       ├── widgets/
│   │       │   ├── split_mode_selector.dart
│   │       │   └── item_assign_widget.dart
│   │       └── providers/
│   │
│   ├── receipt_scan/
│   │   ├── data/
│   │   │   └── services/
│   │   │       └── ml_kit_ocr_service.dart
│   │   ├── domain/
│   │   │   ├── entities/           parsed_item.dart
│   │   │   └── usecases/
│   │   │       └── parse_receipt.dart          # ⭐ OCR pipeline
│   │   └── presentation/
│   │       ├── pages/              scan_receipt_page.dart
│   │       └── widgets/            receipt_review_widget.dart
│   │
│   ├── settlement/
│   │   ├── domain/
│   │   │   ├── entities/           settlement.dart, balance.dart
│   │   │   └── usecases/
│   │   │       ├── simplify_debts.dart         # ⭐ graph algorithm
│   │   │       ├── settle_up.dart
│   │   │       └── get_balances.dart
│   │   └── presentation/
│   │       └── pages/              balance_page.dart, settle_up_page.dart
│   │
│   └── analytics/
│       ├── domain/
│       │   └── usecases/
│       │       ├── get_spending_summary.dart
│       │       └── get_ai_insight.dart         # Gemini API
│       └── presentation/
│           └── pages/              analytics_page.dart
│
├── injection_container.dart        # GetIt DI setup
└── main.dart
```

---

## 3.3 Core Domain Entities

```dart
// user.dart
class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final BankInfo? bankInfo;
}

// expense.dart
class Expense extends Equatable {
  final String id;
  final String groupId;
  final String title;
  final double totalAmount;
  final String paidById;
  final List<Item> items;
  final List<Split> splits;
  final String? receiptImageUrl;
  final DateTime createdAt;
}

// item.dart
class Item extends Equatable {
  final String id;
  final String name;
  final double price;
  final List<String> assignedToUserIds;  // siapa yang pakai item ini
}

// split_result.dart
class SplitResult extends Equatable {
  final String userId;
  final double amount;       // berapa yang harus dibayar
  final double paid;         // berapa yang sudah dibayar
  double get balance => paid - amount;  // positif = lebih bayar, negatif = kurang bayar
}

// balance.dart — computed, tidak disimpan di DB
class Balance extends Equatable {
  final String fromUserId;   // yang punya hutang
  final String toUserId;     // yang dihutangi
  final double amount;
}

// settlement.dart
class Settlement extends Equatable {
  final String id;
  final String groupId;
  final String fromUserId;
  final String toUserId;
  final double amount;
  final String? proofImageUrl;
  final DateTime createdAt;
  final DateTime? confirmedAt;  // null = belum dikonfirmasi
}
```

---

## 3.4 Key Use Cases

### CalculateSplitUseCase ⭐

```
Input:  Expense (dengan items & user assignments)

Process:
  1. Untuk setiap Item → sum price, bagi ke assignedToUserIds
  2. Kumpulkan total per userId → totalOwed
  3. Hitung delta: jika userId == paidById, balance = paid - totalOwed
                  jika tidak,             balance = -totalOwed

Output: List<SplitResult>

Split Modes:
  - EQUAL       → totalAmount / memberCount per orang
  - BY_ITEM     → berdasarkan item assignment (default setelah OCR)
  - PERCENTAGE  → user input % masing-masing
  - CUSTOM      → user input nominal masing-masing
```

### SimplifyDebtsUseCase ⭐⭐ (paling complex)

```
Input:  List<Balance> — semua hutang mentah dalam grup

Process (Min Cash Flow Algorithm):
  1. Hitung net balance per user (total_owed - total_owes)
  2. Pisahkan menjadi: creditors (net > 0) dan debtors (net < 0)
  3. Greedy matching: debtor terbesar bayar ke creditor terbesar
  4. Ulangi sampai semua balance = 0

Contoh:
  Mentah:  A→B 50k, B→C 30k, C→A 20k
  Hasil:   A→B 30k  (3 transaksi jadi 1!)

Output: List<Settlement> yang minimal
```

### ParseReceiptUseCase ⭐

```
Input:  String (raw OCR text dari ML Kit)

Process:
  1. Split teks per baris
  2. Regex pattern: /(.*?)\s+(\d+[\.,]\d{2,3})$/  → nama + harga
  3. Filter noise: baris terlalu pendek, baris tanpa angka, header/footer
  4. Normalize harga: hapus titik/koma pemisah ribuan, parse float
  5. Hitung confidence score per item (berdasarkan pattern match quality)

Output: List<ParsedItem> { name, price, confidence }
        confidence > 0.8  → auto-selected
        confidence < 0.5  → perlu review manual
```

---

## 3.5 Tech Stack

| Layer | Package | Versi | Fungsi |
|-------|---------|-------|--------|
| State Management | `flutter_riverpod` | ^2.4.0 | State & DI |
| Navigation | `go_router` | ^12.0.0 | Declarative routing + deep links |
| Local DB | `isar` | ^3.1.0 | Offline-first storage |
| Remote DB | `(Mocked)` | - | Data statis / dummy delay untuk simulasi |
| Auth | `(Mocked)` | - | Login simulasi dengan dummy user |
| Storage | `path_provider` | ^2.1.5 | Simpan foto receipt & bukti bayar ke local device |
| OCR | `google_mlkit_text_recognition` | ^0.11.0 | On-device receipt scan |
| AI | `google_generative_ai` | ^0.3.0 | Gemini API spending insight |
| Charts | `fl_chart` | ^0.65.0 | Analytics visualization |
| HTTP | `dio` | ^5.4.0 | HTTP client + interceptors |
| DI | `get_it` | ^7.6.4 | Service locator |
| Functional | `dartz` | ^0.10.1 | `Either<Failure, T>` pattern |
| Image | `image_picker` | ^1.0.4 | Camera & gallery |
| Notifications | `flutter_local_notifications` | ^16.2.0 | Reminder |
| Animations | `lottie` | ^3.0.0 | Micro-animations |
| Equality | `equatable` | ^2.0.5 | Value equality untuk entities |
| Freezed | `freezed` | ^2.4.0 | Immutable data classes (opsional) |

---

## 3.6 Error Handling Pattern

```dart
// Semua repository mengembalikan Either, bukan throw
abstract class ExpenseRepository {
  Future<Either<Failure, List<Expense>>> getGroupExpenses(String groupId);
  Future<Either<Failure, Expense>> createExpense(Expense expense);
}

// Use case menggunakan Either
class CreateExpense implements UseCase<Expense, CreateExpenseParams> {
  @override
  Future<Either<Failure, Expense>> call(CreateExpenseParams params) async {
    return await repository.createExpense(params.toExpense());
  }
}

// Provider handle di presentation layer
final expenseProvider = AsyncNotifierProvider<ExpenseNotifier, List<Expense>>(() {
  return ExpenseNotifier();
});
```

---

## 3.7 Storage Strategy (Local-Only Demo)

Karena ini project portfolio/demo:
```
User Action
  │
  ▼
Write ke Isar (local) langsung → UI update (optimistic)
  │
  ▼
(Opsional) Simulated network delay 1 detik untuk memberi kesan "saving to cloud"
```
