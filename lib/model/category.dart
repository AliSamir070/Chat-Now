class Category{
  String id;
  String title;
  String imagePath;
  Category({required this.id , required this.title , required this.imagePath});

  static List<Category> getCategories(){
    return [
      Category(id: "sports", title: "Sports", imagePath: "assets/images/sports.png"),
      Category(id: "movies", title: "Movies", imagePath: "assets/images/movie.png"),
      Category(id: "music", title: "Music", imagePath: "assets/images/music.png"),
    ];
  }
  static Category? getCategorybyId(String id){
    List<Category> categories = getCategories();
    for(Category category in categories ){
      if(category.id==id){
        return category;
      }
    }
  }
}