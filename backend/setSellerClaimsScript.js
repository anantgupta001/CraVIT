// backend/setSellerClaimsScript.js
const admin = require('firebase-admin');
const path = require('path');
const readline = require('readline');

// Initialize Firebase Admin SDK using the service account key
const serviceAccountPath = path.resolve(__dirname, 'serviceAccountKey.json');
admin.initializeApp({
  credential: admin.credential.cert(serviceAccountPath)
});

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

function askQuestion(query) {
  return new Promise(resolve => rl.question(query, resolve));
}

async function setClaims() {
  try {
    console.log("Setting custom claims for a seller user.");
    const uid = await askQuestion("Enter the UID of the seller user: ");
    const vendorId = await askQuestion("Enter the Vendor ID for this seller (e.g., demo_vendor_1): ");

    if (!uid || !vendorId) {
      console.error("UID and Vendor ID cannot be empty. Please try again.");
      rl.close();
      return;
    }

    await admin.auth().setCustomUserClaims(uid, { role: "seller", vendorId: vendorId });
    console.log(`Successfully set custom claims for user ${uid}: { "role": "seller", "vendorId": "${vendorId}" }`);

    // Verify the claims (optional)
    const user = await admin.auth().getUser(uid);
    console.log("Verified claims:", user.customClaims);

  } catch (error) {
    console.error("Error setting custom claims:", error);
  } finally {
    rl.close();
  }
}

setClaims();