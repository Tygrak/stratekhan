const int width = 15;

class Row{
  int inRow = 0;
  int blocks = 0;
  List<int> threats = new List<int>();

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

  Row InLine(int pos, int x, int y){
    Row r = new Row();
    r.inRow = 1;
    int color = brd[pos];
    int cpos = pos;
    int xpos = pos%15;
    while (cpos-y*width >= 0 && xpos-x >= 0 && cpos-y*width < brd.length && xpos-x < width){
      cpos = cpos-y*width-x;
      xpos -= x;
      if (brd[cpos] != color){
        if (cpos-y*width >= 0 && xpos-x >= 0 && cpos-y*width < brd.length && xpos-x < width && brd[cpos-y*width-x] == color){
          cpos = cpos-y*width-x;
          continue;
        } else if (cpos-y*width < 0 || xpos-x < 0 || cpos-y*width >= brd.length || xpos-x >= width || (brd[cpos-y*width-x] != color && brd[cpos-y*width-x] != 0)){
          r.blocks++;
        } else{
          r.threats.add(cpos-y*width-x);
        }
        cpos = cpos+y*width+x;
        break;
      }
    }
    while (cpos+y*width >= 0 && xpos+x >= 0 && cpos+y*width < brd.length && xpos+x < width){
      cpos = cpos+y*width+x;
      xpos += x;
      if (brd[cpos] != color){
        if (cpos+y*width >= 0 && xpos+x >= 0 && cpos+y*width < brd.length && xpos+x < width && brd[cpos+y*width+x] == color){
          cpos = cpos+y*width+x;
          r.threats.add(cpos);
          continue;
        } else if (cpos+y*width < 0 || xpos+x < 0 || cpos-y*width >= brd.length || xpos-x >= width || (brd[cpos-y*width-x] != color && brd[cpos-y*width-x] != 0)){
          r.blocks++;
        } else{
          r.threats.add(cpos+y*width+x);
        }
        break;
      } else if (brd[cpos] == color){
        r.inRow++;
      }
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
      if (brd[cpos] != color){
        if (cpos-y*width < 0 || xpos-x < 0 || cpos-y*width >= brd.length || xpos-x >= width || (brd[cpos-y*width-x] != color && brd[cpos-y*width-x] != 0)){
          r.blocks++;
        } else{
          r.threats.add(cpos-y*width-x);
        }
        cpos = cpos+y*width+x;
        break;
      }
    }
    while (cpos+y*width >= 0 && xpos+x >= 0 && cpos+y*width < brd.length && xpos+x < width){
      cpos = cpos+y*width+x;
      xpos += x;
      if (brd[cpos] != color){
        if (cpos+y*width < 0 || xpos+x < 0 || cpos-y*width >= brd.length || xpos-x >= width || (brd[cpos-y*width-x] != color && brd[cpos-y*width-x] != 0)){
          r.blocks++;
        } else{
          r.threats.add(cpos-y*width-x);
        }
        break;
      } else if (brd[cpos] == color){
        r.inRow++;
      }
    }
    return r;
  }
}