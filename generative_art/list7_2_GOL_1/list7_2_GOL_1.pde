int _cellSize = 10;
Cell[][] _cellArray;
int _numX, _numY;

void setup() {
  size(1000, 1000);
  _numX = floor(width/_cellSize);
  _numY = floor(height/_cellSize);
  restart();
}

void restart(){
  _cellArray = new Cell[_numX][_numY];
  for (int xNum=0; xNum<_numX; xNum++){
    for (int yNum=0; yNum<_numY; yNum++){
      Cell newCell = new Cell(xNum,yNum);
      _cellArray[xNum][yNum] = newCell;
    }
  }
  
  //get present states
  for (int xNum=0; xNum<_numX; xNum++){
    for (int yNum=0; yNum<_numY; yNum++){
      int abv = yNum-1;
      int blw = yNum+1;
      int lft = xNum-1;
      int rit = xNum+1;
      
      if (abv <    0){abv=_numY-1;}
      if (blw==_numY){blw=0;}
      if (lft <    0){lft=_numX-1;}
      if (rit==_numX){rit=0;}
      
      _cellArray[xNum][yNum].addNeighbour( _cellArray[ lft][ abv] );
      _cellArray[xNum][yNum].addNeighbour( _cellArray[ lft][yNum] );
      _cellArray[xNum][yNum].addNeighbour( _cellArray[ lft][ blw] );
      _cellArray[xNum][yNum].addNeighbour( _cellArray[xNum][ blw] );
      _cellArray[xNum][yNum].addNeighbour( _cellArray[ rit][ blw] );
      _cellArray[xNum][yNum].addNeighbour( _cellArray[ rit][yNum] );
      _cellArray[xNum][yNum].addNeighbour( _cellArray[ rit][ abv] );
      _cellArray[xNum][yNum].addNeighbour( _cellArray[xNum][ abv] );
    }
  }
}

void draw() {
  background(200);

  for (int xNum=0; xNum<_numX; xNum++){
    for (int yNum=0; yNum<_numY; yNum++){
      _cellArray[xNum][yNum].calcNextState();
    }
  }
  
  translate(_cellSize/2,_cellSize/2);
  
  for (int xNum=0; xNum<_numX; xNum++){
    for (int yNum=0; yNum<_numY; yNum++){
      _cellArray[xNum][yNum].drawMe();
    }
  }
}

void mouseReleased(){
  restart();
}

//=======================================================
class Cell {
  float x,y;
  boolean state;
  boolean nextState;
  Cell[] neighbours;
  
  Cell (float xNum, float yNum){
    x = xNum * _cellSize;
    y = yNum * _cellSize;
    
    if (random(2)>1){
      nextState = true; //live
    }else{
      nextState = false; //dead
    }
    
    state = nextState;
    neighbours = new Cell[0];
  }
  
  void addNeighbour(Cell cell){
    neighbours = (Cell[])append(neighbours,cell);
  }

  void calcNextState(){
    int liveCount=0;
    for (int i=0; i<neighbours.length; i++){
      if(neighbours[i].state){
        liveCount++;
      }
    }
    
    if(state){
      if( (liveCount==2) || (liveCount==3) ){
        nextState=true;
      }else{
        nextState=false;
      }
    }else{
      if(liveCount==3){
        nextState=true;
      }else{
        nextState=false;
      }
    }
  }
  
  void drawMe(){
    state = nextState;
    stroke(0);
    if (state){
      fill(0); //live
    }else{
      fill(255); //dead
    }
    ellipse(x,y,_cellSize,_cellSize);
    
  }
}
