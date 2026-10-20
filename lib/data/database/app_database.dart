import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

// ---------------------------------------------------------------------------
// TABLES
// ---------------------------------------------------------------------------

class MonthlyBudgets extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get year => integer()();
  IntColumn get month => integer()(); // 1 to 12
  IntColumn get amountPaise => integer()(); // in paise (e.g. 2500000 = ₹25,000)
  BoolColumn get carryForward => boolean().withDefault(const Constant(true))();
  IntColumn get carriedAmountPaise => integer().withDefault(const Constant(0))();

  @override
  List<Set<Column>> get uniqueKeys => [{year, month}];
}

class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  TextColumn get emoji => text().withLength(min: 1, max: 10)();
  TextColumn get colorHex => text().withLength(min: 6, max: 9)(); // e.g. #0D9488
  IntColumn get monthlyLimitPaise => integer()(); // in paise
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  IntColumn get categoryId => integer().references(Categories, #id)();
  TextColumn get whereSpent => text().withLength(min: 1, max: 100)();
  IntColumn get amountPaise => integer()(); // in paise
  TextColumn get paymentMode => text().withLength(min: 1, max: 50)(); // UPI, Cash, Card, etc.
  TextColumn get note => text().nullable()();
  TextColumn get receiptPath => text().nullable()();
  TextColumn get splitExpenseId => text().nullable()(); // link to split if generated
  BoolColumn get isRecurringGenerated => boolean().withDefault(const Constant(false))();
}

class PaymentModes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

class RecurringExpenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  IntColumn get categoryId => integer().references(Categories, #id)();
  IntColumn get amountPaise => integer()();
  IntColumn get dayOfMonth => integer()(); // 1 to 31
  TextColumn get paymentMode => text().withDefault(const Constant('UPI / GPay / PhonePe'))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

class SavingsGoals extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  IntColumn get targetPaise => integer()();
  IntColumn get savedPaise => integer().withDefault(const Constant(0))();
  DateTimeColumn get deadline => dateTime().nullable()();
  TextColumn get emoji => text().withDefault(const Constant('🎯'))();
}

class Persons extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get phone => text().nullable()();
  TextColumn get avatarColor => text().withDefault(const Constant('#0D9488'))();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
}

class SplitExpenses extends Table {
  TextColumn get id => text()(); // e.g. SPL-12345
  DateTimeColumn get date => dateTime()();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  TextColumn get groupName => text().nullable()(); // e.g. Goa Trip
  IntColumn get totalAmountPaise => integer()();
  IntColumn get paidByPersonId => integer().nullable()(); // null = 'Me'
  TextColumn get splitType => text()(); // Equal, Exact, Percentage, Shares
  IntColumn get categoryId => integer().nullable()();
  TextColumn get note => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class SplitShares extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get splitExpenseId => text().references(SplitExpenses, #id, onDelete: KeyAction.cascade)();
  IntColumn get personId => integer().nullable()(); // null = 'Me'
  IntColumn get shareAmountPaise => integer()();
}

class Settlements extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  IntColumn get fromPersonId => integer().nullable()(); // null = 'Me'
  IntColumn get toPersonId => integer().nullable()(); // null = 'Me'
  IntColumn get amountPaise => integer()();
  TextColumn get mode => text().withDefault(const Constant('UPI / GPay / PhonePe'))();
  TextColumn get note => text().nullable()();
}

class AppSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userName => text().withDefault(const Constant('Student'))();
  TextColumn get currency => text().withDefault(const Constant('INR'))();
  TextColumn get themeMode => text().withDefault(const Constant('system'))(); // light, dark, system
  BoolColumn get carryForwardDefault => boolean().withDefault(const Constant(true))();
  BoolColumn get pinEnabled => boolean().withDefault(const Constant(false))();
  TextColumn get pinCode => text().nullable()();
  BoolColumn get notificationsEnabled => boolean().withDefault(const Constant(true))();
  IntColumn get reminderHour => integer().withDefault(const Constant(21))(); // 9 PM
  IntColumn get reminderMinute => integer().withDefault(const Constant(0))();
}

// ---------------------------------------------------------------------------
// DATABASE CLASS
// ---------------------------------------------------------------------------

@DriftDatabase(tables: [
  MonthlyBudgets,
  Categories,
  Expenses,
  PaymentModes,
  RecurringExpenses,
  SavingsGoals,
  Persons,
  SplitExpenses,
  SplitShares,
  Settlements,
  AppSettings,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'pocketplan_db',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    );
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
      );
}
