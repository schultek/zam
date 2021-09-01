import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum AttachmentOption { image, file }

class AttachmentBottomSheet extends StatelessWidget {
  const AttachmentBottomSheet({Key? key}) : super(key: key);

  static Future<AttachmentOption?> open(BuildContext context) {
    return showModalBottomSheet<AttachmentOption>(
      context: context,
      builder: (BuildContext context) => const AttachmentBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _attachmentButton(
                context: context,
                icon: Icons.photo,
                option: AttachmentOption.image,
              ),
              _attachmentButton(
                context: context,
                icon: Icons.attach_file,
                option: AttachmentOption.file,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _attachmentButton({required BuildContext context, required IconData icon, required AttachmentOption option}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(shape: const CircleBorder()),
      onPressed: () {
        Navigator.pop(context, option);
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Icon(icon),
      ),
    );
  }
}
