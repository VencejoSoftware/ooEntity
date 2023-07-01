unit CalculatedDataField;

interface

uses
  SysUtils,
  Field,
  DataField;

type
  ICalculatedDataField = interface(IDataField)
    ['{6CB1CEF4-25A8-4332-8449-780B2F0EBEA4}']
    function Code: String;
  end;

  TCalculatedDataField = class sealed(TInterfacedObject, IDataField, ICalculatedDataField)
  strict private
    _Code: String;
  public
    function Name: String;
    function Kind: TDataFieldKind;
    function Constraints: TDataFieldConstraintSet;
    function IsRequired: Boolean;
    function Code: String;
    constructor Create(const Code: String);
    class function New(const Code: String): ICalculatedDataField;
  end;

implementation

function TCalculatedDataField.Name: String;
begin
  Result := EmptyStr;
end;

function TCalculatedDataField.Kind: TDataFieldKind;
begin
  Result := Unknown
end;

function TCalculatedDataField.Constraints: TDataFieldConstraintSet;
begin
  Result := [];
end;

function TCalculatedDataField.IsRequired: Boolean;
begin
  Result := False;
end;

function TCalculatedDataField.Code: String;
begin
  Result := _Code;
end;

constructor TCalculatedDataField.Create(const Code: String);
begin
  _Code := Code;
end;

class function TCalculatedDataField.New(const Code: String): ICalculatedDataField;
begin
  Result := TCalculatedDataField.Create(Code);
end;

end.
