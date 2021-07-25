class Meals {
  String name;
  String id;
  String deis;
  String image;
  String numberOrders;
  double lat;
  double long;
  double rating;

  Meals(this.name, this.id, this.deis, this.image,this.numberOrders, this.lat, this.long,
      this.rating);


}

List<Meals> MEALS_DATA = [
  Meals("Le Bernardin", "1",
      "A package can help you to change your flutter app's statusbar's color or navigationbar's color programmatically.",
      "https://lh5.googleusercontent.com/p/AF1QipMKRN-1zTYMUVPrH-CcKzfTo6Nai7wdL7D8PMkt=w340-h160-k-no","152",
    40.738380, -73.988426,4
  ),
  Meals("Gramercy Tavern", "2",
      "o change your flutter app's statusbar's co A package can help you tlor or navigationbar's color programmatically.",
      "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MjF8fHJlc3RhdXJhbnR8ZW58MHx8MHx8&ixlib=rb-1.2.1&w=1000&q=80","123",
      40.761421, -73.981667,2.6
  ),
  Meals("Restaurant - bar Le 47", "44",
      "Really good restaurant, elegant and modern yet classic decor and fantastic food!",
      "https://media-cdn.tripadvisor.com/media/photo-s/1a/18/3a/cb/restaurant-le-47.jpg","223",
      40.791421, -73.961667,4.4
  ),
  Meals("Boxcar Social, ", "34",
      " elegant and modern yet classic decor and fantas Really good restaurant,tic food!",
      "https://images.unsplash.com/photo-1414235077428-338989a2e8c0?ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8cmVzdGF1cmFudHxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&w=1000&q=80","223",
      40.794421, -73.97667,4.4
  ),
  Meals("Le Bernardin", "3",
      "color or navigationbar's color prograA package can help you to change your flutter app's statusbar's mmatically.",
      "https://lh5.googleusercontent.com/p/AF1QipMKRN-1zTYMUVPrH-CcKzfTo6Nai7wdL7D8PMkt=w340-h160-k-no","143",
      40.733380, -73.958426,4
  ),
  Meals("Blue Hill", "4",
      "s statusbar's color or navigationbar's color programmatically.A package can help you to change your flutter app' ",
      "https://images.unsplash.com/photo-1504940892017-d23b9053d5d4?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60","342",
      40.732128, -73.999619,4
  ),
];