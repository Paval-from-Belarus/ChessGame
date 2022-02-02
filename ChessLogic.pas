unit ChessLogic;

interface
uses ChessTypes;

function isEnemy(const base, target: TPlayer): Boolean;

function canKnightMove (const currentPos, nextPos: TFigurePosition): Boolean;

function canBishopMove(const currentPos, nextPos: TFigurePosition; const gameField: TChessField): Boolean;

function canPawnMove(const currentPos, nextPos: TFigurePosition; var gameField: TChessField; const player: TPlayer):Boolean;

function getFigure(var gameField: TChessField; const  currentPos, nextPos: TFigurePosition): figurePointer;

implementation

type
  knightSingleCoordinate = array[1..2] of ShortInt;
  TKnightPoints = record
  horizontal: knightSingleCoordinate;
  vertical: knightSingleCoordinate;
  end;
  // ones replace twoes and twoes replace ones
  procedure replaceKnightCoordinate(var ones, twoes: knightSingleCoordinate);
  var helper: -1..1;
      newTwoes: knightSingleCoordinate;
  begin
     helper:= ones[1];
     newTwoes[1]:= helper*twoes[1];
     newTwoes[2]:= helper*twoes[2];
     twoes[1]:= -1*ones[1];
     twoes[2]:= -1*ones[2];
     ones:= newTwoes;
  end;
  procedure changeKnightPoints(var movePoints: TKnightPoints);
  begin
    with movePoints do
    begin
    if abs(horizontal[1]) = 1 then
      replaceKnightCoordinate(horizontal, vertical)
      else
      replaceKnightCoordinate(vertical, horizontal)
    end;
  end;

function isEnemy(const base, target: TPlayer): Boolean;
begin
  Result:= ord(base) <> ord(target);
end;
procedure destroyFigure(const figurePos: TFigurePosition; var gameField: TChessField);
begin
  dispose(gameField[figurePos.digit][figurePos.letter]);
end;
function canKnightMove (const currentPos, nextPos: TFigurePosition): Boolean;
var movePoints: TKnightPoints;
    i, j, digit: TFieldDigits;
    stop: Boolean;
    letter: TFieldLetters;
begin
with movePoints do
begin
horizontal[1]:= 1;
horizontal[2]:= -1;
vertical[1]:= 2;
vertical[2]:= 2;
stop:= false;
i:= 1;
while not stop and (i <= 4) do
  begin
  j:= 1;
  while (j <= 2) and not stop do
      begin
        digit:=  currentPos.digit + vertical[j];
        letter:= char(ord(currentPos.letter) + horizontal[j]);
        stop:= (nextPos.digit = digit) and (nextPos.letter = letter);
        inc(j);
      end;
  if not stop then
  begin
  inc(i);
  changeKnightPoints(movePoints);
  end;
  end;
  Result:= stop;
end;
end;

function canBishopMove(const currentPos, nextPos: TFigurePosition; const gameField: TChessField): Boolean;
var
i, digitDistance, letterDistance, digitStep, letterStep: ShortInt;
  tempPos: TFigurePosition;
  stop: boolean;
begin
digitDistance:= nextPos.digit - currentPos.digit;
letterDistance:= ord(nextPos.letter) - ord(currentPos.letter);
if (abs(digitDistance) = abs(letterDistance)) and (digitDistance <> 0)then
  begin
    digitStep:= abs(digitDistance) div digitDistance;
    letterStep:= abs(letterDistance) div letterDistance;
    tempPos:= currentPos;
    stop:= false;
    i:= 1;
    while (i <= abs(digitDistance) - 1) and not stop do
    begin
         inc(tempPos.letter, letterStep);
         inc(tempPos.digit, digitStep);
         if gameField[tempPos.digit][tempPos.letter] <> nil then stop:= true else
            inc(i);
    end;
    Result:= not stop;
  end else Result:= false;
end;
function canPawnMove(const currentPos, nextPos: TFigurePosition; var gameField: TChessField; const player: TPlayer):Boolean;
var digitDistance, letterDistance: ShortInt;
    nearFigure: figurePointer;
begin
    digitDistance:= nextPos.digit - currentPos.digit;   //todo: make function to calculating   between points
    letterDistance:= ord(nextPos.letter) - ord(currentPos.letter);
    nearFigure:= gameField[nextPos.digit][nextPos.letter];
    Result:= false;
    if digitDistance*ord(player) > 0 then begin
        if letterDistance = 0 then begin
          case abs(digitDistance) of
          1: Result:= nearFigure = nil;
          2: Result:= (player = white) and (currentPos.digit = 2) or (player = black) and (currentPos.digit = 7);
          end
        end
        else if (abs(letterDistance) = abs(digitDistance)) and (abs(digitDistance) = 1) then begin
            if (nearFigure <> nil) and isEnemy(nearFigure^.player, player) then Result:= True
              else begin
                    nearFigure:= gameField[nextPos.digit - ord(player)][nextPos.letter];
                               //todo: only on first line
                    if (nearFigure <> nil) and (nearFigure^.self = pawn) then begin
                                Result:= (player = white) and (nextPos.digit = 6) or (player = black) and (nextPos.digit = 3);
                                if Result then begin
                                   dispose(nearFigure);
                                   gameField[nextPos.digit - ord(player)][nextPos.letter]:= nil;
                                end;
                        end;
              end;
          end;
    end;
end;
function canRookMove(const currentPos, nextPos:TFigurePosition; const gameField: TChessField): Boolean;
var i, digitDistance, letterDistance, digitStep, letterStep: ShortInt;
  tempPos: TFigurePosition;
  stop: boolean;
begin
digitDistance:= nextPos.digit - currentPos.digit;
letterDistance:= ord(nextPos.letter) - ord(currentPos.letter);
Result:= true;
   if digitDistance = 0 then  begin
     digitStep:= 0;
     letterStep:= abs(letterDistance) div letterDistance;
   end
   else if letterDistance = 0 then begin
     digitStep:= abs(digitDistance) div digitDistance;
     letterStep:= 0;
   end else Result:= false;
    if Result then begin
      tempPos:= currentPos;
      stop:= false;
      i:= 1;
      while (i <= abs(digitDistance) - 1) and not stop do
      begin
           inc(tempPos.letter, letterStep);
           inc(tempPos.digit, digitStep);
           if gameField[tempPos.digit][tempPos.letter] <> nil then stop:= true else
              inc(i);
      end;
      Result:= not stop or (i = 1);
    end;
end;
function canQueenMove(const currentPos, nextPos:TFigurePosition; const gameField: TChessField): Boolean;
var i, digitDistance, letterDistance, digitStep, letterStep: ShortInt;
  tempPos: TFigurePosition;
  stop: boolean;
begin
digitDistance:= nextPos.digit - currentPos.digit;
letterDistance:= ord(nextPos.letter) - ord(currentPos.letter);
Result:= true;
  if digitDistance = 0 then  begin
  digitStep:= 0;
  letterStep:= abs(letterDistance) div letterDistance;
  end
 else if letterDistance = 0 then begin
        digitStep:= abs(digitDistance) div digitDistance;
        letterStep:= 0;
      end
      else if abs(letterDistance) = abs(digitDistance) then begin
        digitStep:= abs(digitDistance) div digitDistance;
        letterStep:= abs(letterDistance) div letterDistance;
      end else Result:= false;
    if Result then begin
      tempPos:= currentPos;
      stop:= false;
      i:= 1;
      while (i <= abs(digitDistance) - 1) and not stop do
      begin
           inc(tempPos.letter, letterStep);
           inc(tempPos.digit, digitStep);
           if gameField[tempPos.digit][tempPos.letter] <> nil then stop:= true else
              inc(i);
      end;
      Result:= not stop or (i = 1);
    end;
end;
function isCheck(const currentPos: TFigurePosition; const gameField: TChessField): Boolean;
begin
isCheck:= false;
end;
function canKingMove(const currentPos, nextPos:TFigurePosition; const gameField: TChessField): Boolean;
var digitDistance, letterDistance: ShortInt;
begin
digitDistance:= abs(nextPos.digit - currentPos.digit);
letterDistance:= abs(ord(nextPos.letter) - ord(nextPos.letter));
Result:= not isCheck(currentPos, gameField) and (digitDistance = letterDistance) and (digitDistance = 1) or
                         (digitDistance*letterDistance = 0) and (abs(digitDistance - letterDistance) = 1);
end;
function getFigure(var gameField: TChessField; const  currentPos, nextPos: TFigurePosition): figurePointer;
var chosenFigure, targetFigure: figurePointer;
isAvailable: Boolean;
begin
//todo: Check correct final position
//   ((gameField[digit][letter] = nil)) or
           // isEnemyPlayers(gameField[currentPos.digit][currentPos.letter], gameField[digit][letter])
 isAvailable:= false;
 chosenFigure:= gameField[currentPos.digit, currentPos.letter];
 //logical check it means check by rules of turning
 case chosenFigure^.self of
 rook: isAvailable:= canRookMove(currentPos, nextPos, gameField);
 bishop: isAvailable:= canBishopMove(currentPos, nextPos, gameField);
 knight: isAvailable:= canKnightMove(currentPos, nextPos);
 queen: isAvailable:= canQueenMove(currentPos, nextPos, gameField);
 king: isAvailable:= canKingMove(currentPos, nextPos, gameField);
 pawn: isAvailable:= canPawnMove(currentPos, nextPos, gameField, chosenFigure.player);
 end;
  if isAvailable then
  begin
  targetFigure:= gameField[nextPos.digit][nextPos.letter];
  if targetFigure = nil then Result:= chosenFigure else
  if isEnemy(chosenFigure.player, targetFigure.player) then begin
    dispose(targetFigure);
    Result:= chosenFigure;
  end else Result:= nil;
  end
   else
  Result:= nil;
end;
end.
