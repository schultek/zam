import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../files_provider.dart';

class FileViewPage extends StatefulWidget {
  final int index;
  const FileViewPage({required this.index, Key? key}) : super(key: key);

  static Route route(int index) {
    return MaterialPageRoute(builder: (context) => FileViewPage(index: index));
  }

  @override
  _FileViewPageState createState() => _FileViewPageState();
}

class _FileViewPageState extends State<FileViewPage> {
  late PageController controller;

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: widget.index);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        var files = ref.watch(orderedFilesProvider).value ?? [];

        return Scaffold(
          backgroundColor: Colors.black,
          body: LayoutBuilder(
            builder: (context, constraints) => Stack(
              children: [
                PageView.builder(
                  controller: controller,
                  itemCount: files.length,
                  itemBuilder: (context, index) {
                    return Image.file(
                      File(files[index].filePath),
                      fit: BoxFit.contain,
                      cacheWidth: constraints.maxWidth.floor(),
                    );
                  },
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Material(
                    color: Colors.black45,
                    child: SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(Icons.arrow_back),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Material(
                    color: Colors.black45,
                    child: SafeArea(
                      top: false,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              onPressed: () async {
                                if (controller.page != null) {
                                  ref.read(filesLogicProvider).deleteFile(files[controller.page!.round()]);
                                }
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
