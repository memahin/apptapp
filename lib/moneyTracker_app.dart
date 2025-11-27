import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Entry Point
void main() {
  runApp(const MoneyTrackerApp());
}

class MoneyTrackerApp extends StatelessWidget {
  const MoneyTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F1115),
        primaryColor: const Color(0xFF34D399),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF34D399),
          surface: Color(0xFF1C1E26),
        ),
      ),
      home: const TrackerHome(),
    );
  }
}

class TrackerHome extends StatefulWidget {
  const TrackerHome({super.key});

  @override
  State<TrackerHome> createState() => _TrackerHomeState();
}

class _TrackerHomeState extends State<TrackerHome> {
  // --- State & Data ---
  final List<Transaction> _transactions = [];

  double get _totalIncome => _transactions
      .where((t) => !t.isExpense)
      .fold(0.0, (sum, item) => sum + item.amount);

  double get _totalExpense => _transactions
      .where((t) => t.isExpense)
      .fold(0.0, (sum, item) => sum + item.amount);

  double get _balance => _totalIncome - _totalExpense;

  // --- Logic ---
  void _addNewTransaction(String title, double amount, bool isExpense) {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: title,
      amount: amount,
      isExpense: isExpense,
      date: DateTime.now(),
    );

    setState(() {
      _transactions.insert(0, newTx);
    });
    Navigator.pop(context);
  }

  void _deleteTransaction(String id) {
    final index = _transactions.indexWhere((tx) => tx.id == id);
    final deletedItem = _transactions[index];

    setState(() {
      _transactions.removeAt(index);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF1C1E26),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Text('Record deleted: ${deletedItem.title}', style: const TextStyle(color: Colors.white)),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: const Color(0xFF34D399),
          onPressed: () {
            setState(() {
              _transactions.insert(index, deletedItem);
            });
          },
        ),
      ),
    );
  }

  // --- UI: Add Transaction Modal ---
  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF1C1E26),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          padding: EdgeInsets.only(
            top: 25,
            left: 25,
            right: 25,
            bottom: MediaQuery.of(context).viewInsets.bottom + 25,
          ),
          child: NewTransactionForm(onSubmit: _addNewTransaction),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      backgroundColor: const Color(0xFF0F1115),
      appBar: AppBar(
        title: const Text('Money Tracker-Expense & Budget'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context, rootNavigator: true).maybePop(),
        ),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: Column(
        children: [
          // 1. Minimal Balance Card
          _buildBalanceCard(),

          // 2. Section Header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Transactions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text('See All', style: TextStyle(color: Colors.white.withOpacity(0.5))),
                ),
              ],
            ),
          ),

          // 3. Clean List
          Expanded(
            child: _transactions.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: _transactions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (ctx, index) {
                return _buildTransactionItem(_transactions[index]);
              },
            ),
          ),
        ],
      ),

      // Minimal FAB
      floatingActionButton: FloatingActionButton(
        onPressed: () => _startAddNewTransaction(context),
        backgroundColor: const Color(0xFF34D399),
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1E26), // Clean Dark Surface
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          const Text(
            'Total Balance',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            '\$${_balance.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSimpleSummary(
                label: 'Income',
                amount: _totalIncome,
                color: const Color(0xFF34D399),
                icon: Icons.arrow_downward,
              ),
              Container(width: 1, height: 30, color: Colors.white10),
              _buildSimpleSummary(
                label: 'Expense',
                amount: _totalExpense,
                color: Colors.redAccent,
                icon: Icons.arrow_upward,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleSummary({required String label, required double amount, required Color color, required IconData icon}) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '\$${amount.toStringAsFixed(0)}',
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.account_balance_wallet_outlined,
              size: 60, color: Colors.white.withOpacity(0.1)),
          const SizedBox(height: 16),
          Text(
            'No Data',
            style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(Transaction tx) {
    return Dismissible(
      key: ValueKey(tx.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => _deleteTransaction(tx.id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(Icons.delete_outline, color: Colors.red[300]),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1E26),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: tx.isExpense
                    ? Colors.red.withOpacity(0.1)
                    : const Color(0xFF34D399).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                tx.isExpense ? Icons.shopping_bag_outlined : Icons.attach_money,
                color: tx.isExpense ? Colors.redAccent : const Color(0xFF34D399),
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tx.title,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${tx.date.day}/${tx.date.month} • ${tx.date.hour}:${tx.date.minute.toString().padLeft(2, '0')}",
                    style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12),
                  ),
                ],
              ),
            ),
            Text(
              '${tx.isExpense ? "-" : "+"}\$${tx.amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: tx.isExpense ? Colors.white : const Color(0xFF34D399),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Data Models & Forms ---

class Transaction {
  final String id;
  final String title;
  final double amount;
  final bool isExpense;
  final DateTime date;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.isExpense,
    required this.date,
  });
}

class NewTransactionForm extends StatefulWidget {
  final Function(String, double, bool) onSubmit;

  const NewTransactionForm({super.key, required this.onSubmit});

  @override
  State<NewTransactionForm> createState() => _NewTransactionFormState();
}

class _NewTransactionFormState extends State<NewTransactionForm> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  bool _isExpense = true;

  void _submitData() {
    if (_amountController.text.isEmpty) return;
    final enteredTitle = _titleController.text.isEmpty ? "Untitled" : _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredAmount <= 0) return;

    widget.onSubmit(enteredTitle, enteredAmount, _isExpense);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'New Transaction',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            IconButton(
              icon: Icon(Icons.close, color: Colors.white.withOpacity(0.5)),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ),
        const SizedBox(height: 20),

        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              _buildTypeBtn('Income', false),
              _buildTypeBtn('Expense', true),
            ],
          ),
        ),
        const SizedBox(height: 20),

        TextField(
          controller: _titleController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Description',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _amountController,
          style: const TextStyle(color: Colors.white),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            hintText: 'Amount',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
            prefixText: '\$ ',
            prefixStyle: const TextStyle(color: Colors.white),
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _submitData,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF34D399),
              foregroundColor: Colors.black,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _buildTypeBtn(String label, bool isExpenseBtn) {
    final isSelected = _isExpense == isExpenseBtn;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isExpense = isExpenseBtn;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? (isExpenseBtn ? Colors.redAccent : const Color(0xFF34D399))
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white.withOpacity(0.5),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}