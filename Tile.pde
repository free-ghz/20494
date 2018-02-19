/* 2018-02-19 D */
class Tile {
  PImage image;
  public Tile(PImage input) {
    this.image = input;
  }
  public Tile(int width, int height, color fill) {
    PImage construct = new PImage(width, height);
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        construct.set(x,y,fill);
      }
    }
    this.image = construct;
  }
  
  /*
  * gives a new copy of the current tile
  */
  public Tile copy() {
    PImage swef = new PImage(image.width,image.height);
    image.loadPixels();
    color[] current = image.pixels;
    color[] noob = new color[current.length];
    System.arraycopy(current,0,noob,0,current.length);
    swef.pixels = noob;
    swef.updatePixels();
    return new Tile(swef);
  }
  
  /*
  * slices the tile up into smaller tiles.
  */
  public Tile[] slice(int x, int y) {
    int amount = x*y;
    Tile[] output = new Tile[amount];
    int sliceWidth = int(image.width)/x;
    int sliceHeight = int(image.height)/y;
    println("slice width: " + sliceWidth + ", slice height: " + sliceHeight);
    
    int actual = 0;
    for (int b = 0; b < y; b++) {
      for (int a = 0; a < x; a++) {
        output[actual] = new Tile(new PImage(sliceWidth,sliceHeight));
        for (int d = 0; d < sliceHeight; d++) {
          for (int c = 0; c < sliceWidth; c++) {
            output[actual].set(c,d,
              image.get((a*sliceWidth)+c,(b*sliceHeight)+d));
          }
        }
        actual++;
      }
    }
    return output;
  }
  
  /*
  * write the image to the screen yo
  */
  public void applyColor(int x, int y, color c) {
    for (int b = 0; b < image.height; b++) {
      for (int a = 0; a < image.width; a++) {
        if (get(a,b) == c) {
          point(x+a,y+b);
        }
      }
    }
  }
  public void drawImage(int x, int y) {
    for (int b = 0; b < image.height; b++) {
      for (int a = 0; a < image.width; a++) {
        stroke(get(a,b));
        point(x+a,y+b);
      }
    }
  }
  
  
  /*
  * getter and setter for individual pixels on the internal PImage
  */
  public color get(int x, int y) {
    return image.get(x,y);
  }
  public void set(int x, int y, color z) {
    image.set(x,y,z);
  }
  public int getWidth() {
    return image.width;
  }
  public int getHeight() {
    return image.height;
  }
  /*
  *  drawing stuff
  */
  public void ln(int a, int b, int x, int y, color h) {
    int modX = 0;
    int modY = 0;
    boolean swef;
    if (abs(a-x) > abs(b-y)) {
      swef = false;
    } else {
      swef = true;
      int t1 = a;
      a = b;
      b = t1;
      t1 = x;
      x = y;
      y = t1;
    }
    if (a > x) modX = -1; else modX = 1;
    if (b > y) modY = -1; else modY = 1;
    float yparts = (float)((float)(b-y)/(float)(a-x));
    println(yparts);
    for (int i = a; i != x; i += modX) {
      int j = b + int((yparts)*(i-a));
      if (swef) this.set(j,i,h); else this.set(i,j,h);
     // println(i + ", " + j);
    }
  }
}
