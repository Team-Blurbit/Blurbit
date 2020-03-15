Group Project - README
===

# Blurbit

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
This app will allow users to find more information regarding any book they encounter. Descriptions, reviews and nearby stores with books for sale will be displayed for the user to interact with.

### App Evaluation
- **Category:** Books / Shopping
- **Mobile:** The main part of the app will be mobile, especially since the barcode scanner and the bookstore location finder make most sense for mobile devices. Parts of the app could probably expanded for web use in the future, like the search history, the best selling device and the book store finder without using a current location, but the main market will be mobile devices.
- **Story:** Find book reviews if you are in a bookstore and see an interesting book, but aren't sure if it's good or not, especially if you never heard of it before. Find nearby bookstores where you can discover new books. If you are not sure where to start with your book search, recommendations can help you.
- **Market:** Any person who likes reading books and buying them in person could use the app. Persons who like to gift books but don't know a lot of books or are unfamiliar with genres the person to gift knows could use the app as well, even though they might not use it as often.
- **Habit:** This app could be used whenever a person decides to buy a new book or looking for new books to read. 
- **Scope:** We would start with a book finder for reviews, but would then expand it to have bookstore finder and recommendations. Potentially, the app could be more connected to Amazon or have additional features like search by name, best selling books or optical character recognition for finding the book by title.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**
* AS A user, I WANT to scan a barcode, SO THAT I can read reviews.
* AS A user, I WANT to "expand" to long reviews, SO THAT I can read them easily.
* AS A user, I WANT to view my search history, SO THAT I can recall past results.
* AS A user, I WANT to view nearby stores, SO THAT I may purchase the product.
* AS A user, I WANT to view store details, SO THAT I can determine if the store meets my criteria.
* AS A system, I WANT to present the user with recommendations, SO THAT sales increase.
* AS A user, I WANT to find nearby bookstores by location, SO THAT I can find a bookstore to go to.

**Optional Nice-to-have Stories** 

* AS A user, I WANT to view best-selling Amazon books, SO THAT I get to learn about new, trending books.
* AS A user, I WANT to remove a search, SO THAT my recommendations are not influenced.
* AS A user, I WANT to search by book title, SO THAT I can find a book without a barcode.
* AS A user, I WANT to scan a book title, SO THAT I don't have to type the title.
* AS A user, I WANT to add a profile picture, SO THAT my reviews are recognizable.
* AS A user, I WANT to write reviews, SO THAT I can contribute.
* Pending Stories
    * User can login
    * User can stay logged in
    * User can log out

### 2. Screen Archetypes

* Login/Register - The user can login in or create an account
   * Upon opening the app, the user is prompted to a login/register screen if they are not signed in
* Barcode scanner -user can scan the barcode of a book
   * Upon scanning the book, the user will be lead to the review screen of the book.
* Review screen
   * The user is shown the book cover, title and author at the top
   * Below, a list of reviews is displayed, which can be expanded on click.
* Review expansion screen
    * a full review is shown in detail
* Bookstore finder screen
    * The user can enter a location to find nearby bookstores. By default, the location should be the user location.
    * A map with pinpoints for bookstores in the area entered by the user is shown.
    * Upon clicking on a pinpoint, the user will be lead to a screen containing detailed information about the bookstore.
* Bookstore detail screen
    * Detailed info about the bookstore, including name, an image (if available), location, website, phone number and hours of operation, are displayed.
    * Optional: if the user clicks on the website, it will open a popup to the website.
    * Optional: if the user clicks on the phone number, it will open the phone.
* Related or recommended books
    * If the user is looking at a book that they like on the review screen, they can go to this screen to see other similar books.
* Search history screen
    * shows a list of the books searched before
    * Upon clicking on a book on the search list, the user will be lead to the review screen of the book.
 
### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Barcode Scanner
* Recommendations
* Bookstore Finder
* Search History

**Flow Navigation** (Screen to Screen)

* Barcode Scanner -> Review screen -> Detailed review screen
* Bookstore finder -> Bookstore details screen 
* Recommendations -> Review Screen -> Detailed review screen
* Search History -> Review screen -> Detailed review screen

## Wireframes

<img src="https://i.imgur.com/O53ve9a.png" width=600>

### [BONUS] Digital Wireframes & Mockups
<p float="left>
   <img src="https://i.imgur.com/UTdV8qS.png" width=75 style="padding:10px;">
   <img src="https://i.imgur.com/v2WQCFA.png" width=75 style="padding:10px;">
   <img src="https://i.imgur.com/r5DHG3g.png" width=75 style="padding:10px;">
   <img src="https://i.imgur.com/ic3qjrU.png" width=75 style="padding:10px;">
   <img src="https://i.imgur.com/5qURfsy.png" width=75 style="padding:10px;">
   <img src="https://i.imgur.com/xVOEpp7.png" width=75 style="padding:10px;">
   <img src="https://i.imgur.com/ubgj1he.png" width=75>
</p>

### [BONUS] Interactive Prototype

## Schema 
[This section will be completed in Unit 9]
### Models
[Add table of models]
### Networking
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]
