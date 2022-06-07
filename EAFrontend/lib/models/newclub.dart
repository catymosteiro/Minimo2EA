class NewClubModel {
  String clubName;
  String description;
  String idAdmin;
  String category;

  NewClubModel(
      {required this.clubName,
      required this.description,
      required this.idAdmin,
      required this.category});

  factory NewClubModel.fromJson(Map<String, dynamic> json) {
    return NewClubModel(
        clubName: json['clubname'],
        description: json['description'],
        idAdmin: json['idAdmin'],
        category: json['category']);
  }

  static Map<String, dynamic> toJson(NewClubModel credentials) {
    return {
      'clubName': credentials.clubName,
      'description': credentials.description,
      'idAdmin': credentials.idAdmin,
      'category': credentials.category
    };
  }
}
