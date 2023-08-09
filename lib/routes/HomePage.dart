import 'package:flutter/material.dart';
import '../pages/ViewPlant.dart';
import '../pages/statePage.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: tabs(context),
          body: TabBarView(
            children: [state(context), image(context)],
          ),
        )
    );
  }

  PreferredSizeWidget tabs(BuildContext context) {
    return AppBar(
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(30), // Ajusta el valor para aumentar el espacio entre AppBar y TabBar.
        child: Container(
          padding: const EdgeInsets.only(bottom: 8), // Ajusta el valor para aumentar o disminuir el espaciado.
          child: const TabBar(
            tabs: [
              Tab(text: 'Estado', icon: Icon(Icons.water_drop),),
              Tab(text: 'Visualizar planta', icon: Icon(Icons.camera_alt),)
            ],
          ),
        ),
      ),
    );
  }

  Widget state(BuildContext context) {
    return const StatePage();
  }

  Widget image(BuildContext context) {
    return const ViewPlant();
  }
}
