# User Directory App

A Flutter application that demonstrates working with REST APIs, pagination, filtering, sorting, search functionality, and state management. This project is clean, modular, and production-ready, following modern UI and architecture practices.
## 🚀 Overview

The app displays a list of users fetched from a REST API and provides features such as:

- Infinite scrolling pagination
- Sorting and filtering
- Local search
- Loading, error, and empty states
- Optional: Pull-to-refresh and responsive layout
- User detail screen with profile information

---
![Home Screen](screenshots/home_screen.png)  
![User Detail Screen](screenshots/detail_screen.png)  


## 🔗 API

- Base URL: `https://dummyjson.com`
- Example endpoint:  
  `https://dummyjson.com/users?limit=10&skip=0&key=gender&value=male`
## ⚡ Features

### Home Screen

- Displays user list with name, email, and thumbnail avatar
- Infinite scrolling using `limit` and `skip` parameters
- Sorting alphabetically (A-Z, Z-A) locally
- Filter users by gender
- Local search by first name or last name
- Loading, error, and empty states

### Profile Screen

- Shows full user details:
  - All data

## 🎨 UI & Theme

- Material 3 based modern UI
- Light and dark mode support
- Centralized theming with `ThemeData`
- Clean, consistent, and professional layout
- Responsive design

---

## 🛠 Tech Stack

- **Flutter** for cross-platform UI
- **GetX** for state management
- **Architecture:** Modular & clean code (MVVM / layered)
- **Networking:** REST API integration using `Dio`
- **Utilities:** Reusable widgets, proper error handling, Simmer loader
- **Null Safety** enforced
- Optimized builds for performance

---

## ⚙ Installation

1. Clone the repository:

```bash
git clone https://github.com/your-username/user_directory_app.git
