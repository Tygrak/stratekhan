const int width = 15;

class Row{
  int inRow = 0;
  int blocks = 0;
  List<int> threats = new List<int>();
}

class RowEnded{
  int inRow = 0;
  int blocks = 0;
  int endPos = 0;
  List<int> threats = new List<int>();
}

class Move{
  int pos;
  int inRow;
  Move(int position, int threatInRow){
    pos = position;
    inRow = threatInRow;
  }
}

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

  int PlaceEnd(int pos){
    brd[pos] = redTurn;
    EndTurn();
    return CheckWin(pos);
  }

  int CheckWin(int pos){
    if (InLineGapless(pos, 1, 1).inRow == 5){
      return brd[pos];
    } else if (InLineGapless(pos, 1, 0).inRow == 5){
      return brd[pos];
    } else if (InLineGapless(pos, 1, -1).inRow == 5){
      return brd[pos];
    } else if (InLineGapless(pos, 0, 1).inRow == 5){
      return brd[pos];
    }
    return 0;
  }

  void EndTurn(){
    redTurn = redTurn == 1 ? 2 : 1;
  }

  RowEnded InLine(int pos, int x, int y){
    RowEnded r = new RowEnded();
    r.inRow = 1;
    int color = brd[pos];
    int cpos = pos;
    int xpos = pos%15;
    while (cpos-y*width >= 0 && xpos-x >= 0 && cpos-y*width < brd.length && xpos-x < width){
      cpos = cpos-y*width-x;
      xpos -= x;
      if (brd[cpos] == 0 && cpos-y*width >= 0 && xpos-x >= 0 && cpos-y*width < brd.length && xpos-x < width && brd[cpos-y*width-x] == color){
        cpos = cpos-y*width-x;
        r.threats.add(cpos);
        continue;
      } else if (cpos-y*width < 0 || xpos-x < 0 || cpos-y*width >= brd.length || xpos-x >= width || (brd[cpos-y*width-x] != color && brd[cpos-y*width-x] != 0)){
        r.blocks++;
        break;
      } else if (brd[cpos] == 0){
        r.threats.add(cpos-y*width-x);
        break;
      }
    }
    while (cpos+y*width >= 0 && xpos+x >= 0 && cpos+y*width < brd.length && xpos+x < width){
      cpos = cpos+y*width+x;
      xpos += x;
      if (brd[cpos] == 0 && cpos+y*width >= 0 && xpos+x >= 0 && cpos+y*width < brd.length && xpos+x < width && brd[cpos+y*width+x] == color){
        cpos = cpos+y*width+x;
        r.threats.add(cpos);
        continue;
      } else if (cpos+y*width < 0 || xpos+x < 0 || cpos+y*width >= brd.length || xpos+x >= width || (brd[cpos+y*width+x] != color && brd[cpos+y*width+x] != 0)){
        r.blocks++;
        break;
      } else if (brd[cpos] == 0){
        r.threats.add(cpos+y*width+x);
        break;
      }
      r.inRow++;
    }
    return r;
  }

  Row InLineGapless(int pos, int x, int y){
    Row r = new Row();
    r.inRow = 1;
    int color = brd[pos];
    int cpos = pos;
    int xpos = pos%15;
    while (cpos-y*width >= 0 && xpos-x >= 0 && cpos-y*width < brd.length && xpos-x < width){
      cpos = cpos-y*width-x;
      xpos -= x;
      if (cpos-y*width < 0 || xpos-x < 0 || cpos-y*width >= brd.length || xpos-x >= width || (brd[cpos-y*width-x] != color && brd[cpos-y*width-x] != 0)){
        r.blocks++;
        break;
      } else if (brd[cpos] == 0){
        r.threats.add(cpos-y*width-x);
        break;
      }
    }
    while (cpos+y*width >= 0 && xpos+x >= 0 && cpos+y*width < brd.length && xpos+x < width){
      cpos = cpos+y*width+x;
      xpos += x;
      if (cpos+y*width < 0 || xpos+x < 0 || cpos+y*width >= brd.length || xpos+x >= width || (brd[cpos+y*width+x] != color && brd[cpos+y*width+x] != 0)){
        r.blocks++;
        break;
      } else if (brd[cpos] == 0){
        r.threats.add(cpos+y*width+x);
        break;
      }
      r.inRow++;
    }
    return r;
  }

  List<Move> GetThreats(){
    Row r =  new Row();
    int color = 0;
    List<Move> moves = new List<Move>();
    void ClearRow(){
      if (r.inRow >= 2){
        for (var i = 0; i < r.threats.length; i++) {
          moves.add(new Move(r.threats[i], r.inRow));
        }
      }
      r =  new Row();
      color = 0;
    }
    for (int x = 0; x < width; x++) {
      ClearRow();
      for (int y = 0; y < width; y++) {
        if (brd[x+y*width] != 0){
          if (color == 0){
            color = brd[x+y*width];
            if (y-1 >= 0 && brd[x+(y-1)*width] == 0){
              r.threats.add(x+(y-1)*width);
            } else{
              r.blocks++;
            }
          } else if (brd[x+y*width] != color){
            r.blocks++;
            ClearRow();
          }
          r.inRow++;
        } else{
          if (color != 0){
            r.threats.add(x+y*width);
            ClearRow();
          }
        }
      }
    }
    for (int y = 0; y < width; y++) {
      ClearRow();
      for (int x = 0; x < width; x++) {
        if (brd[x+y*width] != 0){
          if (color == 0){
            color = brd[x+y*width];
            if (x-1 >= 0 && brd[x-1+y*width] == 0){
              r.threats.add(x-1+y*width);
            } else{
              r.blocks++;
            }
          } else if (brd[x+y*width] != color){
            r.blocks++;
            ClearRow();
          }
          r.inRow++;
        } else{
          if (color != 0){
            r.threats.add(x+y*width);
            ClearRow();
          }
        }
      }
    }
    for (int y = 4; y < width; y++) {
      ClearRow();
      int yp = y;
      for (int x = 0; x < width && yp < width; x++) {
        yp++;
        if (brd[x+y*width] != 0){
          if (color == 0){
            color = brd[x+yp*width];
            if (x-1 >= 0 && yp-1 >= 0 && brd[x-1+(yp-1)*width] == 0){
              r.threats.add(x-1+(yp-1)*width);
            } else{
              r.blocks++;
            }
          } else if (brd[x+yp*width] != color){
            r.blocks++;
            ClearRow();
          }
          r.inRow++;
        } else{
          if (color != 0){
            r.threats.add(x+yp*width);
            ClearRow();
          }
        }
      }
    }
    for (int y = 0; y < width-4; y++) {
      ClearRow();
      int yp = y;
      for (int x = 0; x < width && yp >= 0; x++) {
        yp--;
        if (brd[x+y*width] != 0){
          if (color == 0){
            color = brd[x+yp*width];
            if (x-1 >= 0 && yp+1 >= 0 && brd[x-1+(yp-1)*width] == 0){
              r.threats.add(x-1+(yp+1)*width);
            } else{
              r.blocks++;
            }
          } else if (brd[x+yp*width] != color){
            r.blocks++;
            ClearRow();
          }
          r.inRow++;
        } else{
          if (color != 0){
            r.threats.add(x+yp*width);
            ClearRow();
          }
        }
      }
    }
    return moves;
  } 
}