class Instagram {
  
  SimplePointMarker marker;
  
  String url;
  int posX;
  int posY; 
  PImage img;

  
  Instagram(float tempLat,
            float tempLong,
            String tempURL){
    url = tempURL;      
          
    Location location = new Location(tempLat, tempLong);
    marker = new SimplePointMarker(location);  
    ScreenPosition tweetPos = marker.getScreenPosition(map);
    //image(img,tweetPos.x,tweetPos.y,15,10);
    posX = int(tweetPos.x);
    posY = int(tweetPos.y);
   
    img = loadImage(url); 
  }
  
  void show(){
    image(img,posX,posY,50,50);  
  }
  
}
