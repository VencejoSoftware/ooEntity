{$REGION 'documentation'}
{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Object to format text
  @created(29/05/2018)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit SyntaxFormat;

interface

uses
  SysUtils,
  SyntaxFormatSymbol;

type
{$REGION 'documentation'}
  {
    Enum for syntax format settings
    @value NewLine Add a CRLF for each value
    @value DelimitedValue Delimted value
    @value Indented Add margin for each value
    @value Enclosed Enclose text between list delimiters
  }
{$ENDREGION}
  TSyntaxFormatSettings = set of (Spaced, Separated, Wordwrapped, Delimited, Indented, Enclosed);

{$REGION 'documentation'}
  {
    @abstract(Formetter interface)
    Syntax format use a symbol list to apply over text or array of texts
    @member(
    Concatenate Concatenates each iten array with a SPACE symbol between them
    @param(ArrayText Array of texts)
    @return(Plain text with all items with SPACES)
    )
    @member(
    JoinItems Join an array of text using a SEPARATOR between items
    @param(Items Array of texts)
    @return(Plain text with all items with SEPARATORS)
    )
    @member(
    EncloseList Join an array of text using a SEPARATOR between items and enclose with list delimiter symbols
    @param(Items Array of texts)
    @return(Plain text with all items with SEPARATORS)
    )
    @member(
    AddMargin Add MARGIN symbol to left side of text
    @param(Line Line text to concatenate with margin)
    @return(Margin with text line)
    )
    @member(
    Delimite Delimite a text value with DELIMITERS symbols
    @param(Value Text to delimite)
    @return(Delimited string)
    )
    @member(
    ChangeSettings Change current parser settings
    @param(Settings Setting to apply)
    )
  }
{$ENDREGION}

  ISyntaxFormat = interface
    ['{9DF47F30-302B-4565-9453-9CDAFF580719}']
    function TextFormat(const Text: String; const Settings: TSyntaxFormatSettings): String;
    function ItemsFormat(const Items: array of string; const Settings: TSyntaxFormatSettings = []): String;
  end;

{$REGION 'documentation'}
  {
    @abstract(Implementation of @link(ISyntaxFormat))
    @member(ItemsFormat @SeeAlso(ISyntaxFormat.ItemsFormat))
    @member(JoinItems @SeeAlso(ISyntaxFormat.JoinItems))
    @member(EncloseList @SeeAlso(ISyntaxFormat.EncloseList))
    @member(AddMargin @SeeAlso(ISyntaxFormat.AddMargin))
    @member(Delimite @SeeAlso(ISyntaxFormat.Delimite))
    @member(ChangeSettings @SeeAlso(ISyntaxFormat.ChangeSettings))
    @member(
    Create Object constructor
    @param(Elements @link(ISyntaxFormatElements List of symbols to use))
    )
    @member(
    New Create a new @classname as interface
    @param(Elements @link(ISyntaxFormatElements List of symbols to use))
    )
  }
{$ENDREGION}

  TSyntaxFormat = class sealed(TInterfacedObject, ISyntaxFormat)
  strict private
    _SymbolList: ISyntaxFormatSymbolList;
  private
    function Delimite(const Value: String): String;
    function Indent(const Line: String): String;
    function Enclose(const Value: String): String;
    function WordWrap(const Value: String): String;
    function Space(const Value: String): String;
    function Separate(const Value: String): String;
  public
    function TextFormat(const Text: String; const Settings: TSyntaxFormatSettings): String;
    function ItemsFormat(const Items: array of string; const Settings: TSyntaxFormatSettings = []): String;
    constructor Create(const SymbolList: ISyntaxFormatSymbolList);
    class function New(const SymbolList: ISyntaxFormatSymbolList): ISyntaxFormat;
  end;

implementation

function TSyntaxFormat.Delimite(const Value: String): String;
begin
  Result := _SymbolList.Symbol(DelimiterStarter) + Value + _SymbolList.Symbol(DelimiterFinisher);
end;

function TSyntaxFormat.Indent(const Line: String): String;
begin
  Result := _SymbolList.Symbol(Indentator) + Line;
end;

function TSyntaxFormat.Enclose(const Value: String): String;
begin
  Result := _SymbolList.Symbol(ListStarter) + Value + _SymbolList.Symbol(ListFinisher);
end;

function TSyntaxFormat.WordWrap(const Value: String): String;
begin
  Result := _SymbolList.Symbol(WordWrapper) + Value;
end;

function TSyntaxFormat.Space(const Value: String): String;
begin
  Result := Value + _SymbolList.Symbol(Spacer);
end;

function TSyntaxFormat.Separate(const Value: String): String;
begin
  Result := Value + _SymbolList.Symbol(Separator);
end;

function TSyntaxFormat.TextFormat(const Text: String; const Settings: TSyntaxFormatSettings): String;
begin
  Result := Text;
  if Length(Result) < 1 then
    Exit;
  if (Delimited in Settings) then
    Result := Delimite(Result);
  if (Enclosed in Settings) then
    Result := Enclose(Result);
  if (Separated in Settings) then
    Result := Separate(Result);
  if (Spaced in Settings) then
    Result := Space(Result);
  if (Indented in Settings) then
    Result := Indent(Result);
  if (Wordwrapped in Settings) then
    Result := WordWrap(Result);
end;

function TSyntaxFormat.ItemsFormat(const Items: array of string; const Settings: TSyntaxFormatSettings = []): String;
var
  i: Integer;
begin
  Result := EmptyStr;
  for i := 0 to High(Items) do
    Result := Result + TextFormat(TrimRight(Items[i]), Settings);
  if (Separated in Settings) then
    Result := Copy(Result, 1, Length(Result) - Length(_SymbolList.Symbol(Separator)));
  if (Spaced in Settings) then
    Result := Copy(Result, 1, Length(Result) - Length(_SymbolList.Symbol(Spacer)));
end;

constructor TSyntaxFormat.Create(const SymbolList: ISyntaxFormatSymbolList);
begin
  _SymbolList := SymbolList;
end;

class function TSyntaxFormat.New(const SymbolList: ISyntaxFormatSymbolList): ISyntaxFormat;
begin
  Result := TSyntaxFormat.Create(SymbolList);
end;

end.
