unit ChessTypes;

interface
 type
  TChessFigures = (pawn, knight, bishop, rook, queen, king);
  TFieldLetters = 'a'..'h';
  TFieldDigits = 1..8;
  TPlayer = (white = 1, black = -1);
  figurePointer = ^TFigure;
  TFigurePosition = record
    letter: Char;
    digit: Integer;
  end;
  TFigure = record
  image: Char;
  self: TChessFigures;
  player: TPlayer;
  end;
  TChessEnumRaw = array[TFieldLetters] of TChessFigures;
  TChessRaw = array[TFieldLetters] of figurePointer;
  TChessField = array[TFieldDigits] of TChessRaw;
  TDrawbleFigures = array[TChessFigures] of char;
  TValuesFigures = array[TChessFigures] of ShortInt;

const
  PAWN_RAW_INITIAL: TChessEnumRaw = (pawn, pawn, pawn, pawn, pawn, pawn, pawn, pawn);
  FIGURES_RAW_INITIAL: TChessEnumRaw = (rook, knight, bishop, king, queen, bishop, knight, rook);
  DrawbleFigures: TDrawbleFigures = ('i', 'k', '^', 'r', 'q', '!');
  FiguresValues: TValuesFigures = (1, 3, 3, 4, 8, 10);
  fieldDigits: set of TFieldDigits = [1..8];
  fieldLetters: set of TFieldLetters = ['a'..'h'];
implementation

end.
