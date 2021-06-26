# 1MDeMAVille
# UNE MIN DE MA VILLE

A new Flutter application to share 1 min video with  people from the city government.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## PROJECT DIRECTORIES

### lib/layouts
    This directory will contain the layouts for all the screens.
        layouts/home
            Home file, should contain the main file 
        layouts/onboarding
            Layout to handle the onboarding process
        layouts/account 
            Should contain all the files related to the account
        layouts/auth 
            Should contain all the files related to the authentication process
        layouts/video 
            Should contain all the files related to the video : form, video submitting, etc...
        layouts/video feed 
            Should contain all the files related to the videofeed (newsfeed of video), with research, etc.

### lib/models
    This directory will contain the models 
        models/admin
        models/citizen
        models/department
        models/user
        models/video

### lib/services
    This directory will contain the services : databases, etc.
        services/auth
            This file will handle the auth process
        services/databases
            The files in this directory will handle the CRUD with databases

### lib/shared
    This directory will contains the shared files for all others directories
    lib/shared/colors
        The main colors used in the app
