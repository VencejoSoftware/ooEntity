{$REGION 'documentation'}
{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Object to define a filter join/logical operator
  @created(29/05/2018)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit FilterJoin;

interface

uses
  SysUtils,
  IterableList,
  SyntaxFormat,
  Statement;

type
{$REGION 'documentation'}
  {
    @abstract(Filter join interface)
  }
{$ENDREGION}
  IFilterJoin = interface(IStatement)
    ['{BD0D7411-78EF-44AC-AFAC-64B9D7948293}']
  end;

{$REGION 'documentation'}
  {
    @abstract(Implementation of @link(IFilterJoin))
    Filter join without representation
    @member(
    Syntax @SeeAlso(IStatement.Syntax)
    @return(Empty string)
    )
    @member(Create Object constructor)
    @member(New Create a new @classname as interface)
  }
{$ENDREGION}

  TFilterJoinNone = class sealed(TInterfacedObject, IFilterJoin)
  public
    function Syntax: String;
    class function New: IFilterJoin;
  end;

{$REGION 'documentation'}
  {
    @abstract(Implementation of @link(IFilterJoin))
    A filter join wich contatenate a list of join objects
    @member(
    Syntax @SeeAlso(IStatement.Syntax)
    @return(Text with syntaxis of all join items)
    )
    @member(
    Create Object constructor
    @param(SyntaxFormat @link(ISyntaxFormat syntax SyntaxFormat))
    @param(Joins Array of join objects to concatenate)
    )
    @member(
    New Create a new @classname as interface
    @param(Joins Array of join objects to concatenate)
    )
  }
{$ENDREGION}

  TFilterJoinConcatenate = class sealed(TInterfacedObject, IFilterJoin)
  strict private
    _List: IIterableList<IFilterJoin>;
    _SyntaxFormat: ISyntaxFormat;
  public
    function Syntax: String;
    constructor Create(const SyntaxFormat: ISyntaxFormat; const Joins: array of IFilterJoin);
    class function New(const SyntaxFormat: ISyntaxFormat; const Joins: array of IFilterJoin): IFilterJoin;
  end;

implementation

{ TFilterJoinNone }

function TFilterJoinNone.Syntax: String;
begin
  Result := EmptyStr;
end;

class function TFilterJoinNone.New: IFilterJoin;
begin
  Result := TFilterJoinNone.Create;
end;

{ TFilterJoinConcatenate }

function TFilterJoinConcatenate.Syntax: String;
var
  SyntaxList: array of string;
  i: Integer;
begin
  Result := EmptyStr;
  SetLength(SyntaxList, _List.Count);
  for i := 0 to Pred(_List.Count) do
    SyntaxList[i] := _List.Items[i].Syntax;
  Result := _SyntaxFormat.ItemsFormat(SyntaxList, [Spaced]);
end;

constructor TFilterJoinConcatenate.Create(const SyntaxFormat: ISyntaxFormat; const Joins: array of IFilterJoin);
begin
  _List := TIterableList<IFilterJoin>.New;
  _List.FromArray(Joins);
  _SyntaxFormat := SyntaxFormat;
end;

class function TFilterJoinConcatenate.New(const SyntaxFormat: ISyntaxFormat; const Joins: array of IFilterJoin)
  : IFilterJoin;
begin
  Result := TFilterJoinConcatenate.Create(SyntaxFormat, Joins);
end;

end.
