class MinAvgDither implements TileFilter {
  Tile entryPoint;
  Tile dithered;
  boolean forcenext = true;
  
  public MinAvgDither() {
    fixKernel();
  }
  public void receive(Tile input) {
    message("bell labs style 3x2 kernel.");
    this.entryPoint = input.copy();
  }
  public Tile deliver() {
    dithered = entryPoint.copy();
    apply();
    return dithered;
  }
  public void message(String msg) {
    println("min avg dith > " + msg);
  }
  
  private void apply() {
    for (int y = 0; y < 94; y++) {
      for (int x = 0; x < 204; x++) {
        
        float swef = red(dithered.get(x,y));
        int nova = round(swef);
        float error = -(nova-swef);
        dithered.set(x,y,color(nova,nova,nova)); 
        
        for (int b = 0; b < kernel.length; b++) {
          for (int a = -2; a < kernel[b].length-2; a++) {
            
            if (y+b < 94) {
              float v = red(dithered.get((x+a+204)%204,y+b));
              v = v + kernel[b][a+2]*error;
              dithered.set((x+a+204)%204,y+b,color(v,v,v));
            }
            
          }
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
  }
  
  private void fixKernel() {
    for (int y = 0; y < 3; y++) {
      for (int x = 0; x < 5; x++) {
        kernel[y][x] = kernel[y][x] / 48.0;
      }
    }
  }
  float[][] kernel = {{0,0,0,7,5},
                      {3,5,7,5,3},
                      {1,3,5,3,1}};
  
}
