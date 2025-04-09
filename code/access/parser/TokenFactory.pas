unit TokenFactory;

interface

uses
  SysUtils, StrUtils,
  Token;

type
  ITokenFactory = interface
    ['{8B137879-9229-4FE7-B4B7-9E0ECCE6C19B}']
    function ParseText(const Text: string; const Separator: String = ','): ITokenList;
  end;

  TTokenFactory = class sealed(TInterfacedObject, ITokenFactory)
  private
    function FindToken(const Text: string; const InitialPos: integer; const Separator: String): IToken;
  public
    function ParseText(const Text: string; const Separator: String = ','): ITokenList;
    class function New: ITokenFactory;
  end;

implementation

function TTokenFactory.FindToken(const Text: string; const InitialPos: integer; const Separator: String): IToken;
var
  StartAt, EndAt: integer;
  ParsedValue: string;
begin
  Result := nil;
  StartAt := PosEx(TToken.TAG_START, Text, InitialPos);
  if (StartAt > 0) then
  begin
    EndAt := PosEx(TToken.TAG_END, Text, Succ(StartAt));
    if (EndAt > 0) then
    begin
      ParsedValue := Copy(Text, StartAt + TToken.TAG_DELIMITER_SIZE, EndAt - StartAt - TToken.TAG_DELIMITER_SIZE);
      Result := TToken.New(ParsedValue, StartAt, EndAt);
    end;
  end;
end;

function TTokenFactory.ParseText(const Text: string; const Separator: String): ITokenList;
var
  CurrentPosition: integer;
  Token: IToken;
begin
  Result := TTokenList.New;
  CurrentPosition := 1;
  repeat
    Token := FindToken(Text, CurrentPosition, Separator);
    if Assigned(Token) then
    begin
      Result.Add(Token);
      CurrentPosition := Token.EndAt + TToken.TAG_DELIMITER_SIZE;
    end;
  until not Assigned(Token);
end;

class function TTokenFactory.New: ITokenFactory;
begin
  Result := Create;
end;

end.
