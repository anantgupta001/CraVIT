# 🍱 Cravit Monorepo

A *two-app Flutter monorepo* for *Cravit, bringing together the **Student App*** and *Seller App* under a clean, scalable, and maintainable structure.  
This setup enables shared logic, consistent design systems, and streamlined CI/CD pipelines across both apps.

---

## 🧭 Overview

Cravit is a platform connecting students with food vendors for seamless food discovery, ordering, and management.  
The monorepo is structured to host multiple Flutter apps and shared packages — making future development, maintenance, and scaling much easier.

---

## 🏗 Project Structure

Cravit/ ├── .editorconfig ├── .gitattributes ├── .github/ │   └── workflows/           # CI/CD configurations (coming soon) ├── apps/ │   ├── student_app/         # Flutter app for students (originally my_home_app) │   └── seller_app/          # Flutter app for vendors ├── packages/                # Shared packages (common widgets, services, utils, etc.) └── README.md

---

## 🚀 Applications

### 🎓 Student App (apps/student_app)
The *Student App* enables students to browse, order, and manage food seamlessly.

#### *Key Features*
- 🏠 *Home Page* – Explore a variety of food options.  
- 🛒 *Cart Management* – Add, remove, and update items easily.  
- ❤ *Favorites* – Mark and view favorite food items.  
- 🍽 *Mess Menu* – Check the daily or weekly menu.  
- 🔔 *Notifications* – Stay updated with offers and order statuses.  
- 👤 *Profile & Settings* – Manage personal info and preferences.  
- 🔐 *Google Sign-In* – Secure and easy authentication.  
- 💳 *Razorpay Integration* – Fast, reliable payments.  
- 🌗 *Theme Provider* – Supports light and dark mode.

---

### 🧾 Seller App (apps/seller_app)
The *Seller App* helps food vendors manage their orders and offerings.  
Currently in active development.

#### *Current Features*
- 🏠 *Home Page:*  
  Displays “Cravit Seller • Live Orders (coming soon)”.

#### *Planned Features*
- 📦 Live Orders Dashboard  
- 🔍 QR Scan / Verify  
- 🧾 Menu Management  
- 📊 Reports & Analytics  
- ⚙ Settings & Preferences

---

## 🧰 Tech Stack

| Area | Technologies |
|------|---------------|
| Framework | Flutter (Dart) |
| State Management | Provider |
| Authentication | Google Sign-In |
| Payments | Razorpay Flutter |
| UI | Material + Cupertino |
| Code Sharing | Local Flutter packages (monorepo setup) |
| CI/CD | GitHub Actions (planned) |

---

## 🧑‍💻 Getting Started

### *1️⃣ Prerequisites*
- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Android Studio or VS Code with Flutter & Dart plugins
- A connected device or emulator

---

### *2️⃣ Clone the Repository*
```bash
git clone <repository_url>
cd Cravit
```

---

### *3️⃣ Install Dependencies*

Run for each app:

```bash
cd apps/student_app && flutter pub get
cd ../seller_app && flutter pub get
```

---

### *4️⃣ Run the Apps*

Student App:

```bash
cd apps/student_app
flutter run
```

Seller App:

```bash
cd apps/seller_app
flutter run
```

To target a specific device:

```bash
flutter devices         # Lists devices
flutter run -d <device_id>
```

---

### 🧪 Development Tips

- Use `flutter pub outdated` to check for dependency updates.
- Run `flutter pub upgrade --major-versions` periodically.
- Place all shared logic, UI, and services in `/packages` for future scalability.
- Maintain code quality by using `flutter_lints` and static analysis.

---

### 🧱 Future Roadmap

✅ Setup base monorepo structure
✅ Create seller app shell
🚧 Integrate Firestore and Firebase Auth
🚧 Add shared packages for UI + networking
🚧 Implement CI/CD pipelines via GitHub Actions
🚧 Add analytics and reporting dashboards
🚧 Harden Firestore security rules per app role

---

### 🤝 Contributing

We welcome contributions!
Please open an issue for bugs, ideas, or enhancements before submitting a pull request.

Guidelines:

- Follow Flutter best practices.
- Keep commits small and descriptive.
- Format code using:

```bash
flutter format .
```

---

### 📄 License

This project is licensed under the MIT License.
(Full license text coming soon.)

---

### 💬 Contact

📧 Team Cravit
For any queries or collaboration: [to be added]

---

> Built with ❤ using Flutter
