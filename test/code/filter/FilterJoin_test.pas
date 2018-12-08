{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit FilterJoin_test;

interface

uses
  SysUtils,
  SyntaxFormat, SyntaxFormatSymbol,
  FilterJoinOr, FilterJoinAnd, FilterJoinNot,
  FilterJoin,
  SymbolListMock,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TFilterJoinTest = class sealed(TTestCase)
  published
    procedure TFilterJoinNoneHasEmptySintax;
    procedure TFilterJoinConcatenateResultText;
  end;

implementation

procedure TFilterJoinTest.TFilterJoinConcatenateResultText;
var
  JoinConcatenate: IFilterJoin;
  SyntaxFormat: ISyntaxFormat;
begin
  SyntaxFormat := TSyntaxFormat.New(TSymbolListMock.New);
  JoinConcatenate := TFilterJoinConcatenate.New(SyntaxFormat, [TFilterJoinAnd.New, TFilterJoinNot.New]);
  CheckEquals('& !', JoinConcatenate.Syntax);
end;

procedure TFilterJoinTest.TFilterJoinNoneHasEmptySintax;
begin
  CheckEquals(EmptyStr, TFilterJoinNone.New.Syntax);
end;

initialization

RegisterTest(TFilterJoinTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
