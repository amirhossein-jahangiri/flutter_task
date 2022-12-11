import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_task/provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int x = 0;
  int y = 0;

  int dx = 0;
  int dy = 0;

  void movement(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    if (x >= (screenWidth - 100)) {
      dx = -1;
    } else if (x <= 0) {
      dx = 1;
    }
    x += dx;

    if (y >= screenHeight - 100) {
      dy = -1;
    } else if (y <= 0) {
      dy = 1;
    }
    y += dy;
  }

  @override
  void didChangeDependencies() {
    Timer.periodic(const Duration(milliseconds: 60), (timer) {
      movement(context);
      setState((){});
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            top: y.toDouble(),
            right: x.toDouble(),
            child: InkWell(
              onTap: () {
                context.read<DisplayImageProvider>().uploadImageFromInternet();
              },
              child: GestureDetector(

                onHorizontalDragUpdate: (details) {
                  int sensitity = 8;
                  if (details.delta.dx > sensitity) {
                    double dxValue = details.delta.dx;
                    x = dxValue.round();

                    setState(() {});
                  } else if (details.delta.dx < -sensitity) {
                    double dxValue = details.delta.dx;
                    x = dxValue.round();

                    setState(() {});
                  }
                },

                child: Container(
                  height: 100,
                  width: 100,
                  color: Colors.blue,
                  child: Consumer<DisplayImageProvider>(
                    builder: (context, imageProvider, child) {
                      switch (imageProvider.status) {
                        case Status.loading:
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          );
                        case Status.failed:
                          return const Center(
                            child: Icon(
                              Icons.error,
                              color: Colors.red,
                              size: 40,
                            ),
                          );
                        case Status.success:
                          return Image.network(
                            imageProvider.imagePath!,
                            fit: BoxFit.cover,
                          );
                        default:
                          return const SizedBox.shrink();
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
