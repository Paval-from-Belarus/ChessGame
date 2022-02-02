program ChessMark;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.Diagnostics,
  System.Math,
  ChessLogic in 'ChessLogic.pas',
  ChessTypes in 'ChessTypes.pas';

const
  FieldSize = 8;


var
  gameScore: byte;
  gameField: TChessField;
  chosenFigure: figurePointer;
  currentPos, nextPos: TFigurePosition;

procedure fieldInitialisation(var gameField: TChessField);
var rev_letter, letter: TFieldLetters;
  chessPointer: figurePointer;
begin
rev_letter:= High(TFieldLetters);
for letter:= Low(TFieldLetters) to High(TFieldLetters) do
begin
//black
  //main figures
    new(chessPointer);
  gameField[8][letter]:= chessPointer;
  chessPointer^.self:= FIGURES_RAW_INITIAL[letter];
  chessPointer^.image:= DrawbleFigures[chessPointer^.self];
  chessPointer^.player:= black;
  //pawns
    new(chessPointer);
  gameField[7][letter]:= chessPointer;
  chessPointer^.self:= PAWN_RAW_INITIAL[letter];
  chessPointer^.image:= DrawbleFigures[chessPointer^.self];
  chessPointer^.player:= black;

//white
//main figures
  new(chessPointer);
  gameField[1][letter]:= chessPointer;
  chessPointer^.self:= FIGURES_RAW_INITIAL[rev_letter];
  chessPointer^.image:= DrawbleFigures[chessPointer^.self];
  chessPointer^.player:= white;
 //pawns
   new(chessPointer);
   gameField[2][letter]:= chessPointer;
  chessPointer^.self:= PAWN_RAW_INITIAL[letter];
  chessPointer^.image:= DrawbleFigures[chessPointer^.self];
  chessPointer^.player:= white;
  //
dec(rev_letter);
end;

end;
procedure DrawField(const gameField: TChessField);
var i: integer; letter: char;
    chessPointer: figurePointer;
begin
write(' ');
  for letter :=  Low(TChessRaw) to  High(TChessRaw) do
    write(letter);
    writeln;
  for i := Low(gameField) to High(gameField) do
  begin
  write(i);
    for letter := Low(TChessRaw) to  High(TChessRaw) do
      begin
       chessPointer:= gameField[i][letter];
       if chessPointer <> nil then
          write(chessPointer^.image) else write(' ');
      end;
    writeln;
  end;
end;



function checkInput(var this, next: TFigurePosition): Boolean;
var turnString: String;
    check: Integer;
begin
 readln(turnString);
 Result:= false;
 val(turnString[2], this.digit, check);
 if check = 0 then
     val(turnString[5], next.digit, check);
  if check = 0 then
    begin
    if (next.digit in fieldDigits) and (this.digit in fieldDigits) then begin
    this.letter:= turnString[1];
    next.letter:= turnString[4];
    Result:= (this.letter <> next.letter) or (this.digit <> next.digit);
    end;
end;
end;
begin
fieldInitialisation(gameField);
  DrawField(gameField);
  repeat
    if checkInput(currentPos, nextPos) then
    begin
      chosenFigure:= getFigure(gameField, currentPos, nextPos);
     if chosenFigure <> nil then begin
      gameField[nextPos.digit, nextPos.letter] := chosenFigure;
      gameField[currentPos.digit, currentPos.letter]:= nil;
     end else writeln('Incorrect input');
     //write('Success');
    end
    else
    begin
      writeln('Incorrect input');
    end;
    DrawField(gameField);
  until false;
//writeln(sizeof(DrawbleFigures));
  readln;
end.

