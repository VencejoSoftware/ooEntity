unit DataValue;

interface

uses
  SysUtils,
  Field, DataField,
  Value,
  IterableList;

type
  IDataValue = interface
    ['{4D8357FF-76F6-4D3C-8043-6FF68BD95269}']
    function DataField: IDataField;
    function Value: IValue;
    function IsNull: Boolean;
    procedure UpdateValue(const Value: IValue);
  end;

  TDataValue = class sealed(TInterfacedObject, IDataValue)
  strict private
    _DataField: IDataField;
    _Value: IValue;
  public
    function DataField: IDataField;
    function Value: IValue;
    function IsNull: Boolean;
    procedure UpdateValue(const Value: IValue);
    constructor Create(const DataField: IDataField; const Value: IValue);
    class function New(const DataField: IDataField; const Value: IValue): IDataValue;
  end;

  IDataValueList = interface(IIterableList<IDataValue>)
    ['{51502D7B-0258-46F1-B9B6-7BA60C07BFB4}']
    function ItemByFieldName(const FieldName: String): IDataValue;
  end;

  TDataValueList = class sealed(TIterableList<IDataValue>, IDataValueList)
  public
    function ItemByFieldName(const FieldName: String): IDataValue;
    class function New: IDataValueList;
  end;

implementation

function TDataValue.DataField: IDataField;
begin
  Result := _DataField;
end;

function TDataValue.Value: IValue;
begin
  Result := _Value;
end;

function TDataValue.IsNull: Boolean;
begin
  Result := Assigned(_Value)
end;

procedure TDataValue.UpdateValue(const Value: IValue);
begin
  _Value := Value;
end;

constructor TDataValue.Create(const DataField: IDataField; const Value: IValue);
begin
  _DataField := DataField;
  _Value := Value;
end;

class function TDataValue.New(const DataField: IDataField; const Value: IValue): IDataValue;
begin
  Result := TDataValue.Create(DataField, Value);
end;

{ TDataValueList }

function TDataValueList.ItemByFieldName(const FieldName: String): IDataValue;
var
  Item: IDataValue;
begin
  Result := nil;
  for Item in Self do
    if SameText(Item.DataField.Name, FieldName) then
      Exit(Item);
end;

class function TDataValueList.New: IDataValueList;
begin
  Result := TDataValueList.Create;
end;

end.
