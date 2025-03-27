unit HashedToken;

interface

uses
  SysUtils,
  Token,
  KeyValue,
  IterableList;

type
  IHashedToken = interface(IToken)
    ['{DC6B2856-25C4-4EB8-8909-1EB0DDAC1222}']
    function Attributes: IKeyValueList;
  end;

  THashedToken = class sealed(TInterfacedObject, IHashedToken)
  const
    NAME_KEY = 'Name';
  strict private
    _Token: IToken;
    _Attributes: IKeyValueList;
  public
    function Name: String;
    function StartAt: Integer;
    function EndAt: Integer;
    function Parse(const Source, Value: String): String;
    function Attributes: IKeyValueList;
    constructor Create(const Token: IToken);
    class function New(const Token: IToken): IHashedToken;
  end;

  IHashedTokenList = interface(IIterableList<IHashedToken>)
    ['{37BB9918-C83B-4A2C-9083-26C5A25A827F}']
    function ItemByName(const Name: String): IHashedToken;
    function FilterByAttribute(const Attribute: IKeyValue): IHashedTokenList;
    function Parse(const Source, HashedTokenName, Value: String): String;
  end;

  THashedTokenList = class sealed(TIterableList<IHashedToken>, IHashedTokenList)
  public
    function ItemByName(const Name: String): IHashedToken;
    function FilterByAttribute(const Attribute: IKeyValue): IHashedTokenList;
    function Parse(const Source, HashedTokenName, Value: String): String;
    class function New: IHashedTokenList;
  end;

implementation

function THashedToken.Name: String;
var
  Attribute: IKeyValue;
begin
  Attribute := _Attributes.ItemByKey(NAME_KEY);
  if Assigned(Attribute) then
    Result := Attribute.Value
  else
    Result := _Token.Name;
end;

function THashedToken.StartAt: Integer;
begin
  Result := _Token.StartAt;
end;

function THashedToken.EndAt: Integer;
begin
  Result := _Token.EndAt;
end;

function THashedToken.Parse(const Source, Value: String): String;
begin
  Result := _Token.Parse(Source, Value);
end;

function THashedToken.Attributes: IKeyValueList;
begin
  Result := _Attributes;
end;

constructor THashedToken.Create(const Token: IToken);
begin
  _Attributes := TKeyValueList.New;
  _Token := Token;
end;

class function THashedToken.New(const Token: IToken): IHashedToken;
begin
  Result := THashedToken.Create(Token);
end;

{ THashedTokenList }

function THashedTokenList.ItemByName(const Name: String): IHashedToken;
var
  Item: IHashedToken;
begin
  Result := nil;
  for Item in Self do
    if SameText(Item.Name, Name) then
      Exit(Item);
end;

function THashedTokenList.Parse(const Source, HashedTokenName, Value: String): String;
var
  Item: IHashedToken;
begin
  Result := Source;
  Item := ItemByName(HashedTokenName);
  if Assigned(Item) then
    Result := Item.Parse(Source, Value);
end;

function THashedTokenList.FilterByAttribute(const Attribute: IKeyValue): IHashedTokenList;
var
  Item: IHashedToken;
begin
  Result := THashedTokenList.New;
  for Item in Self do
    if Item.Attributes.Exists(Attribute) then
      Result.Add(Item);
end;

class function THashedTokenList.New: IHashedTokenList;
begin
  Result := Create;
end;

end.
