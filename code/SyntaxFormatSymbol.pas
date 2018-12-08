{$REGION 'documentation'}
{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Object to define syntax format symbols
  @created(29/05/2018)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit SyntaxFormatSymbol;

interface

uses
  SysUtils,
  TypInfo,
  IterableList;

type
{$REGION 'documentation'}
{
  Class for syntax format symbol error object
}
{$ENDREGION}
  ESyntaxFormatSymbol = class(Exception)
  end;
{$REGION 'documentation'}
{
  Enum for syntax format symbol code
  @value None empty char representation
  @value Separator List/set separator representation
  @value DelimiterStart Value start delimiter representation
  @value DelimiterFinish Value finish delimiter representation
  @value Margin Left margin representation
  @value Space Space representation
  @value ListStart List start representation
  @value ListFinish List finish representation
}
{$ENDREGION}

  TSyntaxFormatSymbolCode = (None, Separator, DelimiterStarter, DelimiterFinisher, Indentator, Spacer, ListStarter,
    ListFinisher, WordWrapper);

{$REGION 'documentation'}
{
  @abstract(Syntax format symbol interface)
  @member(Code Symbol item code)
  @member(Value Representation value)
}
{$ENDREGION}

  ISyntaxFormatSymbol = interface
    ['{FBBD7114-E32C-4D10-8A5A-6D2D21BED63B}']
    function Code: TSyntaxFormatSymbolCode;
    function Value: String;
  end;

{$REGION 'documentation'}
{
  @abstract(Implementation of @link(ISyntaxFormatSymbol))
  @member(Code @SeeAlso(ISyntaxFormatSymbol.Code))
  @member(Value @SeeAlso(ISyntaxFormatSymbol.Value))
  @member(
    Create Object constructor
    @param(Code Symbol item code)
    @param(Value Representation value)
  )
  @member(
    New Create a new @classname as interface
    @param(Code Symbol item code)
    @param(Value Representation value)
  )
}
{$ENDREGION}

  TSyntaxFormatSymbol = class sealed(TInterfacedObject, ISyntaxFormatSymbol)
  strict private
    _Code: TSyntaxFormatSymbolCode;
    _Value: String;
  public
    function Code: TSyntaxFormatSymbolCode;
    function Value: String;
    constructor Create(const Code: TSyntaxFormatSymbolCode; const Value: String);
    class function New(const Code: TSyntaxFormatSymbolCode; const Value: String): ISyntaxFormatSymbol;
  end;

{$REGION 'documentation'}
{
  @abstract(Syntax format symbol interface)
  @member(
    Symbol Get symbol by his identifier
    @param(Code Symbol code)
    @return(String with symbol value)
  )
  @member(
    Add Add a unique symbol in list
    @param(Symbol Syntax symbol)
  )
}
{$ENDREGION}

  ISyntaxFormatSymbolList = interface
    ['{A7C6BCC9-8709-432C-84F5-1D79B083159E}']
    function Symbol(const Code: TSyntaxFormatSymbolCode): String;
    procedure Add(const Symbol: ISyntaxFormatSymbol);
  end;

{$REGION 'documentation'}
{
  @abstract(Implementation of @link(ISyntaxFormatSymbolList))
  @member(Symbol @SeeAlso(ISyntaxFormatSymbolList.Symbol))
  @member(Add @SeeAlso(ISyntaxFormatSymbolList.Add))
  @member(
    SymbolByCode Get symbol by his code
    @param(Code Symbol code)
    @return(A Syntax symbol)
  )
  @member(
    CodeToText Use RTTI to convert code enumeration to string
    @param(Code Symbol code)
    @return(String with text representation)
  )
  @member(Create Object constructor)
  @member(New Create a new @classname as interface)
}
{$ENDREGION}

  TSyntaxFormatSymbolList = class sealed(TInterfacedObject, ISyntaxFormatSymbolList)
  strict private
    _List: IIterableList<ISyntaxFormatSymbol>;
  private
    function SymbolByCode(const Code: TSyntaxFormatSymbolCode): ISyntaxFormatSymbol;
    function CodeToText(const Code: TSyntaxFormatSymbolCode): String;
  public
    function Symbol(const Code: TSyntaxFormatSymbolCode): String;
    procedure Add(const Symbol: ISyntaxFormatSymbol);
    constructor Create;
    class function New: ISyntaxFormatSymbolList;
  end;

implementation

function TSyntaxFormatSymbol.Code: TSyntaxFormatSymbolCode;
begin
  Result := _Code;
end;

function TSyntaxFormatSymbol.Value: String;
begin
  Result := _Value;
end;

constructor TSyntaxFormatSymbol.Create(const Code: TSyntaxFormatSymbolCode; const Value: String);
begin
  _Code := Code;
  _Value := Value;
end;

class function TSyntaxFormatSymbol.New(const Code: TSyntaxFormatSymbolCode; const Value: String): ISyntaxFormatSymbol;
begin
  Result := TSyntaxFormatSymbol.Create(Code, Value);
end;

{ TSyntaxFormatSymbolList }

function TSyntaxFormatSymbolList.CodeToText(const Code: TSyntaxFormatSymbolCode): String;
begin
  Result := GetEnumName(TypeInfo(TSyntaxFormatSymbolCode), Ord(Code));
end;

function TSyntaxFormatSymbolList.SymbolByCode(const Code: TSyntaxFormatSymbolCode): ISyntaxFormatSymbol;
var
  Symbol: ISyntaxFormatSymbol;
begin
  Result := nil;
  for Symbol in _List do
    if (Symbol.Code = Code) then
      Exit(Symbol);
end;

procedure TSyntaxFormatSymbolList.Add(const Symbol: ISyntaxFormatSymbol);
begin
  if Assigned(SymbolByCode(Symbol.Code)) then
    raise ESyntaxFormatSymbol.Create(Format('Symbol "%s" is duplicated', [CodeToText(Symbol.Code)]));
  _List.Add(Symbol)
end;

function TSyntaxFormatSymbolList.Symbol(const Code: TSyntaxFormatSymbolCode): String;
var
  Symbol: ISyntaxFormatSymbol;
begin
  Symbol := SymbolByCode(Code);
  if not Assigned(Symbol) then
    raise ESyntaxFormatSymbol.Create(Format('Symbol "%s" not founded', [CodeToText(Code)]));
  Result := Symbol.Value;
end;

constructor TSyntaxFormatSymbolList.Create;
begin
  _List := TIterableList<ISyntaxFormatSymbol>.New;
end;

class function TSyntaxFormatSymbolList.New: ISyntaxFormatSymbolList;
begin
  Result := TSyntaxFormatSymbolList.Create;
end;

end.
