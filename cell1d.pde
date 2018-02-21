class Cellular1D implements TileFilter {
  Tile entryPoint;
  Tile current;
  boolean forcenext = false;
  
  int[] rules = {22,26,60,102,99,6,14,7,12,16,28,57};
  /*
    22  - ifs
    26  - ifs svag
    60  - ifs 90grader
    102 - ifs 90grader
    99  - pyramider
    
    6   - isometriska trappor
    14  - isometriska trappor heldragna
    7   - isometriska trappor i annan riktning
    12  - horisontella streck
    16  - 3d perspektiv
    28  - 3d perspektiv
    
    57 owoow
  */
  
  int rule = 99;
  public Cellular1D() {
      rule = rules[int(random(rules.length))];
  }
  public Cellular1D(boolean automate, boolean random, int rule) {
    if (automate) forcenext = true;
    if (random) {
      //rule = rules[int(random(rules.length))];
      rule = int(random(256));
    } else {
      rule = rule;
    }
  }
  public void receive(Tile input) {
    if (!forcenext) message("drag horizontally to change algorithm! upper half = all, lower = nice ones");
    else message("shoutout to hans frisk");
    this.entryPoint = input.copy();
  }
  public Tile deliver() {
    current = entryPoint.copy();
    apply();
    return current;
  }
  public void message(String msg) {
    println("cell 1d > " + msg);
  }
  
  public void apply() {
    convertrule();
    for (int x = 0; x < 204; x++) {
      for (int y = 0; y < 94; y++) {
        // input image
        //if (red(current.get(x,y)) < 0.1) set(x,y,#000000); // don't need this i think!
        
        // also do cellular stuff, yeah
        if (x == 203) break; // but not on the last row
        int mask = 0;
        // check states left, mid, right
        if (red(current.get(x,(y+93)%94)) < 0.1) mask += 4;
        if (red(current.get(x,y)) < 0.1)          mask += 2;
        if (red(current.get(x,(y+1)%94)) < 0.1)  mask += 1;
        if (rulearray[7-mask]) {
          current.set(x+1,y,#000000);
        } else {
          //current.set(x+1,y,#ffffff); the trick is in not doing this
        }
      }
    }
  }
  
  
  
  
  public boolean forceNext() {
    return forcenext;
  }
  
  public void leftClick(int x, int y) {
  }
  public void leftDrag(int x, int y) {
    if (y >= 47) {
      rule = rules[int(constrain(map(x,0,204,0,rules.length),0,rules.length-1))];
    } else {
      rule = constrain(int(map(x,0,204,0,128))%128,0,128);
    }
  }
  
  
  boolean[] rulearray = new boolean[8];
  void convertrule() {
    String bits = Integer.toBinaryString(rule);
    int i;
    int wew = 8 - bits.length();
    for (i = 0; i < wew; i++) {
      rulearray[i] = false;
    }
    for (i = wew ; i < 8; i++) {
      if (bits.charAt(i-wew) != '1') {
        rulearray[i] = false;
      } else {
        rulearray[i] = true;
      }
    }
  }
  
}
