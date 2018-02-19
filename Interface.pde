public interface TileFilter {
  public void leftClick(int x, int y);
  public void leftDrag(int x, int y);
  public void receive(Tile input);
  public Tile deliver();
  public boolean forceNext();
  public void message(String msg);
}
