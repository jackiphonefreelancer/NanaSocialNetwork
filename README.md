# NanaSocialNetwork

NanaSocialNetwork is iOS application for a micro social media service

### Prerequisites
- Xcode version 12.5
- Swift 5
- iOS 11.2 or later

### How to run the project?
1. Clone this repo
2. Open terminal and navigate to project directory
3. Run `pod install`
4. Open `NanaSocialNetwork.xcworkspace` and run the project on simulator or real device

### Third party frameworks
- Use `cocoapods` as a dependencies manager to import frameworks.
- In this project contains 3 third party frameworks
  - Firebase: Beckend as a services
    - Firebase Authentication: to support email/password authentication
    - Firestore Database: to store realtime posts and users
    - Firebase Storage: to store image file
  - RxSwift: Swift-specific implementation of the Reactive Extensions standard
  - KingFisher: Library for downloading and caching images

### Project Overviews
- Features
  - Supported Dark/Light mode
  - Sign in/ Sign up/ Sign out (with email/password medthod)
  - Create new post (text and image) and delete your post
  - Realtime feeds
  - Screens: There are 5 main screens in this version
    - Login: User can login using email/password
    - Register: User can register new account by using email and password.
    - Home: User can see timelines/my posts
    - Create Post: User can create new post with image (maximum 1 image for this version)
    - Profile: User can see user information like email and displayname, and also logout on this screen.

### Step to test
1. Open the app and tap 'register now' to create a new account.
2. Once account is created, app will back to login screen.
3. Login with your registered email and password.
4. Once login is completed, app will bring you to home screen and now you can see timelines.
5. Tap '+' icon to create a new post.
6. After you created your post, you will see it in timelines or your posts. Then you can delete it anytime.

### Limit of usage
In this prohect uses free license account of Firebase, so there are some limitation of usages
1. Cloud Firestore:
  - Write/Delete: 20K per day
  - Read: 50K per day
2. Cloud Storage:
  - Bytes stored: 5GB
  - Bandwidth: 1GB per day
3. Authetication: No limit for email/password authetication

