Note:- I push code on new id of my github because last one have been lost due to lost of Mobile Number.
Github (old ID):- https://github.com/Luckykandpal021
Github (new ID):- https://github.com/Lucky-Kandpal/namekart

Document: Overview of Task Management App Implementation(NameKart)
1. Overview
The task management app allows users to create, edit, and delete tasks with features such as speech-to-text input for titles and descriptions. The app integrates multiple Flutter libraries and packages for various functionalities, including state management and speech recognition.

2. Code Structure
The code is organized into several files, each handling distinct aspects of the application:

main.dart:

Entry point of the app.
Initializes TaskProvider for state management using the Provider package.
Defines the MyApp widget to set up the app's theme and home screen (HomeScreen).
home_screen.dart:

Displays a list of tasks using a ListView.builder.
Provides navigation to the TaskScreen for task creation or editing.
Includes a floating action button to add new tasks.
database_helper.dart:

Manages database interactions using SQLite.
Handles CRUD operations for tasks, such as inserting, querying, updating, and deleting.
state_management.dart:

Defines TaskProvider using ChangeNotifier to manage task data and notify listeners of changes.
Handles task loading, addition, update, and deletion.
task_screen.dart:

Provides the UI for creating and editing tasks.
Includes text fields for the title and description, date/time pickers, and a switch for task completion.
Integrates speech-to-text functionality for voice input in both fields.
3. Libraries Used
flutter/material.dart: Provides UI components and theming.
provider/provider.dart: Implements state management using the Provider package.
sqflite/sqflite.dart: Facilitates SQLite database operations.
path/path.dart: Assists with file path management.
intl/intl.dart: Handles date and time formatting.
permission_handler/permission_handler.dart: Manages permission requests, particularly for microphone access.
speech_to_text/speech_to_text.dart: Provides speech-to-text functionality for voice input.
4. Approach
State Management:

Used Provider to manage the task state across the app, allowing tasks to be added, updated, and deleted efficiently.
Database Integration:

Implemented SQLite database operations through the sqflite package for persistent task storage.
Speech-to-Text Feature:

Integrated the speech_to_text package to allow users to input task titles and descriptions via voice. Added permissions handling and speech recognition logic in task_screen.dart.
UI Design:

Designed a user-friendly interface with Flutter's Material components, including input fields, buttons, and date pickers.
5. Challenges and Resolutions
Challenge: Ensuring data consistency and managing database operations.
Resolution: Implemented a single DatabaseHelper class for managing all database interactions, ensuring a centralized approach to CRUD operations.
