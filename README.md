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

### Gem requirements

- mini_magick gem - To parse Exif data
- Geocoder gem - Upon creation of a photo record, reverse geocode the lat/long coordinates embedded in a photo to populate the address tags for the Photo
- pagy - for pagination
- image_processing - for resizing photos

### Standalone app requirements

- imageMagick - dependency of mini_magick

### CSS requirements

- All pages will use custom css

### Rails stack

#### Production

- Active Storage - To coordinate the storing of files
- Webpacker - For packaging assets into consumable resources for the browser
- Password hashing: bcrypt gem
- Database: PostgreSQL, pg gem
- Rails 6

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

- Uses geocoder to get an address based on a latitude and logitude embedded in the photo data. Populates City, State, and Country columns of the Photo model.

### Deployment instructions

#### prerequisites

- install ruby 2.7.2
- install postgres - project uses postgres for test, development, and production. Also make sure the current profile has a role that can createdb and login
- a valid google maps api key. I have locked down the current production api key to the heroku address https://aqueous-mesa-56772.herokuapp.com because the api key can be read by looking at the page source. In order to prevent anonymous internet users from using the key, I have added the heroku address as the only site that can use that particular key.  
  For convenience, I have included a develpment api key on line 70 of maps/index.html.erb. No action needs to be taken for it to work correctly in develpment. The api key only needs to be changed when pushing to production.

#### starting app in development

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

- To start the memory profiler uncomment all the lines in config/initializers/memory_profiler.rb. This will start a profiling session when the rails server starts. On stopping a rails server, it will print a log to the command line

## Development log

### Differences between proposal and final product

- I decided not to go with bootstrap because of performace concerns. Removing bootstrap improved response time for my pages from 60ms to 37ms.
- I decided to swap out kaminari with pagy because of memory use.
- I was not able to implement the drag and drop file upload. I spent many hours trying to get drop.js to work but I was unable to make it work. I have left that file in the project but I'm not using it.

### Major setbacks in development

- On one of the final days of development, I set up the production database with a very secure password of &fNsYF42Mf^7=w8d. This password worked and I successfully set up the production environment. However, when I shut down the computer, it would not shut off because of postgres. I did not want to power cycle it right away so I left it on until the next morning. In the morning, it was still stuck. I hard power cycled. Then when I tried to launch my production environment I got the error message:

```
URI::InvalidURIError: bad URI(is not URI?).  "postgres://capstone_project_wad_c5_s4_750:&fNsYF42Mf^7=w8d@localhost/capstone_project_wad_c5_s4_750_production".
```

I could no longer start the rails server. Every rails command resulted in the same invalid uri error. Rails test, rails c, rails s, etc all resulted in the uri error. I tried running other projects and got the same uri error. I ran rails new and got the uri error. I checked postres, it was alive and accepting requests. The database existed and I could run manual operations against the database. I think the problem was that the password I used contained special characters that messed up postgres in some way. Changing the password in database.yml did not help. I reset the password in posgres. That did not help. I removed and reinstalled postgres. That still did not fix the error. I was still getting the invalid uri error when running rails new. I had to reboot to clear the old password from memory and the new instance of postgres finally picked up the updated password. Since the password gets concatinated into a url for the postgres requests, my guess is that the & ampersand symbol is the problem since it's a reserved character in url encoding. I probably did not have to reinstall postgres. I should have killed the daemon process to clear the bad password from memory.

- I moved from using sprockets to webpacker. This mean moving my images and stylesheets to app/javascript/stylesheets. I moved the files to the new folder and configured webpacker to use my new stylesheets. Everything looked good. No problems with the styles. But now when I tried to submit a comment, I got the following error:

```
 ActionView::Template::Error - link_directory argument must be a directory:   app/views/comments/create.js.erb:0:in `view template'
```

I only moved the stylesheets over. I did not touch the view folder at all. I did't alter any javascript files either. The error turned out to be a general sprokets error. I had deleted the app/assets/stylesheets directory and sprockets expects that directory to exist, even if it's empty. I added the folder back and everything worked correctly.  
Moving all assets from sprockets to webpacker was well worth it because it fixed the race condition that made my tests fail incorrectly. Under sprockets, when the entire test suite was launched at once, tests would run and fail before sprockets had finished compiling the assets. Running a single test file under sprockets worked fine but multiple test files would intermittently fail. Now, with webpacker, all tests pass and I don't get incorrectly failing tests.
