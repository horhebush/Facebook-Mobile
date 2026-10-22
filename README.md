# Pawbook

Facebook replication app from Mobile Programming, updated for **Long Exam 1**
of Advanced Mobile Programming (INF231).

**Name:** Jorge Fuertes
**Section:** INF231

Pawbook started as a pet-themed Facebook clone with hard-coded posts and a
JSON file for accounts. The long exam replaces all of that with the
[dummyjson.com](https://dummyjson.com) API: sign-in, posts, comments and
likes all go through the network now.

Sign in with any dummyJSON account, for example `emilys` / `emilyspass`.

## Structure

```
lib/
├── models/      Post, Comment, User
├── providers/   ThemeProvider (dark/light, saved on the device)
├── screens/     splash, signin, home, newsfeed, notification, profile, detail, settings
├── services/    PostService, CommentService, UserService
├── widgets/     custom_button, custom_dialogs, custom_font, custom_info,
│                custom_inkwell_button, custom_textformfield, post_card,
│                pawbook_logo, pawbook_loading
├── constants.dart   host from assets/.env, palette, avatarUrl()
└── main.dart
```

The services are the only files that touch `http` and `jsonDecode`. Every
method returns a model or a list of models, so the screens never see raw JSON.

## The given code

`models/post.dart` and `services/post_service.dart` are the handout's snippets.
One field was added to the model: `title`, because the API sends it and the
feed shows it. The rest is as given, including the `postId` fallback that the
posts endpoint never fills (it stays `0`).

## Enhancement 1: sign-in, saved session, splash

`UserService.loginUser()` posts to `/auth/login`. On success it writes every
field of the response into `SharedPreferences`; `getUser()` reads them back
through the same `User.fromJson` the response went through, so one factory
covers both sources. `isLoggedIn()` only checks that an access token is stored.

`SplashScreen` waits two seconds, asks `isLoggedIn()`, and calls
`pushReplacementNamed` to `/home` or `/signin`. Replacement matters: the
splash leaves the stack, so Back cannot return to it.

A wrong password answers `{"message": "Invalid credentials"}`. The service
reads that field instead of showing the raw body.

## Enhancement 2: profile posts, settings, sign out

`PostService.getPostsByUser()` calls `/posts/user/{id}` with the id of the
signed-in user. `HomeScreen` loads the saved user once and hands it to
`ProfileScreen`, which renders those posts with the same `PostCard` the feed
uses. The About tab shows the saved fields; the stats line counts the posts
and their likes.

`SettingsScreen` has the dark-mode switch and the Sign Out button. The theme
choice is kept in `SharedPreferences` by `ThemeProvider`, so it survives a
restart and also survives signing out: `logout()` removes only the user keys
rather than calling `prefs.clear()`. Sign Out goes through a confirm dialog,
then `pushNamedAndRemoveUntil('/signin')` so the feed is gone from the stack.

## Enhancement 3: comments, likes, adding comments

`CommentService.getComments()` reads `/posts/{id}/comments` and
`DetailScreen` lists them under the post. The comments endpoint nests the
author as `{id, username, fullName}`, which `Comment.fromJson` flattens.
Avatars come from `/icon/{username}/128`, the same pattern the user records
use, so no extra request is needed per comment.

The like button is clickable on the card and on the detail screen.
`PostService.toggleLike()` keeps a set of liked ids in `SharedPreferences`
and sends the new count with `PATCH /posts/{id}`. dummyJSON answers with the
updated post but does not store it, which is why the saved id is what makes a
like stick across restarts. When the detail screen closes, the card re-reads
the set so the two stay in step.

`addComment()` posts to `/comments/add` as the signed-in user. The response is
appended to the list on screen. Like the PATCH, it is simulated: the API
echoes the comment back and forgets it.

The Alerts tab reuses all three: it fetches the user's posts, then the
comments on each, and shows "X commented on your post". Tapping one opens the
post.

## Feed

`NewsfeedScreen` makes two calls: `/posts` and `/users?limit=0&select=...`.
Posts only carry a `userId`, so the second call builds a map of every user
and each card looks up its author's name and avatar from it. That is two
requests for the whole feed instead of one per post. The ad carousel from the
original app is kept, one after every third post.

## Running

```bash
flutter pub get
flutter analyze      # No issues found!
flutter test
flutter run
```

`assets/.env` holds `HOST=https://dummyjson.com` and is committed on purpose.
