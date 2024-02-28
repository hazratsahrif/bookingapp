class BannerAdsModel {
  bool? success;
  List<Ads>? ads;

  BannerAdsModel({this.success, this.ads});

  BannerAdsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['ads'] != null) {
      ads = <Ads>[];
      json['ads'].forEach((v) {
        ads!.add(new Ads.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.ads != null) {
      data['ads'] = this.ads!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Ads {
  int? id;
  String? title;
  int? status;
  String? banner;
  String? des;
  String? webUrl;
  String? createdAt;
  String? updatedAt;

  Ads(
      {this.id,
      this.title,
      this.status,
      this.banner,
      this.des,
      this.webUrl,
      this.createdAt,
      this.updatedAt});

  Ads.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    status = json['status'];
    banner = json['banner'];
    des = json['des'];
    webUrl = json['web_url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['status'] = this.status;
    data['banner'] = this.banner;
    data['des'] = this.des;
    data['web_url'] = this.webUrl;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
