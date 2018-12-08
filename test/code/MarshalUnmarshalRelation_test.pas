{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit MarshalUnmarshalRelation_test;

interface

uses
  Classes, SysUtils,
  DataInput, DataOutput,
  TStringsDataOutput, TStringsDataInput,
  Entity,
  ObjectAEntityMock, ObjectBEntityMock,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TEntityTest = class sealed(TTestCase)
  published
    procedure TestRelationDataOutput;
  end;

implementation

procedure TEntityTest.TestRelationDataOutput;
var
  ObjectB: IObjectBEntityMock;
  StringList: TStrings;
  DataOutput: IDataOutput;
begin
  StringList := TStringList.Create;
  try
    StringList.Add('ID=88');
    StringList.Add('Name=Text for ID 88');
    StringList.Add('ObjectA.Code=666');
    StringList.Add('ObjectA.Value=1.234');
    ObjectB := TObjectBEntityMock.New(0);
    ObjectB.Unmarshal(TTStringsDataInput.New(StringList));
    StringList.Clear;
    DataOutput := TTStringsDataOutput.New(StringList);
    ObjectB.Marshal(DataOutput);
    CheckEquals('88', StringList.Values['ID']);
    CheckEquals('Text for ID 88', StringList.Values['Name']);
    CheckEquals('666', StringList.Values['ObjectA.Code']);
    CheckEquals('1' + FormatSettings.DecimalSeparator + '234', StringList.Values['ObjectA.Value']);
  finally
    StringList.Free;
  end;
end;

initialization

RegisterTest(TEntityTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
