import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_layout_homework3/TopRatedMovie.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    home: TopRatedMovieHome(),
    routes: {
      SecondScreen.routeName: (context) => SecondScreen() //simple extract
    },
  ));
}

class TopRatedMovieHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TopRatedMovieState();
  }
}

class TopRatedMovieState extends State<TopRatedMovieHome> {
  var url =
      "https://api.themoviedb.org/3/movie/top_rated?api_key=f66f74d7ca62dc1d7ac1e75ba3df1530";

  TopRatedMovie topRatedMovie;

  @override
  void initState() {
    super.initState();
    fectchData();
  }

  fectchData() async {
    var data = await http.get(url);

    var jsonData = jsonDecode(data.body);
    topRatedMovie = TopRatedMovie.fromJson(jsonData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TopRated Movie'),
      ),
      body: topRatedMovie == null
          ? Center(child: CircularProgressIndicator())
          : GridView.count(
              crossAxisCount: 2,
              children: topRatedMovie.results
                  .map(
                    (topRated) => Padding(
                      padding: EdgeInsets.all(2.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, SecondScreen.routeName,
                              arguments: Results(
                                popularity: topRated.popularity,
                                voteCount: topRated.voteCount,
                                video: topRated.video,
                                posterPath: topRated.posterPath,
                                id: topRated.id,
                                adult: topRated.adult,
                                backdropPath: topRated.backdropPath,
                                originalLanguage: topRated.originalLanguage,
                                originalTitle: topRated.originalTitle,
                                genreIds: topRated.genreIds,
                                title: topRated.title,
                                voteAverage: topRated.voteAverage,
                                overview: topRated.overview,
                                releaseDate: topRated.releaseDate,
                              ));
                        },
                        child: Hero(
                            tag: topRated.posterPath,
                            child: Card(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Container(
                                    child: Image.network(
                                        "https://image.tmdb.org/t/p/w500/" +
                                            topRated.posterPath),
                                    width: 140,
                                    height: 140,
                                  ),
                                  Text(
                                    topRated.originalTitle,
                                    style: TextStyle(
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            )),
                      ),
                    ),
                  )
                  .toList(),
            ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  static const routeName = '/passArguments';

  @override
  Widget build(BuildContext context) {
    final Results args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated Movie'),
      ),
      body: Column(children: [
        Image.network("https://image.tmdb.org/t/p/w500/" + args.posterPath, width: 200,height: 200),
        Text(args.originalTitle,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
            Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text("Rating: "+args.voteAverage.toString()),
            Text(args.releaseDate),
          ],
        ),
        Text(args.overview),
    
        
      ]),
    );
  }
}
