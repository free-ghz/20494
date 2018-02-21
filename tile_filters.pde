Tile base;
Tile display;
TileFilter[] filterStack;
int stackPlace = -1;
boolean running = true;
void setup() {
  size(204,94);
  noSmooth();
  base = new Tile(loadImage("input.png"));
  //base = new Tile(204,94,#ffffff);
  fill(#ffffff);
  stroke(#000000);
  colorMode(RGB, 1.0);
  
  restart_shit();
}
void restart_shit() {
  println("-----");
  stackPlace = -1;
  running = true;
  filterStack = new TileFilter[] {
    new Spotscope(true),
    new Cellular1D(false,true,0),
    new Vignette(true),
    new PositionalDither(true,0),
    new Vignette(true),
    new PositionalDither(true,0)
  };
  
  nextFilter(); // init run
}
void draw() {
  rect(-1,-1,206,96); // larger, to avoid borders
  display = filterStack[stackPlace].deliver();
  display.drawImage(0,0);
  //display.applyColor(0,0,#000000);
  if (stackPlace < filterStack.length-1 && filterStack[stackPlace].forceNext()) nextFilter();
}
void mouseDragged() {
  if (mouseButton == LEFT) {
    if (running) filterStack[stackPlace].leftDrag(mouseX,mouseY);
  }
}
void mousePressed() {
  if (mouseButton == LEFT) {
    if (running) filterStack[stackPlace].leftClick(mouseX,mouseY);
  } else if (mouseButton == RIGHT) {
    nextFilter();
  }
}
void nextFilter() {
  if (stackPlace < filterStack.length-1) {
    Tile thing;
    if (stackPlace >= 0) {
      thing = filterStack[stackPlace].deliver();
    } else {
      thing = base;
    }
    stackPlace++;
    filterStack[stackPlace].receive(thing);
  } else {
    // save image!
    Long wew = (long)System.currentTimeMillis();
    String lel = "output/" + wew.toString() + ".png";
    save(lel);
    println("saved as " + lel);
    running = false;
  }
}
void keyReleased() {
  if (key == 'x') {
    restart_shit();
  }
}
  
