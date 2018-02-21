class PositionalDither implements TileFilter {
  Tile entryPoint;
  Tile current;
  int grid;
  float bias;
  boolean forcenext = false;
  
  public PositionalDither() {
    message("a positional dither! drag horizontally to change map, vertically to change bias.");
    grids = standardGrids;
    grid = 2;
    bias = 1;
  }
  public PositionalDither(boolean automate, int gridNo) {
    bias = random(0.5,1.5);
    if (automate) {
      forcenext = true;
    } 
    if (gridNo == 0) {
      grids = standardGrids;
    } else if (gridNo == 1) {
      grids = weirdGrids;
    } else if (gridNo == 2) {
      grids = spiralGrids;
    } else if (gridNo == 3) {
      grids = unevenGrids;
    } else grids = standardGrids;
    grid = int(random(grids.length));
  }
  public void message(String msg) {
    println("pos. dither > " + msg);
  }
  public void receive(Tile input) {
    if (forcenext) {
      message("using random values");
    } else {
      message("a positional dither! drag horizontally to change map, vertically to change bias.");
    }
    this.entryPoint = input.copy();
    //this.current = input.copy();
  }
  public Tile deliver() {
    current = entryPoint.copy();
    apply();
    return current;
  }
  
  public void apply() {
    int side = grids[grid].length;
    int amt = side*side;
    
    for(int y = 0; y < current.getHeight(); y++) {
      for (int x = 0; x < current.getWidth(); x++) {
        color suspect = current.get(x,y);
        int tresh = grids[grid][x%side][y%side];
        double value = lum(suspect)*amt*bias;
        if (suspect == #ffffff) {
          current.set(x,y,#ffffff);
        } else if (value <= tresh) {
          current.set(x,y,#000000);
        } else {
          current.set(x,y,#ffffff);
        }
      }
    }

  }
  
  
  public boolean forceNext() {
    return forcenext;
  }
  
  public float lum(color a) {
    return (red(a)+green(a)+blue(a))/3;
  }
  
  public void leftClick(int x, int y) {}
  public void leftDrag(int x, int y) {
    bias = constrain(y,0,94)/94.0;
    bias = pow(bias*2,4)/4;
    int swef = int(constrain(map(x, 0, 204, 0, grids.length),0,grids.length-1));
    if (swef != this.grid) {
      int o = grids[swef].length;
      println(o+ "x" + o + "grid");
    }
    this.grid = swef;
  }
  
  int[][][] grids;
  int[][][] standardGrids = {
      {{0,2},{1,3}},
      
      {{0,7,3},
      {6,5,2},
      {4,1,8}},
      
      {{0,8,2,10},
      {12,4,14,6},
      {3,11,1,9},
      {15,7,13,5}},
      
      {{0,48,12,60,3,51,15,63},
      {32,16,44,28,35,19,47,31},
      {8,56,4,52,11,59,7,55},
      {40,24,36,20,43,27,39,23},
      {2,50,14,62,1,49,13,61},
      {34,18,46,30,33,17,45,29},
      {10,59,6,54,9,57,5,53},
      {42,26,38,22,41,25,37,21}}
    };
  int[][][] weirdGrids = {
      {{0,1,2},
      {3,4,5},
      {6,7,8}},
      
      {{0,2,5},
      {1,4,7},
      {3,6,8}},
      
      {{0,8,1,9},
      {2,10,3,11},
      {4,12,5,13},
      {6,14,7,15}}
  };
  int[][][] spiralGrids = {
    {{00,01,02,03,04,05,06,07,8},
    {31,32,33,34,35,36,37,38,9},
    {30,55,56,57,58,59,60,39,10},
    {29,54,71,72,73,74,61,40,11},
    {28,53,70,79,80,75,62,41,12},
    {27,52,69,78,77,76,63,42,13},
    {26,51,68,67,66,65,64,43,14},
    {25,50,49,48,47,46,45,44,15},
    {24,23,22,21,20,19,18,17,16}}
  };
  int [][][] unevenGrids = {
    
      {{0,1,2,1,0},
      {1,2,3,2,1},
      {2,4,7,4,2},
      {1,2,3,2,1},
      {0,1,2,1,0}},
      
      {{0,2,0,2},
      {4,8,4,8},
      {6,16,10,12},
      {5,9,5,9}},
      
      {{7,0,7},
      {9,1,9},
      {7,0,7}}
  };
}
