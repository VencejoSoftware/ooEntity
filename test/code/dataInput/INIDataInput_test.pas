{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit INIDataInput_test;

interface

uses
  Classes, SysUtils,
  IniFiles,
  Key,
  DataInput,
  INIDataInput,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TINIDataInputTest = class sealed(TTestCase)
  strict private
    _FileName: String;
    _INI: TIniFile;
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

procedure TINIDataInputTest.ExistKeyTextReturnTrue;
begin
  CheckTrue(_DataInput.ExistKey(TTextKey.New('TEXT')));
end;

procedure TINIDataInputTest.ExistKeyNoneReturnFalse;
begin
  CheckFalse(_DataInput.ExistKey(TTextKey.New('none')));
end;

procedure TINIDataInputTest.IsNullReturnTrue;
begin
  CheckTrue(_DataInput.IsNull(TTextKey.New('NULL')));
end;

procedure TINIDataInputTest.ReadIntegerReturn88;
begin
  CheckEquals(88, _DataInput.ReadInteger(TTextKey.New('Number')));
end;

procedure TINIDataInputTest.ReadBooleanReturnTrue;
begin
  CheckTrue(_DataInput.ReadBoolean(TTextKey.New('BooleanTrue')));
end;

procedure TINIDataInputTest.ReadBooleanReturnFalse;
begin
  CheckFalse(_DataInput.ReadBoolean(TTextKey.New('BooleanFalse')));
end;

procedure TINIDataInputTest.ReadFloatResturn23456;
var
  Value: Extended;
begin
  Value := Round(_DataInput.ReadFloat(TTextKey.New('Float')) * 10000) / 10000;
  CheckEquals(2.3456, Value);
end;

procedure TINIDataInputTest.ReadStringReturnTest;
begin
  CheckEquals('Test', _DataInput.ReadString(TTextKey.New('Text')));
end;

procedure TINIDataInputTest.ReadDateTimeReturn01102030;
var
  DateValue: TDate;
begin
  DateValue := EncodeDate(2030, 10, 1);
  CheckEquals(DateValue, _DataInput.ReadDateTime(TTextKey.New('Date')));
end;

procedure TINIDataInputTest.ReadDateTimeReturn23052010112233;
var
  DateValue: TDateTime;
begin
  DateValue := EncodeDate(2020, 05, 23) + EncodeTime(11, 22, 33, 0);
  CheckEquals(DateValue, _DataInput.ReadDateTime(TTextKey.New('DateTime')));
end;

procedure TINIDataInputTest.ReadCharReturnA;
begin
  CheckEquals('A', _DataInput.ReadChar(TTextKey.New('Char')));
end;

procedure TINIDataInputTest.EnterSectionSectionAReturn666;
begin
  _DataInput.EnterSection(TTextKey.New('SectionA'));
  CheckEquals(666, _DataInput.ReadInteger(TTextKey.New('Code')));
  _DataInput.ExitSection(TTextKey.New('SectionA'));
  CheckEquals('test', _DataInput.ReadString(TTextKey.New('Code')));
end;

procedure TINIDataInputTest.SetUp;
const
  SECTION = 'BASE';
begin
  inherited;
  _FileName := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'test_values.ini';
  _INI := TIniFile.Create(_FileName);
  _INI.WriteInteger(SECTION, 'Number', 88);
  _INI.WriteBool(SECTION, 'BooleanTrue', True);
  _INI.WriteBool(SECTION, 'BooleanFalse', False);
  _INI.WriteFloat(SECTION, 'Float', 2.3456);
  _INI.WriteString(SECTION, 'text', 'Test');
  _INI.WriteString(SECTION, 'Null', TINIDataInput.NULL);
  _INI.WriteString(SECTION, 'Char', 'A');
  _INI.WriteDate(SECTION, 'Date', EncodeDate(2030, 10, 1));
  _INI.WriteDateTime(SECTION, 'DateTime', EncodeDate(2020, 05, 23) + EncodeTime(11, 22, 33, 0));
  _INI.WriteInteger('SectionA', 'Code', 666);
  _INI.WriteString(SECTION, 'Code', 'test');
  _DataInput := TINIDataInput.New(_INI, SECTION);
end;

procedure TINIDataInputTest.TearDown;
begin
  inherited;
  if FileExists(_FileName) then
    DeleteFile(_FileName);
  _INI.Free;
end;

initialization

RegisterTest(TINIDataInputTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
