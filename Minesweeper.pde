import de.bezier.guido.*;
private static final int NUM_ROWS = 20; //20
private static final int NUM_COLS = 20; //20
private static final int NUM_BOMBS = 50;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int r = 0; r < NUM_ROWS; r++){
      for(int c = 0; c < NUM_COLS; c++){
        buttons[r][c] = new MSButton(r, c);
      }
    }
    
    
    setMines();
}
public void setMines()
{
    //your code
    while(mines.size() < NUM_BOMBS){
      int r = (int)(Math.random() * NUM_ROWS);
      int c = (int)(Math.random() * NUM_COLS);
      if(!mines.contains(buttons[r][c]))
        mines.add(buttons[r][c]);
    }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true){
        displayWinningMessage();
        noLoop();
    }
    else if(isLost() == true){
      displayLosingMessage();
      noLoop();
    }
}
public boolean isWon()
{
    //your code here
    for(int i = 0; i < mines.size(); i++)
      if(!mines.get(i).isFlagged())
        return false;
    for(int r = 0; r < NUM_ROWS; r++)
      for(int c = 0; c < NUM_COLS; c++)
        if(mines.contains(buttons[r][c]))
          if(buttons[r][c].isClicked())
            return true;
    return false;
}
public boolean isLost()
{
  for(int i = 0; i < mines.size(); i++)
    if(mines.get(i).isClicked() && !mines.get(i).isFlagged())
      return true;
  return false;
}
public void displayLosingMessage()
{
    //your code here
    for(int r = 0; r < NUM_ROWS; r++){
      for(int c = 0; c < NUM_ROWS; c++){
        buttons[r][c].setLabel("");
        fill(255);
      }
    }
    buttons[10][6].setLabel("Y");
    buttons[10][7].setLabel("O");
    buttons[10][8].setLabel("U");
    buttons[10][9].setLabel("");
    buttons[10][10].setLabel("L");
    buttons[10][11].setLabel("O");
    buttons[10][12].setLabel("S");
    buttons[10][13].setLabel("T");
}
public void displayWinningMessage()
{
    //your code here
    for(int r = 0; r < NUM_ROWS; r++){
      for(int c = 0; c < NUM_ROWS; c++){
        buttons[r][c].setLabel("");
        fill(255);
      }
    }
    buttons[10][6].setLabel("Y");
    buttons[10][7].setLabel("O");
    buttons[10][8].setLabel("U");
    buttons[10][9].setLabel("");
    buttons[10][10].setLabel("W");
    buttons[10][11].setLabel("O");
    buttons[10][12].setLabel("N");
    buttons[10][13].setLabel("!");
}
public boolean isValid(int r, int c)
{
    //your code here
    if(r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS)
      return true;
    return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    //your code here
    for(int r = row - 1; r <= row + 1; r++)
      for(int c = col - 1; c <= col + 1; c++)
        if(isValid(r, c) && mines.contains(buttons[r][c]))
          numMines++;
    if(mines.contains(buttons[row][col]))
      numMines--;
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col;
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        clicked = true;
        //your code here
        if(mouseButton == LEFT && flagged == false){
          if(countMines(myRow, myCol) > 0){
            setLabel(countMines(myRow, myCol));
          }
          else{
            if(isValid(myRow, myCol-1) && !buttons[myRow][myCol-1].isClicked())
              buttons[myRow][myCol-1].mousePressed();
            if(isValid(myRow, myCol+1) && !buttons[myRow][myCol+1].isClicked())
              buttons[myRow][myCol+1].mousePressed();
            if(isValid(myRow+1, myCol) && !buttons[myRow+1][myCol].isClicked())
              buttons[myRow+1][myCol].mousePressed();
            if(isValid(myRow-1, myCol) && !buttons[myRow-1][myCol].isClicked())
              buttons[myRow-1][myCol].mousePressed();
            if(isValid(myRow+1, myCol-1) && !buttons[myRow+1][myCol-1].isClicked())
              buttons[myRow+1][myCol-1].mousePressed();
            if(isValid(myRow-1, myCol-1) && !buttons[myRow-1][myCol-1].isClicked())
              buttons[myRow-1][myCol-1].mousePressed();
            if(isValid(myRow+1, myCol+1) && !buttons[myRow+1][myCol+1].isClicked())
              buttons[myRow+1][myCol+1].mousePressed();
            if(isValid(myRow-1, myCol+1) && !buttons[myRow-1][myCol+1].isClicked())
              buttons[myRow-1][myCol+1].mousePressed();
          }
        }
        if(mouseButton == RIGHT && myLabel == "" && clicked == false){
          if(flagged == false){
            flagged = true;
          }
          else{
            flagged = false;
            clicked = false;
          }
        }
    }
    public void draw () 
    {    
        if (flagged)
            fill(50);
        else if( clicked && mines.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
    public boolean isClicked()
    {
    return clicked;
    }
}
