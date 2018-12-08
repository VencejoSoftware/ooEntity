{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit SortOrderDescending;

interface

uses
  SyntaxFormat,
  Key,
  SortOrder;

type
  TSortOrderDescending = class sealed(TInterfacedObject, ISortOrder)
  strict private
    _Key: ITextKey;
    _SyntaxFormat: ISyntaxFormat;
  public
    function Key: ITextKey;
    function Direction: TSortDirection;
    function Syntax: String;
    constructor Create(const Key: ITextKey; const SyntaxFormat: ISyntaxFormat);
    class function New(const Key: ITextKey; const SyntaxFormat: ISyntaxFormat): ISortOrder;
  end;

implementation

function TSortOrderDescending.Direction: TSortDirection;
begin
  Result := Ascending;
end;

function TSortOrderDescending.Key: ITextKey;
begin
  Result := _Key;
end;

function TSortOrderDescending.Syntax: String;
begin
  Result := _SyntaxFormat.ItemsFormat([_Key.Value, 'DESCENDING'], [Spaced]);
end;

constructor TSortOrderDescending.Create(const Key: ITextKey; const SyntaxFormat: ISyntaxFormat);
begin
  _Key := Key;
  _SyntaxFormat := SyntaxFormat;
end;

class function TSortOrderDescending.New(const Key: ITextKey; const SyntaxFormat: ISyntaxFormat): ISortOrder;
begin
  Result := TSortOrderDescending.Create(Key, SyntaxFormat);
end;

end.
