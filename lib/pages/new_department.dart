import 'dart:convert';

import 'package:appointment_app/utils/http_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewDepartment extends StatefulWidget {
  @override
  _NewDepartmentState createState() => _NewDepartmentState();
}

class _NewDepartmentState extends State<NewDepartment> {
  var isLoading = false;

  final _nameController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Your departments'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Form(
        child: ListView(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 36.0),
          children: <Widget>[
            Text(
              "Fill out following information",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.title,
            ),
            Text(
              "to add New Department",
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: EdgeInsets.only(top: 36),
              child: TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  filled: true,
                  labelText: 'Name',
                  hintText: 'Name',
                ),
                validator: (res) {
                  if (res.trim() == "") {
                    return "Name is required";
                  } else {
                    return null;
                  }
                },
                enabled: !isLoading,
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {
          HttpClient.of(context)
              .client
              .post("/department",
                  body: jsonEncode({
                    "name": _nameController.text,
                  }))
              .then((res) {
            Navigator.pop(context);
          }).catchError((err) {
            _scaffoldKey.currentState.showSnackBar(
              SnackBar(
                content: Text("Something went wrong"),
              ),
            );
          });
          // handle saving here
        },
      ),
    );
  }
}
