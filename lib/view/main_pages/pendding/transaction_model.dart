class Transaction {
  final String title;
  final double amount;
  final DateTime date;

  Transaction({required this.title, required this.amount, required this.date});
}
 class TransactionList {
  List<Transaction> transactions = [];
   void addTransaction(Transaction transaction) {
    transactions.add(transaction);
  }

 

  // Các phương thức khác để quản lý giao dịch
}