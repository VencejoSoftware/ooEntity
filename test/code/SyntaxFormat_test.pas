{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit SyntaxFormat_test;

interface

uses
  SyntaxFormatSymbol, SyntaxFormat,
  SymbolListMock,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TSyntaxFormatTest = class sealed(TTestCase)
  strict private
    _SyntaxFormat: ISyntaxFormat;
  protected
    procedure SetUp; override;
  published
    procedure ItemsFormatValue1SomeReturnText;
    procedure ItemsFormatNewLineValue1SomeReturnText;
    procedure ItemsFormatDelimtedValue1SomeReturnText;
    procedure ItemsFormatIndentValue1SomeReturnText;
    procedure ItemsFormatEncloseValue1SomeReturnText;
    procedure ItemsFormatAllSettedValue1SomeReturnText;
    procedure ItemsFormatEmptyReturnEmptyText;
    procedure JoinItems1234AReturnText;
    procedure JoinItemsEmptyReturnEmptyText;
    procedure AddMarginMoveOneTabRight;
    procedure DelimiteValueIsDelimValDelim;
    procedure EncloseList1234ReturnEnclosedText;
    procedure EncloseListEmptyReturnEmptyText;
  end;

implementation

procedure TSyntaxFormatTest.ItemsFormatValue1SomeReturnText;
begin
  CheckEquals('value 1 some', _SyntaxFormat.ItemsFormat(['value', '1', 'some'], [Spaced]));
end;

procedure TSyntaxFormatTest.ItemsFormatNewLineValue1SomeReturnText;
begin
  CheckEquals(sLineBreak + 'value ' + sLineBreak + '1 ' + sLineBreak + 'some',
    _SyntaxFormat.ItemsFormat(['value', '1', 'some'], [Spaced, Wordwrapped]));
end;

procedure TSyntaxFormatTest.ItemsFormatDelimtedValue1SomeReturnText;
begin
  CheckEquals('"value" "1" "some"', _SyntaxFormat.ItemsFormat(['value', '1', 'some'], [Spaced, Delimited]));
end;

procedure TSyntaxFormatTest.ItemsFormatIndentValue1SomeReturnText;
begin
  CheckEquals(#9'value '#9'1 '#9'some', _SyntaxFormat.ItemsFormat(['value', '1', 'some'], [Spaced, Indented]));
end;

procedure TSyntaxFormatTest.ItemsFormatEncloseValue1SomeReturnText;
begin
  CheckEquals('(value) (1) (some)', _SyntaxFormat.ItemsFormat(['value', '1', 'some'], [Spaced, Enclosed]));
end;

procedure TSyntaxFormatTest.ItemsFormatAllSettedValue1SomeReturnText;
begin
  CheckEquals(sLineBreak + #9'("value") ' + sLineBreak + #9'("1") ' + sLineBreak + #9'("some")',
    _SyntaxFormat.ItemsFormat(['value', '1', 'some'], [Spaced, Wordwrapped, Indented, Delimited, Enclosed]));
end;

procedure TSyntaxFormatTest.ItemsFormatEmptyReturnEmptyText;
begin
  CheckEquals('', _SyntaxFormat.ItemsFormat([]));
end;

procedure TSyntaxFormatTest.JoinItems1234AReturnText;
begin
  CheckEquals('1,2,3,4,A', _SyntaxFormat.ItemsFormat(['1', '2', '3', '4', 'A'], [Separated]));
end;

procedure TSyntaxFormatTest.JoinItemsEmptyReturnEmptyText;
begin
  CheckEquals('', _SyntaxFormat.ItemsFormat([]));
end;

procedure TSyntaxFormatTest.AddMarginMoveOneTabRight;
begin
  CheckEquals(#9'value', _SyntaxFormat.TextFormat('value', [Indented]));
end;

procedure TSyntaxFormatTest.DelimiteValueIsDelimValDelim;
begin
  CheckEquals('"value"', _SyntaxFormat.TextFormat('value', [Delimited]));
end;

procedure TSyntaxFormatTest.EncloseList1234ReturnEnclosedText;
begin
  CheckEquals('(1,2,3,4,A)', _SyntaxFormat.TextFormat(_SyntaxFormat.ItemsFormat(['1', '2', '3', '4', 'A'], [Separated]),
    [Enclosed]));
end;

procedure TSyntaxFormatTest.EncloseListEmptyReturnEmptyText;
begin
  CheckEquals('', _SyntaxFormat.ItemsFormat([], [Separated, Enclosed]));
end;

procedure TSyntaxFormatTest.SetUp;
begin
  inherited;
  _SyntaxFormat := TSyntaxFormat.New(TSymbolListMock.New);
end;

initialization

RegisterTest(TSyntaxFormatTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
