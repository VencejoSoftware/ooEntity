{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit KeyGUID_test;

interface

uses
  SysUtils,
  Key, GUIDKey,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TGUIDKeyTest = class sealed(TTestCase)
  published
    procedure ValueIs92E5F173_8258_4CBC_84EC_F07A2B7578FF;
    procedure AsStringIs92E5F173_8258_4CBC_84EC_F07A2B7578FF;
    procedure NullIs00000000_0000_0000_0000_000000000000;
    procedure NewUniqueReturnSomething;
  end;

implementation

procedure TGUIDKeyTest.ValueIs92E5F173_8258_4CBC_84EC_F07A2B7578FF;
const
  Key: TGUID = '{92E5F173-8258-4CBC-84EC-F07A2B7578FF}';
begin
  CheckTrue(Key = TGUIDKey.New(Key).Value);
end;

procedure TGUIDKeyTest.AsStringIs92E5F173_8258_4CBC_84EC_F07A2B7578FF;
const
  Key = '{92E5F173-8258-4CBC-84EC-F07A2B7578FF}';
begin
  CheckEquals(Key, TGUIDKey.New(StringToGUID(Key)).AsString);
end;

procedure TGUIDKeyTest.NullIs00000000_0000_0000_0000_000000000000;
begin
  CheckEquals(GUIDToString(TGUIDKey.NULL), TGUIDKey.New(TGUIDKey.NULL).AsString);
end;

procedure TGUIDKeyTest.NewUniqueReturnSomething;
begin
  CheckFalse(Length(TGUIDKey.NewUnique.AsString) = 0);
end;

initialization

RegisterTest(TGUIDKeyTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
