import 'package:flutter/material.dart';
import 'package:gradient_text/gradient_text.dart';
import 'package:intl/intl.dart';

class FoodDetailPage extends StatelessWidget {
  final String imgUrl;
  final String imageName;
  final String imageCaption;
  final String userName;
  final DateTime createdTimeOfPost;

  FoodDetailPage({
    @required this.imgUrl,
    @required this.imageName,
    @required this.imageCaption,
    this.userName,
    this.createdTimeOfPost,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: 10, right: 10, top: 30, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
             
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                    ),
                  ),
                ],
              ),
            ),
                 SizedBox(
              height: 50,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Image.network(
                imgUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    imageName,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    imageCaption,
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                  SizedBox(height: 40),
                  userName != null
                      ? Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            child: GradientText(
                              userName,
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 8, 8, 8),
                                  Color.fromARGB(255, 2, 2, 2),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              style: TextStyle(
                                fontSize: 25,
                               
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      : Text(
                          '',
                        ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      DateFormat.yMMMd().add_jm().format(
                            createdTimeOfPost,
                          ),
                      style: TextStyle(
                        fontSize: 25,
                        color: Color.fromARGB(255, 3, 3, 3),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
