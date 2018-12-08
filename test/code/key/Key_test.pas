{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit Key_test;

interface

uses
  SysUtils,
  Key,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TTextKeyTest = class sealed(TTestCase)
  published
    procedure ValueIsIDKey1;
    procedure EmptyValueRaiseError;
  end;

implementation

procedure TTextKeyTest.ValueIsIDKey1;
const
  Key = 'ID_KEY_1';
begin
  CheckEquals(Key, TTextKey.New(Key).Value);
end;

procedure TTextKeyTest.EmptyValueRaiseError;
var
  Failed: Boolean;
begin
  Failed := False;
  try
    TTextKey.New(EmptyStr).Value;
  except
    on E: EKey do
    begin
      CheckEquals('Text key can not be empty', E.Message);
      Failed := True;
    end;
  end;
  CheckTrue(Failed);
end;

initialization

RegisterTest(TTextKeyTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
