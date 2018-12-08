{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit FilterCriteria_test;

interface

uses
  SysUtils,
  Key,
  SyntaxFormat, SyntaxFormatSymbol,
  FilterCriteria,
  FilterCriteriaNull, FilterCriteriaEqual, FilterCriteriaBetween, FilterCriteriaList,
  SymbolListMock,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TFilterCriteriaTest = class sealed(TTestCase)
  strict private
    _SyntaxFormat: ISyntaxFormat;
  protected
    procedure SetUp; override;
  published
    procedure TFilterCriteriaNullSyntaxIsField1IsNil;
    procedure TFilterCriteriaEqualSyntaxIsField1_ABC;
    procedure TFilterCriteriaBetweenSyntaxIsField1Between123and999;
    procedure TFilterCriteriaListSyntaxIsABCDEFG123;
  end;

implementation

procedure TFilterCriteriaTest.TFilterCriteriaNullSyntaxIsField1IsNil;
begin
  CheckEquals('FIELD1 IS NIL', TFilterCriteriaNull.New(_SyntaxFormat, TTextKey.New('FIELD1')).Syntax);
end;

procedure TFilterCriteriaTest.TFilterCriteriaBetweenSyntaxIsField1Between123and999;
begin
  CheckEquals('FIELD1 BETWEEN 123 & 999', TFilterCriteriaBetween.New(_SyntaxFormat, TTextKey.New('FIELD1'), 123,
    999).Syntax);
end;

procedure TFilterCriteriaTest.TFilterCriteriaEqualSyntaxIsField1_ABC;
begin
  CheckEquals('FIELD1 = ABC', TFilterCriteriaEqual.New(_SyntaxFormat, TTextKey.New('FIELD1'), 'ABC').Syntax);
end;

procedure TFilterCriteriaTest.TFilterCriteriaListSyntaxIsABCDEFG123;
begin
  CheckEquals('FIELD1 IN (A,B,C,D,E,F,G,1,2,3)', TFilterCriteriaList.New(_SyntaxFormat, TTextKey.New('FIELD1'),
    ['A', 'B', 'C', 'D', 'E', 'F', 'G', '1', '2', '3']).Syntax);
end;

procedure TFilterCriteriaTest.SetUp;
begin
  inherited;
  _SyntaxFormat := TSyntaxFormat.New(TSymbolListMock.New);
end;

initialization

RegisterTest(TFilterCriteriaTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
