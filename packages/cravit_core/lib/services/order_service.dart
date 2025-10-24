import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:cravit_core/core/firestore_paths.dart';
import 'package:cravit_core/models/order.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<AppOrder>> streamOrdersForVendor(String vendorId, {List<String>? statuses}) {
    Query query = _firestore.collection(FirestorePaths.orders()).where('vendorId', isEqualTo: vendorId);

    if (statuses != null && statuses.isNotEmpty) {
      query = query.where('status', whereIn: statuses);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => AppOrder.fromJson(doc.data() as Map<String, dynamic>..['id'] = doc.id)).toList();
    });
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    await _firestore.collection(FirestorePaths.orders()).doc(orderId).update({'status': newStatus});
  }

  Future<void> acceptOrder(String orderId) async {
    try {
      await _functions.httpsCallable('acceptOrder').call({'orderId': orderId});
    } on FirebaseFunctionsException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<String> markReady(String orderId) async {
    try {
      final HttpsCallableResult result = await _functions.httpsCallable('markReady').call({'orderId': orderId});
      return result.data['pickupCode'] as String;
    } on FirebaseFunctionsException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> completeOrder(String orderId, String pickupCode) async {
    try {
      await _functions.httpsCallable('completeOrder').call({'orderId': orderId, 'pickupCode': pickupCode});
    } on FirebaseFunctionsException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> createOrder({
    required String vendorId,
    required List<Map<String, dynamic>> items,
    required double totalAmount,
    String? fcmToken,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("User not logged in.");
    }

    final orderData = {
      'userId': user.uid,
      'vendorId': vendorId,
      'items': items,
      'totalAmount': totalAmount,
      'status': 'placed',
      'createdAt': FieldValue.serverTimestamp(),
      if (fcmToken != null) 'fcmToken': fcmToken,
    };

    await _firestore.collection(FirestorePaths.orders()).add(orderData);
  }
}
