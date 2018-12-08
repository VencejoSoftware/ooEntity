{$REGION 'documentation'}
{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Object to define a parseable sort order list
  @created(29/05/2018)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit SortOrderList;

interface

uses
  SysUtils,
  SyntaxFormat, SyntaxFormatSymbol,
  IterableList,
  SortOrder;

type
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IIterableList))
  List of parseable sort order objects
  @member(
    Syntax Parse object to a syntax text
    @return(String with syntax)
  )
}
{$ENDREGION}
  ISortOrderList = interface(IIterableList<ISortOrder>)
    ['{97806885-D80F-455F-B63C-4443FC169523}']
    function Syntax: String;
  end;

{$REGION 'documentation'}
{
  @abstract(Implementation of @link(ISortOrderList))
  @member(Parse @SeeAlso(ISortOrderList.Parse))
  @member(
    Create Object constructor
    @param(SyntaxFormat @link(ISyntaxFormat syntax SyntaxFormat))
  )
  @member(
    New Create a new @classname as interface
    @param(SyntaxFormat @link(ISyntaxFormat syntax SyntaxFormat))
  )
}
{$ENDREGION}

  TSortOrderList = class sealed(TIterableList<ISortOrder>, ISortOrderList)
  strict private
    _SyntaxFormat: ISyntaxFormat;
  public
    function Syntax: String;
    constructor Create(const SyntaxFormat: ISyntaxFormat); reintroduce;
    class function New(const SyntaxFormat: ISyntaxFormat): ISortOrderList;
  end;

implementation

function TSortOrderList.Syntax: String;
var
  SyntaxList: array of string;
  i: Integer;
begin
  Result := EmptyStr;
  SetLength(SyntaxList, Count);
  for i := 0 to Pred(Count) do
    SyntaxList[i] := Items[i].Syntax;
  Result := _SyntaxFormat.ItemsFormat(SyntaxList, [Spaced, Separated]);
end;

constructor TSortOrderList.Create(const SyntaxFormat: ISyntaxFormat);
begin
  inherited Create;
  _SyntaxFormat := SyntaxFormat;
end;

class function TSortOrderList.New(const SyntaxFormat: ISyntaxFormat): ISortOrderList;
begin
  Result := TSortOrderList.Create(SyntaxFormat);
end;

end.
