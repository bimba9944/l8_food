class FoodModel{
  String date ='';
  String defVal = '';
  String email = '';
  int index = 0;
  int indexOfDay = 0;
  String userId = '';

  FoodModel();

  FoodModel.fromDocument({dynamic document}){
    date = document['date'];
    defVal = document['defVal'];
    email = document['email'];
    index = document['index'];
    indexOfDay = document['indexOfDay'];
    userId = document['userId'];
  }

  FoodModel.blank() {
    date = "";
    defVal = "";
    email = "";
    index = 0;
    indexOfDay = 0;
    userId = "";
  }

  FoodModel clone() {
    return FoodModel.blank()
      ..date = date
      ..defVal = defVal
      ..email = email
      ..index = index
      ..indexOfDay = indexOfDay
      ..userId = userId;
  }

}