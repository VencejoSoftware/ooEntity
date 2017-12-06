{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooKeyString_test;

interface

uses
  SysUtils,
  ooKey.Intf, ooTextKey,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TTextKeyTest = class(TTestCase)
  published
    procedure TestNewStringKeyCreateUnique;
    procedure TestNewStringKey;
  end;

implementation

procedure TTextKeyTest.TestNewStringKey;
const
  Key = 'ID_KEY_1';
begin
  CheckEquals(Key, TTextKey.New(Key).AsString);
end;

procedure TTextKeyTest.TestNewStringKeyCreateUnique;
begin
  CheckFalse(Length(TTextKey.New.AsString) = 0);
end;

initialization

RegisterTest(TTextKeyTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
