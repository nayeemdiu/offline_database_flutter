import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:databaseoffline/Database/DataBase_Helper.dart';
import 'package:databaseoffline/Model/Info_model.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController titleEditingController = TextEditingController();
  TextEditingController nameEditingController = TextEditingController();
  late int _id;

  static List dasboardList=[];

  static Future  postSecuredApi () async{
    print("dashboard counter");
    //Get user data from local device
    String token = 'GbEpb00VbPn70ja0CG7wHKDfr4fDIyfa';
    String userId = '10';

    final body = {"userId": userId};

    // Api url

    String url = "https://crm.ihelpbd.com/crm/api/crm/dashboard.php";
    HttpClient httpClient = HttpClient();

    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));

    // content type
    request.headers.set('content-type', 'application/json');
    request.headers.set('token', token);

    request.add(utf8.encode(json.encode(body)));

    //Get response
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    var data = jsonDecode(reply);


    // DashboardModel midel=DashboardModel.fromJson(data);
    // print('midel.data ${midel.data}');
    // for(Map i in data['data']){
    //   dasboardList.add(Data.fromJson(i));
    // }
    // Closed request
    httpClient.close();

    if (data["status"].toString().contains("200")) {
      final item = json.decode(reply)["data"];

      print(item);


    } else {

    }

    // http.post(
    //   Uri.parse("https://crm.ihelpbd.com/crm/api/crm/dashboard.php"),
    //
    //   headers: {
    //     "token": "xhXXerZanCsmlc0iDfWqoh8hUHllsMD4",
    //     'accept': 'application/json',
    //     'content-type': 'application/json'
    //   },
    //   body: jsonEncode({
    //     "userId": "10"
    //   }),
    //
    // ).then((response) {
    //   if (response.statusCode == 200) {
    //     print(json.decode(response.body));
    //     // Do the rest of job here
    //   }
    // }).onError((error, stackTrace) {
    //   print('ERROR 3 ${error}');
    // });


  }

  @override
  void initState() {
    // TODO: implement initState
    postSecuredApi();
    super.initState();
  }


  Random random = Random();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details page'),
        centerTitle: true,

        leading: Icon(Icons.menu,color: Colors.deepOrange,),
        actions: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: OutlinedButton(onPressed: (){
                },
                  child: Text('Next',style: TextStyle(color: Colors.yellow)),),
              ),


            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: nameEditingController,
                  decoration: InputDecoration(
                    hintText: 'Name',
                  ),
                ),
                TextField(
                  controller: titleEditingController,
                  decoration: InputDecoration(
                    hintText: 'Degicnation',
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: isLoading
                      ? CircularProgressIndicator()
                  /// add button
                      : ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });

                        final todo = Information(
                          id: random.nextInt(1000),
                          name: nameEditingController.text.toString(),
                          degicnation: titleEditingController.text.toString(),
                        );

                        await DatabaseHelper.instance.addTodos(todo);
                        setState(() {
                          isLoading = false;
                        });
                      },
                      child: Text('ADD')),
                ),

                SizedBox(
                  width: 5,
                ),
                // update button

                Expanded(
                  child: ElevatedButton(
                      onPressed: () async {
                        final todo = Information(
                          id: _id,
                          name: nameEditingController.text,
                          degicnation: titleEditingController.text,
                        );

                        await DatabaseHelper.instance.addTodos(todo);
                      },
                      child: Text('Update')),
                ),
              ],
            ),
          ),
          Expanded(
              child: FutureBuilder(
                  future: DatabaseHelper.instance.getTodos(),
                  builder: (context, AsyncSnapshot<List<Information>> snapshot) {
                    if (snapshot.hasError) {
                      return Text("Error");
                    }
                    return snapshot.data!.isEmpty
                        ? Text("No Data Found")
                        : ListView(
                      children: snapshot.data!.map((Information todo) {
                        return ListTile(

                          title: Text(todo.name.toString()),
                          subtitle: Text(todo.degicnation.toString()),
                          // update and edit
                          leading: IconButton(
                            onPressed: () async {
                              setState(() {
                                _id = todo.id!;
                                nameEditingController.text = todo.name!;
                                titleEditingController.text = todo.degicnation!;

                              });
                            },
                            icon: Icon(Icons.edit),
                          ),
                          // Delet Button
                          trailing: IconButton(
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });
                              await DatabaseHelper.instance
                                  .delteTodo(todo.id);
                              setState(() {
                                isLoading = false;
                              });
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  })),
        ],
      ),
    );
  }

}
