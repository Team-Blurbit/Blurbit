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

**Completed User Stories**
- [x] User can scan a book's barcode get its ISBN number.
- [x] User can search a book by ISBN or UPC code and view its Amazon reviews. The ISBN can be retrieved from the barcode scanner.
- [x] User can view recent searches.
- [x] User can log in to view reviews and recent searches.
- [x] User can stay logged in.
- [x] User can log out on the search page.
- [x] User can view a map view of the phone's current surrounding location.
- [x] User can see book stores in surrounding location as blue markers and view their name on click.
- [x] User can see detailed information about the store name and hours on a details screen when clicking on a book store.
- [x] User can search a book by title.
- [x] User can click on a review to see an expanded review screen.
- [ ] Work in progress: user can view recommendations based on past searches.

**Required Must-have Stories**
* AS A user, I WANT to scan a barcode, SO THAT I can read reviews.
* AS A user, I WANT to "expand" long reviews, SO THAT I can read them easily.
* AS A user, I WANT to view my search history, SO THAT I can recall past results.
* AS A user, I WANT to view nearby stores, SO THAT I may visit the store.
* AS A user, I WANT to view store details, SO THAT I can determine if the store meets my criteria.
* AS A system, I WANT to present the user with recommendations, SO THAT sales increase.

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
    
### Video Walkthrough

Here's a walkthrough of implemented user stories:
<p float="left">
   <img src='walkthrough.gif' title='Video Walkthrough' height='580' alt='Video Walkthrough' />
   <img src='http://g.recordit.co/NIXV4VfbY1.gif' title='Video Walkthrough' height='580' alt='Video Walkthrough' />
</p>
<p float="left">
   <img src='http://recordit.co/OaENZyRQXa.gif' title='ML Playground' height='580' alt='ML Playground' />
</p>

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
<p float="left">
   <img src="https://i.imgur.com/UTdV8qS.png" width=75 style="padding:10px;">
   <img src="https://i.imgur.com/v2WQCFA.png" width=75 style="padding:10px;">
   <img src="https://i.imgur.com/r5DHG3g.png" width=75 style="padding:10px;">
   <img src="https://i.imgur.com/ic3qjrU.png" width=75 style="padding:10px;">
   <img src="https://i.imgur.com/5qURfsy.png" width=75 style="padding:10px;">
   <img src="https://i.imgur.com/xVOEpp7.png" width=75 style="padding:10px;">
   <img src="https://i.imgur.com/ubgj1he.png" width=75>
 </p>

## Schema 
### Models
#### User 
| Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | userId      | String   | unique id for the user (default field) |
   | username    | String   |unique name for the user |
   | password    | String   |password for the user |
   | profilePicture    |File  |profile picture of the user|
#### Search 
   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | searchId      | String   | unique id for the search (default field) |
   | bookId        | String   |book searched |
   | userId        | Pointer to User   |user that conducted the search |
   | createdAt    |DateTime  |timestamp for the time of the search (default field) |
#### Review 
   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | reviewId      | String   | unique id for the search (default field) |
   | bookId        | String   |book to review |
   | userId        | Pointer to User|review author |
   | review        | String|review content |
   | createdAt    |DateTime  |timestamp for the time the review is created (default field) |
### Networking
#### List of network requests by screen
   - User login/signup screen
      - (Create/POST) Create a new user object
        ```swift
        let user = PFUser()
        user.username = usernameField.text
        user.password = passwordField.text
        user.signUpInBackground{ (success,error) in
            if success{
                print("Successfully signed up.")
            }
            else{
                print("Error: \(error?.localizedDescription)")
            }
        }
        ```
      - (Read/GET) Query user object by username and password
         ```swift
        let username = usernameField.text
        let password = passwordField.text
        PFUser.logInWithUsername(inBackground: username, password: password) 
        { (user, error) in
            if user != nil{
                print("Successfully logged in.")
                // TODO: Go to barcode scanner screen
            }
            else{
                print("Error: \(error?.localizedDescription)")
            }
        }
         ```
   - Barcode Scanner Screen
      - (Create/POST) Create a new search object
          ```swift
        let search=PFObject(className:"Searches")
        var bookId = "book ID String"
        search["userId"]=PFUser.current()!
        search["bookId"]=bookId
        selectedPost.saveInBackground { (success, error) in
            if success{
                print("Search saved")
            }
            else{
                print("Search could not be saved")
            }
        }
          ```
   - Create Review Screen
      - (Create/POST) Create a new review object
          ```swift
        let review=PFObject(className:"Reviews")
        var bookId = "book ID String"
        var text = "text from user input"
        review["userId"]=PFUser.current()!
        review["bookId"]=bookId
        review["text"]=text
        selectedPost.saveInBackground { (success, error) in
            if success{
                print("Review saved")
            }
            else{
                print("Review could not be saved")
            }
        }
          ```
   - Search History Screen
      - (Read/GET) Query searches by user
          ```swift
        let currentUser=PFUser.current()!
        let query = PFQuery(className:"Searches")
        query.whereKey("userId", equalTo: currentUser)
        query.order(byDescending: "createdAt")
        query.findObjectsInBackground {(searches: [PFObject]?, error: Error?) in
           if let error = error { 
              print(error.localizedDescription)
           } else if let searches = searches {
              print("Successfully retrieved \(searches.count) posts.")
          // TODO: Do something with searches...
           }
        }
          ```
      - (Delete) Delete existing search
          ```swift
        var bookId = "book ID string"
        let query = PFQuery(className:"Followers")
        query.whereKey("follower", equalTo: bookId)
        query.findObjectsInBackgroundWithBlock {
        (searchesToDelete: [PFObject]?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                for search in searchesToDelete as! [PFObject] {
                    search.deleteInBackground()
                }
            }
        }
          ```
   - Profile Screen
      - (Update/PUT) Update user profile image
          ```swift
        var userId=PFUser.current()!.objectId
        let imageData=imageView.image!.pngData()
        let file=PFFileObject(name:"image.png", data:imageData!)
        var query = PFQuery(className:"Users")
        query.getObjectInBackgroundWithId(userId) {
          (user: PFUser?, error: Error?) in
              if error != nil {
                println(error)
              } else if let user = user {
                user["image"]=file
                user.saveInBackground()
              }
        }
          ```
#### [OPTIONAL:] Existing API Endpoints
##### Rainforest API
- Base URL - [https://api.rainforestapi.com/](https://api.rainforestapi.com/)

   HTTP Verb | Endpoint | Description
   ----------|----------|------------
    `GET`    | /request?api_key=[API KEY]&type=reviews&amazon_domain=amazon.com&gtin=updcode | get all reviews with detailed info for a specific book as well as author info|
    `GET`    | /request?api_key=[API KEY]&type=bestsellers&url=https://www.amazon.com/best-sellers-books-Amazon/zgbs/books/ref=zg_bs_nav_0 | get best selling books of Amazon|
    
##### Google Places API
- Base URL - [https://maps.googleapis.com/maps/api/place](https://maps.googleapis.com/maps/api/place)

   HTTP Verb | Endpoint | Description
   ----------|----------|------------
    `GET`    | /nearbysearch/json?location=latutude,longitude&radius=500&types=book_store&key=YOUR_API_KEY | get all nearby bookstores|
    `GET`    | /details/output?key=YOUR_API_KEY&place_id=place_id | get detailed information about a bookstore|
