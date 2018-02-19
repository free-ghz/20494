class Vignette implements TileFilter {
  Tile entryPoint;
  boolean forcenext = false;
  Tile current;
  float weight = 0.5;
  
  public Vignette() {
  }
  public Vignette(boolean force) {
    if (force) {
      forcenext = true;
      weight = random(0,20);
    } 
  }
  public void message(String msg) {
    println("vignette > " + msg);
  }
  public void receive(Tile input) {
    if (forcenext) {
      message("adds a random fade to white.");
    } else {
      message("adds a fade to white. drag horizontally to change intensity.");
    }
    this.entryPoint = input.copy();
  }
  public Tile deliver() {
    current = entryPoint.copy();
    apply();
    return current;
  }
  
  private void apply() {
    float waveX = 3.14159265359 / 204.0;
    float waveY = 3.14159265359 / 94.0;
    for(int y = 0; y < current.getHeight(); y++) {
      for (int x = 0; x < current.getWidth(); x++) {
        color in = current.get(x,y);
        float mod = red(in);
        // "gamla" algen som ser bra ut på svartvitt men inte på gråskala
        //float amt = 1 - ( (1-mod) * (sin(waveX*x)*sin(waveY*y)*weight));
        float amt = mod + 1 - constrain(sin(waveX*x)*sin(waveY*y)*weight,0,1);
        color out = color(amt,amt,amt);
        current.set(x,y,out);
      }
    }
  }
  
  
  
  public boolean forceNext() {
    return forcenext;
  }
  
  public void leftClick(int x, int y) {
  }
  public void leftDrag(int x, int y) {
    // x = weight
    float weightIn = constrain(map(x,0,204,0,1),0,1);
    weight = map(weightIn,0,1,1,20);
  }
  
}
