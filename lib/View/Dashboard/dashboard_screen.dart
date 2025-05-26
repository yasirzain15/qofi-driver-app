import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qufi_driver_app/Controller/completed_orders_controller.dart';
import 'package:qufi_driver_app/Controller/ongoing_orders_controller.dart';
import 'package:qufi_driver_app/Core/Constants/app_colors.dart';
import 'package:qufi_driver_app/Model/order_model.dart';
import 'package:qufi_driver_app/Services/auth_services.dart';
import 'package:qufi_driver_app/View/login/login_screen.dart';
import 'package:qufi_driver_app/Widgets/Dashboard/ongoing_order_card.dart';
import 'package:qufi_driver_app/Widgets/Dashboard/orders_status.dart';

class DriverDashboardScreen extends StatelessWidget {
  const DriverDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _DriverDashboardContent(),
    );
  }
}

class _DriverDashboardContent extends StatefulWidget {
  @override
  State<_DriverDashboardContent> createState() =>
      _DriverDashboardContentState();
}

class _DriverDashboardContentState extends State<_DriverDashboardContent> {
  final int _selectedIndex = 1; // Default to Orders tab
  final Map<String, bool> _pickedStates = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchOrders());
  }

  Future<void> _fetchOrders() async {
    try {
      final ongoingController = context.read<OngoingOrdersController>();
      final completedController = context.read<CompletedOrdersController>();

      final String? token = await AuthService().getToken();
      print("🔹 Using Token for API Request: $token");

      if (token == null || token.isEmpty) {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
        return;
      }

      await Future.wait([
        ongoingController.fetchOngoingOrders(token),
        completedController.fetchCompletedOrders(token),
      ]);
    } catch (e) {
      debugPrint('Error fetching orders: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load orders: ${e.toString()}')),
        );

        if (e.toString().contains('401') ||
            e.toString().contains('Unauthorized')) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      }
    }
  }

  void _onPickPressed(String orderId) => setState(() {
    _pickedStates[orderId] = !(_pickedStates[orderId] ?? false);
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<OngoingOrdersController, CompletedOrdersController>(
      builder: (context, ongoing, completed, _) {
        final ongoingOrders =
            ongoing.ongoingOrders?.data.driverOrders
                .map(
                  (order) => OrderModel.fromDriverOrder(
                    order,
                    'Ongoing',
                    picked: _pickedStates[order.orderNo] ?? false,
                  ),
                )
                .toList() ??
            [];

        final completedOrders =
            completed.completedOrders
                .map(
                  (order) => OrderModel.fromCompletedOrder(
                    order,
                    'Completed',
                    picked: _pickedStates[order.orderNo] ?? false,
                  ),
                )
                .toList();

        return _buildScaffold(
          context,
          ongoing,
          completed,
          ongoingOrders,
          completedOrders,
        );
      },
    );
  }

  Scaffold _buildScaffold(
    BuildContext context,
    OngoingOrdersController ongoing,
    CompletedOrdersController completed,
    List<OrderModel> ongoingOrders,
    List<OrderModel> completedOrders,
  ) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: _buildBody(ongoing, completed, ongoingOrders, completedOrders),
    );
  }

  Widget _buildBody(
    OngoingOrdersController ongoing,
    CompletedOrdersController completed,
    List<OrderModel> ongoingOrders,
    List<OrderModel> completedOrders,
  ) {
    if (ongoing.isLoading || completed.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (ongoing.error.isNotEmpty || completed.error != null) {
      return Center(
        child: Text(
          ongoing.error.isNotEmpty ? ongoing.error : completed.error!,
        ),
      );
    }

    return _selectedIndex == 1
        ? _buildOrdersTab(ongoingOrders, completedOrders)
        : Center(
          child: Text(
            _selectedIndex == 0 ? 'Dashboard Content' : 'Settings Content',
          ),
        );
  }

  Widget _buildOrdersTab(
    List<OrderModel> ongoingOrders,
    List<OrderModel> completedOrders,
  ) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const ProfileSection(
            driverName: 'John Doe', // Replace with dynamic data
            totalOrders: 15,
            completedCount: 10,
            ongoingCount: 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              Column(
                children: [
                  Text(
                    (ongoingOrders.length + completedOrders.length).toString(),
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                  ),
                  Text("Orders", style: TextStyle(color: Colors.grey)),
                ],
              ),
              Column(
                children: [
                  Text(
                    completedOrders.length.toString(),
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                  ),
                  Text("Completed", style: TextStyle(color: Colors.grey)),
                ],
              ),
              Column(
                children: [
                  Text(
                    ongoingOrders.length.toString(),
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                  ),
                  Text("Ongoing", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),

          if (ongoingOrders.isNotEmpty) ...[
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15, top: 10, bottom: 10),
                  child: Text(
                    "Ongoing",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _fetchOrders,
                child: OrdersList(
                  orders: ongoingOrders,
                  onPickPressed: _onPickPressed,
                ),
              ),
            ),
          ] else ...[
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.assignment_outlined,
                      size: 60,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 16),
                    Text(
                      "No Ongoing Orders",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "You currently don't have any ongoing orders",
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
