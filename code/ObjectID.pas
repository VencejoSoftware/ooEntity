unit ObjectID;

interface

type
  IObjectID = interface
    ['{D1EB9E11-E3B8-4852-99A8-9E81030CABCC}']
    function Value: NativeInt;
    function IsEqual(const ID: IObjectID): Boolean;
  end;

  TObjectID = class sealed(TInterfacedObject, IObjectID)
  strict private
    _Value: NativeInt;
  public
    function Value: NativeInt;
    function IsEqual(const ID: IObjectID): Boolean;
    constructor Create(const Value: NativeInt);
    class function New(const Value: NativeInt): IObjectID;
  end;

implementation

function TObjectID.Value: NativeInt;
begin
  Result := _Value;
end;

function TObjectID.IsEqual(const ID: IObjectID): Boolean;
begin
  Result := Assigned(ID) and (ID.Value = _Value);
end;

constructor TObjectID.Create(const Value: NativeInt);
begin
  _Value := Value;
end;

class function TObjectID.New(const Value: NativeInt): IObjectID;
begin
  Result := TObjectID.Create(Value);
end;

end.
