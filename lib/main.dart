import 'dart:io';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'graphql/graphql_api.graphql.dart';
import 'graphql_provide.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

String get host {
  if (Platform.isAndroid) {
    return '10.0.2.2';
  } else {
    return 'localhost';
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GraphqlProvider(
      uri: 'http://$host:9002/graphql',
      child: MaterialApp(
          title: "Artemis",
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.blue,
            // This makes the visual density adapt to the platform that you run
            // the app on. For desktop platforms, the controls will be smaller and
            // closer together (more dense) than on mobile platforms.
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: Scaffold(
            appBar: AppBar(
              title: Text("Artemis"),
            ),
            body: Query(
              options: QueryOptions(
                documentNode: CompaniesDataQuery().document,
              ),
              builder: (
                QueryResult result, {
                Future<QueryResult> Function() refetch,
                FetchMore fetchMore,
              }) {
                if (result.hasException) {
                  return Text(result.exception.toString());
                }

                if (result.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final allCompanies = CompaniesData$Query.fromJson(result.data).allCompanies;

                return ListView.builder(
                  itemBuilder: (_, index) {
                    return ListTile(
                      leading: Icon(Icons.card_travel),
                      title: Text(allCompanies[index].name),
                      subtitle: Text(allCompanies[index].industry),
                    );
                  },
                  itemCount: allCompanies.length,
                );
              },
            ),
          )),
    );
  }
}
