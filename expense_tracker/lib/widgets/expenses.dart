import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final String _expensesKey = 'expenses_key'; // Key for SharedPreferences

  @override
  void initState() {
    super.initState();
    _loadExpenses(); // Load expenses when the app starts
  }

  // Load expenses from SharedPreferences
  Future<void> _loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final expensesData = prefs.getString(_expensesKey);

    if (expensesData != null) {
      final List<Map<String, dynamic>> expenseMaps =
          List<Map<String, dynamic>>.from(json.decode(expensesData));
      final expenses = expenseMaps.map((map) => Expense.fromJson(map)).toList();

      setState(() {
        _registeredExpenses.addAll(expenses);
      });
    }
  }

  // Save expenses to SharedPreferences
  Future<void> _saveExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final expensesData = json.encode(
        _registeredExpenses.map((expense) => expense.toJson()).toList());

    await prefs.setString(_expensesKey, expensesData);
  }

 
  



  final List<Expense> _registeredExpenses = [
    // Expense(
    //     title: 'Flutter Course',
    //     amount: 19.99,
    //     date: DateTime.now(),
    //     category: Category.work),
    // Expense(
    //     title: 'Cinema',
    //     amount: 15.69,
    //     date: DateTime.now(),
    //     category: Category.leisure),
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
        useSafeArea: true,
        context: context,
        builder: (ctx) => NewExpense(onAddExpense: _addExpense),
        isScrollControlled: true);
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
      _saveExpenses(); // Save expenses when the widget is updated
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
      _saveExpenses(); // Save expenses when the widget is updated
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${expense.title} removed'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    Widget mainContent = const Center(
      child: Text('No expenses found. Start adding some!'),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses Tracker'),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: width < 600
          ? Column(
              children: [
                Chart(expenses: _registeredExpenses),
                Expanded(
                  child: mainContent,
                )
              ],
            )
          : Row(children: [
              Expanded(child: Chart(expenses: _registeredExpenses)),
              Expanded(
                child: mainContent,
              )
            ]),
    );
  }
}
