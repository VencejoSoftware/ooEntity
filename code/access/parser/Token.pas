unit Token;

interface

uses
  SysUtils, StrUtils,
  IterableList;

type
  IToken = interface
    ['{C875E223-785B-42FF-A607-72A5543432DC}']
    function Name: String;
    function StartAt: Integer;
    function EndAt: Integer;
    function Parse(const Source, Value: String): String;
  end;

  TToken = class sealed(TInterfacedObject, IToken)
  const
    TAG_DELIMITER_SIZE = 2;
    TAG_START = '{{';
    TAG_END = '}}';
  strict private
    _Name: String;
    _StartAt, _EndAt: Integer;
  public
    function Name: String;
    function StartAt: Integer;
    function EndAt: Integer;
    function Parse(const Source, Value: String): String;
    constructor Create(const Name: String; const StartAt, EndAt: Integer);
    class function New(const Name: String; const StartAt, EndAt: Integer): IToken;
    class function TokenizeText(const Text: String): String;
    class function IsToken(const Text: String): Boolean;
  end;

  ITokenList = interface(IIterableList<IToken>)
    ['{DA13452B-8CFD-49E1-B922-BF93910A5000}']
    function ItemByName(const Name: String): IToken;
    function Parse(const Source, TokenName, Value: String): String;
  end;

  TTokenList = class sealed(TIterableList<IToken>, ITokenList)
  public
    function ItemByName(const Name: String): IToken;
    function Parse(const Source, TokenName, Value: String): String;
    class function New: ITokenList;
  end;

implementation

function TToken.Name: String;
begin
  Result := _Name;
end;

function TToken.StartAt: Integer;
begin
  Result := _StartAt;
end;

function TToken.EndAt: Integer;
begin
  Result := _EndAt;
end;

function TToken.Parse(const Source, Value: String): String;
begin
  Result := StringReplace(Source, TAG_START + _Name + TAG_END, Value, [rfReplaceAll, rfIgnoreCase]);
end;

constructor TToken.Create(const Name: String; const StartAt, EndAt: Integer);
begin
  _Name := Name;
  _StartAt := StartAt;
  _EndAt := EndAt;
end;

class function TToken.New(const Name: String; const StartAt, EndAt: Integer): IToken;
begin
  Result := Create(Name, StartAt, EndAt);
end;

class function TToken.TokenizeText(const Text: String): String;
begin
  Result := TAG_START + Text + TAG_END;
end;

class function TToken.IsToken(const Text: String): Boolean;
begin
  Result := (LeftStr(Text, Length(TAG_START)) = TAG_START) and (RightStr(Text, Length(TAG_END)) = TAG_END);
end;
{ TTokenList }

function TTokenList.ItemByName(const Name: String): IToken;
var
  Item: IToken;
begin
  Result := nil;
  for Item in Self do
    if SameText(Item.Name, Name) then
      Exit(Item);
end;

function TTokenList.Parse(const Source, TokenName, Value: String): String;
var
  Item: IToken;
begin
  Result := Source;
  Item := ItemByName(TokenName);
  if Assigned(Item) then
    Result := Item.Parse(Source, Value);
end;

class function TTokenList.New: ITokenList;
begin
  Result := Create;
end;

end.
