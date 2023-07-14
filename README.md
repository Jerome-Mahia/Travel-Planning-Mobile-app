# travel_planner_app_cs_project

## Introduction

This mobile application combines the power of Flutter for the frontend and Django for the backend to create a seamless and intuitive experience for generating itineraries powered by ChatGPT
## Features
* ChatGPT Integration: The core functionality of this application is based on integrating ChatGPT which allows users to generate  personalized itineraries.
* Intuitive User Interface: The app provides a user-friendly interface, designed with Flutter, that enables seamless interaction and a smooth experience for generating 
  itineraries.
* Backend powered by Django: The Django backend handles the communication between the Flutter frontend and the ChatGPT model. It ensures smooth data flow and manages the 
  logic for generating the itineraries.
* Personalized Recommendations: Using ChatGPT's natural language processing capabilities, the app takes into account user preferences, interests, and constraints to 
  provide personalized itinerary recommendations.
* Flexible and Customizable: The app allows users to customize their preferences, such as desired attractions, budget, time constraints, and transportation options, to 
  generate tailored itineraries that meet their specific needs.
* Seamless Integration with External APIs: The application seamlessly integrates with external APIs to retrieve real-time data, such as  transportation 
  schedules, and attraction details, to enhance the accuracy and relevance of the generated itineraries.
* Save and Share Itineraries: Users can save their generated itineraries and share them with friends and family. They can also modify and refine their itineraries based on 
  feedback and suggestions from others.
  
## <u>Technologies</u>
The project is created with:
   
* Programming Languages: 
  * Dart
  * Python
  * HTML/CSS
      
* Front-End Frameworks and Libraries:
   * Flutter
   
* Back-End Frameworks:
   * Django

* Database Management:
     * PostgreSQL

* Additional Tools:
   * Visual Studio Code

## <u>Setup flutter frontend<u/>

# Prerequisites

* Flutter SDK: Download and install the Flutter SDK from the official Flutter website. Follow the installation instructions specific to your operating system: Flutter         Installation Guide

* Dart SDK: Flutter relies on the Dart programming language. The Flutter SDK includes the Dart SDK, but if you already have Dart installed, make sure it is the latest 
  stable version.

* Integrated Development Environment (IDE): You can use any text editor or IDE for Flutter development, but the recommended IDE is Visual Studio Code with the Flutter and     Dart plugins installed. Alternatively, you can use Android Studio with the Flutter plugin.

* Android Emulator or iOS Simulator: To run and test your Flutter application, you will need either an Android emulator or an iOS simulator. Make sure you have set up the 
  emulator or simulator of your choice before proceeding.

## <ul>Setting up the Flutter Project<ul/>

* Clone or download the project repository from a version control system (e.g., GitHub) or create a new project using the Flutter CLI command: flutter create project_name.

* Open a terminal or command prompt and navigate to the project's root directory.

* Run the command flutter pub get to fetch and install the project dependencies. This command will download the necessary packages and libraries specified in the 
  pubspec.yaml file.

* Connect your physical device or start the Android emulator/iOS simulator.

* To verify that Flutter is set up correctly and devices are connected, run the command flutter devices. It will display the list of connected devices.

* Run the command flutter run to launch the application on the connected device or emulator. If you have multiple devices connected, use the flutter run -d device_id 
  command, where device_id is the identifier of the target device.

* Wait for the application to build and launch on the selected device. The first build may take a while, but subsequent builds will be faster.

## <ul>Setting up Django backend<ul/>

# Prerequisites

* Python (version 3.6 or higher)
* pip (Python package manager)
* virtualenv (optional but recommended)

# Setup virtual env
* Open a terminal or command prompt.
* Navigate to your project directory.
* Run the following command to create a virtual environment:
  ```
  
    myenv\Scripts\activate
   
  ```
# Install Requirements

* Ensure your virtual environment is activated (if you created one).
* Run the following command to install Django using pip:
  ```
  
  pip install -r requirements.txt

  ```

* Run migrations using
```

python manage.py migrate

```

* Run locally using

```

python manage.py runserver

```

# Django Resources
* Django Official Documentation: The official documentation provides comprehensive information about Django, including tutorials, guides, and references for different 
  aspects of web development with Django.['https://docs.djangoproject.com/en/4.2/']
* Python Packages['https://pypi.org/)https://pypi.org/']
  
# Flutter resources
* Flutter Official Documentation:['https://docs.flutter.dev/']



