{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit FilterCriteria;

interface

uses
  SysUtils,
  Key,
  SyntaxFormat,
  Statement,
  IterableList;

type
  IFilterCriteria = interface(IStatement)
    ['{50A8C014-1724-4A7C-84E5-4C050F8C9FA8}']
    function Key: ITextKey;
    function Required: Boolean;
    function IsNull: Boolean;
  end;

  IFilterCriteriaList = interface(IIterableList<IFilterCriteria>)
    ['{3E477DE4-1BC6-46A0-84BA-797EC17DEC21}']
    function Syntax: String;
  end;

  TFilterCriteriaList = class sealed(TIterableList<IFilterCriteria>, IFilterCriteriaList)
  strict private
    _SyntaxFormat: ISyntaxFormat;
  public
    function Syntax: String;
    constructor Create(const SyntaxFormat: ISyntaxFormat); reintroduce;
    class function New(const SyntaxFormat: ISyntaxFormat): IFilterCriteriaList;
  end;

implementation

function TFilterCriteriaList.Syntax: String;
var
  SyntaxList: array of string;
  i: Integer;
begin
  Result := EmptyStr;
  SetLength(SyntaxList, Count);
  for i := 0 to Pred(Count) do
    SyntaxList[i] := Items[i].Syntax;
  Result := _SyntaxFormat.TextFormat(_SyntaxFormat.ItemsFormat(SyntaxList, [Separated, Spaced]), [Enclosed]);
end;

constructor TFilterCriteriaList.Create(const SyntaxFormat: ISyntaxFormat);
begin
  inherited Create;
  _SyntaxFormat := SyntaxFormat;
end;

class function TFilterCriteriaList.New(const SyntaxFormat: ISyntaxFormat): IFilterCriteriaList;
begin
  Result := TFilterCriteriaList.Create(SyntaxFormat);
end;

end.
