import hypermedia.net.*;

import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.utils.*;
import de.fhpotsdam.unfolding.providers.*;
import de.fhpotsdam.unfolding.marker.*;

UDP udp;  // define the UDP object (sets up)
 
UnfoldingMap map;
PImage twitterLogo;
SimplePointMarker tweetMarker;
int mapFrames;
Tweet[] tweets;
Instagram[] instagrams;

PGraphics tweetLayer;
PGraphics mapLayer;

void setup() {
  // low frame rate to attempt lighter load
  frameRate(10); 

  size(800,600);
  tweetLayer = createGraphics(width,height);
  
  // Setting up map
  map = new UnfoldingMap(this, new Microsoft.AerialProvider()); 
  Location guildford = new Location(51.23622f, -0.570409f);  
  map.zoomAndPanTo(guildford, 13);
  mapFrames = 50; // my own for initial load and then no processing
  
  // get logo and place at marker location
  twitterLogo = loadImage("Twitter_logo_blue.png");
  
  // UDP connectivity setup 
  udp = new UDP( this, 6000 ); 
  udp.listen( true );   

  // array of tweets for display
  tweets = new Tweet[0];
  instagrams = new Instagram[0];
  
}

void draw(){
  //if (mapFrames > 0) {
    map.draw();
  //  mapFrames -= 1;
  //}

  //draw instagram images
  for (Instagram instagram : instagrams) {
    instagram.show();
  }
  
  // draw tweets  
  tweetLayer.beginDraw();
  tweetLayer.clear();
  for (Tweet tweet : tweets) {
    tweet.show();
  }
  tweetLayer.endDraw(); 
  image(tweetLayer,0,0);
  

}

void receive( byte[] data, String ip, int port ) {  // <-- extended handler
  String networkMessage = new String( data );
  println(networkMessage);
  String[] parts = split(networkMessage, "::::");
  String type = parts[0]; // tweet
  float sentLat = float(parts[1]);
  float sentLong = float(parts[2]);
  String sentMessage = parts[3];  

  if (type.equals("tweet")) {
    if (sentLat > 0) {
      Tweet twt = new Tweet(sentLat,sentLong,sentMessage);
      tweets = (Tweet[]) append(tweets, twt);
    }
  } 
  else if (type.equals("instagram")) {
    if (sentLat > 0) {
      Instagram inst = new Instagram(sentLat,sentLong,sentMessage);
      instagrams = (Instagram[]) append(instagrams, inst);
    }
    
  }
}


