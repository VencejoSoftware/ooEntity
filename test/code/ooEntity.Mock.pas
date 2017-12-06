{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooEntity.Mock;

interface

uses
  SysUtils,
  Generics.Collections,
  ooTextKey,
  ooDataInput.Intf, ooDataOutput.Intf,
  ooEntity.Intf;

type
  IEntityMock = interface
    ['{BAF94D3C-1CD5-4B86-BD46-FC261CFD3835}']
    function ID: Integer;
    function Value: String;
  end;

  TEntityMock = class sealed(TInterfacedObject, IEntityMock)
  private
    _ID: Integer;
    _Value: string;
  public
    function ID: Integer;
    function Value: String;
    constructor Create(const ID: Integer; const Value: String);
    class function New(const ID: Integer; const Value: String): IEntityMock;
  end;

  TEntityMockDB = class sealed(TInterfacedObject, IEntity, IEntityMock)
  private
    _EntityMock: IEntityMock;
  public
    function Marshal(const DataOutput: IDataOutput): Boolean;
    function Unmarshal(const DataInput: IDataInput): Boolean;
    function ID: Integer;
    function Value: String;
    constructor Create(const DataInput: IDataInput);
    class function New(const DataInput: IDataInput): IEntityMock;
  end;

  TEntityMockDBList = TList<IEntityMock>;

implementation

function TEntityMockDB.ID: Integer;
begin
  Result := _EntityMock.ID;
end;

function TEntityMockDB.Value: String;
begin
  Result := _EntityMock.Value;
end;

function TEntityMockDB.Unmarshal(const DataInput: IDataInput): Boolean;
begin
  _EntityMock := TEntityMock.New(DataInput.ReadInteger(TTextKey.New('ID')),
    DataInput.ReadString(TTextKey.New('FIELD1')));
  Result := True;
end;

function TEntityMockDB.Marshal(const DataOutput: IDataOutput): Boolean;
begin
  DataOutput.WriteInteger(TTextKey.New('ID'), _EntityMock.ID);
  DataOutput.WriteString(TTextKey.New('FIELD1'), _EntityMock.Value);
  Result := True;
end;

constructor TEntityMockDB.Create(const DataInput: IDataInput);
begin
  Unmarshal(DataInput);
end;

class function TEntityMockDB.New(const DataInput: IDataInput): IEntityMock;
begin
  Result := TEntityMockDB.Create(DataInput);
end;

{ TEntityMock }

function TEntityMock.ID: Integer;
begin
  Result := _ID;
end;

function TEntityMock.Value: String;
begin
  Result := _Value;
end;

constructor TEntityMock.Create(const ID: Integer; const Value: String);
begin
  _ID := ID;
  _Value := Value;
end;

class function TEntityMock.New(const ID: Integer; const Value: String): IEntityMock;
begin
  Result := TEntityMock.Create(ID, Value);
end;

end.
