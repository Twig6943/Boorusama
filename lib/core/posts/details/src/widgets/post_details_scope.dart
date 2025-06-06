// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

// Project imports:
import '../../../../settings/providers.dart';
import '../../../post/post.dart';
import '../types/inherited_post.dart';
import '../types/post_details.dart';
import 'post_details_controller.dart';

class PostDetailsScope<T extends Post> extends ConsumerStatefulWidget {
  const PostDetailsScope({
    required this.initialIndex,
    required this.initialThumbnailUrl,
    required this.posts,
    required this.dislclaimer,
    required this.child,
    required this.scrollController,
    super.key,
  });

  final int initialIndex;
  final String? initialThumbnailUrl;
  final List<T> posts;
  final String? dislclaimer;
  final AutoScrollController? scrollController;
  final Widget child;

  @override
  ConsumerState<PostDetailsScope<T>> createState() =>
      _PostDetailsLayoutSwitcherState<T>();
}

class _PostDetailsLayoutSwitcherState<T extends Post>
    extends ConsumerState<PostDetailsScope<T>> {
  late PostDetailsController<T> controller;

  @override
  void initState() {
    super.initState();

    controller = PostDetailsController<T>(
      scrollController: widget.scrollController,
      initialPage: widget.initialIndex,
      initialThumbnailUrl: widget.initialThumbnailUrl,
      posts: widget.posts,
      reduceAnimations: ref.read(settingsProvider).reduceAnimations,
      dislclaimer: widget.dislclaimer,
    );
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PostDetails(
      data: PostDetailsData(
        posts: widget.posts,
        controller: controller,
      ),
      child: CurrentPostScope(
        post: controller.currentPost,
        child: widget.child,
      ),
    );
  }
}

class CurrentPostScope<T extends Post> extends StatelessWidget {
  const CurrentPostScope({
    required this.post,
    required this.child,
    super.key,
  });

  final ValueNotifier<T> post;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: post,
      builder: (context, post, _) => InheritedPost<T>(
        post: post,
        child: child,
      ),
    );
  }
}
