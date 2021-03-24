class CoffersResponseModel {
  String sId;
  String treasury;
  String treasuryTotal;
  String salaries;
  String salariesMonth;
  String bills;
  String abdelazizTreasury;
  String abdelrahmanTreasury;
  String bahaaTreasury;
  String ibrahimTreasury;
  String publishedAt;
  String createdAt;
  String updatedAt;
  int iV;
  var id;

  CoffersResponseModel(
      {this.sId,
        this.treasury,
        this.treasuryTotal,
        this.salaries,
        this.salariesMonth,
        this.bills,
        this.abdelazizTreasury,
        this.abdelrahmanTreasury,
        this.bahaaTreasury,
        this.ibrahimTreasury,
        this.publishedAt,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.id});

  CoffersResponseModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    treasury = json['treasury'];
    treasuryTotal = json['treasury_total'];
    salaries = json['salaries'];
    salariesMonth = json['salaries_month'];
    bills = json['bills'];
    abdelazizTreasury = json['abdelaziz_treasury'];
    abdelrahmanTreasury = json['abdelrahman_treasury'];
    bahaaTreasury = json['bahaa_treasury'];
    ibrahimTreasury = json['ibrahim_treasury'];
    publishedAt = json['published_at'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['treasury'] = this.treasury;
    data['treasury_total'] = this.treasuryTotal;
    data['salaries'] = this.salaries;
    data['salaries_month'] = this.salariesMonth;
    data['bills'] = this.bills;
    data['abdelaziz_treasury'] = this.abdelazizTreasury;
    data['abdelrahman_treasury'] = this.abdelrahmanTreasury;
    data['bahaa_treasury'] = this.bahaaTreasury;
    data['ibrahim_treasury'] = this.ibrahimTreasury;
    data['published_at'] = this.publishedAt;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['id'] = this.id;
    return data;
  }
}
