# Splitee

A simple app for bill splitting. Made as an assignment for CareStack using Flutter, Typescript, and MongoDB.

![TypeScript](https://img.shields.io/badge/typescript-%23007ACC.svg?style=for-the-badge&logo=typescript&logoColor=white)
![Express.js](https://img.shields.io/badge/express.js-%23404d59.svg?style=for-the-badge&logo=express&logoColor=%2361DAFB)
![JWT](https://img.shields.io/badge/JWT-black?style=for-the-badge&logo=JSON%20web%20tokens)
![MongoDB](https://img.shields.io/badge/MongoDB-%234ea94b.svg?style=for-the-badge&logo=mongodb&logoColor=white)
![Nodemon](https://img.shields.io/badge/NODEMON-%23323330.svg?style=for-the-badge&logo=nodemon&logoColor=%BBDEAD)
![NodeJS](https://img.shields.io/badge/node.js-6DA55F?style=for-the-badge&logo=node.js&logoColor=white)
![Prisma](https://img.shields.io/badge/Prisma-3982CE?style=for-the-badge&logo=Prisma&logoColor=white)
![Postman](https://img.shields.io/badge/Postman-FF6C37?style=for-the-badge&logo=postman&logoColor=white)
![Render](https://img.shields.io/badge/Render-%46E3B7.svg?style=for-the-badge&logo=render&logoColor=white)
![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)
![Visual Studio Code](https://img.shields.io/badge/Visual%20Studio%20Code-0078d7.svg?style=for-the-badge&logo=visual-studio-code&logoColor=white)
![Adobe Illustrator](https://img.shields.io/badge/adobe%20illustrator-%23FF9A00.svg?style=for-the-badge&logo=adobe%20illustrator&logoColor=white)

## [📕 Frontend docs](https://github.com/RohitEdathil/Splitee/tree/master/sp_frontend#readme)

## [📗 Backend docs](https://github.com/RohitEdathil/Splitee/tree/master/sp_backend#readme)

## [📺 Demo video](https://youtu.be/83x_o12jnS0)

# Project Documentation

## Features

### Bills

- Create a bill and split it with anyone individually
- The creditor can edit and delete the bill
- Creditor can mark payment status of the bill
- Cost can be split equally or unequally, based on an amount or percentage

### Groups

- Anyone can create a group
- A user can join a group by scanning a QR code
- A user can leave a group, the associated bills will be migrated to individual bills
- The name of the group can be changed by the members
- All the features of bills are available in groups too, but the involved users are limited to the group members
- Pending payments are shown in the group page
- Balance of each user is also shown
- **Magic Split** - A feature that automatically redistributes the dues to minimize the number of transactions required to settle the bill

### User

- Anyone can create an account
- A user can edit their name and email

## Magic Split

This algorithm uses a greedy approach to minimize the number of transactions required to settle the bill. Uses a min-heap and a max-heap to keep track of the users with maximum credit and maximum debit.

- Calculates the total credit and debit of each user
- Finds the person with the maximum credit and the person with the maximum debit
- They both are paired and the minimum of the two is subtracted from the credit and debit of both
- This process is repeated until all the credits and debits are zero

## Demo

The demo is deployed on Render, and the database is hosted on MongoDB Atlas.

The app can be downloaded from the link below

### **[Download Splitee](https://github.com/RohitEdathil/Splitee/releases/download/v1.0/app-arm64-v8a-release.apk)**

The app in the link above is built for arm64-v8a architecture (works for most cases). If you are using another architecture, you can find a build for your architecture in the releases section.

**⚠️Note: The app is hosted on a free tier of Render, so it may take a few seconds to load the first time you open it due to [❄️Cold Start](<https://en.wikipedia.org/wiki/Cold_start_(computing)>)**

For exploring the app, you can use the following credentials

```
User-id: rtvrtvrtv
Password: qwerty
```

## Gallery
<span>
<img src="screenshots/login.jpg" width="250">
<img src="screenshots/groups.jpg" width="250">
<img src="screenshots/indi.jpg" width="250">
<img src="screenshots/list_bill.jpg" width="250">
<img src="screenshots/create_bill.jpg" width="250">
<img src="screenshots/view_bill.jpg" width="250">
<img src="screenshots/edit_part.jpg" width="250">
<img src="screenshots/summary.jpg" width="250">
<img src="screenshots/balance.jpg" width="250">
<img src="screenshots/group_options.jpg" width="250">
<img src="screenshots/magic.jpg" width="250">
<img src="screenshots/user_settings.jpg" width="250">
</span>
