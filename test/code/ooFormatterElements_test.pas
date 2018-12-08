{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooFormatterElements_test;

interface

uses
  ooFormatterElements,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TFormatterElementsTest = class sealed(TTestCase)
  strict private
    _Elements: IFormatterElements;
  protected
    procedure SetUp; override;
  published
    procedure AddNonExistentElementIsOk;
    procedure AddExistentElementRaisedError;
    procedure SymbolSeparatorIsComa;
    procedure SymbolSpaceRaisedError;
  end;

implementation

procedure TFormatterElementsTest.AddNonExistentElementIsOk;
begin
  _Elements.Add(TFormatterSymbol.New(Space, ' '));
  CheckEquals(' ', _Elements.Symbol(TFormatterSymbolID.Space));
end;

procedure TFormatterElementsTest.AddExistentElementRaisedError;
var
  Failed: Boolean;
begin
  Failed := False;
  try
    _Elements.Add(TFormatterSymbol.New(TFormatterSymbolID.DelimiterStart, '#'));
  except
    on E: EFormatterSymbol do
    begin
      Failed := True;
      CheckEquals('Symbol "DelimiterStart" is duplicated', E.Message);
    end;
  end;
  CheckTrue(Failed);
end;

procedure TFormatterElementsTest.SymbolSeparatorIsComa;
begin
  CheckEquals(',', _Elements.Symbol(TFormatterSymbolID.Separator));
end;

procedure TFormatterElementsTest.SymbolSpaceRaisedError;
var
  Failed: Boolean;
begin
  Failed := False;
  try
    _Elements.Symbol(TFormatterSymbolID.Space);
  except
    on E: EFormatterSymbol do
    begin
      Failed := True;
      CheckEquals('Symbol "Space" not founded', E.Message);
    end;
  end;
  CheckTrue(Failed);
end;

procedure TFormatterElementsTest.SetUp;
begin
  inherited;
  _Elements := TFormatterElements.New;
  _Elements.Add(TFormatterSymbol.New(TFormatterSymbolID.Separator, ','));
  _Elements.Add(TFormatterSymbol.New(TFormatterSymbolID.DelimiterStart, '"'));
  _Elements.Add(TFormatterSymbol.New(TFormatterSymbolID.DelimiterFinish, '"'));
  _Elements.Add(TFormatterSymbol.New(TFormatterSymbolID.Margin, #9));
end;

initialization

RegisterTest(TFormatterElementsTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
