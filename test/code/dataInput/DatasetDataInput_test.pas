{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit DatasetDataInput_test;

interface

uses
  Classes, SysUtils,
  DB,
  RxMemDS,
  Key,
  DataInput,
  DatasetDataInput,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TDatasetDataInputTest = class sealed(TTestCase)
  strict private
    _Dataset: TDataset;
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
    procedure ReadBooleanIntReturnTrue;
    procedure ReadBooleanIntReturnFalse;
    procedure ReadFloatResturn23456;
    procedure ReadStringReturnTest;
    procedure ReadDateTimeReturn01102030;
    procedure ReadDateTimeReturn23052010112233;
    procedure ReadCharReturnA;
    procedure EnterSectionSectionAReturn666;
  end;

implementation

procedure TDatasetDataInputTest.ExistKeyTextReturnTrue;
begin
  CheckTrue(_DataInput.ExistKey(TTextKey.New('TEXT')));
end;

procedure TDatasetDataInputTest.ExistKeyNoneReturnFalse;
begin
  CheckFalse(_DataInput.ExistKey(TTextKey.New('none')));
end;

procedure TDatasetDataInputTest.IsNullReturnTrue;
begin
  CheckTrue(_DataInput.IsNull(TTextKey.New('NULL')));
end;

procedure TDatasetDataInputTest.ReadIntegerReturn88;
begin
  CheckEquals(88, _DataInput.ReadInteger(TTextKey.New('Number')));
end;

procedure TDatasetDataInputTest.ReadBooleanReturnTrue;
begin
  CheckTrue(_DataInput.ReadBoolean(TTextKey.New('BooleanTrue')));
end;

procedure TDatasetDataInputTest.ReadBooleanReturnFalse;
begin
  CheckFalse(_DataInput.ReadBoolean(TTextKey.New('BooleanFalse')));
end;

procedure TDatasetDataInputTest.ReadBooleanIntReturnTrue;
begin
  CheckTrue(_DataInput.ReadBoolean(TTextKey.New('BooleanIntTrue')));
end;

procedure TDatasetDataInputTest.ReadBooleanIntReturnFalse;
begin
  CheckFalse(_DataInput.ReadBoolean(TTextKey.New('BooleanIntFalse')));
end;

procedure TDatasetDataInputTest.ReadFloatResturn23456;
var
  Value: Extended;
begin
  Value := Round(_DataInput.ReadFloat(TTextKey.New('Float')) * 10000) / 10000;
  CheckEquals(2.3456, Value);
end;

procedure TDatasetDataInputTest.ReadStringReturnTest;
begin
  CheckEquals('Test', _DataInput.ReadString(TTextKey.New('Text')));
end;

procedure TDatasetDataInputTest.ReadDateTimeReturn01102030;
var
  DateValue: TDate;
begin
  DateValue := EncodeDate(2030, 10, 1);
  CheckEquals(DateValue, _DataInput.ReadDateTime(TTextKey.New('Date')));
end;

procedure TDatasetDataInputTest.ReadDateTimeReturn23052010112233;
var
  DateValue: TDateTime;
begin
  DateValue := EncodeDate(2020, 05, 23) + EncodeTime(11, 22, 33, 0);
  CheckEquals(DateValue, _DataInput.ReadDateTime(TTextKey.New('DateTime')));
end;

procedure TDatasetDataInputTest.ReadCharReturnA;
begin
  CheckEquals('A', _DataInput.ReadChar(TTextKey.New('Char')));
end;

procedure TDatasetDataInputTest.EnterSectionSectionAReturn666;
begin
  _DataInput.EnterSection(TTextKey.New('SectionA'));
  CheckEquals(666, _DataInput.ReadInteger(TTextKey.New('Code')));
  _DataInput.ExitSection(TTextKey.New('SectionA'));
  CheckEquals('test', _DataInput.ReadString(TTextKey.New('Code')));
end;

procedure TDatasetDataInputTest.SetUp;
begin
  inherited;
  _Dataset := TRxMemoryData.Create(nil);
  _Dataset.FieldDefs.Add('Number', ftInteger);
  _Dataset.FieldDefs.Add('BooleanTrue', ftBoolean);
  _Dataset.FieldDefs.Add('BooleanFalse', ftBoolean);
  _Dataset.FieldDefs.Add('BooleanIntTrue', ftInteger);
  _Dataset.FieldDefs.Add('BooleanIntFalse', ftInteger);
  _Dataset.FieldDefs.Add('Float', ftFloat);
  _Dataset.FieldDefs.Add('text', ftString, 50);
  _Dataset.FieldDefs.Add('Null', ftString);
  _Dataset.FieldDefs.Add('Char', ftString, 1);
  _Dataset.FieldDefs.Add('Date', ftDate);
  _Dataset.FieldDefs.Add('DateTime', ftDateTime);
  _Dataset.FieldDefs.Add('SectionA_Code', ftInteger);
  _Dataset.FieldDefs.Add('Code', ftString, 50);
  _Dataset.FieldDefs.Update;
  _Dataset.Open;
  _Dataset.Edit;
  _Dataset.FieldByName('Number').AsInteger := 88;
  _Dataset.FieldByName('BooleanTrue').AsBoolean := True;
  _Dataset.FieldByName('BooleanFalse').AsBoolean := False;
  _Dataset.FieldByName('BooleanIntTrue').AsInteger := 1;
  _Dataset.FieldByName('BooleanIntFalse').AsInteger := 0;
  _Dataset.FieldByName('Float').AsExtended := 2.3456;
  _Dataset.FieldByName('text').AsString := 'Test';
  _Dataset.FieldByName('Null').Clear;
  _Dataset.FieldByName('Char').AsString := 'A';
  _Dataset.FieldByName('Date').AsDateTime := EncodeDate(2030, 10, 1);
  _Dataset.FieldByName('DateTime').AsDateTime := EncodeDate(2020, 05, 23) + EncodeTime(11, 22, 33, 0);
  _Dataset.FieldByName('SectionA_Code').AsInteger := 666;
  _Dataset.FieldByName('Code').AsString := 'test';
  _Dataset.Post;
  _DataInput := TDatasetDataInput.New(_Dataset);
end;

procedure TDatasetDataInputTest.TearDown;
begin
  inherited;
  _Dataset.Free;
end;

initialization

RegisterTest(TDatasetDataInputTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
