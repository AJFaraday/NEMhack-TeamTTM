import hypermedia.net.*;

import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.utils.*;
import de.fhpotsdam.unfolding.providers.*;
import de.fhpotsdam.unfolding.marker.*;

UDP udp;  // define the UDP object (sets up)
 
// experimental stuff
float[][] positions;
float[] pos; 
 
UnfoldingMap map;
PImage twitterLogo;
SimplePointMarker tweetMarker;

void setup() {
  // low frame rate to attempt lighter load
  frameRate(4); 
  
  size(800,600);
  map = new UnfoldingMap(this, new Microsoft.AerialProvider()); 
  //map = new UnfoldingMap(this);
  // this is for mouse interaction
  Location guildford = new Location(51.23622f, -0.570409f);
  
  map.zoomAndPanTo(guildford, 12);
  
  // get logo and place at marker location
  twitterLogo = loadImage("Twitter_logo_blue.png");
  
  // UDP connectivity setup 
  udp = new UDP( this, 6000 ); 
  udp.listen( true );
  
  positions = new float[0][0];
}

void draw(){
  map.draw();
  
  for (int i = 0; i < positions.length; i++) {
    pos = positions[i];
    image(twitterLogo, pos[0],pos[1],15,12);
  }
}

void receive( byte[] data, String ip, int port ) {  // <-- extended handler
  String message = new String( data );
  println(message);
  String[] parts = split(message, "::::");
  float sentLat = float(parts[0]);
  float sentLong = float(parts[1]);    //"24" -> 24

  Location tweet = new Location(sentLat, sentLong);
  tweetMarker = new SimplePointMarker(tweet);  
  ScreenPosition tweetPos = tweetMarker.getScreenPosition(map);
  //image(img,tweetPos.x,tweetPos.y,15,10);
  float[] pos = {tweetPos.x,tweetPos.y};
 
  //positions.append(pos);

  positions = (float[][])append(positions, pos);  
  
  // simple marker placement
  //map.addMarkers(tweetMarker);
}
