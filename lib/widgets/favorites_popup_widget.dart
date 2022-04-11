// import 'package:flutter/material.dart';

// class FavoritePopupWidget extends StatefulWidget {
//   @override
//   _FavoritePopupWidgetState createState() => _FavoritePopupWidgetState();
// }

// enum FilteOptions { Favorites, All }

// class _FavoritePopupWidgetState extends State<FavoritePopupWidget> {
//   bool showOnlyFavorites = false;

//   @override
//   Widget build(BuildContext context) {
//     return PopupMenuButton(
//       onSelected: (FilteOptions selectedValue) {
//         print(selectedValue);
//         setState(() {
//           if (selectedValue == FilteOptions.Favorites) {
//             showOnlyFavorites = true;
//           } else {
//             showOnlyFavorites = false;
//           }
//         });
//       },
//       icon: Icon(Icons.more_vert),
//       itemBuilder: (_) => [
//         PopupMenuItem(
//           child: Align(
//             alignment: Alignment.centerRight,
//             child: Text('فقط المفضلة'),
//           ),
//           value: FilteOptions.Favorites,
//         ),
//         PopupMenuItem(
//           child: Align(
//             alignment: Alignment.centerRight,
//             child: Text('الكل'),
//           ),
//           value: FilteOptions.All,
//         ),
//       ],
//     );
//   }
// }
