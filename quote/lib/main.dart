import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:math';

void main() {
  runApp(InspiringQuotesApp());
}

class InspiringQuotesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inspiring Quotes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: QuoteScreen(),
    );
  }
}

class QuoteScreen extends StatefulWidget {
  @override
  _QuoteScreenState createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  String _quote = "Welcome! Get inspired by a new quote each day.";
  List<String> _quotes = [
    "The only limit to our realization of tomorrow is our doubts of today.",
    "The purpose of our lives is to be happy.",
    "Life is what happens when you're busy making other plans.",
    "Get busy living or get busy dying.",
    "You have within you right now, everything you need to deal with whatever the world can throw at you."
  ];
  List<String> _favoriteQuotes = [];
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadQuote();
    _loadFavorites();
  }

  void _loadQuote() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _quote =
          prefs.getString('quote') ?? _quotes[Random().nextInt(_quotes.length)];
      _isFavorite = _favoriteQuotes.contains(_quote);
    });
  }

  void _refreshQuote() {
    setState(() {
      var s = _quote = _quotes[Random().nextInt(_quotes.length)];
      _isFavorite = _favoriteQuotes.contains(_quote);
    });
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('quote', _quote);
    });
  }

  void _shareQuote() {
    Share.share(_quote);
  }

  void _favoriteQuote() {
    setState(() {
      if (_favoriteQuotes.contains(_quote)) {
        _favoriteQuotes.remove(_quote);
        _isFavorite = false;
      } else {
        _favoriteQuotes.add(_quote);
        _isFavorite = true;
      }
    });
    _saveFavorites();
  }

  void _saveFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('favorites', _favoriteQuotes);
  }

  void _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoriteQuotes = prefs.getStringList('favorites') ?? [];
      _isFavorite = _favoriteQuotes.contains(_quote);
    });
  }

  void _viewFavorites() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            FavoriteQuotesScreen(favoriteQuotes: _favoriteQuotes),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inspiring Quotes"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: _viewFavorites,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _quote,
              style: TextStyle(fontSize: 24.0, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: _refreshQuote,
                ),
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: _shareQuote,
                ),
                IconButton(
                  icon: Icon(
                    Icons.favorite,
                    color: _isFavorite ? Colors.red : Colors.grey,
                  ),
                  onPressed: _favoriteQuote,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FavoriteQuotesScreen extends StatelessWidget {
  final List<String> favoriteQuotes;

  FavoriteQuotesScreen({required this.favoriteQuotes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorite Quotes"),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: favoriteQuotes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(favoriteQuotes[index]),
          );
        },
      ),
    );
  }
}
