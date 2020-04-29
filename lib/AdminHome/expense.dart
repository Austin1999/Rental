import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:rental_prototype/main.dart';
import 'package:toast/toast.dart';

class ExpensePage extends StatefulWidget {
  final DocumentSnapshot flat, user, detail;
  ExpensePage({this.flat, this.user, this.detail});
  @override
  _ExpensePageState createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  final _formKey = GlobalKey<FormState>();

  _updateData() {
   Firestore.instance
        .collection('places')
        .document(widget.flat.documentID)
        .collection('flats')
        .document(widget.user.documentID)
        .collection('users')
        .document(widget.detail.documentID)
        .collection('expenses')
        .document(_expense.text)
        .setData({'expense': _expense.text, 'amount': _amount.text});
  }

  _deleteUserExpense(data) {
   Firestore.instance
        .collection('user')
        .document(widget.detail.documentID)
        .collection('expenses')
        .document(data)
        .delete();
    Toast.show("Expense Deleted", context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  }

  _deleteExpense(data) {
    Firestore.instance
        .collection('places')
        .document(widget.flat.documentID)
        .collection('flats')
        .document(widget.user.documentID)
        .collection('users')
        .document(widget.detail.documentID)
        .collection('expenses')
        .document(data)
        .get()
        .then((snapshot) {
       Firestore.instance
        .collection('places')
        .document(widget.flat.documentID)
        .collection('flats')
        .document(widget.user.documentID)
        .collection('users')
        .document(widget.detail.documentID).updateData({'total_amount': FieldValue.increment(
          -(int.parse(snapshot.data['amount']))
        )});
        Firestore.instance
        .collection('places')
        .document(widget.flat.documentID)
        .collection('flats')
        .document(widget.user.documentID)
        .updateData({'total_amount': FieldValue.increment(
          -(int.parse(snapshot.data['amount']))
        )});
        Firestore.instance
        .collection('places')
        .document(widget.flat.documentID)
        .collection('flats')
        .document(widget.user.documentID)
        .collection('users')
        .document(widget.detail.documentID)
        .collection('expenses')
        .document(data).delete();
    });
  }

  _updateExpense()  {
   Firestore.instance
        .collection('places')
        .document(widget.flat.documentID)
        .collection('flats')
        .document(widget.user.documentID)
        .collection('users')
        .document(widget.detail.documentID)
        .updateData(
            {'total_amount': FieldValue.increment(int.parse(_amount.text))});
  }

  _updateUser() {
    Firestore.instance
        .collection('user')
        .document(widget.detail.documentID)
        .collection('expenses')
        .document(_expense.text)
        .setData({'expense': _expense.text, 'amount': _amount.text});
  }

  TextEditingController _expense = TextEditingController();
  TextEditingController _amount = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Your Expenses'),
        backgroundColor: Colors.redAccent,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.home),
              iconSize: 35.0,
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              })
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.04), BlendMode.dstATop),
            image: AssetImage('assets/skyscraper.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: StreamBuilder(
            stream: Firestore.instance
                .collection('places')
                .document(widget.flat.documentID)
                .collection('flats')
                .document(widget.user.documentID)
                .collection('users')
                .document(widget.detail.documentID)
                .collection('expenses')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                return ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot expense = snapshot.data.documents[index];
                      return Slidable(
                          actionPane: SlidableBehindActionPane(),
                          actionExtentRatio: 0.30,
                          child: Container(
                            height: 70.0,
                            decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.black12)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  '${expense['expense']}',
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${expense['amount']}',
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          secondaryActions: <Widget>[
                            IconSlideAction(
                              caption: 'Delete',
                              color: Colors.red,
                              icon: Icons.delete,
                              onTap: (){
                                _deleteExpense(expense.documentID);
                                _deleteUserExpense(expense.documentID);
                              },
                            )
                          ]);
                    });
              }
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    content: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _expense,
                            decoration: InputDecoration(
                              labelText: 'Expense Name',
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _amount,
                            decoration: InputDecoration(
                              labelText: 'Expense Amount',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                              color: Colors.redAccent,
                              child: Text(
                                'Add Expense',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: (
                              )  {
                                
                                _updateData();
                                _updateUser();
                                _updateExpense();
                               Firestore.instance
                                    .collection('places')
                                    .document(widget.flat.documentID)
                                    .collection('flats')
                                    .document(widget.user.documentID)
                                    .updateData({
                                  'total_amount': FieldValue.increment(
                                      int.parse(_amount.text))
                                });
                                Navigator.pop(context);
                                _formKey.currentState.reset();
                              }),
                        )
                      ],
                    ),
                  ),
                ));
              });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
    );
  }
}
