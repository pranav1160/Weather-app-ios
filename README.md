## 🌦️ WeatherApp-iOS — Project Structure 🏗️  

[![Watch the video](https://img.youtube.com/vi/izlw7PDNT5w/0.jpg)](https://youtube.com/shorts/izlw7PDNT5w)

My app is built with **Swift & SwiftUI**, following **MVVM (Model-View-ViewModel)** to keep things modular and scalable. Here's how everything is structured:  

📂 **Extensions/** → Houses Swift extensions like color utilities to enhance SwiftUI components.  

📂 **models/** → The heart of our data layer:  
- **dailyModels/** → Models for daily weather data  
- **hourlyModels/** → Models for hourly weather updates  
- **weathermodels/** → Core weather data structures & condition helpers  

📂 **Utils/** → Services to fetch weather data from APIs using async networking.  

📂 **viewModels/** → Handles business logic & transforms raw data into UI-ready formats.  

📂 **views/** → SwiftUI components for displaying weather beautifully.  

📂 **Resources/** → Assets & media files used across the app.  

📄 **Constants.swift** → Stores API keys & reusable constants.  

📄 **Info.plist** → App configuration & environment settings.  

🚀 **Designed for performance, readability, and a great user experience!** 🚀  

---

## **🚀 Setup Instructions for WeatherApp-iOS**

### **Step 1: Get an API Key**  
1. Sign up at **[OpenWeather](https://home.openweathermap.org/users/sign_up)**  
2. Generate an API key from the **API Keys** section  

---

### **Step 2: Add the API Key to `Info.plist`**  
1. Open the project in **Xcode**  
2. Navigate to `Info.plist`  
3. Add a new key:  
   - **Key:** `API_KEY`  
   - **Type:** `String`  
   - **Value:** `your_api_key_here`  

---

### **Step 3: Run the App**  
Now, build and run the app using:  
- **Xcode → Run (`⌘ + R`)**

---

### **🔒 Important Notes**  
- The `Info.plist` file is **ignored in Git**, so your API key stays private  
- If you face issues, ensure you correctly added the `API_KEY` in `Info.plist`

