{$REGION 'documentation'}
{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Object to define a Globally Unique Identifier key
  @created(29/05/2018)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit GUIDKey;

interface

uses
  SysUtils,
  Key;

type
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IKey) as TGUID data)
  @member(Value TGUID value of key)
  @member(AsString Return the TGUID value as a string)
}
{$ENDREGION}
  IGUIDKey = interface(IKey<TGUID>)
    ['{87D2758F-5C38-4C92-86F2-F061C9E9C360}']
    function AsString: String;
  end;

{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IGUIDKey))
  TGUID key object
  @member(Value @SeeAlso(IGUIDKey.Value))
  @member(AsString @SeeAlso(IGUIDKey.AsString))
  @member(NULL Null value of TGUID)
  @member(
    Create Object constructor
    @param(Value TGUID Value for the key)
  )
  @member(
    New Create a new @classname as interface
    @param(Value TGUID Value for the key)
  )
  @member(
    NewUnique Create a new @classname as interface with auto-create GUID value
  )
}
{$ENDREGION}

  TGUIDKey = class sealed(TInterfacedObject, IGUIDKey)
  const
    NULL: TGUID = '{00000000-0000-0000-0000-000000000000}';
  strict private
    _Value: TGUID;
  public
    function Value: TGUID;
    function AsString: String;
    constructor Create(const Value: TGUID);
    class function New(const Value: TGUID): IGUIDKey;
    class function NewUnique: IGUIDKey;
  end;

implementation

function TGUIDKey.Value: TGUID;
begin
  Result := _Value;
end;

function TGUIDKey.AsString: String;
begin
  Result := GUIDToString(_Value);
end;

constructor TGUIDKey.Create(const Value: TGUID);
begin
  _Value := Value;
end;

class function TGUIDKey.New(const Value: TGUID): IGUIDKey;
begin
  Result := TGUIDKey.Create(Value);
end;

class function TGUIDKey.NewUnique: IGUIDKey;
var
  Value: TGUID;
begin
  if CreateGuid(Value) <> S_OK then
    Value := NULL;
  Result := TGUIDKey.Create(Value);
end;

end.
