# Get Em!

**Video Demo**


[![demo](https://github.com/gdsmith1/Get-Em/blob/main/projectdescription/images/demothumbnail.jpg)](https://github.com/gdsmith1/Get-Em/blob/main/projectdescription/videos/demo.mp4)
[OneDrive alternative](https://csuchico-my.sharepoint.com/personal/jmvelazquez2_csuchico_edu/_layouts/15/stream.aspx?id=%2Fpersonal%2Fjmvelazquez2%5Fcsuchico%5Fedu%2FDocuments%2FGet%20Emm%21%20App%20Demo%2Emp4&nav=eyJyZWZlcnJhbEluZm8iOnsicmVmZXJyYWxBcHAiOiJPbmVEcml2ZUZvckJ1c2luZXNzIiwicmVmZXJyYWxBcHBQbGF0Zm9ybSI6IldlYiIsInJlZmVycmFsTW9kZSI6InZpZXciLCJyZWZlcnJhbFZpZXciOiJNeUZpbGVzTGlua0NvcHkifX0&ga=1&referrer=StreamWebApp%2EWeb&referrerScenario=AddressBarCopied%2Eview)

<!-- Output copied to clipboard! -->

<!-----

Conversion notes:

* Docs to Markdown version 1.0β34
* Thu Oct 05 2023 21:07:09 GMT-0700 (PDT)
* Source doc: cins project proposal
* This document has images: check for >>>>>  gd2md-html alert:  inline image link in generated source and store images to your server. NOTE: Images in exported zip file from Google Docs may not appear in  the same order as they do in your doc. Please check the images!

----->



**Project Title**

_Get ‘Em!_
[https://github.com/gdsmith1/Get-Em](https://github.com/gdsmith1/Get-Em)

**Project Members**

Gibson Smith, Ismael Kane, Jesus Velazquez

**Project Description**

The goal of this project is to make an Android-only game similar to Niantic’s _Pokemon Go_.  The app will use a Google Maps API to track the players location, as well as place markers on the map to represent opportunities to catch the “pokemon”.  When the player reaches these locations, they can start a catch event, where they will have a randomly generated chance to collect them.  The app will also utilize a stateless database to store information about “pokemon” that players catch and when and where they were caught.  The app will allow players to query this database to see the creature they caught, and in another section to see recently caught creatures from all players.

**Project UI’s**

Login Page:

![login](https://github.com/gdsmith1/Get-Em/blob/main/projectdescription/images/image1.png)

Home Page:

![home](https://github.com/gdsmith1/Get-Em/blob/main/projectdescription/images/image7.png)

1. Creatures to capture
2. Player Icon
3. Capture button
4. Community Page
5. Inventory Page
6. Settings Page

Inventory Page

![inventory](https://github.com/gdsmith1/Get-Em/blob/main/projectdescription/images/image2.png)

1. Creature descriptions
2. Back button

Settings Page

![settings](https://github.com/gdsmith1/Get-Em/blob/main/projectdescription/images/image3.png)

1. Back button
2. Difficulty setting
3. Sign out
4. Hello Username
5. User Profile Picture

Community Page

![community](https://github.com/gdsmith1/Get-Em/blob/main/projectdescription/images/image4.png)

1. Back button
2. Player List with quick description

Activity Page

![activity](https://github.com/gdsmith1/Get-Em/blob/main/projectdescription/images/image5.png)

1. Back button
2. Ball to throw at creature
3. Creature
4. Stamina Tracker

**Diagram Screen Relationships**

![map](https://github.com/gdsmith1/Get-Em/blob/main/projectdescription/images/image6.png)


**Project Deliverables**



* Firebase authentication with a Gmail account to assign users
* Multiple pages in a navigation stack
* Actively updating location as accurately as possible (with user permissions)
* Randomly generated POIs added to the map
* Capture button that only functions when nearby a POI
* Backend Firebase database that remains stateless
* Database is only visible from inventory and community queries
* Database holds a collection for each user, each collections holds a document for information about the creature caught
* Creature’s documents hold information such as species, weight, value, location caught (regional accuracy), date caught, difficulty caught on, etc.

**Additional Goals**



* Friends system to connect users
* Website view of the database to show live player stats
* Navigation directions via Google Maps towards points of interest
* Profile pictures for players, replaces default icon
* Camera background for catch events

**Project Organization**



* Part 1
    * Authentication screen 
    * Attach users to database collections
* Part 2
    * Navigation stack
    * Screen UI’s
* Part 3
    * Location permissions
    * Active location updates
    * Google Maps API
* Part 4
    * Gameplay elements (creatures appear, catch events)
    * Settings Page
* Part 5
    * Firebase database information updates
    * Database queries on community and inventory pages
* Part 6
    * Optional goals
    * Final UI design
