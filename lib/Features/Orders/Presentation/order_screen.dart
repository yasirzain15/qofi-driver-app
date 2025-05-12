import 'package:flutter/material.dart';
import 'package:qufi_driver_app/Core/Constants/app_colors.dart';
import 'widgets/order_card.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          title: const Text(
            'Orders',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          bottom: const TabBar(
            labelColor: AppColors.text,
            unselectedLabelColor: AppColors.subText,
            indicatorColor: AppColors.primary,
            tabs: [Tab(text: 'Ongoing'), Tab(text: 'Completed')],
          ),
        ),
        body: const TabBarView(
          children: [
            OrderList(status: 'Picked'),
            OrderList(status: 'Completed'),
          ],
        ),
      ),
    );
  }
}

class OrderList extends StatelessWidget {
  final String status;

  const OrderList({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        OrderCard(
          orderNumber: '#1234',
          name: 'James Smith',
          address: 'COD Main St',
          status: status,
        ),
        const SizedBox(height: 12),
        OrderCard(
          orderNumber: '#1232',
          name: 'Meilly Johnson',
          address: '456 Elm St',
          status: status,
        ),
      ],
    );
  }
}
