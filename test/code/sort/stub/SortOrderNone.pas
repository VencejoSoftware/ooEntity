{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit SortOrderNone;

interface

uses
  SysUtils,
  Key,
  SortOrder;

type
  TSortOrderNone = class sealed(TInterfacedObject, ISortOrder)
  public
    function Key: ITextKey;
    function Direction: TSortDirection;
    function Syntax: String;
    class function New: ISortOrder;
  end;

implementation

function TSortOrderNone.Direction: TSortDirection;
begin
  Result := None;
end;

function TSortOrderNone.Key: ITextKey;
begin
  Result := nil;
end;

function TSortOrderNone.Syntax: String;
begin
  Result := EmptyStr;
end;

class function TSortOrderNone.New: ISortOrder;
begin
  Result := TSortOrderNone.Create;
end;

end.
