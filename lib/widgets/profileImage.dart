import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../ screen/getstate/fetchdata.dart';

class userProfileImage extends StatefulWidget {
  @override
  _userProfileImageState createState() => _userProfileImageState();
}

class _userProfileImageState extends State<userProfileImage> {
  @override
  Widget build(BuildContext context) {
    Get.put(FetchdDbController()).assignDB();
    return GetBuilder<FetchdDbController>(
      builder: (fetchedDb) {
        return fetchedDb.dburl == null
            ? Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                child: Icon(
                  Icons.upload_file_sharp,
                  size: 100,
                ),
              )
            : Container(
                width: 150,
                height: 200,
                //child: Text('hi'),
                decoration: BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.circular(100),
                  image: DecorationImage(
                      image: NetworkImage(fetchedDb.dburl as String),
                      //image: AssetImage('assets/images/gamjaprofile.jpeg'),
                      fit: BoxFit.fill),
                ),
              );
      },
      init: FetchdDbController(),
    );
  }
}
