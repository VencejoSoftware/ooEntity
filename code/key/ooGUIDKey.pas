{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooGUIDKey;

interface

uses
  SysUtils,
  ooKey.Intf;

type
  TGUIDKey = class sealed(TInterfacedObject, IKey)
  strict private
  const
    NULL_GUID: TGUID = '{00000000-0000-0000-0000-000000000000}';
  strict private
    _Value: TGUID;
  private
    function CreateUnique: TGUID;
    function IsEmptyKey(const Value: TGUID): Boolean;
  public
    function AsString: String;

    constructor Create(const Value: TGUID);

    class function New(const Value: TGUID): IKey; overload;
    class function New: IKey; overload;
  end;

implementation

function TGUIDKey.AsString: String;
begin
  Result := GUIDToString(_Value);
end;

function TGUIDKey.CreateUnique: TGUID;
begin
  if CreateGuid(Result) <> S_OK then
    Result := NULL_GUID;
end;

function TGUIDKey.IsEmptyKey(const Value: TGUID): Boolean;
begin
  Result := IsEqualGUID(Value, NULL_GUID);
end;

constructor TGUIDKey.Create(const Value: TGUID);
begin
  if IsEmptyKey(Value) then
    _Value := CreateUnique
  else
    _Value := Value;
end;

class function TGUIDKey.New(const Value: TGUID): IKey;
begin
  Result := Create(Value);
end;

class function TGUIDKey.New: IKey;
begin
  Result := TGUIDKey.Create(NULL_GUID);
end;

end.
