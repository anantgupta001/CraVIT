"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.setSellerClaims = exports.completeOrder = exports.markReady = exports.acceptOrder = exports.onOrderStatusUpdateNotifyStudent = exports.onOrderCreateNotifySeller = void 0;
const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
const db = admin.firestore();
// Helper function to generate a 6-digit pickup code
function genPickupCode() {
    return Math.floor(100000 + Math.random() * 900000).toString().padStart(6, '0');
}
// 1a) onOrderCreateNotifySeller (Firestore trigger)
exports.onOrderCreateNotifySeller = functions.firestore
    .document("orders/{orderId}")
    .onCreate(async (snap, context) => {
    const order = snap.data();
    if (!order)
        return;
    const vendorId = order.vendorId;
    const orderId = order.id;
    const amount = order.amount;
    functions.logger.info(`New order ${orderId} for vendor ${vendorId}`);
    try {
        await admin.messaging().sendToTopic(`vendor_${vendorId}`, {
            data: {
                type: "new_order",
                orderId: orderId,
                vendorId: vendorId,
                amount: amount ? amount.toString() : "0", // FCM data payload values must be strings
            },
        });
        functions.logger.info(`FCM sent to vendor_${vendorId} for order ${orderId}`);
    }
    catch (error) {
        functions.logger.error(`Failed to send FCM for new order ${orderId}:`, error);
    }
});
// 1b) onOrderStatusUpdateNotifyStudent (Firestore trigger)
exports.onOrderStatusUpdateNotifyStudent = functions.firestore
    .document("orders/{orderId}")
    .onUpdate(async (change, context) => {
    const before = change.before.data();
    const after = change.after.data();
    if (!before || !after || before.status === after.status)
        return;
    if (after.status === "ready") {
        let pickupCode = after.pickupCode;
        if (!pickupCode) {
            // Generate pickup code if missing and write back atomically
            pickupCode = genPickupCode();
            await db.collection("orders").doc(after.id).update({
                pickupCode: pickupCode,
                readyAt: admin.firestore.FieldValue.serverTimestamp(),
            });
            functions.logger.info(`Generated pickup code ${pickupCode} for order ${after.id}`);
        }
        const fcmToken = after.fcmToken;
        if (fcmToken) {
            try {
                await admin.messaging().sendToDevice(fcmToken, {
                    data: {
                        type: "order_ready",
                        orderId: after.id,
                        pickupCode: pickupCode || "",
                        vendorId: after.vendorId,
                    },
                });
                functions.logger.info(`FCM sent to student for order ${after.id}`);
            }
            catch (error) {
                functions.logger.error(`Failed to send FCM to student for order ${after.id}:`, error);
            }
        }
        else {
            functions.logger.warn(`No FCM token for student of order ${after.id}. Skipping notification.`);
        }
    }
});
// 1c) acceptOrder (Callable HTTPS)
exports.acceptOrder = functions.https.onCall(async (data, context) => {
    // 1. Auth check
    if (!context.auth || context.auth.token.role !== "seller" || context.auth.token.vendorId === undefined) {
        throw new functions.https.HttpsError("unauthenticated", "User is not authenticated or not a seller with a vendor ID.");
    }
    const { orderId } = data;
    if (!orderId) {
        throw new functions.https.HttpsError("invalid-argument", "Order ID is required.");
    }
    const vendorIdFromToken = context.auth.token.vendorId;
    return db.runTransaction(async (transaction) => {
        const orderRef = db.collection("orders").doc(orderId);
        const orderDoc = await transaction.get(orderRef);
        if (!orderDoc.exists) {
            throw new functions.https.HttpsError("not-found", "Order not found.");
        }
        const order = orderDoc.data();
        if ((order === null || order === void 0 ? void 0 : order.vendorId) !== vendorIdFromToken) {
            throw new functions.https.HttpsError("permission-denied", "Access denied. Seller does not own this order.");
        }
        // Preconditions
        if (order.status !== "placed" && order.status !== "accepted") {
            throw new functions.https.HttpsError("failed-precondition", "Order is not in 'placed' or 'accepted' status.");
        }
        // Update status
        transaction.update(orderRef, {
            status: "accepted",
            acceptedAt: admin.firestore.FieldValue.serverTimestamp(),
        });
        functions.logger.info(`Order ${orderId} accepted by vendor ${vendorIdFromToken}`);
        return { success: true };
    });
});
// 1d) markReady (Callable HTTPS)
exports.markReady = functions.https.onCall(async (data, context) => {
    // 1. Auth check
    if (!context.auth || context.auth.token.role !== "seller" || context.auth.token.vendorId === undefined) {
        throw new functions.https.HttpsError("unauthenticated", "User is not authenticated or not a seller with a vendor ID.");
    }
    const { orderId } = data;
    if (!orderId) {
        throw new functions.https.HttpsError("invalid-argument", "Order ID is required.");
    }
    const vendorIdFromToken = context.auth.token.vendorId;
    return db.runTransaction(async (transaction) => {
        const orderRef = db.collection("orders").doc(orderId);
        const orderDoc = await transaction.get(orderRef);
        if (!orderDoc.exists) {
            throw new functions.https.HttpsError("not-found", "Order not found.");
        }
        const order = orderDoc.data();
        if ((order === null || order === void 0 ? void 0 : order.vendorId) !== vendorIdFromToken) {
            throw new functions.https.HttpsError("permission-denied", "Access denied. Seller does not own this order.");
        }
        // Preconditions
        if (order.status !== "accepted") {
            throw new functions.https.HttpsError("failed-precondition", "Order is not in 'accepted' status.");
        }
        let pickupCode = order.pickupCode;
        if (!pickupCode) {
            pickupCode = genPickupCode();
        }
        // Update status
        transaction.update(orderRef, {
            status: "ready",
            pickupCode: pickupCode,
            readyAt: admin.firestore.FieldValue.serverTimestamp(),
        });
        functions.logger.info(`Order ${orderId} marked ready by vendor ${vendorIdFromToken} with code ${pickupCode}`);
        return { pickupCode: pickupCode }; // Return the pickupCode for UI
    });
});
// 1e) completeOrder (Callable HTTPS)
exports.completeOrder = functions.https.onCall(async (data, context) => {
    // 1. Auth check
    if (!context.auth || context.auth.token.role !== "seller" || context.auth.token.vendorId === undefined) {
        throw new functions.https.HttpsError("unauthenticated", "User is not authenticated or not a seller with a vendor ID.");
    }
    const { orderId, pickupCode } = data;
    if (!orderId || !pickupCode) {
        throw new functions.https.HttpsError("invalid-argument", "Order ID and pickup code are required.");
    }
    const vendorIdFromToken = context.auth.token.vendorId;
    return db.runTransaction(async (transaction) => {
        const orderRef = db.collection("orders").doc(orderId);
        const orderDoc = await transaction.get(orderRef);
        if (!orderDoc.exists) {
            throw new functions.https.HttpsError("not-found", "Order not found.");
        }
        const order = orderDoc.data();
        if ((order === null || order === void 0 ? void 0 : order.vendorId) !== vendorIdFromToken) {
            throw new functions.https.HttpsError("permission-denied", "Access denied. Seller does not own this order.");
        }
        // Verify pickupCode
        if (order.pickupCode !== pickupCode) {
            throw new functions.https.HttpsError("failed-precondition", "Invalid pickup code.");
        }
        // Preconditions
        if (order.status !== "ready") {
            throw new functions.https.HttpsError("failed-precondition", "Order is not in 'ready' status.");
        }
        // Update status
        transaction.update(orderRef, {
            status: "completed",
            completedAt: admin.firestore.FieldValue.serverTimestamp(),
        });
        functions.logger.info(`Order ${orderId} completed by vendor ${vendorIdFromToken}`);
        return { success: true };
    });
});
// 1f) Admin utility to set custom claims
const ADMIN_UDS = ["JntE2mlRJIR1VtbAoLda3JSDYG92", "YOUR_ADMIN_UID_2"]; // TODO: Replace with actual admin UIDs
exports.setSellerClaims = functions.https.onCall(async (data, context) => {
    // Auth check - only allowed for specific admin UIDs
    if (!context.auth || !ADMIN_UDS.includes(context.auth.uid)) {
        throw new functions.https.HttpsError("permission-denied", "Only authorized administrators can set custom claims.");
    }
    const { uid, vendorId } = data;
    if (!uid || !vendorId) {
        throw new functions.https.HttpsError("invalid-argument", "UID and vendorId are required to set seller claims.");
    }
    try {
        await admin.auth().setCustomUserClaims(uid, { role: "seller", vendorId: vendorId });
        functions.logger.info(`Custom claims set for user ${uid}: { role: "seller", vendorId: "${vendorId}" } by admin ${context.auth.uid}`);
        return { status: "success" };
    }
    catch (error) {
        functions.logger.error(`Failed to set custom claims for user ${uid}:`, error);
        throw new functions.https.HttpsError("internal", "Failed to set custom claims.", error);
    }
});
//# sourceMappingURL=index.js.map