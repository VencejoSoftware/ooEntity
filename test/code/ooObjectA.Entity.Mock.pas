unit ooObjectA.Entity.Mock;

interface

uses
  SysUtils,
  Generics.Collections,
  ooTextKey,
  ooDataInput.Intf, ooDataOutput.Intf,
  ooEntity.Intf;

type
  IObjectAEntityMock = interface(IEntity)
    ['{A5AB316E-A621-4C9E-9148-50B52CA636A7}']
    function Code: Integer;
    function Value: Extended;
  end;

  TObjectAEntityMock = class sealed(TInterfacedObject, IObjectAEntityMock)
  strict private
  const
    ID_CODE = 'CODE';
    VALUE_KEY = 'VALUE';
  strict private
    _Code: Integer;
    _Value: Extended;
  public
    function Code: Integer;
    function Value: Extended;
    function Marshal(const DataOutput: IDataOutput): Boolean;
    function Unmarshal(const DataInput: IDataInput): Boolean;
    constructor Create(const Code: Integer);
    class function New(const Code: Integer): IObjectAEntityMock;
  end;

implementation

function TObjectAEntityMock.Code: Integer;
begin
  Result := _Code;
end;

function TObjectAEntityMock.Value: Extended;
begin
  Result := _Value;
end;

function TObjectAEntityMock.Marshal(const DataOutput: IDataOutput): Boolean;
begin
  DataOutput.WriteInteger(TTextKey.New(ID_CODE), Code);
  DataOutput.WriteFloat(TTextKey.New(VALUE_KEY), Value);
  Result := True;
end;

function TObjectAEntityMock.Unmarshal(const DataInput: IDataInput): Boolean;
begin
  _Code := DataInput.ReadInteger(TTextKey.New(ID_CODE));
  _Value := DataInput.ReadFloat(TTextKey.New(VALUE_KEY));
  Result := True;
end;

constructor TObjectAEntityMock.Create(const Code: Integer);
begin
  _Code := Code;
end;

class function TObjectAEntityMock.New(const Code: Integer): IObjectAEntityMock;
begin
  Result := TObjectAEntityMock.Create(Code);
end;

end.
