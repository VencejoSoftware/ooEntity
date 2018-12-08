{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit FilterCriteriaBetween;

interface

uses
  SysUtils,
  Key,
  SyntaxFormat,
  FilterCriteria,
  FilterJoinAnd;

type
  TFilterCriteriaBetween = class sealed(TInterfacedObject, IFilterCriteria)
  private
    _Key: ITextKey;
    _Value1, _Value2: Cardinal;
    _SyntaxFormat: ISyntaxFormat;
  public
    function Key: ITextKey;
    function Required: Boolean;
    function IsNull: Boolean;
    function Syntax: String;
    constructor Create(const SyntaxFormat: ISyntaxFormat; const Key: ITextKey; const Value1, Value2: Cardinal);
    class function New(const SyntaxFormat: ISyntaxFormat; const Key: ITextKey; const Value1, Value2: Cardinal)
      : IFilterCriteria;
  end;

implementation

function TFilterCriteriaBetween.Key: ITextKey;
begin
  Result := _Key;
end;

function TFilterCriteriaBetween.Required: Boolean;
begin
  Result := True;
end;

function TFilterCriteriaBetween.IsNull: Boolean;
begin
  Result := (_Value1 > 0) and (_Value2 > 0);
end;

function TFilterCriteriaBetween.Syntax: String;
begin
  Result := _SyntaxFormat.ItemsFormat([_Key.Value, 'BETWEEN', IntToStr(_Value1), TFilterJoinAnd.New.Syntax,
    IntToStr(_Value2)], [Spaced]);
end;

constructor TFilterCriteriaBetween.Create(const SyntaxFormat: ISyntaxFormat; const Key: ITextKey;
  const Value1, Value2: Cardinal);
begin
  _SyntaxFormat := SyntaxFormat;
  _Key := Key;
  _Value1 := Value1;
  _Value2 := Value2;
end;

class function TFilterCriteriaBetween.New(const SyntaxFormat: ISyntaxFormat; const Key: ITextKey;
  const Value1, Value2: Cardinal): IFilterCriteria;
begin
  Result := TFilterCriteriaBetween.Create(SyntaxFormat, Key, Value1, Value2);
end;

end.
