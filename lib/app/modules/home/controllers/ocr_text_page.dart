import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scanify/app/static/constants.dart';
import 'package:scanify/app/widgets/my_network_image.dart';

class OcrTextPage extends StatelessWidget {
  final XFile? image;
  final String? text;
  const OcrTextPage({super.key, this.image, this.text});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text Detector'),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          if(image != null) MyNetworkImage(
            fit: BoxFit.contain,
            height: .5.sh,
            imageUrl: image!.path,
            imageType: ImageType.file,
          ),
        if (image != null)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SelectableText (
                text ?? '',
              showCursor: true,
              cursorWidth: 2,
              cursorColor: Clr.primary,
            ),
          ),
      ],
      ),
    );
  }
}


class SelectAllDialogContent extends StatefulWidget {
  @override
  State<SelectAllDialogContent> createState() => _SelectAllDialogContentState();
}

class _SelectAllDialogContentState extends State<SelectAllDialogContent> {
  final TextEditingController _controller = TextEditingController(
    text: "This is some selectable text that can be selected fully using a button.",
  );

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: Get.height / 2, // Half of screen height
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _controller,
              readOnly: true,
              maxLines: null,
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _controller.selection = TextSelection(baseOffset: 0, extentOffset: _controller.text.length);
              },
              child: Text("Select All"),
            ),
            ElevatedButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: _controller.text));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Copied to clipboard!")),
                );
              },
              child: Text("Copy"),
            ),
          ],
        ),
      ),
    );
  }
}