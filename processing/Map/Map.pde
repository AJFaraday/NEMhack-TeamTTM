PImage img;
String place = "guildford";


void setup() {
  // set up canvas
  size(640, 360);

  // load image from url
  // url is from google static maps api... https://developers.google.com/maps/documentation/staticmaps/?csw=1
  String url = "http://maps.googleapis.com/maps/api/staticmap?center=PLACE&size=WIDTHxHEIGHT&sensor=false";
  url = url.replaceAll("PLACE",place);
  url = url.replaceAll("WIDTH",str(width));  
  url = url.replace("HEIGHT",str(height));
  
  img = loadImage(url,"png");
}

void draw() {
  image(img,0,0);

  
  stroke(0);
  noFill();
  if(mousePressed){
    ellipse(mouseX,mouseY,10,10);
  }
}
