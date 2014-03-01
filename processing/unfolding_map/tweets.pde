class Tweet {
  
  SimplePointMarker marker;
  
  String message;
  int posX;
  int posY; 
  int opacity;

  
  Tweet(float tempLat,
        float tempLong,
        String tempMessage){
    message = tempMessage;      
    opacity = 255;      
          
    Location location = new Location(tempLat, tempLong);
    marker = new SimplePointMarker(location);  
    ScreenPosition tweetPos = marker.getScreenPosition(map);
    //image(img,tweetPos.x,tweetPos.y,15,10);
    posX = int(tweetPos.x);
    posY = int(tweetPos.y); 
  }
  
  void show(){
    if (opacity > 0){
      opacity -= 1;
    }
    image(twitterLogo, posX,posY,15,12);
    
    tweetLayer.fill(0,255,0,opacity);
    tweetLayer.text(message, posX + 15, posY + 10);
  
  }
  
}
