import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_wallet/services/api_methods.dart';
import 'package:crypto_wallet/services/flutterfire.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'add_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  double bitcoin = 0.0;
  double ethereum = 0.0;
  double tether = 0.0;

  @override
  void initState() {
    getValues();
  }

  getValues() async {
    bitcoin = await getPrice("bitcoin");
    ethereum = await getPrice("ethereum");
    tether = await getPrice("tether");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    getValues(String id, double amount) {
      if (id == "bitcoin") {
        return bitcoin * amount;
      } else if (id == "ethereum") {
        return ethereum * amount;
      } else {
        return tether * amount;
      }
    }

    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(FirebaseAuth.instance.currentUser?.uid)
                    .collection('Coins')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return ListView(
                    children: snapshot.data!.docs.map((document) {
                      return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.blue,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 2.0,
                              ),
                              Text("Coin Name: ${document.id}",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18.0)),
                              Text(
                                  "Amount Owned: \$${getValues(document.id, document['Amount']).toStringAsFixed(2)}",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18.0)),
                              IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                                onPressed: () async {
                                  await removeCoin(document.id);
                                },
                              )
                            ],
                          ));
                    }).toList(),
                  );
                }),
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddView()),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
