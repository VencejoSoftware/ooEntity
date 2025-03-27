unit AutoIncrementDataField;

interface

uses
  Field,
  DataField,
  Sequence;

type
  IAutoIncrementDataField = interface(IDataField)
    ['{837DF577-A8BF-4A41-B595-8E90FE37C5A6}']
    function Sequence: ISequence;
  end;

  TAutoIncrementDataField = class sealed(TInterfacedObject, IDataField, IAutoIncrementDataField)
  strict private
    _DataField: IDataField;
    _Factory: ISequence;
  public
    function Name: String;
    function Kind: TDataFieldKind;
    function Constraints: TDataFieldConstraintSet;
    function IsRequired: Boolean;
    function Sequence: ISequence;
    constructor Create(const DataField: IDataField; const Factory: ISequence);
    class function New(const DataField: IDataField; const Factory: ISequence): IAutoIncrementDataField;
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

function TAutoIncrementDataField.Sequence: ISequence;
begin
  Result := _Factory;
end;

constructor TAutoIncrementDataField.Create(const DataField: IDataField; const Factory: ISequence);
begin
  _DataField := DataField;
  _Factory := Factory;
end;

class function TAutoIncrementDataField.New(const DataField: IDataField; const Factory: ISequence)
  : IAutoIncrementDataField;
begin
  Result := Create(DataField, Factory);
end;

end.
