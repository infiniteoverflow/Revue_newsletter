A server app built using [Shelf](https://pub.dev/packages/shelf),
configured to enable running with [Docker](https://www.docker.com/). This app fetches the Issues of a Revue Newsletter.

# Running the code

## Running with the Dart SDK

You can run the example with the [Dart SDK](https://dart.dev/get-dart)
like this:

```
$ dart run bin/server.dart
Server listening on port 8080
```

## Running with Docker

If you have [Docker Desktop](https://www.docker.com/get-started) installed, you
can build and run with the `docker` command:

```
$ docker build . -t myserver
$ docker run -it -p 8080:8080 myserver
Server listening on port 8080
```

## Endpoint details

After running the Dart app using the steps mentioned above, open the url : http://localhost:8080/newsletter

**Request Method :** `POST`  
**Request body :** 
```json
{
    "profile":"The-Flutter-Bi-Weekly"
}
```

_Note: Change the newsletter name accordingly to get its issue._