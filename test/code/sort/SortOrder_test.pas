{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit SortOrder_test;

interface

uses
  SysUtils,
  SyntaxFormat, SyntaxFormatSymbol,
  Key,
  SortOrder,
  SortOrderAscending, SortOrderDescending, SortOrderNone,
  SymbolListMock,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TSortOrderTest = class sealed(TTestCase)
  strict private
    _SyntaxFormat: ISyntaxFormat;
  protected
    procedure SetUp; override;
  published
    procedure SyntaxAscendingIsField1ASCENDING;
    procedure SyntaxDescendingIsField1DESCENDING;
    procedure SyntaxNoneIsEmpty;
  end;

implementation

procedure TSortOrderTest.SyntaxAscendingIsField1ASCENDING;
var
  SortOrder: ISortOrder;
begin
  SortOrder := TSortOrderAscending.New(TTextKey.New('Field1'), _SyntaxFormat);
  CheckEquals('Field1 ASCENDING', SortOrder.Syntax);
end;

procedure TSortOrderTest.SyntaxDescendingIsField1DESCENDING;
var
  SortOrder: ISortOrder;
begin
  SortOrder := TSortOrderDescending.New(TTextKey.New('Field1'), _SyntaxFormat);
  CheckEquals('Field1 DESCENDING', SortOrder.Syntax);
end;

procedure TSortOrderTest.SyntaxNoneIsEmpty;
begin
  CheckEquals(EmptyStr, TSortOrderNone.New.Syntax);
end;

procedure TSortOrderTest.SetUp;
begin
  inherited;
  _SyntaxFormat := TSyntaxFormat.New(TSymbolListMock.New);
end;

initialization

RegisterTest(TSortOrderTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
