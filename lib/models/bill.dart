class Bill {
  int ? ID;
  String? LITER;
  String? PRICE;
  String? FUELTYPE;
  String? DATE;

  Bill({ this.LITER, this.PRICE, this.DATE, this.FUELTYPE, this.ID});

  Bill.fromJson(Map<String, dynamic> json) {
    ID = json['ID'];
    LITER = json['LITER'];
    PRICE = json['PRICE'];
    FUELTYPE = json['FUELTYPE'];
    DATE = json['DATE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.ID;
    data['LITER'] = this.LITER;
    data['PRICE'] = this.PRICE;
    data['FUELTYPE'] = this.FUELTYPE;
    data['DATE'] = this.DATE;
    return data;
  }
}