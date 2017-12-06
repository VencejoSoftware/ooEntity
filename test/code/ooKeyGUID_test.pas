{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooKeyGUID_test;

interface

uses
  SysUtils,
  ooKey.Intf, ooGUIDKey,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TGUIDKeyTest = class(TTestCase)
  published
    procedure TestNewGuidKeyCreateUnique;
    procedure TestNewGuidKey;
  end;

implementation

procedure TGUIDKeyTest.TestNewGuidKey;
const
  Key = '{92E5F173-8258-4CBC-84EC-F07A2B7578FF}';
begin
  CheckEquals(Key, TGUIDKey.New(StringToGUID(Key)).AsString);
end;

procedure TGUIDKeyTest.TestNewGuidKeyCreateUnique;
begin
  CheckFalse(Length(TGUIDKey.New.AsString) = 0);
end;

initialization

RegisterTest(TGUIDKeyTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
