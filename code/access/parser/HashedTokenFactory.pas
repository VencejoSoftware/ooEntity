unit HashedTokenFactory;

interface

uses
  SysUtils, StrUtils,
  KeyValue,
  Token, HashedToken;

type
  IHashedTokenFactory = interface
    ['{1067DC07-FD52-4B96-84AC-2EB45F8B63E2}']
    function ParseText(const Text: string; const Separator: String = ','): IHashedTokenList;
  end;

  THashedTokenFactory = class sealed(TInterfacedObject, IHashedTokenFactory)
  private
    function FindHashedToken(const Text: string; const InitialPos: integer; const Separator: String): IHashedToken;
  public
    function ParseText(const Text: string; const Separator: String = ','): IHashedTokenList;
    class function New: IHashedTokenFactory;
  end;

implementation

function THashedTokenFactory.FindHashedToken(const Text: string; const InitialPos: integer;
  const Separator: String): IHashedToken;
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
      Result := THashedToken.New(TToken.New(ParsedValue, StartAt, EndAt));
      if Pos(Separator, ParsedValue) > 0 then
        Result.Attributes.LoadFromString(ParsedValue, Separator);
    end;
  end;
end;

function THashedTokenFactory.ParseText(const Text: string; const Separator: String): IHashedTokenList;
var
  CurrentPosition: integer;
  HashedToken: IHashedToken;
begin
  Result := THashedTokenList.New;
  CurrentPosition := 1;
  repeat
    HashedToken := FindHashedToken(Text, CurrentPosition, Separator);
    if Assigned(HashedToken) then
    begin
      Result.Add(HashedToken);
      CurrentPosition := HashedToken.EndAt + TToken.TAG_DELIMITER_SIZE;
    end;
  until not Assigned(HashedToken);
end;

class function THashedTokenFactory.New: IHashedTokenFactory;
begin
  Result := THashedTokenFactory.Create;
end;

end.

