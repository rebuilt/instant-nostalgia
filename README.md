# Instant Nostalgia

This is the repository for the Instant Nostalgia website, live here:

https://aqueous-mesa-56772.herokuapp.com

The website allows users to see their photos on a map. A marker is placed on the map corresponding to the location the photo was taken. Users can create albums and share those albums with specific users. Or they can make an album public and share it with the world.

## Third party services

### External APIs

- Amazon S3 - aws-sdk-s3 - Storage endpoint
- Google maps javascript API - Embed a dynamic map on the frontend and populate map with markers corresponding to locations where the photos were taken
- Heroku - Deployment service

### Javascript requirements

- Stimulus - For linking html elements to javascript objects and binding javascript methods to html element events.
- Tiny slider - A javascript library for populating the maps view with a row of photos.
- Dropzone.js - For drag and drop file upload

### Gem requirements

- mini_magick gem - To parse Exif data
- Geocoder gem - Upon creation of a photo record, reverse geocode the lat/long coordinates embedded in a photo to populate the address tags for the Photo
- pagy - for pagination
- image_processing - for resizing photos

### Standalone app requirements

- imageMagick - dependency of mini_magick

### CSS requirements

- All pages are based on custom css

### Rails stack

#### Production

- Active Storage - To coordinate the storing of files
- Webpacker - For packaging assets into consumable resources for the browser
- Password hashing: bcrypt gem
- Database: PostgreSQL, pg gem
- Rails 6
- Action text - rich text for comments

#### Development

- guard/Rack-livereload - automatically reloads page on edits in the code
- better_errors - different view of rails errors messages
- memory_profiler - for profiling memory use
- rack-mini-profiler - includes load times at top left of page
- solargraph - ruby language server for vim
- flamegraph - for profiling application
- stackprof - required by flamegraph
- i18n-tasks - for translations.
- easy-translate - required by i18n-tasks

## Ruby version

- Ruby 2.7.2

## Rails version

- Rails 6.0.3.4

## System dependencies

# Image Magick

```bash
sudo apt install imagemagick
```

## Configuration

### Database creation

rails db:setup

### Database initialization

This project does not include any seed data

### How to run the test suite

#### model tests:

```bash
rails test
```

#### system tests:

```bash
rails test:system
```

### Services (job queues, cache servers, search engines, etc.)

#### Reverse geocode job

- app/jobs/reverse_geocode_job.rb - Uses geocoder to get an address based on a latitude and logitude embedded in the photo data. Populates City, State, and Country columns of the Photo model.

### Deployment instructions

#### prerequisites

- install ruby 2.7.2
- install postgres - project uses postgres for test, development, and production. Also make sure the current profile has a role that can createdb and login
- a valid google maps api key. I have locked down the current production api key to the heroku address https://aqueous-mesa-56772.herokuapp.com because the api key can be read by looking at the page source. In order to prevent anonymous internet users from using the key, I have added the heroku address as the only site that can use that particular key.  
  For convenience, I have included a develpment api key on line 70 of maps/index.html.erb. No action needs to be taken for it to work correctly in develpment. The api key only needs to be changed when pushing to production.

#### Starting app in development

- Commands to get up and running

```bash
git clone https://github.com/epfl-extension-school/capstone-project-wad-c5-s2-750-2181.git
cd capstone-project-wad-c5-s2-750-2181
bundle install
rails db:setup
rails webpacker:install
./bin/webpack-dev-server        - or compile assets manually
sudo apt install imagemagick
rails s
```

- If you want to enable live reloading when changes to the app are made start the guard process before the rails webserver

```bash
bundle exec guard
```

- To start the memory profiler uncomment all the lines in config/initializers/memory_profiler.rb. This will start a profiling session when the rails server starts. On stopping a rails server, it will print a log to the command line. This will take several minutes depending on the amount of time spent profiling. Be patient, it has not crashed.

- Mini profiler is enabled by default. You'll see a display of the time in milliseconds it takes for a page to load on the top left of every page you visit. This time is not accurate if you have auto-reload enabled since auto-reload slows down page loads by half a second, unless loading page from turbolinks cache.

## Development log

### Differences between proposal and final product

- I decided not to go with bootstrap because of performace concerns. Removing bootstrap improved response time for my pages from 60ms to 37ms.
- I decided to swap out kaminari with pagy because of memory use.
- I used rich text for comments but was not able to display rich text when updating the page on an ajax request. You can see formatting on page load or page refresh but not on ajax update.

### Major setbacks in development

- On one of the final days of development, I set up the production database with a very secure password of &fNsYF42Mf^7=w8d. This password worked and I successfully set up the production environment. However, when I shut down the computer, it would not shut off because of postgres. I did not want to power cycle it right away so I left it on until the next morning. In the morning, it was still stuck. I hard power cycled. Then when I tried to launch my production environment I got the error message:

```
URI::InvalidURIError: bad URI(is not URI?).  "postgres://capstone_project_wad_c5_s4_750:&fNsYF42Mf^7=w8d@localhost/capstone_project_wad_c5_s4_750_production".
```

I could no longer start the rails server. Every rails command resulted in the same invalid uri error. Rails test, rails c, rails s, etc all resulted in the uri error. I tried running other projects and got the same uri error. I ran rails new and got the uri error. I checked postres, it was alive and accepting requests. The database existed and I could run manual operations against the database. I think the problem was that the password I used contained special characters that messed up postgres in some way. Changing the password in database.yml did not help. I reset the password in posgres. That did not help. I removed and reinstalled postgres. That still did not fix the error. I was still getting the invalid uri error when running rails new. I had to reboot to clear the old password from memory and the new instance of postgres finally picked up the updated password. Since the password gets concatinated into a url for the postgres requests, my guess is that the & ampersand symbol is the problem since it's a reserved character in url encoding. The rails server attempted to make a request to the database using the malformed uri and the connection was left open, being blocked by the & character. I probably did not have to reinstall postgres. I should have killed the daemon process after changing the password in postgres to clear the bad password from memory.

- I moved from using sprockets to webpacker. This meant moving my images and stylesheets to app/javascript/stylesheets. I moved the files to the new folder and configured webpacker to use my new stylesheets. Everything looked good. No problems with the styles. But now when I tried to submit a comment, I got the following error:

```
 ActionView::Template::Error - link_directory argument must be a directory:   app/views/comments/create.js.erb:0:in `view template'
```

I only moved the stylesheets over. I did not touch the view folder at all. I didn't alter any javascript files either. The error turned out to be a general sprokets error. I had deleted the app/assets/stylesheets directory and sprockets expects that directory to exist, even if it's empty. I added the folder back and everything worked correctly.  
Moving all assets from sprockets to webpacker was well worth it because it fixed the race condition that made my tests fail incorrectly. Under sprockets, when the entire test suite was launched at once, tests would run and fail before sprockets had finished compiling the assets. Running a single test file under sprockets worked fine but multiple test files would intermittently fail. Now, with webpacker, all tests pass and I only get failed test the first time webpacker needs to rebuild the stylesheets. After the first run, stylesheets have already been compiled and tests pass without incorrect failures.

- I had a lot of trouble getting the upload functionality to work correctly. I was testing with a set of photos that had gps information in the metadata so all my uploads worked. However, I was informed that the uploads did not work correctly for all users. In retrospect, I didn't experience upload failures because every photo I uploaded did not trigger a failure. I'm still not sure why the uploads failed but I made a lot of changes to handle all the failures I could think of. After testers triggered some failures, I read the Heroku logs and discovered H27 errors. The Heroku documentation explains "The causes of H27 errors are often hard to pin down as it involves the client (i.e. the users browser) opening a request and then closing the connection before a response can be returned." The following are the steps I took:
  1. Since all the testers used MacOs to upload I installed macOs on a virtual machine to see if the operating system would make a difference. It did not. I successfully uploaded my photo set without triggering H27 errors.
  2. I simulated slow network speed in the browser. My uploads all worked even at the lowest setting. I increased request timeout for the dropzone anyway from 30 seconds to an hour
  3. I corrected a problem in the photo.create method. That method loops through an array of items to create each photo record. However, I made the mistake of handling errors inside the loop. The error was short circuiting the loop and calling the render method to return to the photo.new view. I'm now handling errors outside the loop.
  4. I knew I made a mistake in handling errors but the handling of errors is only half the problem. I still wasn't sure what type of errors were occurring in the system. I started testing uploads with gifs, and movies, and text files. I managed to see an error locally in development. I got a server error of 500 which happened because of an unexpected null. Parsing the metadata of the file failed because of a missing 'DateTime' entry. I was handling null errors when it came to GPS metadata but I was missing a check for 'DateTime'. I corrected that oversight.
  5. I removed the file chooser button. Instead I relied on dropzone.js to handle everything to do with uploads. I deleted direct_uploads.js. Now instead of two elements separately uploading files, only one element will upload files. It's possible that one element was causing a request to close before a response could be returned for the other.
  6. I have also added file type checking to the frontend. Previously I only had checks on the backend. Now I'm limiting file types at the frontend and the backend.
