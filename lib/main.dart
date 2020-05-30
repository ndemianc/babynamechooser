import "package:flutter/material.dart";
import "package:english_words/english_words.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import 'swipe_feed_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Startup Name Generator',
        theme: ThemeData(
          primaryColor: Colors.cyan,
        ),
//        home: RandomWords()
          home: SwipeFeedPage(),
    );
  }
}


class RandomWordsState extends State<RandomWords> {
  final _suggestions = <String>[];
  final _saved = Set<String>();
  final _biggerFont = const TextStyle(fontSize: 18.0);

  void _pushSaved() {
    Navigator.of(context).push(
        MaterialPageRoute<void>(
            builder: (BuildContext context) {
              final Iterable<ListTile> tiles = _saved.map(
                      (String pair) {
                    return ListTile(
                        title: Text(
                          pair,
                          style: _biggerFont,
                        )
                    );
                  }
              );
              final List<Widget> divided = ListTile
                  .divideTiles(
                context: context,
                tiles: tiles,
              ).toList();

              return Scaffold(
                  appBar: AppBar(
                      title: Text('Saved Suggestions')
                  ),
                  body: ListView(children: divided)
              );
            }
        )
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          title: Text('Startup Name Generator'),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
          ]
      ),

      // body: _buildSuggestions(),
//      body: StreamBuilder(
//          stream: Firestore.instance.collection('babyname').snapshots(),
//          builder: (context, snapshot) {
//            if (!snapshot.hasData) return Center(
//              child: CircularProgressIndicator(),
//            );
//
//            return ListView.builder(
//              itemExtent: 80.0,
//              itemCount: snapshot.data.documents.length,
//              itemBuilder: (context, index) =>
//                  _buildRow(snapshot.data.documents[index]),
//            );
//          }
//      },
      body: GridView.count(
        crossAxisCount: 2,
        children: List.generate(100, (index) {
          return Center(
            child: Text(
              'Item $index',
              style: Theme.of(context).textTheme.headline
            ),
          );
        }),
      )
    );

  }

//  Widget _buildSuggestions() {
//    return ListView.builder(
//        padding: const EdgeInsets.all(16.0),
//        itemBuilder: (context, i) {
//          if (i.isOdd) return Divider();
//
//          final index = i ~/ 2;
//          if (index >= _suggestions.length) {
//            _suggestions.addAll(generateWordPairs().take(10));
//          }
//
//          return _buildRow(_suggestions[index]);
//        });
//  }

  Widget _buildRow(DocumentSnapshot pair) { //_buildRow(WordPair pair) {
    final bool alreadySaved = _saved.contains(pair['name']);

    return ListTile(
        title: Text(
          pair['name'],
          style: _biggerFont,
        ),
        trailing: Icon(
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : null,
        ),
        onTap: () {
          setState(() {
            if (alreadySaved) {
              _saved.remove(pair['name']);
            } else {
              _saved.add(pair['name']);
            }
          });
        }
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}