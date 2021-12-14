import 'package:flutter/material.dart';



class Mydrawer extends StatelessWidget {
  const Mydrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Drawer Header'),
          ),
          ListTile(
            title: const Text('Item 1',style: TextStyle(fontSize: 20),),
            leading: Icon(Icons.home,color:Colors.lightGreen),
            trailing: Icon(Icons.arrow_right,color:Colors.grey),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: const Text('Composant',style: TextStyle(fontSize: 20),),
            leading: Icon(Icons.architecture,color:Colors.lightGreen),
            trailing: Icon(Icons.arrow_right,color:Colors.grey),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
        ],
      ),
    );
  }

}
