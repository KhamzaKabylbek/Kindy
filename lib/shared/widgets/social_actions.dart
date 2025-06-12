import 'package:flutter/material.dart';
import 'package:kindy/core/constants/app_colors.dart';

class SocialActionsWidget extends StatelessWidget {
  final int likes;
  final int comments;
  final bool hasLiked;
  final VoidCallback onLikePressed;
  final VoidCallback onCommentPressed;

  const SocialActionsWidget({
    Key? key,
    required this.likes,
    required this.comments,
    required this.hasLiked,
    required this.onLikePressed,
    required this.onCommentPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          // Лайк
          InkWell(
            onTap: onLikePressed,
            child: Row(
              children: [
                Icon(
                  hasLiked ? Icons.favorite : Icons.favorite_border,
                  color: hasLiked ? Colors.red : Colors.grey,
                  size: 24.0,
                ),
                const SizedBox(width: 4.0),
                Text(
                  '$likes',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24.0),

          // Комментарий
          InkWell(
            onTap: onCommentPressed,
            child: Row(
              children: [
                const Icon(
                  Icons.chat_bubble_outline,
                  color: Colors.grey,
                  size: 22.0,
                ),
                const SizedBox(width: 4.0),
                Text(
                  '$comments',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),

          // Свободное пространство для комментария
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Container(
                height: 36.0,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Text(
                    'Напишите комментарий',
                    style: TextStyle(color: Colors.grey[400], fontSize: 14.0),
                    overflow: TextOverflow.ellipsis,
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
