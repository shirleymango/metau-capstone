# metau-capstone

Shirley's Original App Design Project 
===

# Floofcards

## Table of Contents
1. [Overview](#Overview)
2. [Product Spec](#Product-Spec)
3. [Wireframes](#Wireframes)
4. [Project Progress](#Project-Progress)
5. [Schema](#Schema)

## Overview
### Description

The brain is like any other muscle that needs to be trained. Forget Quizlet and welcome a new study tool that you can use to memorize nearly anything! This flashcards app uses *spaced repetition*. Spaced repetition is a technique where the user recalls a fact repeatedly over time. Actively recalling a memory decreases the rate of decay and we want to boost our curve of memory again and again until the fact is ingrained in our memory.


More info on spaced repetition:
- https://fluent-forever.com/wp-content/uploads/2014/05/LeitnerSchedule.pdf
- https://e-student.org/spaced-repetition/

This app will allow users to create flashcards and study them every day with the Leitner Box Schedule. There will be 7 levels for the cards. Level 1 cards are reviewed every day, Level 2 cards are reviewed every other day, Level 3 cards are reviewed every 4th day, all to way to Level 7 cards, which are reviewed every 64 days.

### App Evaluation
- **Category:** Education
- **Scope:** For everyone (ages 8+)

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User can login
    * Verify that username field and password fields are filled
    * Verify that username and password match a valid account
    * Otherwise, display a pop-up with corresponding error message
* User can create a new account
    * Verify that username field and password fields are filled
    * Verify that an account with the same username has not been created before
    * Otherwise, display a pop-up with corresponding error message
* User can create flashcards
    * Flashcards include text field for the front and text field for the back
* User can flip through flashcards
    * Tapping the flashcard flips the card
    * User can flip back and forth as many times as they want
* User can pass/fail a card 
    * Tapping right button pushes card to the next level **passing a Level 7 card means the card graduates from your study stack!! the info on the card is practically ingrained in your mind :)
    * Tapping left button fails a card, bumping it back to Level 1
* App keeps track of Leitner Box Schedule and user can view their schedule
    * Gridview created using Google Sheets API [or Airtable API]
    * Every cell is a day, labels mark which levels need to be reviewed each day
* App gives daily notification to review cards
    * Daily push notification with message to user about reviewing flashcards
    * Cards displayed in study set are only of levels scheduled for the day

**Optional Nice-to-have Stories**

* User can create separate decks of cards
* User can view which cards are in each level
* User can follow friends and congratulate them on their progress
* App incorporates keyboards for different languages
* App uses Mandarin handwriting recognition API
* Activity log for each card

Ideas from Katie and Zenan:
* Manually changing levels
* Add cards while studying
* Overview of day’s performance at end screen
* Skip button - move card to the end of the stack

### 2. Screen Archetypes
* Login Screen
    * User can login
* Sign Up Screen
    * User can create a new account
* Study Screen
    * User can flip through flashcards
    * User can pass/fail a card
* Creation Screen
    * User can create flashcards
* Schedule Screen
    * User can see their schedule with which levels of cards to review each day

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Home Screen
* Study Screen
* Creation Screen
* Schedule Screen

**Flow Navigation** (Screen to Screen)
* Home Screen
    * => Login
    * => Sign up
* Login Screen
   * => Study Screen
* Sign up Screen
    * => Study Screen
* Study Screen
    * => Back to Home
    * => Creation
* Creation Screen
    * => Study

## Wireframes
Original wireframes
<img src="https://i.imgur.com/kXPHwhf.jpg">

Modification to wireframes: Bottom navigation bar (to be consistent across all screens except for home, login, and sign up)
![](https://i.imgur.com/rvhmtek.jpg)


Additional wireframe: Calendar Screen [likely to use Google Sheets API]
![](https://i.imgur.com/hT4DUTH.jpg)

## Project Progress
### Milestones

* Week 1: 
    * Home Screen
    * Login Screen and Sign up Screen
    * Setting up UIViewControllers in Storyboard for all other screens
    * Create Navigation bar
* Week 2: 
    * Study Screen: allow users to create flashcards
    * Create Flashcard subclass
    * Create Parse database
* Week 3: 
    * Study Screen: work on showing the correct cards each day
    * Connect API / SDK
    * End Screen with overview of the day's performance
* Week 4: 
    * Work on additional features such as: manually changing levels and moving card to the end of the stack
    * Continue working with API / SDK
* Week 5:
    * Continue working on stretch features
* Week 6: Project presentations

### Giving updates throughout project
* Will create a Workplace Group and will post weekly updates

## Schema
### Models
#### User


| Property | Type   | Description        |
| -------- | ------ |:------------------ |
| username | String | username for login |
| password | String | password for login |
| objectID   | String | unique for user    |
| userDay   | Number | the day number of the Leitner Schedule that the user is on    |
| prevFinishedDate   | Date | date when the user last finished studying a daily stack of cards    |

#### Flashcard

| Property | Type   | Description        |
| -------- | ------ |:------------------ |
| userID | String | user the card is associated with |
| levelNum | Number | level number (1-7) |
| objectID   | String | unique for card    |
| frontText | String | content for front of flashcard |
| backText | String | content for back of flashcard |

#### Schedule


