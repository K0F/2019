

PImage logo;

void setup() {
  size(1024,768);
  logo = loadImage("logo.png");
}



void draw() {
  background(255);
  image(logo,width-logo.width-40,20);
}

class Thumbnail {
  PImage thumb;
  PVector pos;
  String filename;
  float w, h;
  int id;

  Thumbnail(String _filename, float _x, float _y, int _id) {
    id = _id;
    filename=_filename+"";
    pos = new PVector(_x, _y);
    w = 320;
    h = 240;
  }

  void draw() {
    rect(pos.x,pos.y,w,h);
    image(thumb, pos.x, pos.y);
  }

  boolean over() {
    if (mouseX>pos.x&&mouseX<w+pos.x)
      return true;

    if (mouseY>pos.y&&mouseY<h+pos.y)
      return true;

    return false;
  }
}
