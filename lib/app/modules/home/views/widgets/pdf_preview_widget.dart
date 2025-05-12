// import 'package:flutter/material.dart';
// import 'package:pdf_render/pdf_render.dart';
// import 'package:scanify/app/widgets/loading_pro.dart';
// import 'package:scanify/app/widgets/my_network_image.dart';

// class PdfPreviewWidget extends StatelessWidget {
//   final String filePath;
//   final double? height;
//   final double? width;
//   const PdfPreviewWidget({super.key, required this.filePath, this.height, this.width});

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<PdfPageImage?>(
//       future: _loadPdfPreview(filePath),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
//           return MyNetworkImage(
//             height: height ?? 72,
//             width: width ?? 72,
//             fit: BoxFit.contain,
//             radius: 8,
//             imageUrl: '',
//             imageBtyes: snapshot.data?.pixels,
//           );
//         } else if (snapshot.hasError) {
//           return MyNetworkImage(
//             height: height ?? 72,
//             width: width ?? 72,
//             fit: BoxFit.contain,
//             radius: 8,
//             imageUrl: '',
//           );
//         }
//         return  SizedBox(
//           height: height ?? 72,
//           width: width ?? 72,
//           child: Center(
//             child: LoadingPro(
//               size: 20,
//               backgroundColor: Colors.transparent,
//               platFormIsIOS: true,
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Future<PdfPageImage?> _loadPdfPreview(String path) async {
//     final doc = await PdfDocument.openFile(path);
//     final page = await doc.getPage(1);
//     final image = await page.render(height: int.tryParse(height?.toString() ?? '72'), width: int.tryParse(width?.toString() ?? '72'),);
//     return image;
//   }
// }