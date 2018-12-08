{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit FilterJoinedCriteria_test;

interface

uses
  SysUtils,
  Key,
  SyntaxFormat, SyntaxFormatSymbol,
  FilterJoin, FilterJoinOr, FilterJoinAnd, FilterJoinNot,
  FilterCriteria,
  FilterCriteriaNull, FilterCriteriaEqual, FilterCriteriaBetween, FilterCriteriaList,
  FilterJoinedCriteria,
  SymbolListMock,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TFilterJoinedCriteriaTest = class sealed(TTestCase)
  strict private
    _SyntaxFormat: ISyntaxFormat;
  protected
    procedure SetUp; override;
  published
    procedure AndEqualABCIsText;
    procedure OrNotIsNull;
  end;

implementation

procedure TFilterJoinedCriteriaTest.AndEqualABCIsText;
var
  JoinedCriteria: IFilterJoinedCriteria;
begin
  JoinedCriteria := TFilterJoinedCriteria.New(_SyntaxFormat, TFilterJoinAnd.New,
    TFilterCriteriaEqual.New(_SyntaxFormat, TTextkey.New('FIELD1'), 'abc'));
  CheckEquals('& FIELD1 = abc', JoinedCriteria.Syntax);
end;

procedure TFilterJoinedCriteriaTest.OrNotIsNull;
var
  JoinedCriteria: IFilterJoinedCriteria;
begin
  JoinedCriteria := TFilterJoinedCriteria.New(_SyntaxFormat, TFilterJoinConcatenate.New(_SyntaxFormat,
    [TFilterJoinOr.New, TFilterJoinNot.New]), TFilterCriteriaNull.New(_SyntaxFormat, TTextkey.New('FIELD1')));
  CheckEquals('O ! FIELD1 IS NIL', JoinedCriteria.Syntax);
end;

procedure TFilterJoinedCriteriaTest.SetUp;
begin
  inherited;
  _SyntaxFormat := TSyntaxFormat.New(TSymbolListMock.New);
end;

initialization

RegisterTest(TFilterJoinedCriteriaTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
