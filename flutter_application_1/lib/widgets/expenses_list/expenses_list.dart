import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/expense.dart';
import 'package:flutter_application_1/widgets/expenses_list/expense_item.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList({
    super.key,
    required this.expenses,
    required this.onRemoveExpense,
  });

  final List<Expense> expenses;
  final void Function(Expense expense) onRemoveExpense;

  @override
  Widget build(BuildContext context) {
    final cardMargin = Theme.of(context).cardTheme.margin ?? EdgeInsets.zero;

    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        final expense = expenses[index];

        return Dismissible(
          key: ValueKey(expense),
          background: Container(
            color: Theme.of(context).colorScheme.error.withOpacity(0.8),
            margin: EdgeInsets.symmetric(horizontal: cardMargin.horizontal),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (_) => onRemoveExpense(expense),
          child: ExpenseItem(expense),
        );
      },
    );
  }
}
