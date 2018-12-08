{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}

unit ooXML.DataInput_test;

interface

uses
  Classes, SysUtils,
  ooDataInput.Intf, ooDataOutput.Intf,
  ooXML.DataInput,
  ooEntity.Intf, ooEntity.Mock,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TXMLDataInputTest = class(TTestCase)
  published
  end;

implementation

initialization

RegisterTest(TXMLDataInputTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
