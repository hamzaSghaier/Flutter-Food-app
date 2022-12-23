import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_hamza/services/services.dart';
import 'package:flutter_food_hamza/model/food.dart';
import 'package:flutter_food_hamza/services/storage.dart';
import 'package:flutter_food_hamza/widget/custom_raised_button.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class AddFood extends StatefulWidget {
  @override
  _AddFoodState createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {
  Food food = Food();

  File _imageFile;

  Future<void> _pickImage(ImageSource source) async {
    final selected = await ImagePicker().getImage(source: source);
    setState(() {
      _imageFile = File(selected.path);
    });
  }

  void _clear() {
    setState(() {
      _imageFile = null;
    });
  }

  _save() async {
    uploadFoodAndImages(food, _imageFile, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Add New food',
                  style: TextStyle(
                    color: Color.fromARGB(255, 4, 4, 4),
                  ),
                ),
                SizedBox(height: 10),
                ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    _imageFile != null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Container(
                                  width: MediaQuery.of(context).size.width - 20,
                                  child: Image.file(
                                    _imageFile,
                                    fit: BoxFit.fitWidth,
                                    width: 300,
                                    height: 200,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
//                                  FlatButton(
//                                    child: Icon(Icons.crop),
////                              onPressed: _cropImage,
//                                  ),
                                  ElevatedButton(
                                    child: Icon(Icons.refresh),
                                    onPressed: _clear,
                                  ),
                                ],
                              ),
                            ],
                          )
                        : GestureDetector(
                            onTap: () {
                              _pickImage(ImageSource.gallery);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              child: Lottie.asset('images/18714-upload-image.json', repeat: true, width: 100, height: 100),
                            ),
                          ),
                  ],
                ),
                Container(
                  child: TextField(
                    onChanged: (String value) {
                      food.name = value;
                    },
                    
                    decoration: InputDecoration(
                      labelText: 'Add a Title',
                          border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onChanged: (String value) {
                      food.caption = value;
                    },
                    decoration: InputDecoration(
                          border: OutlineInputBorder(),
                      labelText: 'description',
                    ),
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      _save();
                    },
                    child: CustomRaisedButton(
                      buttonText: 'Add new food',
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
