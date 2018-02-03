# Project 4 - *Instagram-clone*

**Instagram-clone** is a photo sharing app using Parse as its backend.

Time spent: **15** hours spent in total

## User Stories

The following **required** functionality is completed:

- [X] User can sign up to create a new account using Firebase authentication (+1pt)
- [X] User can log in and log out of his or her account (+1pt)
- [ ] The current signed in user is persisted across app restarts (+1pt)
- [X] User can take a photo, add a caption, and post it to "Instagram" (+2pt)
- [X] User can view the last 20 posts submitted to "Instagram" (+2pt)
- [X] User can pull to refresh the last 20 posts submitted to "Instagram" (+1pt)
- [ ] User can tap a post to view post details, including timestamp and caption (+2pt)

The following **optional** features are implemented:

- [X] Style the login page to look like the real Instagram login page (+1pt)
- [X] Style the feed to look like the real Instagram feed (+1pt)
- [ ] User can use a tab bar to switch between all "Instagram" posts and posts published only by the user. AKA, tabs for Home Feed and Profile (+2pt)
- [ ] Add a custom camera using the CameraManager library (+1pt)
- [X] User can load more posts once he or she reaches the bottom of the feed using infinite scrolling (+2pt)
- [ ] Show the username and creation time for each post using section headers (+1pt)
   - If you use TableView Section Headers to display the the username and creation time, you'll get "sticky headers" similar to the actual Instagram app.
- [ ] After the user submits a new post, show a progress HUD while the post is being uploaded to Parse (+1pt)
- User Profiles:
   - [ ] Allow the logged in user to add a profile photo (+2pt)
   - [ ] Display the profile photo with each post (+1pt)
   - [ ] Tapping on a post's username or profile photo goes to that user's profile page (+2pt)
- [ ] User can comment on a post and see all comments for each post in the post details screen (+3pt)
- [ ] User can like a post and see number of likes for each post in the post details screen (+1pt)
- [ ] Run your app on your phone and use the camera to take the photo (+1pt)


The following **additional** features are implemented:

- [X] Uses firebase instead of parse
- [X] User can sign in using google or with an email/password
- [X] Keyboard shifts the screen up so you can still see what you are typing in a text box
- [X] User can add their location to a post


## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='http://i.imgur.com/link/to/your/gif/file.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Credits

List an 3rd party libraries, icons, graphics, or other assets you used in your app.

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library


## Notes

Describe any challenges encountered while building the app.

Completely learning how to use firebase auth, storage, and the realtime database took a lot of time since the project was explained to use parse.
