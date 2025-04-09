import 'package:flutter/material.dart';

class TopUpScreen extends StatefulWidget {
  @override
  _TopUpScreenState createState() => _TopUpScreenState();
}

class _TopUpScreenState extends State<TopUpScreen> {
  // Fixed balance for display purposes - this won't change during top-ups
  final double displayBalance = 500.0;
  
  void _handleTopUp(double amount) {
    // Show success message without changing the balance display
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Top-up of \$${amount.toStringAsFixed(2)} successful!"),
        backgroundColor: Colors.green,
      ),
    );
    
    // In a real app, you would update a global state or send to backend
    // Instead of updating local state which causes UI movement
  }

  Widget _buildTransferOption(String title, IconData icon, Color iconColor) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 28),
            SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(String title, {bool showArrow = true}) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade800, width: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            if (showArrow) Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Color(0xFF1A237E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Unified AppBar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      'ADD MONEY',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 48), // Placeholder to balance layout
                  ],
                ),
              ),

              // Account Balance Card - Now Fixed and Won't Change
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.indigo.shade900, Colors.deepPurple.shade900],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Balance',
                        style: TextStyle(
                          color: Colors.grey.shade300,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '\$${displayBalance.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Available for transfers',
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 14,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '\$${(displayBalance * 0.9).toStringAsFixed(2)}',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Up Section - Now with fixed display balance
                      TopUpSection(
                        onTopUp: _handleTopUp,
                      ),
                      
                      SizedBox(height: 20),
                      
                      // Transfer Options Grid
                      Text(
                        'More Options',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 16),
                      GridView.count(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 1.3,
                        children: [
                          _buildTransferOption('Withdraw', Icons.upload, Colors.orange),
                          _buildTransferOption('Recurring deposits', Icons.refresh, Colors.blue),
                          _buildTransferOption('Direct deposits', Icons.account_balance, Colors.purple),
                          _buildTransferOption('Transfer Limits', Icons.settings, Colors.teal),
                        ],
                      ),

                      SizedBox(height: 30),
                      
                      // Transfer options list
                      Text(
                        'Additional Services',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 16),
                      _buildListItem('Transfer accounts in'),
                      _buildListItem('Send a wire transfer'),
                      _buildListItem('Manage payment methods'),
                      
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// TopUpSection component - Modified to not depend on balance display
class TopUpSection extends StatefulWidget {
  final Function(double) onTopUp;

  const TopUpSection({
    Key? key,
    required this.onTopUp,
  }) : super(key: key);

  @override
  _TopUpSectionState createState() => _TopUpSectionState();
}

class _TopUpSectionState extends State<TopUpSection> {
  final TextEditingController _amountController = TextEditingController();
  final List<double> _quickAmounts = [10.0, 25.0, 50.0, 100.0];
  double? _selectedAmount;

  void _processTopUp() {
    double? amount = _selectedAmount ?? double.tryParse(_amountController.text);
    if (amount != null && amount > 0) {
      widget.onTopUp(amount);
      _amountController.clear();
      setState(() {
        _selectedAmount = null;
      });
      // Success notification will be shown by parent
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please enter a valid amount."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 20),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Money to Your Account',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            
            // Quick amount selection
            Text(
              'Quick Amount',
              style: TextStyle(
                color: Colors.grey.shade300,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _quickAmounts.map((amount) {
                bool isSelected = _selectedAmount == amount;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAmount = isSelected ? null : amount;
                      if (!isSelected) {
                        _amountController.clear();
                      }
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? Colors.indigo.shade700 
                          : Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(10),
                      border: isSelected
                          ? Border.all(color: Colors.indigo.shade400, width: 1.5)
                          : null,
                    ),
                    child: Text(
                      '\$${amount.toStringAsFixed(0)}',
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey.shade300,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            
            SizedBox(height: 24),
            Text(
              'Custom Amount',
              style: TextStyle(
                color: Colors.grey.shade300,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade700, width: 0.5),
              ),
              child: TextField(
                controller: _amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                style: TextStyle(color: Colors.white),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      _selectedAmount = null;
                    });
                  }
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.attach_money, color: Colors.grey.shade400),
                  hintText: 'Enter amount',
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
            
            SizedBox(height: 24),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _processTopUp,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    'Add Funds',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            
            SizedBox(height: 16),
            Divider(color: Colors.grey.shade700),
            SizedBox(height: 16),
            
            // Payment methods section
            Row(
              children: [
                Icon(Icons.credit_card, color: Colors.grey.shade400),
                SizedBox(width: 12),
                Text(
                  'Payment Methods',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Spacer(),
                Icon(Icons.chevron_right, color: Colors.grey.shade400),
              ],
            ),
          ],
        ),
      ),
    );
  }
}