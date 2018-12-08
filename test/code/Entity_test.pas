{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit Entity_test;

interface

uses
  Classes, SysUtils,
  DataInput, DataOutput,
  TStringsDataOutput, TStringsDataInput,
  Entity, EntityMock,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TEntityTest = class sealed(TTestCase)
  published
    procedure TestCreateDestroy;
    procedure TestNewWithRead;
    procedure TestNewWithWrite;
  end;

implementation

procedure TEntityTest.TestCreateDestroy;
var
  EntityMock: IEntityMock;
begin
  EntityMock := TEntityMock.New(0, '');
  CheckTrue(Assigned(EntityMock));
end;

procedure TEntityTest.TestNewWithRead;
var
  EntityMock: IEntityMock;
  StringList: TStrings;
begin
  StringList := TStringList.Create;
  try
    StringList.Add('ID=88');
    StringList.Add('FIELD1=Text for ID 88');
    EntityMock := TEntityMockDB.New(TTStringsDataInput.New(StringList));
    CheckEquals(88, EntityMock.ID);
{$IFDEF FPC}
    CheckEquals('Text for ID 88', EntityMock.Value);
{$ELSE}
    CheckEqualsString('Text for ID 88', EntityMock.Value);
{$ENDIF}
  finally
    StringList.Free;
  end;
end;

procedure TEntityTest.TestNewWithWrite;
var
  EntityMock: IEntityMock;
  StringList: TStrings;
  DataOutput: IDataOutput;
begin
  StringList := TStringList.Create;
  try
    StringList.Add('ID=88');
    StringList.Add('FIELD1=Text for ID 88');
    EntityMock := TEntityMockDB.New(TTStringsDataInput.New(StringList));
    StringList.Clear;
    DataOutput := TTStringsDataOutput.New(StringList);
    (EntityMock as TEntityMockDB).Marshal(DataOutput);
    CheckEquals('88', StringList.Values['ID']);
    CheckEquals('Text for ID 88', StringList.Values['FIELD1']);
  finally
    StringList.Free;
  end;
end;

initialization

RegisterTest(TEntityTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
