# LocalPantry: Offline Inventory Tracker
LocalPantry is a lightweight, offline-first inventory management application built entirely within Swift Playgrounds. Designed to run without a network connection, it provides a robust solution for tracking pantry stock, expiration dates, and usage history using local data persistence.

## About The Project
This project demonstrates the development of a fully functional iOS application delivered as a standalone .swiftpm package. The core philosophy of the app is privacy and reliability—all data is stored locally on the device, ensuring the app functions perfectly in zero-connectivity environments.
The app utilizes the MVVM (Model-View-ViewModel) architecture to ensure clean code separation and reactive UI updates.

## Key Features
Detailed Inventory Entry: Users can input new stock with granular details:
- Item Name
- Serial Number/SKU
- Quantity
- Expiry Date\n
Smart Consumption: Remove items as they are used. The app automatically calculates remaining stock or removes the item if the quantity reaches zero.
Persistent Audit Log: A complete history tracking system that records every action.
Inbound: Logs name, time, and quantity added.
Outbound: Logs name, time, and quantity removed.
Offline Persistence: Uses Swift's FileManager and JSONEncoder/Decoder to persist data between app launches. No CoreData or external databases are required.

## Technical Stack
- Language: Swift 5
- UI Framework: SwiftUI
- Platform: Swift Playgrounds (iPad/Mac)
- File Format: .swiftpm
- Data Storage: Local JSON Serialization (Documents Directory)

## Data Structure
The application manages two distinct data streams to ensure accurate historical tracking:
- Inventory State: The current "live" snapshot of what is on the shelves (mutable).
- Transaction History: An append-only log of every Add and Remove event (immutable), ensuring data integrity even if current stock changes.
