import 'package:flutter/material.dart';

class MenuClass {
  String title;
  String routeName;
  MenuClass({required this.title, required this.routeName});
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  List<MenuClass> _menus = [
    MenuClass(title: "Hign Sign", routeName: "/cameraPage"),
    MenuClass(title: "Videos", routeName: "/videosInStorage")
  ];

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Home Page"),
          centerTitle: true,
        ),
        body: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            padding: const EdgeInsets.all(4.0),
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
            children: _menus
                .map((e) => Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: GestureDetector(
                        onTap: () =>
                            {Navigator.pushNamed(context, e.routeName)},
                        child: GridTile(
                          child: Card(
                              color: Colors.blue.shade200,
                              child: Center(
                                child: Text(e.title),
                              )),
                        ),
                      ),
                    ))
                .toList()));
  }
}
