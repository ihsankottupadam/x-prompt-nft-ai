class NftImageModel {
  NftImageModel({
    this.isGenerated = false,
    required this.image,
    required this.text,
  });
  final bool isGenerated;
  final String image;
  final String text;

  static List<NftImageModel> samples = [
    NftImageModel(
      image: "db_img1",
      text:
          'A dog driving a car, Avant-garde artstyle, by Pablo Picasso, by Claude Monet, gradient : [B2EBF2, 00BCD4, ], Purple, Unreal Engine, Devianart Top Rated, CGSociety Top Rated.',
    ),
    NftImageModel(
      image: "db_img2",
      text:
          'Cubism artstyle, by Johannes Vermeer, Red, Blue, Green, Yellow, Flat light, CryEngine, CGSociety Top Rated.',
    ),
    NftImageModel(
      image: "db_img3",
      text:
          'A dog driving a car, Pixelated artstyle, by Vincent Van Gogh, by Johannes Vermeer, gradient : [FFF59D, FBC02D, ], Yellow, Devianart Top Rated, CGSociety Top Rated, Broad light, Maya Engine.',
    ),
    NftImageModel(
      image: "db_img4",
      text:
          'A dog driving a car, Avant-garde artstyle, by Pablo Picasso, by Claude Monet, gradient : [B2EBF2, 00BCD4, ], Purple, Unreal Engine, Devianart Top Rated, CGSociety Top Rated.',
    )
  ];
}
