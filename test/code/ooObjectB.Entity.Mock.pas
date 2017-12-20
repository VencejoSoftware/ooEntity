{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooObjectB.Entity.Mock;

interface

uses
  SysUtils,
  Generics.Collections,
  ooTextKey,
  ooDataInput.Intf, ooDataOutput.Intf,
  ooEntity.Intf,
  ooObjectA.Entity.Mock;

type
  IObjectBEntityMock = interface(IEntity)
    ['{A5AB316E-A621-4C9E-9148-50B52CA636A7}']
    function ID: Integer;
    function Name: String;
    function ObjectA: IObjectAEntityMock;
  end;

  TObjectBEntityMock = class sealed(TInterfacedObject, IObjectBEntityMock)
  strict private
  const
    ID_KEY = 'ID';
    NAME_KEY = 'Name';
    OBJECTA_KEY = 'ObjectA';
  strict private
    _ID: Integer;
    _Name: String;
    _ObjectA: IObjectAEntityMock;
  public
    function ID: Integer;
    function Name: String;
    function ObjectA: IObjectAEntityMock;
    function Marshal(const DataOutput: IDataOutput): Boolean;
    function Unmarshal(const DataInput: IDataInput): Boolean;
    constructor Create(const ID: Integer);
    class function New(const ID: Integer): IObjectBEntityMock;
  end;

implementation

function TObjectBEntityMock.ID: Integer;
begin
  Result := _ID;
end;

function TObjectBEntityMock.Name: String;
begin
  Result := _Name;
end;

function TObjectBEntityMock.ObjectA: IObjectAEntityMock;
begin
  if not Assigned(_ObjectA) then
    _ObjectA := TObjectAEntityMock.New(0);
  Result := _ObjectA;
end;

function TObjectBEntityMock.Marshal(const DataOutput: IDataOutput): Boolean;
begin
  DataOutput.WriteInteger(TTextKey.New(ID_KEY), ID);
  DataOutput.WriteString(TTextKey.New(NAME_KEY), Name);
  DataOutput.EnterSection(TTextKey.New(OBJECTA_KEY));
  ObjectA.Marshal(DataOutput);
  DataOutput.ExitSection(TTextKey.New(OBJECTA_KEY));
  Result := True;
end;

function TObjectBEntityMock.Unmarshal(const DataInput: IDataInput): Boolean;
begin
  _ID := DataInput.ReadInteger(TTextKey.New(ID_KEY));
  _Name := DataInput.ReadString(TTextKey.New(NAME_KEY));
  DataInput.EnterSection(TTextKey.New(OBJECTA_KEY));
  ObjectA.Unmarshal(DataInput);
  DataInput.ExitSection(TTextKey.New(OBJECTA_KEY));
  Result := True;
end;

constructor TObjectBEntityMock.Create(const ID: Integer);
begin
  _ID := ID;
end;

class function TObjectBEntityMock.New(const ID: Integer): IObjectBEntityMock;
begin
  Result := TObjectBEntityMock.Create(ID);
end;

end.
