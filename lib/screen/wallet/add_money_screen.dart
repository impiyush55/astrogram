import 'package:flutter/material.dart';
import '../../helper/color.dart';
import '../../services/auth_service.dart';
import 'payment_info_screen.dart';

class AddMoneyScreen extends StatefulWidget {
  const AddMoneyScreen({super.key});

  @override
  State<AddMoneyScreen> createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen> {
  final TextEditingController _amountController = TextEditingController();
  int _selectedOfferIndex = -1;

  final List<Map<String, dynamic>> _offers = [
    {"amount": 10, "extra": "100% Extra"},
    {"amount": 50, "extra": "100% Extra", "popular": true},
    {"amount": 100, "extra": "100% Extra"},
    {"amount": 200, "extra": "50% Extra"},
    {"amount": 500, "extra": "50% Extra"},
    {"amount": 1000, "extra": "5% Extra"},
    {"amount": 2000, "extra": "10% Extra"},
    {"amount": 3000, "extra": "10% Extra"},
    {"amount": 4000, "extra": "12% Extra"},
    {"amount": 8000, "extra": "12% Extra"},
    {"amount": 15000, "extra": "15% Extra"},
    {"amount": 20000, "extra": "15% Extra"},
    {"amount": 50000, "extra": "20% Extra"},
    {"amount": 100000, "extra": "20% Extra"},
  ];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _proceedToPayment() {
    final amountText = _amountController.text.trim();
    if (amountText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter or select an amount")),
      );
      return;
    }
    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentInfoScreen(rechargeAmount: amount),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : Colors.grey.shade50,
      appBar: AppBar(
        title: const Text("Add Money to Wallet"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.goldAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.goldAccent.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.account_balance_wallet,
                  size: 16,
                  color: AppColors.goldAccent,
                ),
                const SizedBox(width: 6),
                Text(
                  "₹${AuthService.userWalletBalance.toStringAsFixed(0)}",
                  style: const TextStyle(
                    color: AppColors.goldAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Enter Amount",
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkCard : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isDark
                                  ? AppColors.darkBorder
                                  : Colors.grey.shade300,
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            onChanged: (val) {
                              setState(() => _selectedOfferIndex = -1);
                            },
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                            decoration: InputDecoration(
                              hintText: "Enter amount",
                              hintStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                                color: theme.colorScheme.onSurface.withOpacity(
                                  0.3,
                                ),
                              ),
                              prefixIcon: Icon(
                                Icons.currency_rupee,
                                color: AppColors.goldAccent,
                                size: 28,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      _quickAddChip("+ ₹100", 100),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildPromoBanner(isDark),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Trending Offers",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "${_offers.length} Offers Available",
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.goldAccent.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildOffersGrid(isDark),
                ],
              ),
            ),
          ),
          _buildProceedButton(isDark),
        ],
      ),
    );
  }

  Widget _quickAddChip(String label, double val) {
    return InkWell(
      onTap: () {
        final current = double.tryParse(_amountController.text) ?? 0;
        _amountController.text = (current + val).toStringAsFixed(0);
        setState(() => _selectedOfferIndex = -1);
      },
      child: Container(
        height: 54,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.goldAccent.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.goldAccent.withOpacity(0.3)),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.goldAccent,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPromoBanner(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.orange.withOpacity(0.2),
            Colors.orange.withOpacity(0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.orange, Colors.deepOrange],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.flash_on, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "UNMISSABLE OFFER",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                    color: Colors.orange.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Get extra real balance on every recharge!",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOffersGrid(bool isDark) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.25,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _offers.length,
      itemBuilder: (context, index) {
        final offer = _offers[index];
        final bool isPopular = offer['popular'] ?? false;
        final bool isSelected = _selectedOfferIndex == index;

        return InkWell(
          onTap: () {
            setState(() {
              _selectedOfferIndex = index;
              _amountController.text = offer['amount'].toString();
            });
          },
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.goldAccent.withOpacity(0.08)
                  : (isDark ? AppColors.darkCard : Colors.white),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? AppColors.goldAccent
                    : (isPopular
                          ? AppColors.goldAccent.withOpacity(0.4)
                          : (isDark
                                ? AppColors.darkBorder
                                : Colors.grey.shade200)),
                width: isSelected ? 2.5 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.goldAccent.withOpacity(0.2),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  if (isSelected)
                    Positioned(
                      top: -20,
                      right: -20,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.goldAccent.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  if (isPopular)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.orange, Colors.deepOrange],
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                          ),
                        ),
                        child: const Text(
                          "POPULAR",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "₹${offer['amount']}",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? AppColors.goldAccent : null,
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.green.withOpacity(0.2),
                            ),
                          ),
                          child: Text(
                            offer['extra'],
                            style: const TextStyle(
                              color: Color(0xFF4CAF50),
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProceedButton(bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFFF4C430), Color(0xFFFFD700)],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.goldAccent.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _proceedToPayment,
            borderRadius: BorderRadius.circular(16),
            child: const Center(
              child: Text(
                "Continue to Payment",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
