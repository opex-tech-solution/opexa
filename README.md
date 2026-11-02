# OpexA Mobile Application

OpexA is a mobile learning platform designed to help students identify knowledge gaps, build core skills block by block, and track their academic growth.

This repository contains the complete Flutter implementation for the OpexA mobile application, including splash screen animations, onboarding flows, school/home registration paths, authentication, and custom theming.

## 🎨 Features & Highlights

* **Custom Animated Splash Screen:** Smooth fade-in, scale, and slide transitions using Flutter's `AnimationController`.

* **Interactive Onboarding Flow:** PageView onboarding carousel with dynamic button states ("Next" vs. "Get Started") and animated indicator dots.

* **Adaptive Light & Dark Theme:** Built-in dynamic theming via `Styles.themeData()` supporting custom brand colors:

  * **Light Mode Scaffold:** `#F5EEEC`

  * **Dark Mode Scaffold:** `#241A10`

* **Dynamic Auth & Stepper Flow:**

  * **Learning Branch Selection:** Switch between "Through my school" and "I learn at home".

  * **School Code Authentication:** Specialized input fields with helper hints and learner verification UI cards.

  * **Home Account Flow:** Phone number input with country code picker UI and password setup.

  * **Segmented Login Tabs:** Toggle easily between "School code" and "Phone number" modes.

  * **Password Recovery Sequence:** Phone-based OTP prompt and password reset screen.

## 📁 Project Structure

```
lib/
├── main.dart                   # Application entry point & MaterialApp configuration
├── styles.dart                 # Universal app theme & color definitions (Light/Dark)
├── screens/
│   ├── splash_screen.dart      # Animated OpexA splash screen
│   ├── onboarding_screen.dart  # Onboarding slider & dynamic action buttons
│   ├── auth_flow_screens.dart  # Multi-step onboarding (Learning path, School code, Account creation)
│   └── login_flow_screens.dart # Welcome back (segmented tab), Reset & New Password screens
└── widgets/
    └── step_header.dart        # Reusable 6-step progress indicator header

```

## 🚀 Getting Started

### Prerequisites

* [Flutter SDK](https://docs.flutter.dev/get-started/install) (`>=3.0.0`)

* [Dart SDK](https://dart.dev/get-started/sdk) (`>=3.0.0`)

* Android Studio / VS Code with Flutter extension installed.

* An iOS Simulator or Android Emulator.

### Installation

1. **Clone the repository:**

   ```
   git clone https://github.com/your-username/opexa-mobile.git
   cd opexa-mobile
   
   ```

2. **Install dependencies:**

   ```
   flutter pub get
   
   ```

3. **Asset Configuration:**
   Ensure your app logo asset is placed under `assets/images/logo.png` and declared in your `pubspec.yaml`:

   ```
   flutter:
     uses-material-design: true
     assets:
       - assets/images/logo.png
   
   ```

4. **Run the application:**

   ```
   flutter run
   
   ```

## 🛠 Color Palette & Design System

The app utilizes the custom `Styles` class in `styles.dart` to maintain color consistency across light and dark modes:

| Element | Light Mode | Dark Mode | 
| ----- | ----- | ----- | 
| **Scaffold Background** | `#F5EEEC` | `#241A10` | 
| **Card / Input Background** | `#FFFFFF` | `#322418` | 
| **Primary Blue Accent** | `#0052FF` | `#0052FF` | 
| **Primary Action Button** | `#24488A` | `#24488A` | 
| **Primary Text Color** | `#2C221E` | `#FFFFFF` | 
| **Secondary Text Color** | `#7E7672` | `#B3AAA6` | 

## 🧪 Tester Sign-in Codes

For testing sign-in and authentication flows without backend integration, use the pre-configured tester credentials:

* **School Sign-in Codes:**

  * `OPX-482-913` — *Amaka, JSS2 (Public School)*

  * `OPX-517-204` — *Ifeoma, SS1 (Private School)*

  * `OPX-630-417` — *Chinedu, JSS1 (New Account test)*

* **Phone Number Login:** `0803 000 0000`

* **Verification Code:** `246810`

## 🤝 Contributing

1. Fork the Project repository.

2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`).

3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`).

4. Push to the Branch (`git push origin feature/AmazingFeature`).

5. Open a Pull Request.

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.