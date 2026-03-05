# Project name

Riverpod Demo

#### Run these commands:

1. `flutter pub get`
2. `flutter gen-l10n`
3. `dart run build_runner build --delete-conflicting-outputs`

## Crete file folders in Presentation -> Screen Run below command

dart tool/generate_feature.dart {screen_name}

> File structure:

- services
  - **dynamic_links_service** - for universal link
  - **location_service.dart** - location services (handle permission & current address)
  - **AWS Service** - to upload files to S3 bucket
  - **notification_service.dart** - notification setup & notification related methods
  - api
    - **api_client** - dio client with retrofit, interceptors
    - **API Constants**
    - **API Response**

- di
  - **app_providers** - global provider defined, like internet checked, deeplink
  - **theme_notifier** - theme support - dark/light


- gen - assets generated files

- l10n - app localized strings

- widget - common app widgets 
- utils - app utils

- src
  - **data**
    - repository
      - local repository (Local storage)
      - remote repository (API Implementation)
  
  - **domain**
    - Request and Response model using freezed and json serializable 

  - **presentation**
    - screen - app screens
    - notifier - screen providers/methods
    - state - screen state, variables

- router
  - **app_routes.dart** - path names of screens
  - **app_pages.dart** - router setup for navigation

  
## Development SDK

- Flutter 3.32.5

