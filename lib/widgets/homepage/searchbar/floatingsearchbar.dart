// import 'package:dal/widgets/homepage/searchbar/search_results_listview.dart';
// import 'package:flutter/material.dart';
// import 'package:material_floating_search_bar/material_floating_search_bar.dart';

// class FloatingSearchBarWidget extends StatefulWidget {
//   @override
//   _FloatingSearchBarWidgetState createState() =>
//       _FloatingSearchBarWidgetState();
// }

// class _FloatingSearchBarWidgetState extends State<FloatingSearchBarWidget> {
//   static const historyLength = 5;
//   // List<String> _searchHistory = ['نبيل', 'سارة', 'عدنان'];
//   List<String> filteredSearchHistory;
//   String selectedTerm;

//   List<String> filterSearchTerms({@required String filter}) {
//     if (filter != null && filter.isNotEmpty) {
//       return _searchHistory.reversed
//           .where((term) => term.startsWith(filter))
//           .toList();
//     } else {
//       return _searchHistory.reversed.toList();
//     }
//   }

//   void addSearchTerm(String term) {
//     if (_searchHistory.contains(term)) {
//       putSearchTermFirst(term);
//       return;
//     }
//     _searchHistory.add(term);
//     if (_searchHistory.length > historyLength) {
//       _searchHistory.removeRange(0, _searchHistory.length - historyLength);
//     }
//     filteredSearchHistory = filterSearchTerms(filter: null);
//   }

//   void deleteSearcgTerm(String term) {
//     _searchHistory.removeWhere((t) => t == term);
//     filteredSearchHistory = filterSearchTerms(filter: null);
//   }

//   void putSearchTermFirst(String term) {
//     deleteSearcgTerm(term);
//     addSearchTerm(term);
//   }

//   FloatingSearchBarController controller;
//   @override
//   void initState() {
//     super.initState();
//     controller = FloatingSearchBarController();
//     filteredSearchHistory = filterSearchTerms(filter: null);
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height,
//       child: FloatingSearchBar(
//         controller: controller,
//         body: SearchResultsListView(
//           searchTerm: selectedTerm,
//         ),
//         transition: CircularFloatingSearchBarTransition(),
//         physics: BouncingScrollPhysics(),
//         title: Text(
//           selectedTerm ?? 'Search Bar',
//           style: Theme.of(context).textTheme.headline6,
//         ),
//         hint: 'Search and find out... ',
//         actions: [
//           FloatingSearchBarAction.searchToClear(),
//         ],
//         onQueryChanged: (query) {
//           setState(() {
//             filteredSearchHistory = filterSearchTerms(filter: query);
//           });
//         },
//         onSubmitted: (query) {
//           print(query);
//           setState(() {
//             addSearchTerm(query);
//             selectedTerm = query;
//           });
//           controller.close();
//         },
//         builder: (context, transition) {
//           return ClipRRect(
//             borderRadius: BorderRadius.circular(8),
//             child: Material(
//               color: Colors.white,
//               elevation: 4,
//               child: Builder(
//                 builder: (context) {
//                   if (filteredSearchHistory.isEmpty &&
//                       controller.query.isEmpty) {
//                     return Container(
//                       height: 56,
//                       width: double.infinity,
//                       alignment: Alignment.center,
//                       child: Text(
//                         'Start Searching',
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: Theme.of(context).textTheme.caption,
//                       ),
//                     );
//                   } else if (filteredSearchHistory.isEmpty) {
//                     return ListTile(
//                       title: Text(controller.query),
//                       leading: const Icon(Icons.search),
//                       onTap: () {
//                         setState(() {
//                           addSearchTerm(controller.query);
//                           selectedTerm = controller.query;
//                         });
//                         controller.close();
//                       },
//                     );
//                   } else {
//                     return Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: filteredSearchHistory
//                           .map(
//                             (term) => ListTile(
//                               title: Text(
//                                 term,
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               leading: const Icon(Icons.history),
//                               trailing: IconButton(
//                                 icon: Icon(Icons.clear),
//                                 onPressed: () {
//                                   setState(() {
//                                     deleteSearcgTerm(term);
//                                   });
//                                 },
//                               ),
//                               onTap: () {
//                                 setState(() {
//                                   putSearchTermFirst(term);
//                                   selectedTerm = term;
//                                 });
//                                 controller.close();
//                               },
//                             ),
//                           )
//                           .toList(),
//                     );
//                   }
//                 },
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
