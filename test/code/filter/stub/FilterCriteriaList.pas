{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit FilterCriteriaList;

interface

uses
  SysUtils,
  Key,
  SyntaxFormat, SyntaxFormatSymbol,
  FilterCriteria,
  FilterJoinAnd;

type
  TFilterCriteriaList = class sealed(TInterfacedObject, IFilterCriteria)
  private
    _Key: ITextKey;
    _Values: Array of string;
    _SyntaxFormat: ISyntaxFormat;
  public
    function Key: ITextKey;
    function Required: Boolean;
    function IsNull: Boolean;
    function Syntax: String;
    constructor Create(const SyntaxFormat: ISyntaxFormat; const Key: ITextKey; const Values: Array of string);
    class function New(const SyntaxFormat: ISyntaxFormat; const Key: ITextKey; const Values: Array of string)
      : IFilterCriteria;
  end;

implementation

function TFilterCriteriaList.Key: ITextKey;
begin
  Result := _Key;
end;

function TFilterCriteriaList.Required: Boolean;
begin
  Result := True;
end;

function TFilterCriteriaList.IsNull: Boolean;
begin
  Result := Pred(Length(_Values)) = - 1;
end;

function TFilterCriteriaList.Syntax: String;
begin
  Result := _SyntaxFormat.ItemsFormat([_Key.Value, 'IN', _SyntaxFormat.TextFormat(_SyntaxFormat.ItemsFormat(_Values,
    [Separated]), [Enclosed])], [Spaced]);
end;

constructor TFilterCriteriaList.Create(const SyntaxFormat: ISyntaxFormat; const Key: ITextKey;
  const Values: Array of string);
var
  i: Integer;
begin
  _SyntaxFormat := SyntaxFormat;
  _Key := Key;
  SetLength(_Values, Length(Values));
  for i := 0 to High(Values) do
    _Values[i] := Values[i];
end;

class function TFilterCriteriaList.New(const SyntaxFormat: ISyntaxFormat; const Key: ITextKey;
  const Values: Array of string): IFilterCriteria;
begin
  Result := TFilterCriteriaList.Create(SyntaxFormat, Key, Values);
end;

end.
