# 📱 IoT Learning Log (บันทึกการเรียนรู้ IoT)

A personal learning journal application built with **Flutter**. This app helps makers and students document their Arduino/IoT projects, store code snippets, and keep track of their learning progress offline.

แอพพลิเคชันสำหรับบันทึกการเรียนรู้ IoT/Arduino พัฒนาด้วย Flutter ช่วยให้คุณจดบันทึกโปรเจกต์ เก็บโค้ด และรูปภาพผลงานไว้ในเครื่องเดียว

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![SQLite](https://img.shields.io/badge/sqlite-%2307405e.svg?style=for-the-badge&logo=sqlite&logoColor=white)

---

## ✨ Features (ฟีเจอร์หลัก)

- 📝 **Create Logs:** Record project title, descriptions, and learning notes.
- 💻 **Syntax Highlighting:** Beautiful code display for Arduino (C/C++) using `flutter_highlight`.
- 📸 **Image Attachment:** Capture photos or pick from the gallery to save circuit diagrams or results.
- 🔍 **Smart Search:** Search through titles, notes, and code snippets instantly.
- 💾 **Offline Storage:** All data is stored locally using SQLite (No internet required).
- ✏️ **Edit & Delete:** Manage your logs easily.

---

## 📸 Screenshots (รูปตัวอย่าง)

| Home Screen | Add/Edit Log |
|:---:|:---:|
| <img src="screenshots/home.png" width="250" /> | <img src="screenshots/add.png" width="250" /> |
| **หน้าแสดงรายการ** | **หน้าเพิ่มบันทึก** |

| Detail & Code | Search |
|:---:|:---:|
| <img src="screenshots/detail.png" width="250" /> | <img src="screenshots/search.png" width="250" /> |
| **หน้ารายละเอียด & โค้ด** | **หน้าค้นหา** |

---

## 🛠️ Tech Stack & Packages

* **Framework:** [Flutter](https://flutter.dev/)
* **Language:** Dart
* **Database:** `sqflite` (Local SQL Database)
* **State Management:** `setState` (Native)
* **Key Packages:**
    * `flutter_highlight`: For code syntax highlighting.
    * `image_picker`: For camera and gallery access.
    * `path_provider`: For file system access.
    * `intl`: For date formatting.
    * `google_fonts`: For custom typography.

---

## 🚀 Getting Started

To run this project locally:

1. **Clone the repository**
   ```bash
   git clone https://github.com/limouzeen/my_iot_learning
