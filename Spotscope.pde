class Spotscope implements TileFilter {
  Tile entryPoint;
  Tile current;
  boolean forcenext = false;
  boolean inverted = false;
  
  int size = 300;
  
  public Spotscope(boolean inv) {
    forcenext = true;
    inverted = inv;
  }
  public void receive(Tile input) {
    message("non-interactive! random! the TAN backbone of the spotscope processing sketch.");
    this.entryPoint = input.copy();
  }
  public Tile deliver() {
    apply();
    return current;
  }
  public void message(String msg) {
    println("spotscope > " + msg);
  }
  
  boolean applied = false;
  public void apply() {
    if (!applied) {
      message("applying!");
      current = entryPoint.copy();
      sc_setup();
      sc_draw_arcade();
      applied = true;
    }
  }
  
  
  
  public boolean forceNext() {
    return forcenext;
  }
  
  public void leftClick(int x, int y) {
    applied = false;
  }
  public void leftDrag(int x, int y) {
  }
  
  /*
        HENCEFORTH COPIED FROM THE SPITSCOPE
  */
  color[][] canvas = new color[size][size];
  
  private void sc_setup() {
    // genererar "arkader"
    float var_a = random(600)-300;
    float var_b = random(3000)-1500;
    float var_c = random(600)-300;
    float var_d = random(3000)-1050;
    float var_e = round(random(1000)-500);
    float var_f = round(random(1000)-500);
    for(int ix = 0; ix < size; ix++) {
      for(int iy = 0; iy < size; iy++) {
        canvas[ix][iy] = color(0,0,0,0);
      }
    }
     for(int y = 0; y < size; y++) {
      for (int x = 0; x < size; x++) {
        float x_new = x + var_e;
        float y_new = y + var_f;
        if ( tan(((x_new+var_a)/(var_b)+(y_new/var_a)))*tan((y_new/(var_a*var_b))+(x_new*2)) > random(1) ) {
          if (tan((y_new/var_d)*x_new) > 0) {
            float kek = tan((y_new/(var_a*var_b))+(x_new*2));
            canvas[x][y] = color(1-kek,1-kek,1-kek);
          } else {
            float kek = cos((y_new/(var_a*var_b))*(x_new/2));
            canvas[x][y] = color(1-kek,1-kek,1-kek);
          }
        }           
      }
    }
  }
  
  // liten extra som ritar arkaderna i ett tidigt skede
  private void sc_draw_arcade() {
    int ofs_x = (size-204)/2;
    int ofs_y = (size-94)/2;
    for (int y = 0; y < 94; y++) {
      for (int x = 0; x < 204; x++) {
        if (!inverted) {
          current.set(x,y,canvas[ofs_x+x][ofs_y+y]);
        } else {
          float a = red(canvas[ofs_x+x][ofs_y+y]);
          a = 1-a;
          current.set(x,y,color(a,a,a));
        }
      }
    }
  }
  
}
