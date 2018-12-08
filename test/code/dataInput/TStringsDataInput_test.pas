{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit TStringsDataInput_test;

interface

uses
  Classes, SysUtils,
  Key,
  DataInput,
  TStringsDataInput,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TTStringsDataInputTest = class sealed(TTestCase)
  strict private
    _StringList: TStringList;
    _DataInput: IDataInput;
  public
    procedure SetUp; override;
    procedure TearDown; override;
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

procedure TTStringsDataInputTest.ExistKeyTextReturnTrue;
begin
  CheckTrue(_DataInput.ExistKey(TTextKey.New('TEXT')));
end;

procedure TTStringsDataInputTest.ExistKeyNoneReturnFalse;
begin
  CheckFalse(_DataInput.ExistKey(TTextKey.New('none')));
end;

procedure TTStringsDataInputTest.IsNullReturnTrue;
begin
  CheckTrue(_DataInput.IsNull(TTextKey.New('NULL')));
end;

procedure TTStringsDataInputTest.ReadIntegerReturn88;
begin
  CheckEquals(88, _DataInput.ReadInteger(TTextKey.New('Number')));
end;

procedure TTStringsDataInputTest.ReadBooleanReturnTrue;
begin
  CheckTrue(_DataInput.ReadBoolean(TTextKey.New('BooleanTrue')));
end;

procedure TTStringsDataInputTest.ReadBooleanReturnFalse;
begin
  CheckFalse(_DataInput.ReadBoolean(TTextKey.New('BooleanFalse')));
end;

procedure TTStringsDataInputTest.ReadFloatResturn23456;
begin
  CheckEquals(2.3456, _DataInput.ReadFloat(TTextKey.New('Float')));
end;

procedure TTStringsDataInputTest.ReadStringReturnTest;
begin
  CheckEquals('Test', _DataInput.ReadString(TTextKey.New('Text')));
end;

procedure TTStringsDataInputTest.ReadDateTimeReturn01102030;
var
  DateValue: TDate;
begin
  DateValue := EncodeDate(2030, 10, 1);
  CheckEquals(DateValue, _DataInput.ReadDateTime(TTextKey.New('Date')));
end;

procedure TTStringsDataInputTest.ReadDateTimeReturn23052010112233;
var
  DateValue: TDateTime;
begin
  DateValue := EncodeDate(2020, 05, 23) + EncodeTime(11, 22, 33, 0);
  CheckEquals(DateValue, _DataInput.ReadDateTime(TTextKey.New('DateTime')));
end;

procedure TTStringsDataInputTest.ReadCharReturnA;
begin
  CheckEquals('A', _DataInput.ReadChar(TTextKey.New('Char')));
end;

procedure TTStringsDataInputTest.EnterSectionSectionAReturn666;
begin
  _DataInput.EnterSection(TTextKey.New('SectionA'));
  CheckEquals(666, _DataInput.ReadInteger(TTextKey.New('Code')));
  _DataInput.ExitSection(TTextKey.New('SectionA'));
  CheckEquals('test', _DataInput.ReadString(TTextKey.New('Code')));
end;

procedure TTStringsDataInputTest.SetUp;
begin
  inherited;
  _StringList := TStringList.Create;
  _StringList.Add('Number=88');
  _StringList.Add('BooleanTrue=-1');
  _StringList.Add('BooleanFalse=0');
  _StringList.Add('Float=2.3456');
  _StringList.Add('text=Test');
  _StringList.Add('Null=' + TTStringsDataInput.NULL);
  _StringList.Add('Char=A');
  _StringList.Add('Date=01/10/2030');
  _StringList.Add('DateTime=23/05/2020 11:22:33');
  _StringList.Add('SectionA.Code=666');
  _StringList.Add('Code=test');
  _DataInput := TTStringsDataInput.New(_StringList);
end;

procedure TTStringsDataInputTest.TearDown;
begin
  inherited;
  _StringList.Free;
end;

initialization

RegisterTest(TTStringsDataInputTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
