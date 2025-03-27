import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  List transactions = [];

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  fetchTransactions() async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:8000/transactions'));
    if (response.statusCode == 200) {
      setState(() {
        transactions = json.decode(response.body)['transactions'];
      });
    } else {
      throw Exception('Failed to load transactions');
    }
  }

  addTransaction(String description, double amount) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/add_transaction'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'description': description,
        'amount': amount,
      }),
    );

    if (response.statusCode == 200) {
      fetchTransactions(); // Refresh the transactions list
    } else {
      throw Exception('Failed to add transaction');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Money Tracking'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AddTransactionDialog(onAdd: addTransaction);
                },
              );
            },
            child: Text('Add Transaction'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                var transaction = transactions[index];
                return ListTile(
                  title: Text(transaction[1]), // Description
                  subtitle: Text('Amount: \$${transaction[2]}'), // Amount
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AddTransactionDialog extends StatefulWidget {
  final Function(String, double) onAdd;

  const AddTransactionDialog({super.key, required this.onAdd});

  @override
  // ignore: library_private_types_in_public_api
  _AddTransactionDialogState createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog> {
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Transaction'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(hintText: 'Description'),
          ),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: 'Amount'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.onAdd(
              _descriptionController.text,
              double.parse(_amountController.text),
            );
            Navigator.pop(context);
          },
          child: Text('Add'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
