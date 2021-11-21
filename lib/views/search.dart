import 'package:flutter/material.dart';
import 'package:sahamo/widgets/widget.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  TextEditingController searchTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(context),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Color(0x54FFFFFF),
              padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16,),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                        controller: searchTextController,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          hintText: "Enter username...",
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0x36FFFFFF),
                          const Color(0x0FFFFFFF),
                        ]
                      ),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    padding: EdgeInsets.all(12),
                    child: Image.asset("assets/images/search_white.png"),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
