# 🚀 PocketPlan - Flutter Mobile Application (Android / iOS)

**PocketPlan** is a production-quality, offline-first personal budget manager combined with a Splitwise-style group hisab system built with Flutter & Dart.

---

## 🏗️ Architecture & Technology Stack

| Layer | Technology / Package | Details |
| :--- | :--- | :--- |
| **Framework** | Flutter 3.44.6, Dart 3.12 | Null safety, Material 3 design system |
| **Architecture** | Feature-First Clean Architecture | `core/`, `data/`, `domain/services/`, `features/`, `widgets/` |
| **State Management** | `flutter_riverpod` (v2.6) | Reactive providers, streams, and computed selectors |
| **Local Database** | `drift` + `drift_flutter` (SQLite) | Stored internally in **paise** (integers) to prevent floating-point rounding errors |
| **Typography** | `google_fonts` | Poppins for headings & rupee metrics, Inter for body |
| **Formatting** | `intl` | Indian numbering system (e.g. `₹1,25,000`, `₹450.50`) |
| **Charts** | `fl_chart` | Interactive Donut Charts for categories & Bar Charts for debt netting |
| **PDF & Printing** | `pdf` + `printing` | Official A4 portrait printable parent report with itemised audit |
| **Excel & CSV** | `excel` + `csv` | Multi-sheet `.xlsx` workbook (Summary, Expenses, Categories, Hisab) |
| **Sharing & Files** | `share_plus`, `path_provider` | Native OS share sheet (WhatsApp, Gmail, Drive) |
| **WhatsApp Chat** | `url_launcher` | 1-click polite reminder via `https://wa.me/` direct API |

---

## 📂 Project Directory Structure

```text
lib/
├── core/
│   ├── constants/app_constants.dart           # Default categories, emojis, colors, limits
│   ├── theme/app_theme.dart                   # Material 3 light & dark theme definitions
│   └── utils/
│       ├── currency_formatter.dart            # Indian numbering format & paise conversion
│       └── date_formatter.dart                # Month calculations & calendar formatters
├── data/
│   ├── database/
│   │   ├── app_database.dart                  # Drift table declarations
│   │   └── app_database.g.dart                # Generated Drift SQLite code
│   ├── providers/app_providers.dart           # Riverpod state providers & computed summaries
│   └── repositories/
│       └── pocketplan_repository.dart         # Repository CRUD & demo data seeder
├── domain/services/                           # Pure Dart services with 100% unit test coverage
│   ├── balance_calculator.dart                # Person-wise net balance calculation
│   ├── budget_status_calculator.dart          # Safe daily spend & budget status calculator
│   ├── debt_simplifier.dart                   # Greedy min-cash-flow debt simplification
│   └── split_calculator.dart                  # Equal, exact, %, and shares ratio splitter
├── features/
│   ├── dashboard/presentation/                # Hero budget card, animated ring, KPI chips
│   ├── expenses/presentation/                 # Grouped expenses, search, add/edit sheet
│   ├── people/presentation/                   # Friends list, avatar initials, add friend dialog
│   ├── hisab/presentation/                    # Statement ledger, WhatsApp link, PDF export
│   ├── who_owes_whom/presentation/            # Balance chart & simplified debt settlements
│   ├── budget/presentation/                   # Pocket money setup & category limit editor
│   ├── reports/
│   │   ├── presentation/reports_screen.dart   # Monthly parent preview & 12-month overview
│   │   └── services/                          # PDF, Excel, and CSV export engines
│   ├── settings/presentation/                 # Profile name, theme toggle, clear/seed demo
│   └── onboarding/presentation/               # 3 intro slides + quick initialization
├── widgets/
│   ├── app_animated_ring.dart                 # Animated progress ring (green/orange/red)
│   └── main_shell_screen.dart                 # Bottom NavigationBar host
└── main.dart                                  # Application entry point & ProviderScope
```

---

## 🧪 Unit Test Suite (100% Passing)

All domain logic is covered by pure Dart unit tests in `test/unit/`:
- `test/unit/split_calculator_test.dart`: Validates Equal, Exact, Percentage, and Shares ratio calculations with paise remainder rounding.
- `test/unit/balance_calculator_test.dart`: Validates split loans, partial repayments, and reverse friend debts.
- `test/unit/debt_simplifier_test.dart`: Validates cash-flow minimization and cyclical netting.
- `test/unit/budget_status_test.dart`: Validates Safe Daily Spend, % used, and threshold warnings.
- `test/widget_test.dart`: Widget smoke tests for `PocketPlanApp` and `AnimatedProgressRing`.

---

## ⚡ Build and Run Instructions

### 1. Run in Debug Mode
Connect an Android device or launch an Android emulator, then run:
```bash
flutter run
```

### 2. Run Tests
```bash
flutter test
```

### 3. Analyze Code
```bash
flutter analyze
```
*(Currently: **No issues found!**)*

### 4. Build Release Android APK
```bash
flutter build apk --release
```
The compiled APK will be generated at:
```text
build/app/outputs/flutter-apk/app-release.apk
```

### 5. Build Google Play App Bundle (.aab)
```bash
flutter build appbundle --release
```
