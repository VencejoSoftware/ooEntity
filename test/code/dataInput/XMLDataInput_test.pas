{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}

unit XMLDataInput_test;

interface

uses
  Classes, SysUtils,
  XMLTag, XMLItem, XMLParser,
  Key,
  DataInput,
  XMLDataInput,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TXMLDataInputTest = class sealed(TTestCase)
  strict private
    _Parser: IXMLParser;
    _DataInput: IDataInput;
  public
    procedure SetUp; override;
  published
    procedure ExistKeyTextReturnTrue;
    procedure ExistKeyNoneReturnFalse;
    procedure IsNullReturnTrue;
    procedure ReadIntegerReturn88;
    procedure ReadBooleanReturnTrue;
    procedure ReadBooleanReturnFalse;
    procedure ReadFloatResturn23456;
    procedure ReadStringReturnTest;
    procedure ReadDateTimeReturn01102030;
    procedure ReadDateTimeReturn23052010112233;
    procedure ReadCharReturnA;
    procedure EnterSectionSectionAReturn666;
  end;

implementation

procedure TXMLDataInputTest.ExistKeyTextReturnTrue;
begin
  CheckTrue(_DataInput.ExistKey(TTextKey.New('text')));
end;

procedure TXMLDataInputTest.ExistKeyNoneReturnFalse;
begin
  CheckFalse(_DataInput.ExistKey(TTextKey.New('none')));
end;

procedure TXMLDataInputTest.IsNullReturnTrue;
begin
  CheckTrue(_DataInput.IsNull(TTextKey.New('NULL')));
end;

procedure TXMLDataInputTest.ReadIntegerReturn88;
begin
  CheckEquals(88, _DataInput.ReadInteger(TTextKey.New('Number')));
end;

procedure TXMLDataInputTest.ReadBooleanReturnTrue;
begin
  CheckTrue(_DataInput.ReadBoolean(TTextKey.New('BooleanTrue')));
end;

procedure TXMLDataInputTest.ReadBooleanReturnFalse;
begin
  CheckFalse(_DataInput.ReadBoolean(TTextKey.New('BooleanFalse')));
end;

procedure TXMLDataInputTest.ReadFloatResturn23456;
var
  Value: Extended;
begin
  Value := Round(_DataInput.ReadFloat(TTextKey.New('Float')) * 10000) / 10000;
  CheckEquals(2.3456, Value);
end;

procedure TXMLDataInputTest.ReadStringReturnTest;
begin
  CheckEquals('Test', _DataInput.ReadString(TTextKey.New('Text')));
end;

procedure TXMLDataInputTest.ReadDateTimeReturn01102030;
var
  DateValue: TDate;
begin
  DateValue := EncodeDate(2030, 10, 1);
  CheckEquals(DateValue, _DataInput.ReadDateTime(TTextKey.New('Date')));
end;

procedure TXMLDataInputTest.ReadDateTimeReturn23052010112233;
var
  DateValue: TDateTime;
begin
  DateValue := EncodeDate(2020, 05, 23) + EncodeTime(11, 22, 33, 0);
  CheckEquals(DateValue, _DataInput.ReadDateTime(TTextKey.New('DateTime')));
end;

procedure TXMLDataInputTest.ReadCharReturnA;
begin
  CheckEquals('A', _DataInput.ReadChar(TTextKey.New('Char')));
end;

procedure TXMLDataInputTest.EnterSectionSectionAReturn666;
begin
  _DataInput.EnterSection(TTextKey.New('SectionA'));
  CheckEquals(666, _DataInput.ReadInteger(TTextKey.New('Code')));
  _DataInput.ExitSection(TTextKey.New('SectionA'));
  CheckEquals('test', _DataInput.ReadString(TTextKey.New('Code')));
end;

procedure TXMLDataInputTest.SetUp;
const
  XML_CONTENT = //
    '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' + //
    '<TEST>' + //
    '<DATA><Number>88</Number></DATA>' + //
    '<DATA><BooleanTrue>1</BooleanTrue></DATA>' + //
    '<DATA><BooleanFalse>0</BooleanFalse></DATA>' + //
    '<DATA><Float>2.3456</Float></DATA>' + //
    '<DATA><Text>Test</Text></DATA>' + //
    '<DATA><Null><NULL></Null></DATA>' + //
    '<DATA><Char>A</Char></DATA>' + //
    '<DATA><Date>01/10/2030</Date></DATA>' + //
    '<DATA><DateTime>23/05/2020 11:22:33</DateTime></DATA>' + //
    '<DATA><SectionA><Code>666</Code></SectionA></DATA>' + //
    '<DATA><Code>Test</Code></DATA>' + //
    '</TEST>';
begin
  inherited;
  _Parser := TXMLParser.New(XML_CONTENT, TXMLTag.New('TEST'), 1);
  _DataInput := TXMLDataInput.New(_Parser, TXMLTag.New('TEST'));
end;

initialization

RegisterTest(TXMLDataInputTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
