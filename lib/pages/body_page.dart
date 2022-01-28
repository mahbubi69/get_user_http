import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_user_http/theme/colors.dart';
import 'package:http/http.dart' as http;

class BodyPage extends StatefulWidget {
  const BodyPage({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<BodyPage> {
  List users = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  fetchUser() async {
    var baseUrl = "https://randomuser.me/api/?results=100";
    var reponse = await http.get(Uri.parse(baseUrl));
    setState(() {
      isLoading = true;
    });

    if (reponse.statusCode == 200) {
      var item = json.decode(reponse.body)['results'];
      print(item);
      setState(() {
        users = item;
        isLoading = false;
      });
    } else {
      setState(() {
        users = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_is_empty
    if (users.contains(null) || users.length < 0 || isLoading) {
      return Center(
          child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(ColorKu().purple),
      ));
    }
    return ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return getCard(users[index]);
        });
  }

  Widget getCard(item) {
    var fullName = item['name']['title'] +
        " " +
        item['name']['first'] +
        " " +
        item['name']['last'];
    var email = item['email'];
    var imgUrl = item['picture']['large'];

    return Card(
      // padding: EdgeInsets.all(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          title: Row(
            children: <Widget>[
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    color: ColorKu().purple,
                    borderRadius: BorderRadius.circular(60 / 2),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          imgUrl.toString(),
                        ))),
              ),
              const SizedBox(
                width: 6.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(fullName.toString(),
                      style: const TextStyle(
                        fontSize: 15,
                      )),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text(email.toString(),
                      style: const TextStyle(color: Colors.grey)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
