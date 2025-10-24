class FirestorePaths {
  static String orders() => 'orders';
  static String orderDoc(String orderId) => 'orders/$orderId';
  static String vendors() => 'vendors';
  static String vendorDoc(String vendorId) => 'vendors/$vendorId';
}
