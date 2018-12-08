{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit FilterCriteriaNull;

interface

uses
  SysUtils,
  Key,
  SyntaxFormat,
  FilterCriteria;

type
  TFilterCriteriaNull = class sealed(TInterfacedObject, IFilterCriteria)
  private
    _Key: ITextKey;
    _SyntaxFormat: ISyntaxFormat;
  public
    function Key: ITextKey;
    function Required: Boolean;
    function IsNull: Boolean;
    function Syntax: String;
    constructor Create(const SyntaxFormat: ISyntaxFormat; const Key: ITextKey);
    class function New(const SyntaxFormat: ISyntaxFormat; const Key: ITextKey): IFilterCriteria;
  end;

implementation

function TFilterCriteriaNull.Key: ITextKey;
begin
  Result := _Key;
end;

function TFilterCriteriaNull.Required: Boolean;
begin
  Result := True;
end;

function TFilterCriteriaNull.IsNull: Boolean;
begin
  Result := False;
end;

function TFilterCriteriaNull.Syntax: String;
begin
  Result := _SyntaxFormat.ItemsFormat([_Key.Value, 'IS NIL'], [Spaced]);
end;

constructor TFilterCriteriaNull.Create(const SyntaxFormat: ISyntaxFormat; const Key: ITextKey);
begin
  _SyntaxFormat := SyntaxFormat;
  _Key := Key;
end;

class function TFilterCriteriaNull.New(const SyntaxFormat: ISyntaxFormat; const Key: ITextKey): IFilterCriteria;
begin
  Result := TFilterCriteriaNull.Create(SyntaxFormat, Key);
end;

end.
