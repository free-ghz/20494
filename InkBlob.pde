class InkBlob implements TileFilter {
  Tile entryPoint;
  Tile current;
  boolean forcenext = false;
  
  public InkBlob() {
    tiles = new Flow[c_width][c_height];
  }
  public InkBlob(boolean automate) {
    tiles = new Flow[c_width][c_height];
    forcenext = true;
  }
  public void message(String msg) {
    println("inkblob > " + msg);
  }
  public void receive(Tile input) {
    if (forcenext)
      message("this one can take some time.");
    else
      message("click to add additional blobs!");
    this.entryPoint = input.copy();
    this.current = input.copy();
    if (forcenext) apply(); 
  }
  public Tile deliver() {
    if (!forcenext) apply();
    return current;
  }
  
  public boolean forceNext() {
    return forcenext;
  }
  
  public void leftClick(int x, int y) {
    float pref_x = mouseX;
    float pref_y = mouseY;
    float radius = c_radius;
    float step = TAU/c_clickamount;
    for (int i = 0; i < c_clickamount; i++) {
      float px = pref_x + (sin(step*i)*random(radius));
      float py = pref_y + (cos(step*i)*random(radius));
      Point noob = new Point(px, py);
      points.add(noob);
    }
    for (int i = 0; i < c_clickamount; i++) {
      float px = pref_x + (sin(step*i)*random(radius/2));
      float py = pref_y + (cos(step*i)*random(radius/2));
      Point noob = new Point(px, py);
      points.add(noob);
    }
    println(points.size());
  }
  public void leftDrag(int x, int y) {
    Point noob = new Point(mouseX, mouseY);
    points.add(noob);
  }
  
  public void apply() {
    if (firstround) {
      firstround = false;
      for (int x = 0; x < c_width; x++) {
        for (int y = 0; y < c_height; y++) {
          tiles[x][y] = new Flow(x, y);
        }
      }
      if (c_populate) {
        for (int i = 0; i < c_populate_amt; i++) {
          Point noob = new Point(random(c_tilewidth*c_width), random(c_tileheight*c_height));
          points.add(noob);
        }
      }
    } // end if first round
    boolean loopu = true;
    int countz = 0;
    while(loopu) {
      Iterator it = points.iterator();
      while (it.hasNext ()) {
        Point p = (Point) it.next();
        int x = int(floor(p.x()/c_tilewidth));
        int y = int(floor(p.y()/c_tileheight));
        if (x < c_width && x >= 0 && y < c_height && y >= 0) {
          tiles[x][y].movepoint(p);
        } else {
          it.remove();
        }
        if (p.deleteme) {
          it.remove();
        }
      }
      
      if ((!loopu) && forcenext) {
        if (points.size() > 10) loopu = true; 
      } else if (loopu && forcenext) {
        if (points.size() <= 10) loopu = false;
      } else {
        loopu = false;
      }
      countz++;
      if (countz > 1000) {
        message("forcequit");
        break;
      }
    }
  }
  
  import java.util.Iterator;

  Flow[][] tiles;
  
  // where to go
  float c_towards_border = 0.5;
  int c_maxspeed = 10;
  // add people
  boolean c_populate = true;
  int c_populate_amt = 5000;
  // for each tile, how much does it affect a projectile
  boolean c_randomfactor = true;
  float c_factor = 0.1;
  boolean c_random_pointfactor = true;
  float c_pointfactor = 0.1;
  // border
  boolean c_autoborder = true;
  int c_autoborder_tresh = int(c_populate_amt/7);
  
  // size
  int c_tilewidth = 17;
  int c_tileheight = 13;
  int c_width = 12; // 12*17 = 204
  int c_height = 8; // 13*7 = 91
  // what to happen when click
  int c_clickamount = 10;
  float c_radius = 1;
  // colouring
  float c_ambience = 0.7;
  int c_colourcycle = 900;
  boolean c_only_black = true; 
  // stagnation removal
  int c_savedpositions = 50;
  int c_maxmovement = 3;
    
  float c_brightness = 1; //0.7;
  ArrayList<Point> points = new ArrayList<Point>();
  
  
  boolean firstround = true;

  class Flow {
    float xspeed;
    float yspeed;
    float factor;
    Flow(float x, float y) {
      xspeed = (((x-(c_width/2))/c_width)*c_maxspeed)*c_towards_border;
      yspeed = (((y-(c_height/2))/c_height)*c_maxspeed)*c_towards_border;
      float xspeed2 = (-c_maxspeed + random(c_maxspeed*2))*(1-c_towards_border);
      float yspeed2 = (-c_maxspeed + random(c_maxspeed*2))*(1-c_towards_border);
      xspeed += xspeed2;
      yspeed += yspeed2;
      if (c_randomfactor) {
        factor = random(1);
      } else {
        factor = c_factor;
      }
    }
    void movepoint(Point p) {
      p.translate(xspeed,yspeed,factor);
    }
  }
  
  import java.util.Queue;
  import java.util.LinkedList;
  
  class Point {
    float x;
    float y;
    float speedx = 0;
    float speedy = 0;
    float selffactor;
    public int movements = 0;
    Queue<PVector> positions = new LinkedList<PVector>();
    public boolean deleteme = false;
    Point(float x, float y) {
      this.x = x;
      this.y = y;
      if (c_random_pointfactor) {
        selffactor = random(1);
      } else {
        selffactor = c_pointfactor;
      }
    }
    void translate(float xd, float yd, float factor) {
      movements+=1;
      speedx = speedx + ((xd-speedx)*factor*selffactor);
      speedy = speedy + ((yd-speedy)*factor*selffactor);
      float newx = x + speedx;
      float newy = y + speedy;
      float speed = (abs(speedx)+abs(speedy));
      float old = red(current.get(int(x),int(y)));
      float co = old - (((1-c_ambience)-((speed/c_maxspeed)*(1-c_ambience)))*0.3)  ;
      color c = color(co,co,co);
      //line(x,y,newx,newy);
      current.set(int(x),int(y),c);
      x = newx;
      y = newy;
      positions.add(new PVector(x,y));
      if (positions.size() > c_savedpositions) {
        PVector jmf = positions.remove();
        if (abs(jmf.x - x) < c_maxmovement && abs(jmf.y - y) < c_maxmovement) {
          deleteme = true;
        } 
      }
    }
    float x() { return x; }
    float y() { return y; }
  }

}
