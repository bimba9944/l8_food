class MealsModel{
  List<String> hrana =[];
  int index = 0;

  MealsModel();

  MealsModel.fromDocument({dynamic document}){
    hrana = document['hrana'];
    index = document['index'];
  }

  MealsModel.blank() {
    hrana = [];
    index = 0;
  }

  MealsModel clone() {
    return MealsModel.blank()
      ..hrana = hrana
      ..index = index;
  }

}