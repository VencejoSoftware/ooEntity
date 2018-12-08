{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit SortOrderAscending;

interface

uses
  SyntaxFormat,
  Key,
  SortOrder;

type
  TSortOrderAscending = class sealed(TInterfacedObject, ISortOrder)
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

function TSortOrderAscending.Direction: TSortDirection;
begin
  Result := Ascending;
end;

function TSortOrderAscending.Key: ITextKey;
begin
  Result := _Key;
end;

function TSortOrderAscending.Syntax: String;
begin
  Result := _SyntaxFormat.ItemsFormat([_Key.Value, 'ASCENDING'], [Spaced]);
end;

constructor TSortOrderAscending.Create(const Key: ITextKey; const SyntaxFormat: ISyntaxFormat);
begin
  _Key := Key;
  _SyntaxFormat := SyntaxFormat;
end;

class function TSortOrderAscending.New(const Key: ITextKey; const SyntaxFormat: ISyntaxFormat): ISortOrder;
begin
  Result := TSortOrderAscending.Create(Key, SyntaxFormat);
end;

end.
