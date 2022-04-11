import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

class PostBody extends StatefulWidget {
  final List<String> imagesPath;

  const PostBody({Key key, this.imagesPath}) : super(key: key);

  @override
  State<PostBody> createState() => _PostBodyState();
}

class _PostBodyState extends State<PostBody> {
  @override
  Widget build(BuildContext context) {
    return Swiper(
      loop: false,
      itemCount: widget.imagesPath.length,
      pagination: const SwiperPagination(),
      control: const SwiperControl(),
      indicatorLayout: PageIndicatorLayout.COLOR,
      autoplay: false,
      itemBuilder: (context, index) {
        final path = widget.imagesPath[index];
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 2,
          child: Image.network(path, fit: BoxFit.fill),
        );
      },
    );
  }
}
