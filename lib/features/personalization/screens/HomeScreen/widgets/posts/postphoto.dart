import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/common/widgets/shimmer.dart';
import 'package:instagram_clone/features/personalization/screens/HomeScreen/widgets/posts/like.dart';
import 'package:instagram_clone/features/personalization/screens/HomeScreen/widgets/posts/post.dart';
import 'package:instagram_clone/utils/helpers/helper_functions.dart';

class PostPhoto extends StatefulWidget {
  final LikeButtonController likeButtonController;
  final String photo;
  const PostPhoto({super.key, required this.likeButtonController,required this.photo});

  @override
  State<PostPhoto> createState() => _PostPhotoState();
}

class _PostPhotoState extends State<PostPhoto>
    with SingleTickerProviderStateMixin {
  final PostImageController postImageController =
      Get.put(PostImageController());
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _translationAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3000),
    );

    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _translationAnimation = Tween<double>(begin: 0, end: -50).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onDoubleTap() {
    if (_animationController.status == AnimationStatus.completed ||
        _animationController.status == AnimationStatus.forward) {
      _animationController.reset();
    }
    if (!widget.likeButtonController.liked.value) {
      widget.likeButtonController.updateLikeStatus();
    }
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () => _onDoubleTap(),
      child: Stack(
        children: [
          Container(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.5),
            child: PageView.builder(
                onPageChanged: (value) => postImageController.setValue(value),
                itemCount: 1,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return FittedBox(
                    fit: BoxFit.contain,
                    child: CachedNetworkImage(
                      imageUrl: widget.photo,
                      //         imageBuilder: (context, imageProvider) => Container(

                      //   decoration: BoxDecoration(

                      //     image: DecorationImage(
                      //         image: imageProvider,
                      //         fit: BoxFit.cover,
                      //         colorFilter:
                      //            const ColorFilter.mode(Colors.red, BlendMode.colorBurn)),
                      //   ),
                      // ),
                      placeholder: (context, url) =>FittedBox(child: AppShimmerEffect(width: AppHelperFunctions.screenWidth(context)*0.8, height: AppHelperFunctions.screenHeight(context)*0.55,radius: 3,)),
                      errorWidget: (context, url, error) =>
                          const Center(child: SizedBox(height:80,width: 80, child: Icon(FontAwesomeIcons.meta))),
                    ),
                  );
                }),
          ),
          Positioned(
            top: AppHelperFunctions.screenHeight(context) * 0.25,
            left: AppHelperFunctions.screenWidth(context) * 0.4,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _translationAnimation.value),
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Opacity(
                      opacity: _opacityAnimation.value,
                      child: ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return LinearGradient(
                            colors: [
                              Color(0xFFF9CE34),
                              Color(0xFFEE2A7B),
                              Color(0xFF6228D7),
                              // Color(0xFF833AB4),
                              // Color(0xFFC13584),
                              // Color(0xFFE1306C),
                              // Color(0xFFFD1D1D),
                            ],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                          ).createShader(bounds);
                        },
                        child: Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 100,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
