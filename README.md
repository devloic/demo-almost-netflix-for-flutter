this is a "revival" commit of the appwrite almost netflix app

since the scraper is related to this app i decided to include it in almostnetflixprojectsetup folder  
original project can be found [here](https://github.com/Meldiron/almost-netflix-project-setup)

since this is more like a showcase demo I removed signup and the users login as anonymous users

this fork is focused on performance optimization and web compatibility

- removed many notifylisteners that caused too many unecessary rebuilds
- moved future creation outside of futurebuilders (one of them was generating a rebuild loop)
- changed context.read =context.write where relevant according to provider recommendations
- reduced queries to database for watchlist logic in providers
- using getFilePreview so the app doesnt handle huge image files
- removed  
   `_scrollController = ScrollController()
   ..addListener(() {
   setState(() {
   _scrollOffset = _scrollController.offset;
   });
   }); `  
   in home.dart, it was causing rebuilds everytime the user scrolled
   down which slowed the scrolling tremendously

possible improvements:

- change scraper so it stores different image sizes according to app
   needs ( the app for now downloads all the hires images)

suggestion for appwrite:  
I guess getFilePreview is working on client side. Would be cool to have
a cloudinary like functionality on appwrite where images get resized/cached
dynamically on server side according to parameters in the url of the
images

# Almost Netflix - Flutter

![Banner](readme_banner.png)

## Requirements

Before using this project, you will need to have Appwrite instance with Almost Netflix project ready. You can visit Project setup [GitHub repository](https://github.com/Meldiron/almost-netflix-project-setup) or [Dev.to post](https://dev.to/appwrite/did-we-just-build-a-netflix-clone-with-appwrite-28ok).

## Usage

```bash
$ git clone https://github.com/appwrite/demo-almost-netflix-for-flutter.git
$ cd demo-almost-netflix-for-flutter
$ open -a Simulator.app
$ flutter run
```

Make sure to update Endpoint and ProjectID in `lib/api/client.dart`.

The application will be listening on port `3000`. You can visit in on URL `http://localhost:3000`.

### `assets`

The assets directory contains your images such as logos as well as anything else you would like your project to use, be sure to update `pubspec.yaml` with any addition folders.

More information about assets can be found in [the documentation](https://docs.flutter.dev/development/ui/assets-and-images).

### `lib/api`

The `lib/api` folder contains our API request client that is used for communicating with Appwrite endpoints.

### `lib/data`

The `lib/data` folder is where we put anything that represents data such as our models

### `lib/extensions`

We use the `lib/extensions` folder to extend the Dart language with helpers for convience methods.

### `lib/providers`

Our `lib/providers` folder is where we create our `ChangeNotifiers` that allow observation and access across our app.

For more information about Provider library we used can be found in the [documentation](https://pub.dev/packages/provider)

### `lib/screens`

Directory `lib/screens` is where we place all of our top level views and responsible for laying out how we present to our users.

### `lib/widgets`

The `lib/widgets` directory contains all of our Flutter widgets. Widgets are the main component of Flutter and can make up different pars of your screen.

For more information on Widgets can be found in the [documentation](https://docs.flutter.dev/reference/widgets)
