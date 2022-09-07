class UserDataModel{


  String? image;
  String? name;


  UserDataModel({required this.image, required this.name});


  UserDataModel.fromJson(Map<String, dynamic> json){
    image = json['image'];
    name = json['name'];
  }


  Map<String, dynamic> toJson(){
    return{
      'image' : image,
      'name' : name,
    };
  }
}