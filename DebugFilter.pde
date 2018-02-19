class DebugFilter implements TileFilter {
  Tile entryPoint;
  boolean forcenext = false;
  
  public DebugFilter() {
  }
  public void receive(Tile input) {
    message("probably used as a pause");
    this.entryPoint = input.copy();
  }
  public Tile deliver() {
    return entryPoint;
  }
  public void message(String msg) {
    println("debug > " + msg);
  }
  
  
  
  
  public boolean forceNext() {
    return forcenext;
  }
  
  public void leftClick(int x, int y) {
  }
  public void leftDrag(int x, int y) {
  }
  
}
