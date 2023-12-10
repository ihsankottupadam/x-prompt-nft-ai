import 'package:x_prompt/modules/dashboard/models/nft_image_model.dart';
import 'package:x_prompt/utils/constants.dart';
import 'package:x_prompt/utils/fonts.dart';
import 'package:x_prompt/widgets/c_card.dart';
import 'package:x_prompt/widgets/gradient_text.dart';
import 'package:x_prompt/modules/create%20nft/screens/create_nft_screen.dart';
import 'package:x_prompt/utils/session_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class DashBoardScreen extends StatefulWidget {
  static const routename = '/dashboard';
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  bool isTestnet = SessionManager.isTestnet;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(4.w, 1.h, 4.w, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    topBar(),
                    SizedBox(height: 4.h),
                    Text(
                      "Generate NFTs",
                      style: appFont(
                        fontWeight: FontWeight.w500,
                        fontSize: 15.sp,
                      ),
                    ),
                    const SizedBox(height: 10),

                    createNftWidget(),
                    // generateBox(),
                    const SizedBox(height: 20),
                    Text(
                      "Get Inspired",
                      style: appFont(
                        fontWeight: FontWeight.w600,
                        fontSize: 15.sp,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 360,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 10),
                  scrollDirection: Axis.horizontal,
                  itemCount: NftImageModel.samples.length,
                  itemBuilder: (context, index) {
                    return NftViewer(NftImageModel.samples[index]);
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(width: 10);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget topBar() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Hi,',
                style: appFont(fontSize: 15.sp, fontWeight: FontWeight.w500)),
            Text('User x4545',
                style: appFont(fontSize: 16.sp, fontWeight: FontWeight.bold)),
          ],
        ),
        const Spacer(),
        const AppNameWidget(),

        // testnetToggler(),
      ],
    );
  }

  GestureDetector testnetToggler() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isTestnet = isTestnet ? false : true;
          SessionManager.isTestnet = isTestnet;
          print(SessionManager.isTestnet);
        });
      },
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: isTestnet ? Colors.black : Color(0xff8345E6),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0xff26384f).withOpacity(0.05),
              offset: Offset(0, 4),
              blurRadius: 4,
              spreadRadius: 0,
            )
          ],
        ),
        child: isTestnet
            ? SvgPicture.asset(
                "assets/icons/mantle_logo.svg",
                height: 5.h,
              )
            : Image.asset(
                "assets/images/polygon_logo.png",
                height: 5.h,
              ),
      ),
    );
  }

  Widget createNftWidget() {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(CreateNFTScreen.routeName),
      child: CCard(
        height: 100,
        width: double.infinity,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Create',
                    style: appFont(
                        fontWeight: FontWeight.w600,
                        fontSize: 18.sp,
                        color: secondaryColor),
                  ),
                  Text(
                    "personalised unique NFT's",
                    style: appFont(
                      fontWeight: FontWeight.w500,
                      fontSize: 10.sp,
                    ),
                  )
                ],
              ),
            ),
            Transform.scale(
              scale: 1.5,
              child: Image.asset(
                "assets/images/generate_box_image.png",
              ),
            )
          ],
        ),
      ),
    );
  }
}

class NftViewer extends StatelessWidget {
  const NftViewer(
    this.nftImage, {
    super.key,
  });
  final NftImageModel nftImage;

  @override
  Widget build(BuildContext context) {
    return CCard(
      width: MediaQuery.of(context).size.width * 0.6,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          nftImage.isGenerated
              ? CachedNetworkImage(imageUrl: nftImage.image)
              : Image.asset(
                  "assets/images/${nftImage.image}.png",
                ),
          const SizedBox(height: 10),
          Text(
            nftImage.text,
            style: appFont(fontSize: 12),
            overflow: TextOverflow.ellipsis,
            maxLines: 6,
          )
        ],
      ),
    );
  }
}

class AppNameWidget extends StatelessWidget {
  const AppNameWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CCard(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          GradientText(
            "X",
            gradient: LinearGradient(
              colors: [secondaryColor, Colors.yellow],
            ),
            style: GoogleFonts.itim(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(width: 1.w),
          Text(
            "prompt",
            style: appFont(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }
}
