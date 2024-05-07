# **MyPiggy (Noel Rosario)**

Git Link - https://github.com/RosarioNoel-FS/MyPiggyWatchEXT

# **MyPiggy - A Financial Goal Tracking App**

A simple yet powerful application that tracks your Financial goal progress on your iPhone and Apple Watch. It's built using Swift and leverages Apple's WatchConnectivity to communicate between the iPhone and Apple Watch.

## **Tested On**

- iPhone 13 Pro Max (iOS 15)
- Apple Watch Series 7 (watchOS 8)

NOTE: Make sure to have the latest software versions installed on your devices for the optimal performance of the app.

## **Current Functionality**

- **Create Goals**: Create your goals on your iPhone, setting a title and description.
- **Track Goals**: The goals you create on your iPhone are immediately available on your Apple Watch.
- **Update Goals**: You can update the status of your goals from your iPhone and the updates are reflected on your Apple Watch.
- **WatchConnectivity**: The app uses WatchConnectivity to seamlessly transfer data between the iPhone app and the WatchOS app.
- **Background Transfer**: The app uses background transfer (transferUserInfo(_:)) to allow the user to receive goal data even when the watch app is in the background.

## **Known Issues**

- **Data Syncing**: Sometimes, due to the nature of background transfers, data might not appear on the watch immediately after being added on the iPhone. However, the data should appear when the watch app next comes to the foreground or when the system schedules the transfer.

Please make sure to check this document for updates and further details about the project.

# **App Walkthrough**

## **Adding Goals**

Sign up or sign in to the app using your Firebase account.
Press the plus button to add a financial goal.

There are two types of goals you can create:

### **Basic Goal**: 

Give your goal a name, and it will be added to your list of goals.

### **Custom Goal**:

Add a goal name, desired saving amount, and a target date for achieving the goal. Additionally, select the frequency of deposits—daily, weekly, bi-weekly, or monthly. The app will calculate the recommended deposit amount based on your selection.

After entering the necessary details, create the goal, and it will be added to your goal list.

Managing Goals

Both basic and custom goals allow you to make deposits and withdrawals, giving you control over your progress.

If needed, you can break a goal, which simply restricts further deposits and withdrawals without deleting the goal entirely.

The custom goal provides you with a progress overview, showing the amount saved and the total goal amount. This helps you stay motivated and track your financial achievements.

## **Watch Integration**

The app extends its functionality to your smartwatch, allowing you to conveniently keep track of your goals on the go.

Sync your smartwatch with the app to access the goal tracking features.
On your smartwatch, you can view a list of your goals and access a detailed view, similar to the phone app.

Stay updated on your progress and stay motivated wherever you are.

## **MyPiggy simplifies the process of managing your financial goals, ensuring that you stay organized and focused on achieving financial success. Start tracking your goals today and take control of your finances like never before!**

# **MyPiggy Release Notes - Version: Gold Build**

Hello MyPiggy Users,

I'm excited to share the latest updates and improvements in MyPiggy's Gold Build version. As a solo programmer, I've been working hard to enhance your experience with the app. Here's what's new:

## **Swipe to Delete Goals (Mobile Version)**: 

You can now delete goals with a simple swipe gesture in the mobile version. Managing your goals is a breeze!

## **Fixed Goal List Order**:

I've addressed the pesky issue with the goal list order. Your goals will now be displayed correctly, ensuring a seamless user experience.

## **Enhanced Data Handling (Mobile and Watch)**:

Thanks to your feedback, I discovered and fixed a critical bug that caused goals from previous signed-in users to appear in your goal list. Rest assured, your data is now handled accurately and securely between the mobile and watch versions.

## **Fixed Format Bugs**:

I've squashed those annoying format bugs that caused broken goal displays. Now, all your goals will look perfect and tidy.

## **Improved UI for Both Platforms**:

I understand the importance of a visually appealing interface. I've put in the effort to update the user interface on both mobile and watch platforms, making your experience more delightful and engaging.

## **Brand New App Icons**:

To give MyPiggy a fresh look, I've designed unique app icons for both the mobile and watch platforms. These icons are not only eye-catching but also make it easier to identify and access the app.

I hope you enjoy these improvements as much as I enjoyed working on them. Your feedback has been invaluable, and I remain committed to delivering the best personal goal management experience possible. If you encounter any issues or have suggestions, feel free to reach out to me directly. Thank you for being part of the MyPiggy community!

Happy goal-setting,
