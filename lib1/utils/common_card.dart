import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../widget/custom_button.dart';
import 'app_strings.dart';
import 'app_text_style.dart';
import 'colors.dart';
import 'common_method.dart';

class CardPage extends StatelessWidget {
  final int id;
  final String imagePath;
  final String title;
  final String salonName;
  final String address;
  final double averageRating;
  final int totalRating;
  final Widget? icon; // Add a custom icon parameter
  final VoidCallback onPressed;

  const CardPage({
    Key? key,
    required this.id,
    required this.imagePath,
    required this.title,
    required this.salonName,
    required this.address,
    required this.averageRating,
    required this.totalRating,
    this.icon, // Allow this parameter to be nullable
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 150,
            height: 145,
            margin: const EdgeInsets.all(8),
            child: CachedNetworkImage(
              imageUrl: imagePath,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                    colorFilter: const ColorFilter.mode(
                      Colors.transparent,
                      BlendMode.colorBurn,
                    ),
                  ),
                ),
              ),
              placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title.isNotEmpty ? title : 'No Name',
                        style: AppTextStyle.getTextStyle12FontWeightw300,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        salonName.isNotEmpty ? salonName : 'No Title',
                        style: AppTextStyle.getTextStyle18FontWeightBold,
                      ),
                      Text(
                        address.isNotEmpty ? address : 'No Address',
                        style: const TextStyle(
                          fontSize: 12,
                          
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16.0),
                          const SizedBox(width: 4),
                          Text(
                            '${formatAverageRating(averageRating)} (${totalRating}) Rating',
                            style: AppTextStyle.getTextStyle14FontWeight,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (icon != null) // Only display the icon if it's provided
                        Container(
                          height: 40,
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: const Color(0xffE6F4F4),
                          ),
                          child: icon, // Use the passed custom icon
                        ),
                      const SizedBox(width: 25),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          child: CustomButtonWidget(
                            text: AppString.book,
                            textColor: Colors.white,
                            onPressed: onPressed,
                            buttonColor: fabricColor,
                            borderRadius: 5,
                            buttonHeight: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
