{$REGION 'documentation'}
{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Object to define formatter element
  @created(29/05/2018)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit FormatterElements;

interface

uses
  SysUtils,
  TypInfo,
  IterableList;

type
{$REGION 'documentation'}
{
  Class for formatter symbol error object
}
{$ENDREGION}
  EFormatterSymbol = class(Exception)
  end;
{$REGION 'documentation'}
{
  Enum for formatter symbol identifier
  @value Separator List/set separator representation
  @value DelimiterStart Value start delimiter representation
  @value DelimiterFinish Value finish delimiter representation
  @value Margin Left margin representation
  @value Space Space representation
  @value ListStart List start representation
  @value ListFinish List finish representation
}
{$ENDREGION}

  TFormatterSymbolID = (Separator, DelimiterStart, DelimiterFinish, Margin, Space, ListStart, ListFinish);

{$REGION 'documentation'}
{
  @abstract(Formatter symbol interface)
  @member(ID Elemenet identifier)
  @member(Value Representation value)
}
{$ENDREGION}

  IFormatterSymbol = interface
    ['{FBBD7114-E32C-4D10-8A5A-6D2D21BED63B}']
    function ID: TFormatterSymbolID;
    function Value: String;
  end;

{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IFormatterSymbol))
  @member(ID @SeeAlso(IFormatterSymbol.ID))
  @member(Value @SeeAlso(IFormatterSymbol.Value))
  @member(
    Create Object constructor
    @param(ID Elemenet identifier)
    @param(Value Representation value)
  )
  @member(
    New Create a new @classname as interface
    @param(ID Elemenet identifier)
    @param(Value Representation value)
  )
}
{$ENDREGION}

  TFormatterSymbol = class sealed(TInterfacedObject, IFormatterSymbol)
  strict private
    _ID: TFormatterSymbolID;
    _Value: String;
  public
    function ID: TFormatterSymbolID;
    function Value: String;
    constructor Create(const ID: TFormatterSymbolID; const Value: String);
    class function New(const ID: TFormatterSymbolID; const Value: String): IFormatterSymbol;
  end;

{$REGION 'documentation'}
{
  @abstract(Formatter symbol interface))
  @member(
    Symbol Get symbol by his identifier
    @param(ID Symbol identifier)
    @return(String with symbol value)
  )
  @member(
    Add Add a unique symbol in list
    @param(Symbol Formatter symbol)
  )
}
{$ENDREGION}

  IFormatterElements = interface
    ['{A7C6BCC9-8709-432C-84F5-1D79B083159E}']
    function Symbol(const ID: TFormatterSymbolID): String;
    procedure Add(const Symbol: IFormatterSymbol);
  end;

{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IFormatterElements))
  @member(Symbol @SeeAlso(IFormatterElements.Symbol))
  @member(Add @SeeAlso(IFormatterElements.Add))
  @member(
    SymbolByID Get symbol by his identifier
    @param(ID Symbol identifier)
    @return(A formatter Symbol)
  )
  @member(
    IDToText Use RTTI to cast ID enum to string
    @param(ID Symbol identifier)
    @return(String with text representation)
  )
  @member(Create Object constructor)
  @member(New Create a new @classname as interface)
}
{$ENDREGION}

  TFormatterElements = class sealed(TInterfacedObject, IFormatterElements)
  strict private
    _List: IIterableList<IFormatterSymbol>;
  private
    function SymbolByID(const ID: TFormatterSymbolID): IFormatterSymbol;
    function IDToText(const ID: TFormatterSymbolID): String;
  public
    function Symbol(const ID: TFormatterSymbolID): String;
    procedure Add(const Symbol: IFormatterSymbol);
    constructor Create;
    class function New: IFormatterElements;
  end;

implementation

function TFormatterSymbol.ID: TFormatterSymbolID;
begin
  Result := _ID;
end;

function TFormatterSymbol.Value: String;
begin
  Result := _Value;
end;

constructor TFormatterSymbol.Create(const ID: TFormatterSymbolID; const Value: String);
begin
  _ID := ID;
  _Value := Value;
end;

class function TFormatterSymbol.New(const ID: TFormatterSymbolID; const Value: String): IFormatterSymbol;
begin
  Result := TFormatterSymbol.Create(ID, Value);
end;

{ TFormatterElements }

function TFormatterElements.IDToText(const ID: TFormatterSymbolID): String;
begin
  Result := GetEnumName(TypeInfo(TFormatterSymbolID), Ord(ID));
end;

function TFormatterElements.SymbolByID(const ID: TFormatterSymbolID): IFormatterSymbol;
var
  Symbol: IFormatterSymbol;
begin
  Result := nil;
  for Symbol in _List do
    if (Symbol.ID = ID) then
      Exit(Symbol);
end;

procedure TFormatterElements.Add(const Symbol: IFormatterSymbol);
begin
  if Assigned(SymbolByID(Symbol.ID)) then
    raise EFormatterSymbol.Create(Format('Symbol "%s" is duplicated', [IDToText(Symbol.ID)]));
  _List.Add(Symbol)
end;

function TFormatterElements.Symbol(const ID: TFormatterSymbolID): String;
var
  Symbol: IFormatterSymbol;
begin
  Symbol := SymbolByID(ID);
  if not Assigned(Symbol) then
    raise EFormatterSymbol.Create(Format('Symbol "%s" not founded', [IDToText(ID)]));
  Result := Symbol.Value;
end;

constructor TFormatterElements.Create;
begin
  _List := TIterableList<IFormatterSymbol>.New;
end;

class function TFormatterElements.New: IFormatterElements;
begin
  Result := TFormatterElements.Create;
end;

end.
