import 'dart:html';

CanvasElement canvas;
CanvasRenderingContext2D ctx;
const int width = 15;
Board board = new Board();
bool playerTurn = true;

class Board{
  List<int> brd;
  int redTurn;
 
  Board(){
    brd = new List<int>(width*width);
    redTurn = 1;
  }

  Board.copy(Board toCopy){
    brd = new List.from(toCopy.brd);
    redTurn = toCopy.redTurn;
  }

  void EndTurn(){
    redTurn = redTurn == 1 ? 2 : 1;
  }

  int InLine(int pos, int x, int y){
    
  }

  int CheckWin(int pos){
    return 0;
  }
}

void main() {
  canvas = querySelector("#canvas");
  canvas.onClick.listen(CanvasClicked);
  ctx = canvas.context2D;
  Initialize();
  DrawBoard();
}

void Initialize(){
  for (var i = 0; i < board.brd.length; i++) {
    board.brd[i] = 0;
  }
}

void EndTurn(){
  board.EndTurn();
  DrawBoard();
}

void CanvasClicked(e){
  int xc = e.client.x - ctx.canvas.getBoundingClientRect().left;
  int yc = e.client.y - ctx.canvas.getBoundingClientRect().top;
  int x = xc ~/ (canvas.width / width);
  int y = yc ~/ (canvas.height / width);
  print("x: $x, y: $y");
  if (playerTurn){
    if (board.brd[x+y*15] == 0){
      board.brd[x+y*15] = board.redTurn == 1 ? 1 : 2;
      EndTurn();
    }
  }
}

void DrawBoard(){
  ctx.fillStyle = "rgb(0, 0, 0)";
  ctx.fillRect(0, 0, canvas.width, canvas.height);
  ctx.fillStyle = "rgb(18, 3, 75)";
  ctx.strokeStyle = "rgb(18, 3, 75)";
  ctx.lineWidth = 5;
  for (var i = 0; i < width+1; i++) {
    ctx.beginPath();
    ctx.moveTo((canvas.width/(width))*i, 0);
    ctx.lineTo((canvas.width/(width))*i, canvas.height);
    ctx.closePath();
    ctx.stroke();
    ctx.beginPath();
    ctx.moveTo(0, (canvas.height/(width))*i);
    ctx.lineTo(canvas.width, (canvas.height/(width))*i);
    ctx.closePath();
    ctx.stroke();
  }
  for (var i = 0; i < board.brd.length; i++) {
    if (board.brd[i] != 0){
      int x = i % width;
      int y = (i-(i % width))~/width;
      if (board.brd[i] == 1){
        ctx.strokeStyle = "rgb(215, 20, 10)";
      } else{
        ctx.strokeStyle = "rgb(10, 20, 215)";
      }
      ctx.beginPath();
      ctx.moveTo((x+0.5)*(canvas.width/width)-10, (y+0.5)*(canvas.height/width)-10);
      ctx.lineTo((x+0.5)*(canvas.width/width)+10, (y+0.5)*(canvas.height/width)+10);
      ctx.closePath();
      ctx.stroke();
      ctx.beginPath();
      ctx.moveTo((x+0.5)*(canvas.width/width)-10, (y+0.5)*(canvas.height/width)+10);
      ctx.lineTo((x+0.5)*(canvas.width/width)+10, (y+0.5)*(canvas.height/width)-10);
      ctx.closePath();
      ctx.stroke();
    }
  }
}