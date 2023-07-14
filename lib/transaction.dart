import 'package:flutter/material.dart';

class MyTransaction extends StatelessWidget {
  final String transactionName;
  final String money;
  final String expenseOrIncome;

  MyTransaction({
    required this.transactionName,
    required this.money,
    required this.expenseOrIncome,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.all(15),
          color: Colors.grey[100],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.grey[600]),
                    child: Center(
                      child: Icon(
                        Icons.currency_rupee,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(transactionName,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      )),
                ],
              ),
              Text(
                (expenseOrIncome == 'Expense' ? '-' : '+') + '\₹' + money,
                style: TextStyle(
                  //fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color:
                      expenseOrIncome == 'Expense' ? Colors.red[800] : Colors.green[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
