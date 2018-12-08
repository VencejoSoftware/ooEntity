{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooFormatter_test;

interface

uses
  ooFormatterElements, ooFormatter,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TFormatterTest = class sealed(TTestCase)
  strict private
    _Elements: IFormatterElements;
    _Formatter: IFormatter;
  protected
    procedure SetUp; override;
  published
    procedure ConcatenateValue1SomeReturnText;
    procedure ConcatenateNewLineValue1SomeReturnText;
    procedure ConcatenateDelimtedValue1SomeReturnText;
    procedure ConcatenateIndentValue1SomeReturnText;
    procedure ConcatenateEncloseValue1SomeReturnText;
    procedure ConcatenateAllSettedValue1SomeReturnText;
    procedure ConcatenateEmptyReturnEmptyText;
    procedure JoinItems1234AReturnText;
    procedure JoinItemsEmptyReturnEmptyText;
    procedure AddMarginMoveOneTabRight;
    procedure DelimiteValueIsDelimValDelim;
    procedure EncloseList1234ReturnEnclosedText;
    procedure EncloseListEmptyReturnEmptyText;
  end;

implementation

procedure TFormatterTest.ConcatenateValue1SomeReturnText;
begin
  CheckEquals('value 1 some', _Formatter.Concatenate(['value', '1', 'some']));
end;

procedure TFormatterTest.ConcatenateNewLineValue1SomeReturnText;
begin
  _Formatter.ChangeSettings([NewLine]);
  CheckEquals(sLineBreak + 'value ' + sLineBreak + '1 ' + sLineBreak + 'some',
    _Formatter.Concatenate(['value', '1', 'some']));
end;

procedure TFormatterTest.ConcatenateDelimtedValue1SomeReturnText;
begin
  _Formatter.ChangeSettings([DelimitedValue]);
  CheckEquals('"value" "1" "some"', _Formatter.Concatenate(['value', '1', 'some']));
end;

procedure TFormatterTest.ConcatenateIndentValue1SomeReturnText;
begin
  _Formatter.ChangeSettings([Indent]);
  CheckEquals(#9'value '#9'1 '#9'some', _Formatter.Concatenate(['value', '1', 'some']));
end;

procedure TFormatterTest.ConcatenateEncloseValue1SomeReturnText;
begin
  _Formatter.ChangeSettings([Enclose]);
  CheckEquals('(value) (1) (some)', _Formatter.Concatenate(['value', '1', 'some']));
end;

procedure TFormatterTest.ConcatenateAllSettedValue1SomeReturnText;
begin
  _Formatter.ChangeSettings([NewLine, DelimitedValue, Indent, Enclose]);
  CheckEquals(sLineBreak + #9'("value") ' + sLineBreak + #9'("1") ' + sLineBreak + #9'("some")',
    _Formatter.Concatenate(['value', '1', 'some']));
end;

procedure TFormatterTest.ConcatenateEmptyReturnEmptyText;
begin
  CheckEquals('', _Formatter.Concatenate([]));
end;

procedure TFormatterTest.JoinItems1234AReturnText;
begin
  CheckEquals('1,2,3,4,A', _Formatter.JoinItems(['1', '2', '3', '4', 'A']));
end;

procedure TFormatterTest.JoinItemsEmptyReturnEmptyText;
begin
  CheckEquals('', _Formatter.JoinItems([]));
end;

procedure TFormatterTest.AddMarginMoveOneTabRight;
begin
  CheckEquals(#9'value', _Formatter.AddMargin('value'));
end;

procedure TFormatterTest.DelimiteValueIsDelimValDelim;
begin
  CheckEquals('"value"', _Formatter.Delimite('value'));
end;

procedure TFormatterTest.EncloseList1234ReturnEnclosedText;
begin
  CheckEquals('(1,2,3,4,A)', _Formatter.EncloseList(['1', '2', '3', '4', 'A']));
end;

procedure TFormatterTest.EncloseListEmptyReturnEmptyText;
begin
  CheckEquals('', _Formatter.EncloseList([]));
end;

procedure TFormatterTest.SetUp;
begin
  inherited;
  _Elements := TFormatterElements.New;
  _Elements.Add(TFormatterSymbol.New(TFormatterSymbolID.Separator, ','));
  _Elements.Add(TFormatterSymbol.New(TFormatterSymbolID.DelimiterStart, '"'));
  _Elements.Add(TFormatterSymbol.New(TFormatterSymbolID.DelimiterFinish, '"'));
  _Elements.Add(TFormatterSymbol.New(TFormatterSymbolID.Margin, #9));
  _Elements.Add(TFormatterSymbol.New(TFormatterSymbolID.Space, ' '));
  _Elements.Add(TFormatterSymbol.New(TFormatterSymbolID.ListStart, '('));
  _Elements.Add(TFormatterSymbol.New(TFormatterSymbolID.ListFinish, ')'));
  _Formatter := TFormatter.New(_Elements);
end;

initialization

RegisterTest(TFormatterTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
