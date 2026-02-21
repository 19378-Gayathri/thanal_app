 "THANAL - A HAND TO HOLD IN EVERY CRISIS"
 Basic Details
Team Name: Resilient Her's
Team Members
Member 1: DEVATHEERTHA K S - MUTHOOT INSTITUTE OF TECHNOLOGY AND SCIENCE
Member 2: GAYATHRI MURALIKRISHNAN - MUTHOOT INSTITUTE OF TECHNOLOGY AND SCIENCE
Hosted Project Link
https://thanal-app-f10b4.web.app 

Project Description
Thanal is a mobile app that provides immediate support during emergencies and crises. It combines real-time alerts, a checklist for safety, first aid guidance, incident reporting, volunteer registration, and a smart chatbot to guide users through critical situations.

The Problem statement
In emergency situations, people often struggle to find reliable guidance, report incidents, or access immediate help. There is a lack of a single platform that provides real-time alerts, first aid, and community support, especially for people in vulnerable regions.

The Solution
Thanal solves this problem by providing:

Live alerts about emergencies or crises in the area
A checklist to check for essential items.
Emergency contacts each districts as a dropdown. 
First aid guidance with step-by-step instructions
Incident reporting for immediate action
Volunteer registration for community support
Interactive chatbot for guidance and FAQs
Live location sharing
All features are integrated in a single, easy-to-use mobile application.

Technical Details
Technologies/Components Used
For Software:

Software

Languages: Dart (Flutter), Python (Flask)
Frameworks: Flutter, Flask
Libraries: Firebase Auth, Firebase Firestore, HTTP, EasyLocalization
Tools: VS Code, Git, Firebase (for backend hosting)

Features
List the key features of your project:

Features
Live Alerts: Receive weather, disaster, and crisis alerts in real-time.
Checklist: Safety checklist to prepare before, during, and after emergencies.
First Aid: Step-by-step guidance with video tutorials and tips.
Volunteer Registration: Register to help in crises or report incidents.
Chatbot Assistance: AI-powered guidance for emergency situations, with voice support in English and Malayalam.
Incident Reporting: Easily report incidents to local authorities/community.
Emergency Contacts: Quick access to local emergency numbers for fire, police, ambulance, and disaster relief of each district in Kerala.
Donation Ledger: Track donations received or made, including details for transparency.
Live Tracking: Real-time location tracking during emergencies or when volunteering to ensure safety and coordination.

Implementation
For Software:
Installation
1.Flutter App (Frontend)

# Clone the repo
git clone https://github.com/your-repo/thanal_app.git
cd thanal_app

# Install dependencies
flutter pub get

# Run the app
flutter run

2.Backend (Flask API)

# Navigate to backend folder
cd backend

# Install dependencies
pip install -r requirements.txt

# Run the backend
python app.py

3.Firebase Setup

The Thanal app uses Firebase for storing and managing:
Incident Reports
Volunteer Registrations
Donation Ledger

Project Documentation
For Software:
[WhatsApp Image 2026-02-21 at 9 09 48 AM](https://github.com/user-attachments/assets/d6e67c41-039f-41bb-b4d8-17438178d319)
This is the login page of thanal app made using python flask

![WhatsApp Image 2026-02-21 at 9 09 51 AM](https://github.com/user-attachments/assets/0cb9f582-13aa-4820-88de-5c7e0592f1f3)
This is the homescreen of our app showing the features


![WhatsApp Image 2026-02-21 at 9 28 47 AM](https://github.com/user-attachments/assets/6f152f08-f5ac-4af3-96d5-2db885e357e2)


![WhatsApp Image 2026-02-21 at 9 29 14 AM](https://github.com/user-attachments/assets/11fb3e12-dff7-428b-ab4b-3f67938f5fe6)


Diagrams
System Architecture:
The Thanal App uses a hybrid architecture combining Flutter, Firebase, Flask, and an AI chatbot. Each component handles specific responsibilities to ensure smooth functionality and real-time responsiveness.

Architecture Components
Component	Role / Responsibility
Flutter Frontend- Mobile app UI. Handles user interactions, forms (report incidents, volunteer registration, donations), displays live alerts, checklist, first aid guidance, and chatbot interface.
Firebase (Authentication & Firestore DB) -	Stores user data, incident reports, volunteer information, donation ledger. Provides real-time updates for live alerts and notifications. Handles authentication and user sessions.
Flask Backend -Handles login/register endpoints and other API requests (if not fully managed by Firebase).
OpenRouter AI Chatbot	- Provides AI-powered guidance in English and Malayalam, including voice responses for emergency assistance. Integrated into Flutter app via API.
Live Alerts API (e.g., WeatherAPI.com)	- Provides real-time weather/disaster alerts based on user location. Flutter app fetches alerts and displays them via notifications.

Flutter Frontend

The mobile app UI is built using Flutter.
Handles all user interactions, navigation, and local processing.
Directly interacts with Firebase to:
Submit volunteer registrations
Record incident reports
Track donations in the ledger

Displays real-time updates and alerts on the user interface.

Firebase (Authentication & Database)
Authentication: Manages user sign-up and login securely (email/password or phone).
Cloud Firestore: Stores structured data for reports, volunteers, and donations.

Provides real-time syncing so all app users can see updated data immediately.

Flask Backend

Handles login and registration APIs for extra backend control.

OpenRouter AI Chatbot
Integrated into the Flutter app.
Provides voice-enabled guidance in English and Malayalam.

Assists users with queries related to emergencies, first aid, and navigation through the app.

Architecture Diagram Explain your system architecture - components, data flow, tech stack interaction

Application Workflow:

Workflow Add caption explaining your workflow


Build Photos
![WhatsApp Image 2026-02-20 at 6 25 05 PM](https://github.com/user-attachments/assets/3468f04f-296e-47b0-a093-1d6cd382af6b)



Additional Documentation
For Web Projects with Backend:
API Documentation
Base URL: https://api.yourproject.com

Endpoints
GET /api/endpoint

GET /alerts

Description: Returns live weather/disaster alerts.

Response:

{
  "status": "success",
  "data": []
}

POST /report-incident

Description: Submit an incident report.

Request Body:

{
  "location": "Wayanad",
  "type": "Wildlife Intrusion",
  "details": "Elephants entering farmland"
}

Response:

{
  "status": "success",
  "message": "Incident reported"
}

POST /volunteer-register

Description: Register as a volunteer.

Request Body:

{
  "name": "Devatheertha",
  "contact": "1234567890",
  "area": "Wayanad"
}

Response:

{
  "status": "success",
  "message": "Registered as volunteer"
}

POST /donation-entry

Description: Add a donation record.

Request Body:

{
  "donor": "John Doe",
  "amount": 500,
  "purpose": "Relief Fund"
}

Response:

{
  "status": "success",
  "message": "Donation added"
}

For Mobile Apps:
App Flow Diagram
Login → Home → Live Alerts / Checklist / First Aid → Report Incident → Volunteer Registration → Chatbot Assistance → Donations / Emergency Contacts

Caption: User navigates through all features in the app. Chatbot supports voice commands in English and Malayalam.

Installation Guide
For Android (APK):

Downloading and Installing a Pre-built App (APK or IPA)
This is for someone who just wants to use your app without building it themselves.

For Android (APK)
APK = Android Package. It’s the file format for Android apps.
Steps:
Download the APK from a provided link (like GitHub release or Google Drive).
Enable installation from unknown sources:
Go to Settings → Security → Enable Unknown Sources.
Android blocks installing apps outside Play Store by default, so this is required.
Open the downloaded APK → install the app.
Open the app and start using it.

For iOS (IPA) via TestFlight
IPA = iOS app file. iOS apps cannot just be downloaded like APKs; Apple restricts installation.
TestFlight is Apple’s official way to test iOS apps before they’re on the App Store.

Steps:
Download TestFlight app from App Store.
Open the TestFlight link you provide (this is like your app invitation).
Click Install → wait for the app to install.
Open the app from your home screen.


For Scripts / CLI Tools (Backend Commands)

The Thanal project provides a few scripts to run the backend APIs and test functionalities. These are useful for developers who want to test or extend the Flask backend.

Basic Usage
# Run the Flask backend
python app.py [options]

Available Commands
Command	Description
python app.py runserver -	Start the Flask backend server locally
python app.py test -	Run automated tests for backend endpoints
python app.py seed - Seed Firebase or local DB with sample data
python app.py migrate -	Run database migrations (if applicable)
Options

-h, --help -	Show help message and exit
-v, --verbose	- Enable verbose output (detailed logs)
-c, --config FILE -	Use a custom configuration file (e.g., .env)
--version	- Show version information of the backend
Examples
# Example 1: Start backend server
python app.py runserver

# Example 2: Start backend server with verbose logs
python app.py runserver -v

# Example 3: Seed Firebase with sample data
python app.py seed

# Example 4: Use custom config file
python app.py runserver -c config.env


Demo Output
Example 1: Submitting an Incident Report

Input (via Flutter app UI):

{
  "location": "Wayanad",
  "type": "Wildlife Intrusion",
  "details": "Elephants entering farmland"
}

Action: User fills in the report form in the app and clicks Submit Report.

Output (stored in Firebase Firestore / visible in app):

{
  "status": "success",
  "message": "Incident report submitted successfully",
  "reportId": "abc123"
}

What this demonstrates:

Reports are captured in real-time.
Data is synced across devices.
Volunteers and authorities can see the reported incidents instantly.

Example 2: Registering as a Volunteer

Input (via Flutter app UI):

{
  "name": "Devatheertha K S",
  "contact": "1234567890",
  "area": "Wayanad"
}

Action: User fills in volunteer registration form and clicks Register.

Output (stored in Firebase Firestore / visible in app):

{
  "status": "success",
  "message": "Volunteer registered successfully",
  "volunteerId": "vol123"
}

What this demonstrates:

Volunteers are added to the database.
Allows coordination during emergencies.

Example 3: Adding a Donation Entry

Input (via Flutter app UI):

{
  "donor": "John Doe",
  "amount": 500,
  "purpose": "Relief Fund"
}

Action: User submits donation details in the app.
Output (stored in Firebase Firestore / visible in app):

{
  "status": "success",
  "message": "Donation added successfully",
  "donationId": "don123"
}

What this demonstrates:

Tracks donation ledger entries.
Maintains transparency for fund management.

Example 4: Chatbot Assistance (English / Malayalam)

Input (via Flutter app chat interface):
User types or speaks: "How do I provide first aid for a burn?"
User can also speak in Malayalam: "ഒരു ക്ഷതത്തിന് ആദ്യം എങ്ങനെ ശുശ്രൂഷ ചെയ്യാം?"

Output (from OpenRouter AI, via Flutter app):

{
  "responseText": "Clean the burn area gently with cool water. Apply a sterile bandage. Seek medical help if severe.",
  "voiceOutput": "Audio response in selected language"
}

What this demonstrates:

Multilingual, voice-enabled chatbot guidance.
Assists users in real emergencies.

Example 5: Live Alerts

Input: N/A (automatic, based on location & alert API)
Output (in app Home screen):
Notification: "Heavy rainfall expected in Wayanad. Stay indoors and follow safety checklist."

What this demonstrates:
Real-time weather and disaster alerts.
Helps users prepare and take timely action.
Project Demo
Video
This video includes voice-over explaining our app features
(https://drive.google.com/file/d/1YA6Nh8E3Eq17igDXESfZQ78vR3z9xN46/view?usp=sharing)

AI Tools Used: Chatgpt
Key Prompts Used:

"Create Flutter UI for checklist and live alerts"
"Integrate Firebase Firestore for incident reporting"
"Add voice-enabled chatbot support in Flutter for English and Malayalam"

Human Contributions
Devatheertha K S
Flutter frontend development
Firebase integration (authentication, database, live alerts, donation ledger)
UI/UX design decisions

Gayathri Muralikrishnan
Chatbot integration (OpenRouter AI)
Live alerts implementation
Incident reporting and volunteer registration logic
Testing, bug fixes, and app deployment

Team Contributions
DEVATHEERTHA K S: Frontend development
GAYATHRI MURALIKRISHNAN: Backend development
License
This project is licensed under the [LICENSE_NAME] License - see the LICENSE file for details.

Common License Options:

MIT License (Permissive, widely used)
Apache 2.0 (Permissive with patent grant)
GPL v3 (Copyleft, requires derivative works to be open source)
Made with ❤️ at TinkerHub
