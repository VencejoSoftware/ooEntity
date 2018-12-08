{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit FilterCriteriaEqual;

interface

uses
  SysUtils,
  Key,
  SyntaxFormat,
  FilterCriteria;

type
  TFilterCriteriaEqual = class sealed(TInterfacedObject, IFilterCriteria)
  private
    _Key: ITextKey;
    _Value: String;
    _SyntaxFormat: ISyntaxFormat;
  public
    function Key: ITextKey;
    function Required: Boolean;
    function IsNull: Boolean;
    function Syntax: String;
    constructor Create(const SyntaxFormat: ISyntaxFormat; const Key: ITextKey; const Value: String);
    class function New(const SyntaxFormat: ISyntaxFormat; const Key: ITextKey; const Value: String): IFilterCriteria;
  end;

implementation

function TFilterCriteriaEqual.Key: ITextKey;
begin
  Result := _Key;
end;

function TFilterCriteriaEqual.Required: Boolean;
begin
  Result := True;
end;

function TFilterCriteriaEqual.IsNull: Boolean;
begin
  Result := Length(_Value) < 1;
end;

function TFilterCriteriaEqual.Syntax: String;
begin
  Result := _SyntaxFormat.ItemsFormat([_Key.Value, '=', _Value], [Spaced]);
end;

constructor TFilterCriteriaEqual.Create(const SyntaxFormat: ISyntaxFormat; const Key: ITextKey; const Value: String);
begin
  _SyntaxFormat := SyntaxFormat;
  _Key := Key;
  _Value := Value;
end;

class function TFilterCriteriaEqual.New(const SyntaxFormat: ISyntaxFormat; const Key: ITextKey; const Value: String)
  : IFilterCriteria;
begin
  Result := TFilterCriteriaEqual.Create(SyntaxFormat, Key, Value);
end;

end.
