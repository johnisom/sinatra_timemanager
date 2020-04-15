# Time Manager #
## Effectively Track and Intelligently View Your Productive Hours ##

[![Build Status](https://travis-ci.org/johnisom/sinatra_timemanager.svg?branch=master)](https://travis-ci.org/johnisom/sinatra_timemanager)
[![Coverage Status](https://coveralls.io/repos/github/johnisom/sinatra_timemanager/badge.svg?branch=master)](https://coveralls.io/github/johnisom/sinatra_timemanager?branch=master)
[![codebeat badge](https://codebeat.co/badges/4f263840-af20-429e-8493-697f7c2dbfff)](https://codebeat.co/projects/github-com-johnisom-sinatra_timemanager-master)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Made With Love](https://img.shields.io/badge/made%20with-❤-f00)](https://images.unsplash.com/photo-1510771463146-e89e6e86560e)

Time Manager is a [Sinatra][sinatra] web application for tracking study/work time so that you know exactly how many of your precious hours are going to good use. The web app is hosted [here][time-manager] on Heroku and the Github repository is [here][github].

This app was created as an optional project for [Launch School][ls]'s RB175 course. The two other optional projects I created are the games [Tic Tac Toe][ttt] and [Twenty-One][twenty-one].

## Usage ##

Additional help and instructions on how to use this application can be found on the [help section][help] of the app website.

### 1) Go To [The Time Manager][time-manager] ###

<p align="center">
  <img alt="Home Page Signed Out" src="examples/home-signed-out.png" width="750px">
</p>

Here you'll find all the links and pages that you can access in your current state of being signed out,
as well as simple first time instructions on the home (current) page.

### 2) Go To The [Help Page][help] ###

<p align="center">
  <img alt="Help Page" src="examples/help.png" width="750px">
</p>

Here you can read up on all of the different commands: what they do and how to use them.
It is suggested you read this whole section before using this application.

### 3) [Sign In][sign-in] ###

<p align="center">
  <img alt="Sign In Page" src="examples/sign-in.png" width="750px">
</p>

If you already have an account, you can just sign in here and get right to work. If you don't, you may
create one or use the test account that is free for everybody to use as explained in this disclaimer
at the bottom of the *About* section:

<p align="center">
  <img alt="Disclaimer for Heroku's ephemeral file system" src="examples/disclaimer.png">
</p>


### 4) Or, Alternatively, [Sign Up][sign-up] ###

<p align="center">
  <img alt="Sign Up Page" src="examples/sign-up.png" width="750px">
</p>

If you decide to use this application with your own user, it is very important that you are connected to
this application with HTTPS. You can verify this by looking at the URL field in your browser
to see that it has a lock icon and says that your connection is secure. If you view the whole URL
(you must double-click in Chrome, Firefox and Edge show by default), You will see something like this:

<p align="center">
  <img alt="Secure URL Example" src="examples/secure-url.png">
</p>

Once you have signed up, you will now see that your header has changed and has a few additional buttons, one
of which is highligthed in this screenshot:

<p align="center">
  <img alt="Signed In Header with 'About' Highlighted" src="examples/header-signed-in.png" width="750px">
</p>

### 5) Do An Action ###

<p align="center">
  <img alt="Actions Page" src="examples/actions.png" width="750px">
</p>

This is the control terminal of the application. You can start your time, stop it, or undo the last start or stop that you did.
Get familiar with it. I suggest you read up on [Start][start], [Stop][stop], and [Undo][undo] on the [help][help] page.
Be careful with the actions that you commit here. Currently, there is no feature to edit a previously started/stopped time or message, only to delete the last entry, whether it was a start or a stop.

### 6) View Logged Time ###

<p align="center">
  <img alt="Default View Page" src="examples/view-default.png" width="750px">
</p>

This is by no doubt the heart of the application.
All your intelligent reporting is on this very page, where you can view within a specified timeframe with a selection of 5 different view options.
To be able to effectively use this section, read the [help][help] section on [View][view] where you can 
get sufficient help on the [Timeframe][timeframe] and [View Options][view-options] filters of viewing.

Here is an example with Timeframe set from *19* to *13* days ago with the view option of *Day Delimited*:

<p align="center">
  <img alt="Scrolling View" src="examples/scroll.gif">
</p>

### 7) Sign Out (optional) ###

<p align="center">
  <img alt="Sign Out Page" src="examples/sign-out.png" width="750px">
</p>

Once you've finished using the application, go ahead and sign out. While not mandantory, it is reccommended as your session will last the duration that Heorku's dyno is up and running, which is approximately a full day.

## Inspiration ##

TL;DR: Inspired by [this][python-tm].

The design and idea for this app comes from a similar command-line application that I had previously made with Python. The Github repository for that project can be found [here][python-tm]. The impact that my command-line version had on the web application becomes very apparent when you look at the [View][view] page.

I created the original command-line version of this application partly in response to a challenge of getting 400 good hours of Launch School studying in between 2019-11-08–2019-12-31 and partly because I didn't have any idea where my time was *actually* going. At the very least, I needed a tool to help me to track just the raw time going towards study-related stuff, and I didn't want to have to learn to use Microsoft Excel or to manually calculate the time.

Out of this desire came a command-line prototype, implemented in Python, that allowed me to track my raw time as well as displaying each study session. I could just type `time-manager john start` and `time-manager john stop` into my terminal, carefree, and it would take care of it all for me.

However, I quickly came to the realization that this was simply not enough. Sure, I can track my time, sparing me the need to manually write my entries down, but how would I know *exactly* what it was going to? Or how could I quickly view results for each day?

Enter messages and view options.

Implementing messages was easy. All I had to do was change how the data was stored and parsed, and then I had a message I could display.

View options? Not so much.

They required lots of logic to summarize and display and separate, which is reflected by how powerful they can be. No, they won't magically change your lives, but they spare you the mental work that I so desperately wanted to avoid that caused me to make this application in the first place.

After many more iterations of this cycle, I found myself with a command-line application to use on the daily as well as a web aplication to demonstrate my abilities and give my programmings skills a little stretch.

## Limitations ##

This is a fully-functional application that can store usernames and [bcrypt][bcrypt] encrypted password hashes. However, the server that it is hosted on, Heroku, does not support these features, as breifly explained in this disclaimer:
<p align="center">
  <img alt="Disclaimer for Heroku's ephemeral file system" src="examples/disclaimer.png">
</p>

I don't plan on making the web version have permanent accounts or data storage anytime soon, but if requests for that come in, I'll consider it because all it requires is hosting it somewhere without an ephemeral file system.

## Installation ##

1. Clone this repository (`git clone https://github.com/johbnisom/sinatra_timemanager.git`)
2. `cd` into the repository (`cd sinatra_timemanager`)
3. Install dependencies (`bundle install`)
   - If you don’t have ruby-2.6.5, install it
4. Ensure that all tests are passing (`bundle exec rake`)
5. Run the server locally (`bundle exec rackup`)
6. Enjoy tracking and managing your time at http://localhost:9292/

## Contributing ##

Send a pull request or open an issue.

Please also update tests to reflect those changes.

## License ##
[MIT](LICENSE) © 2019

[sinatra]: http://sinatrarb.com/
[ttt]: http://just-a-tic-tac-toe-app.herokuapp.com/
[twenty-one]: http://just-a-twenty-one-app.herokuapp.com/
[time-manager]: https://the-time-manager.herokuapp.com/
[help]: https://the-time-manager.herokuapp.com/help
[start]: https://the-time-manager.herokuapp.com/help#start
[stop]: https://the-time-manager.herokuapp.com/help#stop
[undo]: https://the-time-manager.herokuapp.com/help#undo
[timeframe]: https://the-time-manager.herokuapp.com/help#timeframe
[view-options]: https://the-time-manager.herokuapp.com/help#view-options
[view]: https://the-time-manager.herokuapp.com/view
[sign-in]: https://the-time-manager.herokuapp.com/sign-in
[sign-up]: https://the-time-manager.herokuapp.com/sign-up
[github]: https://github.com/johnisom/sinatra_timemanager/
[python-tm]: https://github.com/johnisom/time_manager/
[ls]: https://launchschool.com/
[bcrypt]: https://github.com/codahale/bcrypt-ruby
