unit ValueSyntaxCoalesce;

interface

uses
  Value,
  DataField,
  DataFilter,
  ValueSyntax;

type
  TValueSyntaxCoalesce = class sealed(TInterfacedObject, IValueSyntax)
  strict private
    _ValueSyntax: IValueSyntax;
  public
    function Parse(const DataField: IDataField; const Value: IValue): string;
    constructor Create;
    class function New: IValueSyntax;
  end;

implementation

function TValueSyntaxCoalesce.Parse(const DataField: IDataField; const Value: IValue): string;
begin
  if Assigned(Value) and Value.IsEmpty then
    Result := DataField.Name
  else
    Result := _ValueSyntax.Parse(DataField, Value);
end;

constructor TValueSyntaxCoalesce.Create;
begin
  _ValueSyntax := TValueSyntax.New;
end;

class function TValueSyntaxCoalesce.New: IValueSyntax;
begin
  Result := Create;
end;

end.
