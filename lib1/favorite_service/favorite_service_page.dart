import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../home_screen/home_screen_viewmodel.dart';
import '../utils/app_text_style.dart';
import '../utils/colors.dart';
import '../utils/common_method.dart';
import '../utils/constants.dart';

class FavoriteServicesPage extends StatefulWidget {
  @override
  State<FavoriteServicesPage> createState() => _FavoriteServicesPageState();
}
class _FavoriteServicesPageState extends State<FavoriteServicesPage> {
  late HomeScreenViewModel _homeScreenViewModel;
  @override
  Widget build(BuildContext context) {
    _homeScreenViewModel = Provider.of<HomeScreenViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
            //Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 22,
          ),
        ),
        title: Center(
          child: Text(
            "Favorite",
            style: AppTextStyle.getTextStyle16FontWeightw600,
          ),
        ),
        centerTitle: true,
      ),
      body: _homeScreenViewModel.favoriteService.isEmpty
          ? Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.question_answer_outlined,
              color: Colors.teal,
              size: 80,
            ),
            const SizedBox(height: 12),
            Text(
              "No favorite services added yet",
              style: AppTextStyle.getTextStyle17FontWeightw600,
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: _homeScreenViewModel.favoriteService.length,
        itemBuilder: (context, index) {
          final service = _homeScreenViewModel.favoriteService[index];
          final serviceProvider = _homeScreenViewModel.serviceProvider[index];
          final List<String> promoImages = (service.image_url ?? '').split(',').map((s) => s.trim()).toList();
          final String salonServiceImage = (promoImages.isNotEmpty && promoImages[0].isNotEmpty)
              ? '$BASE_URL/uploads/${promoImages[0]}' : dummyimage;
          return bottomCard(
            salonServiceImage,
            service.salonName ?? "",
            service.address ?? "",
            "${formatAverageRating(serviceProvider.averageRating!.toDouble())} (${serviceProvider.totalRatings}) Rating"
          );
        },
      ),
    );
  }

  Widget bottomCard(String imagePath, String name, String address, String rating) {
    //double parsedRating = double.tryParse(rating) ?? 0.0;
    return Card(
      elevation: 5,
      shadowColor: Colors.black.withOpacity(0.9),
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 100,
                width: 130,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
                child: CachedNetworkImage(
                  imageUrl: imagePath, // URL of the image
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              Positioned(
                top: 6.0,
                left: 10.0,
                child: Container(
                   decoration: const BoxDecoration(
                     color: Colors.white,
                     shape: BoxShape.circle,
                   ),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(Icons.favorite,color: fabricColor,),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: AppTextStyle.getTextStyle18FontWeightBold,
                      ),
                      Text(
                        address,
                        style: AppTextStyle.getTextStyle14FontWeightw500,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            rating,
                            style: AppTextStyle.getTextStyle14FontWeight,

                            //AppTextStyle.getTextStyle14FontWeightw500,
                          ),
                        ],
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
