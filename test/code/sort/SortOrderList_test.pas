{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit SortOrderList_test;

interface

uses
  SyntaxFormat, SyntaxFormatSymbol,
  Key,
  SortOrderAscending, SortOrderDescending, SortOrderNone,
  SortOrderList,
  SymbolListMock,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TSortOrderListTest = class sealed(TTestCase)
  published
    procedure ParseListReturnStaticText;
  end;

implementation

procedure TSortOrderListTest.ParseListReturnStaticText;
var
  SortOrderList: ISortOrderList;
  SyntaxFormat: ISyntaxFormat;
begin
  SyntaxFormat := TSyntaxFormat.New(TSymbolListMock.New);
  SortOrderList := TSortOrderList.New(SyntaxFormat);
  SortOrderList.Add(TSortOrderAscending.New(TTextKey.New('Field1'), SyntaxFormat));
  SortOrderList.Add(TSortOrderDescending.New(TTextKey.New('Field2'), SyntaxFormat));
  CheckEquals('Field1 ASCENDING, Field2 DESCENDING', SortOrderList.Syntax);
end;

initialization

RegisterTest(TSortOrderListTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
