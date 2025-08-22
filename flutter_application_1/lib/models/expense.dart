import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

final _formatter = DateFormat.yMd();
final _uuid = Uuid();

enum Category { food, travel, leisure, work }

enum Recurrence { none, daily, weekly, monthly, yearly }

const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.flight,
  Category.leisure: Icons.water,
  Category.work: Icons.work,
};

class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    this.currency = 'USD',
    this.recurrence = Recurrence.none,
    this.tags = const [],
  }) : id = _uuid.v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;
  final String currency;
  final Recurrence recurrence;
  final List<String> tags;

  String get formattedDate => _formatter.format(date);

  String get formattedAmount =>
      NumberFormat.currency(symbol: currency).format(amount);
}

class ExpenseBucket {
  const ExpenseBucket({required this.expenses, required this.category});

  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      : expenses = allExpenses.where((e) => e.category == category).toList();

  final Category category;
  final List<Expense> expenses;

  double get totalExpenses =>
      expenses.fold(0, (sum, expense) => sum + expense.amount);

  double totalForMonth(int year, int month) {
    return expenses
        .where((e) => e.date.year == year && e.date.month == month)
        .fold(0, (sum, e) => sum + e.amount);
  }

  double totalForWeek(int year, int weekNumber) {
    return expenses
        .where((e) {
          final weekOfYear = int.parse(DateFormat('w').format(e.date));
          return e.date.year == year && weekOfYear == weekNumber;
        })
        .fold(0, (sum, e) => sum + e.amount);
  }
}

class CategoryBudget {
  final Category category;
  final double limit;

  CategoryBudget({required this.category, required this.limit});

  bool isOverLimit(List<Expense> expenses) {
    final spent = expenses
        .where((e) => e.category == category)
        .fold(0.0, (sum, e) => sum + e.amount);
    return spent > limit;
  }
}

extension ExpenseListUtils on List<Expense> {
  List<Expense> sortByAmount() =>
      [...this]..sort((a, b) => b.amount.compareTo(a.amount));

  List<Expense> sortByDate() =>
      [...this]..sort((a, b) => b.date.compareTo(a.date));

  List<Expense> filterByTag(String tag) =>
      where((e) => e.tags.contains(tag)).toList();
}