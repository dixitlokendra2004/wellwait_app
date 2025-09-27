import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wellwait_app/home_screen/home_screen_viewmodel.dart';

import '../utils/app_strings.dart';
import '../utils/app_text_style.dart';
import '../utils/colors.dart';
import '../utils/common_method.dart';
import '../utils/common_variables.dart';
import 'custom_button.dart';

Widget bottomCard(
    int id,
    String imagePath,
    String title,
    String salonName,
    String address,
    double averageRating,
    int totalRating,
    viewModel,
    BuildContext context,
    VoidCallback onPressed,
    VoidCallback onTap,
    ) {
  // Check if the service is already favorited
  bool isFavorited = Provider.of<HomeScreenViewModel>(context, listen: false).favoriteService.any(
          (service) =>
      service.serviceProviderId == id);

  return Card(
    color: Colors.white,
    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                  colorFilter: const ColorFilter.mode(Colors.transparent, BlendMode.colorBurn),
                ),
              ),
            ),
            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
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
                    Container(
                      height: 40,
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: const Color(0xffE6F4F4),
                      ),
                      child: IconButton(
                        icon: Icon(
                          isFavorited ? Icons.favorite : Icons.favorite_border,
                          color: isFavorited ? fabricColor : Colors.black,
                        ),
                        onPressed: () {
                          onTap();
                         // _viewModel.refreshUI(); // Notify changes to update UI
                        },

                      ),
                    ),
                    const SizedBox(width: 25),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        child: CustomButtonWidget(
                          text: AppString.book,
                          textColor: Colors.white,
                          onPressed: () async {
                            // Call the passed onPressed function
                            onPressed(); // Execute the onPressed callback
                          },
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