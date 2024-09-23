# **REAL TIME GROCERY DELIVERY APPLICATION**

## Overview

This project is a starting point for a Flutter application.

## Introduction

Real Time Grocery Delivery App(SabjiTaza) is a cross-platform mobile application built with Flutter that enables users to order groceries and track their deliveries in real-time. The app offers an intuitive and seamless experience, ensuring users can shop from the comfort of their homes and receive their orders quickly.

## Features & Characteristics
- **Cross-Platform:** Available on Android and iOS.
- **User Authentication:** Secure login and sign-up with email, Google, and Apple ID.
- **Product Catalog:** Browse and search for products across various categories.
- **Real-Time Tracking:** Monitor your order status from the time of purchase to delivery.
- **Multiple Payment Methods:** Supports various payment gateways and cash on delivery.
- **Order History:** Easily reorder from past purchases.
- **Push Notifications:** Get real-time notifications about order updates and special offers.

## Screenshots

## **Tech-Stack**

## Frontend
- **Flutter** - Cross-platform mobile development
- **Dart** - Programming language for Flutter
- **Provider** - State management
- **Firebase** - Authentication, Realtime Database, Firestore, and Analytics

## Backend
- **Node.js**- Backend server
- **Express.js** - Web framework for Node.js
- **MongoDB** - Database
- **Firebase** - Realtime Database, Firestore for data storage
- **Socket.io** - Real-time communication
- **Razorpay API** - Payment processing

## Deployment
- Firebase Hosting - Web app hosting
- Google Play Store & Apple App Store - Mobile app deployment
- Docker - Containerization of backend services

## Installation

## Prerequisites
- **Flutter SDK**
- **Android Studio/Xcode**- For building and running the application
- **Node.js** 
- **MongoDB**-Local or cloud instance
- **Firebase Account**-For backend services

## Steps:
**1.Clone the Repository:**

```bash
git clone https://github.com/yourusername/grocerygo-flutter.git
cd grocerygo-flutter
```
**2.Install Flutter Dependencies:**

```bash
flutter pub get
```
**3.Set up Firebase:**

*Create a Firebase project.*
Add Android and iOS apps to the Firebase project.
Download the google-services.json (Android) and GoogleService-Info.plist (iOS) files and place them in the respective directories.

**4.Backend Setup:**

```bash
cd backend
npm install
```
**5.Run the Application:**

Backend:
```bash
npm start
```

Flutter App:
```bash
flutter run
```

## Usage
- **User App**: Browse and order groceries with real-time order tracking.
- **Admin Panel**: Manage products, orders, and users via a web interface.

## API Endpoints

**Authentication:**
- `POST /api/auth/register` - Register a new user
- `POST /api/auth/login` - User login

**Products:**
- `GET /api/products` - List all products
- `POST /api/products` - Add a new product (*Admin only*)

**Orders:**
- `POST /api/orders` - Place a new order
- `GET /api/orders/:id` - Get order details
- `GET /api/orders/user/:userId` - Get user's orders

## Database Schema

**User Collection:**
- `id`: Unique identifier
- `name`: User's full name
- `email`: User's email address
- `password`: Encrypted password
- `address`: Delivery address
- `orders`: List of order IDs

**Product Collection:**
- `id`: Unique identifier
- `name`: Product name
- `category`: Product category
- `price`: Product price
- `stock`: Available stock
- `description`: Product description

**Order Collection:**
- `id`: Unique identifier
- `user`: User ID
- `products`: List of product IDs and quantities
- `totalPrice`: Total order price
- `status`: Current status (e.g., pending, delivered)
- `createdAt`: Timestamp of order creation

## Contribution
Contributions are welcome! Please fork this repository, create a new branch, and submit a pull request with your changes. See CONTRIBUTING.md for more details.

## License
This project is licensed under the MIT License. See the LICENSE file for details.

## Contact
- **Name** : Ravikant , Mohit(5keTchDev)
- **Email** : Sharma18mohit2018@gmail.com
- **GitHub** : https://github.com/5keTchDev
