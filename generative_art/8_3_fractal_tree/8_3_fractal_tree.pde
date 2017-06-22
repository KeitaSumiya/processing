PImage img;
int _numChildren = 5;
int _maxLevels   = 5;

Branch _trunk;

void setup() {
  size(1000,1000);
//  img = createImage(width, height, ARGB);
//  colorMode(RGB, 255, 255, 255, 128);
  background(255, 0);
  noFill();
  smooth();
  newTree();
}

void newTree() {
  _trunk = new Branch(1, 0, width/2, height/2);
  _trunk.drawMe();
}

void draw() {
  background(255, 0);
  _trunk.updateMe(width/2, height/2);
  _trunk.drawMe();
}

void keyPressed() {
  if (keyCode == ENTER) {
    saveFrame( "img#####.png");
//    img.save("imgT#####.png");
  }
}

class Branch {
  float level, index;
  float x, y;
  float endx, endy;

  float strokeW, alph;
  float len, lenChange;
  float rot, rotChange;

  Branch[] children = new Branch[0];
  Branch(float lev, float ind, float ex, float why) {
    level = lev;
    index = ind;
  
    strokeW = (1/level) * 10;
    alph = 255 / level;
    len = (1/level) * random(500);
    rot = random(360);
    lenChange = random(10) - 5;
    rotChange = random(10) - 5;
  
    updateMe(ex, why);
  
    if (level < _maxLevels) {
      children = new Branch[_numChildren];
      for (int x=0; x<_numChildren; x++) {
        children[x] = new Branch(level+1, x, endx, endy);
      }
    }
  }
  
  void updateMe(float ex, float why) {
    x = ex;
    y = why;

    rot += rotChange;
    if (rot > 360) { rot = 0; }
    else if (rot < 0) { rot = 360; }

    len -= lenChange;
    if (len < 0) { lenChange *= -1; }
    else if (len > 500) { lenChange *= -1; }

    float radian = radians(rot);
    endx = x + (len * cos(radian));
    endy = y + (len * sin(radian));

    for (int i=0; i<children.length; i++) {
      children[i].updateMe(endx, endy);
    }
  }
    
    void drawMe() {
      if (level > 1) {
        strokeWeight(strokeW);
        stroke(0);
//        stroke(0, alph);
//        stroke(0, 255, 0, alph);
//        stroke(random(255), random(255), random(255), alph);
        fill(255, alph);
        line(x, y, endx, endy);
        ellipse(endx, endy, len/12, len/12);
      }
      for (int i=0; i<children.length; i++) {
        children[i].drawMe();
    }
  }
}
