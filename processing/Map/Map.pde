PImage img;
String place = "guildford";


void setup() {
  // set up canvas
  size(640, 640);

  // load image from url
  // url is from google static maps api... https://developers.google.com/maps/documentation/staticmaps/?csw=1
  String url = "http://maps.googleapis.com/maps/api/staticmap?zoom=13&size=WIDTHxHEIGHT&sensor=false";
  url = url.replace("WIDTH",str(height));  
  url = url.replace("HEIGHT",str(width));
  //url = url + "&center=" + place;
  url += "&markers=51.211911,-0.6224141|51.2711197,-0.5084325";
  
  print(url);
  
  img = loadImage(url,"png");
  
  noLoop();
}

void draw() {
  image(img,0,0);

  
  stroke(0);
  noFill();
  
  ellipse(304,192,10,10);
    
}


