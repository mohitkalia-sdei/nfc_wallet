import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_wallet/models/orders.dart';
import 'package:nfc_wallet/service/order_service.dart';

// Instantiate the OrderService
final orderServiceProvider = Provider((ref) => OrderService());

// StreamProvider for all orders
final ordersStreamProvider = StreamProvider<List<UserOrder>>((ref) {
  final orderService = ref.watch(orderServiceProvider);
  return orderService.getAllOrdersStream();
});

// StreamProvider for a single order by ID
final orderStreamProvider = StreamProvider.family<UserOrder?, String>((ref, orderId) {
  final orderService = ref.watch(orderServiceProvider);
  return orderService.getOrderStreamById(orderId);
});
