import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

main(List<String> args) {
  runApp(const AxieScholars());
}

class AxieScholars extends StatefulWidget {
  const AxieScholars({Key? key}) : super(key: key);

  @override
  _AxieScholarsState createState() => _AxieScholarsState();
}

class _AxieScholarsState extends State<AxieScholars> {
  @override
  void initState() {
    super.initState();
  }

  Future getScholarInfo(String roninAddress) async {
    var url = Uri.https(
        'axie-scho-tracker-server.herokuapp.com', '/api/account/$roninAddress');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);

      return jsonResponse;
    } else {
      print(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Axie Scholars'),
        ),
        body: Column(
          children: [
            FutureBuilder(
                future: getScholarInfo(
                    'ronin:c5f9b74947f2d794fe4d1b6ec4dd7b4c6b7e580c'),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasData) {
                    var roninAddress = snapshot.data['databaseData']['roninAddress'];
                    return Card(
                      child: Column(
                        children: [
                          Text(roninAddress),

                          Row(
                            children: [
                              Text('MMR'),
                              Spacer(),
                              Text(snapshot.data['leaderboardData']['elo'].toString())
                            ],
                          )
                        ],
                      ),
                    );
                  } else {
                    return Text(snapshot.error.toString());
                  }
                }),
          ],
        ),
      ),
    );
  }
}
