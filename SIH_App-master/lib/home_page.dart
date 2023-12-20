
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String complaintType = "New Pipeline Connection";
  List<String> options = ['New Pipeline Connection', 'Blockages in Existing', 'Water Quality', 'Leakage Detected'];


  String areaName = "";
  var complaint = "";

  final areaNameController = TextEditingController();
  final complaintController = TextEditingController();

  void clearText() {
    areaNameController.clear();
    complaintController.clear();
  }

  //Add Complaint
  final CollectionReference complaints = FirebaseFirestore.instance.collection("complaint");
  Future<void> addComplaint() {
    return complaints.add({
      "areaName":areaName,
      "complaint":complaint,
      "type":complaintType,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true ,
        backgroundColor: Colors.blue.shade300,
        title: const Text("Grievance Form"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: TextFormField(
                controller: areaNameController,
                autofocus: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Area Name",
                  labelStyle: TextStyle(fontSize: 18),
                  errorStyle: TextStyle(color: Colors.red, fontSize: 15),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please Enter Area Name";
                  }
                  return null;
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: complaintController,
                autofocus: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Complaint",
                  labelStyle: TextStyle(fontSize: 18),
                  errorStyle: TextStyle(color: Colors.red, fontSize: 15),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please Enter Complaint";
                  }
                  return null;
                },
              ),
            ),
        const SizedBox(height: 24),
        Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Select Grievance Type :',
            style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400),
          ),
        const SizedBox(height: 4),
          DropdownButton<String>(
            value: complaintType,
            items: options.map((String option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(option),
              );
            }).toList(),
            onChanged: (String ?newValue) {
              setState(() {
                if(newValue == null){
                    complaintType = options[0];
                }
                else {
                    complaintType = newValue;
                }
              });
            },
          ),
        ],
        ),
            const SizedBox(height: 24,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          areaName = areaNameController.text.toString();
                          complaint = complaintController.text.toString();
                          addComplaint();
                          clearText();
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen),
                    child: const Text("Register",style: TextStyle(fontSize: 19,color: Colors.black))),
                ElevatedButton(
                    onPressed: () {
                      clearText();
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade200),
                    child: const Text("Reset",style: TextStyle(fontSize: 19 ,color: Colors.black),),),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
