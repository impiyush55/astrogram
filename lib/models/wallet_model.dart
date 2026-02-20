class WalletTransaction {
  final String id;
  final String type; // 'CREDIT' or 'DEBIT'
  final double amount;
  final String description;
  final String date;
  final String status; // 'SUCCESS', 'FAILED', 'PENDING'

  WalletTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.date,
    required this.status,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    return WalletTransaction(
      id: json['id']?.toString() ?? '',
      type: json['type'] ?? 'DEBIT',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] ?? '',
      date: json['date'] ?? '',
      status: json['status'] ?? 'SUCCESS',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'description': description,
      'date': date,
      'status': status,
    };
  }
}

class WalletBalance {
  final double balance;
  final String userId;

  WalletBalance({required this.balance, required this.userId});

  factory WalletBalance.fromJson(Map<String, dynamic> json) {
    return WalletBalance(
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      userId: json['userId']?.toString() ?? '',
    );
  }
}
