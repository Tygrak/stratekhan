import 'dart:html';
import 'board.dart';

CanvasElement canvas;
CanvasRenderingContext2D ctx;
Board board = new Board();
bool playerTurn = true;

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

void CanvasClicked(e){
  int xc = e.client.x - ctx.canvas.getBoundingClientRect().left;
  int yc = e.client.y - ctx.canvas.getBoundingClientRect().top;
  int x = xc ~/ (canvas.width / width);
  int y = yc ~/ (canvas.height / width);
  print("x: $x, y: $y");
  if (playerTurn){
    if (board.brd[x+y*15] == 0){
      int playerWon = board.PlaceEnd(x+y*15);
      if (playerWon != 0){
        print(playerWon);
        playerTurn = false;
        ParagraphElement element = querySelector("#gamestate");
        element.appendText("Player$playerWon won!");
      }
      DrawBoard();
      List<Move> threats = board.GetThreats();
      for (var i = 0; i < threats.length; i++) {
        print("${threats[i].pos} : ${threats[i].inRow}");
      }
      //playerTurn = false;
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