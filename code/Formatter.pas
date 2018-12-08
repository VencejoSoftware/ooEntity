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
unit Formatter;

interface

uses
  SysUtils,
  FormatterElements;

type
{$REGION 'documentation'}
{
  Enum for formatter symbol identifier
  @value NewLine Add a CRLF for each value
  @value DelimitedValue Delimted value
  @value Indented Add margin for each value
  @value Enclosed Enclose text between list delimiters
}
{$ENDREGION}
  TFormatterSettings = set of (NewLine, DelimitedValue, Indented, Enclosed);

{$REGION 'documentation'}
{
  @abstract(Formetter interface)
  Formatter use a SYMBOLS list to apply over text or array of texts
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

  IFormatter = interface
    ['{9DF47F30-302B-4565-9453-9CDAFF580719}']
    function Apply(const Text: String; const Settings: TFormatterSettings): String;
    function Concatenate(const Items: array of string; const SymbolID: TFormatterSymbolID = Space;
      const Settings: TFormatterSettings = []): String;
// function Concatenate(const ArrayText: array of string): String;
// function JoinItems(const Items: Array of string): String;
// function EncloseList(const Items: Array of string): String;
// function AddMargin(const Line: String): String;
// function Delimite(const Value: String): String;
// procedure ChangeSettings(const Settings: TFormatterSettings);
  end;

{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IFormatter))
  @member(Concatenate @SeeAlso(IFormatter.Concatenate))
  @member(JoinItems @SeeAlso(IFormatter.JoinItems))
  @member(EncloseList @SeeAlso(IFormatter.EncloseList))
  @member(AddMargin @SeeAlso(IFormatter.AddMargin))
  @member(Delimite @SeeAlso(IFormatter.Delimite))
  @member(ChangeSettings @SeeAlso(IFormatter.ChangeSettings))
  @member(
    Create Object constructor
    @param(Elements @link(IFormatterElements List of symbols to use))
  )
  @member(
    New Create a new @classname as interface
    @param(Elements @link(IFormatterElements List of symbols to use))
  )
}
{$ENDREGION}

  TFormatter = class sealed(TInterfacedObject, IFormatter)
  strict private
    _Elements: IFormatterElements;
  private
    function Delimite(const Value: String): String;
    function Indent(const Line: String): String;
    function Enclose(const Value: String): String;
// _Settings: TFormatterSettings;
// private
// function ApplySettings(const Text: String; const Settings: TFormatterSettings): String;
// function MergeItems(const Items: array of string; const SymbolID: TFormatterSymbolID;
// const Settings: TFormatterSettings): String;
// public
// function Concatenate(const ArrayText: Array of string): String;
// function JoinItems(const Items: Array of string): String;
// function EncloseList(const Items: Array of string): String;
// function AddMargin(const Line: String): String;
// function Delimite(const Value: String): String;
// procedure ChangeSettings(const Settings: TFormatterSettings);
  public
    function Apply(const Text: String; const Settings: TFormatterSettings): String;
    function Concatenate(const Items: array of string; const SymbolID: TFormatterSymbolID = Space;
      const Settings: TFormatterSettings = []): String;
    constructor Create(const Elements: IFormatterElements);
    class function New(const Elements: IFormatterElements): IFormatter;
  end;

implementation

// function TFormatter.MergeItems(const Items: array of string; const SymbolID: TFormatterSymbolID;
// const Settings: TFormatterSettings): String;
// var
// Item: String;
// begin
// Result := EmptyStr;
// for Item in Items do
// if Result = EmptyStr then
// Result := ApplySettings(Item, Settings)
// else
// Result := Result + _Elements.Symbol(SymbolID) + ApplySettings(Item, Settings);
// end;

// function TFormatter.Concatenate(const ArrayText: array of string): String;
// begin
// Result := MergeItems(ArrayText, Space, _Settings);
// end;

// function TFormatter.JoinItems(const Items: array of string): String;
// begin
// Result := MergeItems(Items, Separator, _Settings);
// end;

// function TFormatter.EncloseList(const Items: array of string): String;
// begin
// Result := JoinItems(Items);
// if Length(Result) > 0 then
// Result := ApplySettings(Result, _Settings + [Enclose] - [DelimitedValue]);
// end;


function TFormatter.Delimite(const Value: String): String;
begin
  Result := _Elements.Symbol(DelimiterStart) + Value + _Elements.Symbol(DelimiterFinish);
end;

function TFormatter.Indent(const Line: String): String;
begin
  Result := _Elements.Symbol(Margin) + Line;
end;

function TFormatter.Enclose(const Value: String): String;
begin
  Result := _Elements.Symbol(ListStart) + Value + _Elements.Symbol(ListFinish);
end;

function TFormatter.Apply(const Text: String; const Settings: TFormatterSettings): String;
begin
  Result := Text;
  if Length(Result) < 1 then
    Exit;
  if (DelimitedValue in Settings) then
    Result := Delimite(Result);
  if (Enclosed in Settings) then
    Result := Enclose(Result);
  if (Indented in Settings) then
    Result := Indent(Result);
  if (NewLine in Settings) then
    Result := sLineBreak + Result;
end;

function TFormatter.Concatenate(const Items: array of string; const SymbolID: TFormatterSymbolID;
  const Settings: TFormatterSettings): String;
begin

end;

constructor TFormatter.Create(const Elements: IFormatterElements);
begin
  _Elements := Elements;
// _Settings := [];
end;

class function TFormatter.New(const Elements: IFormatterElements): IFormatter;
begin
  Result := TFormatter.Create(Elements);
end;

end.
