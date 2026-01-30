class Location {
  final String id;
  final String name;
  final String address;
  final String description;
  final int countStar;
  final String imageUrl;

  const Location({
    required this.id,
    required this.name,
    required this.address,
    required this.description,
    required this.countStar,
    required this.imageUrl,
  });

  Location copyWith({required int countStar}) {
    return Location(
      id: id,
      name: name,
      address: address,
      description: description,
      countStar: countStar,
      imageUrl: imageUrl,
    );
  }

  static List<Location> getList() {
    return [ Location(
      id: "L01",
      name: "Hoàng Thành Thăng Long",
      address: "19C Hoàng Diệu, Ba Đình, Hà Nội",
      description: "Di sản thế giới được UNESCO công nhận, trung tâm quyền lực của các triều đại phong kiến Việt Nam.",
      countStar: 5,
      imageUrl: "assets/images/leo.jpg",
    ),
      Location(
        id: "L02",
        name: "Văn Miếu – Quốc Tử Giám",
        address: "58 Quốc Tử Giám, Đống Đa, Hà Nội",
        description: "Trường đại học đầu tiên của Việt Nam, biểu tượng của truyền thống hiếu học.",
        countStar: 5,
        imageUrl: "assets/images/leo.jpg",
      ),
      Location(
        id: "L03",
        name: "Nhà tù Hỏa Lò",
        address: "1 Hỏa Lò, Hoàn Kiếm, Hà Nội",
        description: "Di tích lịch sử gắn với phong trào cách mạng và lịch sử kháng chiến.",
        countStar: 4,
        imageUrl: "assets/images/leo.jpg",
      ),
      Location(
        id: "L04",
        name: "Hồ Gươm",
        address: "Hoàn Kiếm, Hà Nội",
        description: "Biểu tượng văn hóa – lịch sử của thủ đô, gắn với truyền thuyết vua Lê trả gươm.",
        countStar: 5,
        imageUrl: "assets/images/leo.jpg",
      ),
      Location(
        id: "L05",
        name: "Chùa Một Cột",
        address: "Chùa Một Cột, Ba Đình, Hà Nội",
        description: "Ngôi chùa độc đáo có kiến trúc một cột giữa hồ sen, xây dựng từ thời Lý.",
        countStar: 4,
        imageUrl: "assets/images/leo.jpg",
      ),
    ];
  }
}
