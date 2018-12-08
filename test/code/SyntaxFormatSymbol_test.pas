{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit SyntaxFormatSymbol_test;

interface

uses
  SyntaxFormatSymbol,
  SymbolListMock,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TSyntaxFormatSymbolListTest = class sealed(TTestCase)
  strict private
    _SymbolList: ISyntaxFormatSymbolList;
  protected
    procedure SetUp; override;
  published
    procedure AddNonExistentElementIsOk;
    procedure AddExistentElementRaisedError;
    procedure SymbolSeparatorIsComa;
    procedure SymbolNoneRaisedError;
  end;

implementation

procedure TSyntaxFormatSymbolListTest.AddNonExistentElementIsOk;
begin
  _SymbolList.Add(TSyntaxFormatSymbol.New(None, ''));
  CheckEquals('', _SymbolList.Symbol(TSyntaxFormatSymbolCode.None));
end;

procedure TSyntaxFormatSymbolListTest.AddExistentElementRaisedError;
var
  Failed: Boolean;
begin
  Failed := False;
  try
    _SymbolList.Add(TSyntaxFormatSymbol.New(TSyntaxFormatSymbolCode.DelimiterStarter, '#'));
  except
    on E: ESyntaxFormatSymbol do
    begin
      Failed := True;
      CheckEquals('Symbol "DelimiterStarter" is duplicated', E.Message);
    end;
  end;
  CheckTrue(Failed);
end;

procedure TSyntaxFormatSymbolListTest.SymbolSeparatorIsComa;
begin
  CheckEquals(',', _SymbolList.Symbol(TSyntaxFormatSymbolCode.Separator));
end;

procedure TSyntaxFormatSymbolListTest.SymbolNoneRaisedError;
var
  Failed: Boolean;
begin
  Failed := False;
  try
    _SymbolList.Symbol(TSyntaxFormatSymbolCode.None);
  except
    on E: ESyntaxFormatSymbol do
    begin
      Failed := True;
      CheckEquals('Symbol "None" not founded', E.Message);
    end;
  end;
  CheckTrue(Failed);
end;

procedure TSyntaxFormatSymbolListTest.SetUp;
begin
  inherited;
  _SymbolList := TSymbolListMock.New
end;

initialization

RegisterTest(TSyntaxFormatSymbolListTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
