unit AutoIncrementDataField;

interface

uses
  Field,
  DataField,
  AutoIncrementFactory;

type
  IAutoIncrementDataField = interface(IDataField)
    ['{DA144717-5AA7-439F-B24F-55E9B6F6E6DB}']
    function AutoIncrementFactory: IAutoIncrementFactory;
  end;

  TAutoIncrementDataField = class sealed(TInterfacedObject, IDataField, IAutoIncrementDataField)
  strict private
    _DataField: IDataField;
    _Factory: IAutoIncrementFactory;
  public
    function Name: String;
    function Kind: TDataFieldKind;
    function Constraints: TDataFieldConstraintSet;
    function IsRequired: Boolean;
    function AutoIncrementFactory: IAutoIncrementFactory;
    constructor Create(const DataField: IDataField; const Factory: IAutoIncrementFactory);
    class function New(const DataField: IDataField; const Factory: IAutoIncrementFactory): IAutoIncrementDataField;
  end;

implementation

function TAutoIncrementDataField.Name: String;
begin
  Result := _DataField.Name;
end;

function TAutoIncrementDataField.Kind: TDataFieldKind;
begin
  Result := _DataField.Kind;
end;

function TAutoIncrementDataField.Constraints: TDataFieldConstraintSet;
begin
  Result := _DataField.Constraints;
end;

function TAutoIncrementDataField.IsRequired: Boolean;
begin
  Result := _DataField.IsRequired;
end;

function TAutoIncrementDataField.AutoIncrementFactory: IAutoIncrementFactory;
begin
  Result := _Factory;
end;

constructor TAutoIncrementDataField.Create(const DataField: IDataField; const Factory: IAutoIncrementFactory);
begin
  _DataField := DataField;
  _Factory := Factory;
end;

class function TAutoIncrementDataField.New(const DataField: IDataField; const Factory: IAutoIncrementFactory)
  : IAutoIncrementDataField;
begin
  Result := TAutoIncrementDataField.Create(DataField, Factory);
end;

end.
