unit Value;

interface

uses
  SysUtils, AnsiStrings;

type
  IValue = interface
    ['{DE71125B-F177-4320-A8D8-783041456069}']
    function Content: TVarRec;
    function ToString: string;
    function IsEmpty: Boolean;
  end;

  TValue = class sealed(TInterfacedObject, IValue)
  strict private
    _Content: TVarRec;
  private
    function CloneVarRec(const Item: TVarRec): TVarRec;
    procedure FreeVarRec(const Item: TVarRec);
  public
    function Content: TVarRec;
    function ToString: string; reintroduce;
    function IsEmpty: Boolean;
    constructor Create(const Content: TVarRec);
    destructor Destroy; override;
    class function New(const Content: TVarRec): IValue;
    class function NewByVariant(const Value: Variant): IValue;
    class function NewByString(const Value: WideString): IValue;
    class function NewByInt(const Value: Int64): IValue;
    class function NewByFloat(const Value: Extended): IValue;
    class function NewByBoolean(const Value: Boolean): IValue;
    class function NewByDateTime(const Value: TDateTime): IValue;
  end;

implementation

procedure TValue.FreeVarRec(const Item: TVarRec);
begin
  case Item.VType of
    vtExtended:
      Dispose(Item.VExtended);
    vtString:
      Dispose(Item.VString);
    vtCurrency:
      Dispose(Item.VCurrency);
    vtVariant:
      Dispose(Item.VVariant);
    vtInt64:
      Dispose(Item.VInt64);
  end;
end;

function TValue.CloneVarRec(const Item: TVarRec): TVarRec;
var
  W: WideString;
begin
  Result := Item;
  case Item.VType of
    vtExtended:
      begin
        System.New(Result.VExtended);
        Result.VExtended^ := Item.VExtended^;
      end;
    vtString:
      begin
        System.New(Result.VString);
        Result.VString^ := Item.VString^;
      end;
    vtPChar:
      Result.VPChar := AnsiStrings.StrNew(Item.VPChar);
    vtPWideChar:
      begin
        W := Item.VPWideChar;
        GetMem(Result.VPWideChar, (Length(W) + 1) * SizeOf(widechar));
        Move(PWideChar(W)^, Result.VPWideChar^, (Length(W) + 1) * SizeOf(widechar));
      end;
    vtAnsiString:
      begin
        Result.VAnsiString := nil;
        string(Result.VAnsiString) := string(Item.VAnsiString);
      end;
    vtCurrency:
      begin
        System.New(Result.VCurrency);
        Result.VCurrency^ := Item.VCurrency^;
      end;
    vtVariant:
      begin
        System.New(Result.VVariant);
        Result.VVariant^ := Item.VVariant^;
      end;
    vtInterface:
      begin
        Result.VInterface := nil;
        IInterface(Result.VInterface) := IInterface(Item.VInterface);
      end;
    vtWideString:
      begin
        Result.VWideString := nil;
        WideString(Result.VWideString) := WideString(Item.VWideString);
      end;
    vtUnicodeString:
      begin
        Result.VUnicodeString := nil;
        UnicodeString(Result.VUnicodeString) := UnicodeString(Item.VUnicodeString);
      end;
    vtInt64:
      begin
        System.New(Result.VInt64);
        Result.VInt64^ := Item.VInt64^;
      end;
    // VPointer and VObject don't have proper copy semantics so it
    // is impossible to write generic code that copies the contents
  end;
end;

function TValue.Content: TVarRec;
begin
  Result := _Content;
end;

function TValue.ToString: string;
const
  BOOLEAN_TEXT: array [Boolean] of string = ('0', '-1');
begin
  case _Content.VType of
    vtInteger:
      Result := IntToStr(_Content.VInteger);
    vtBoolean:
      Result := BOOLEAN_TEXT[_Content.VBoolean];
    vtChar:
      Result := String(_Content.VChar);
    vtExtended:
      Result := FloatToStr(_Content.VExtended^);
    vtString:
      Result := String(_Content.VString^);
    vtPChar:
      Result := String(AnsiStrings.StrPas(_Content.VPChar));
    vtInt64:
      Result := IntToStr(_Content.VInt64^);
    vtObject:
      Result := _Content.VObject.ClassName;
    vtClass:
      Result := _Content.VClass.ClassName;
    vtAnsiString:
      Result := string(PAnsiString(_Content.VAnsiString));
    vtCurrency:
      Result := CurrToStr(_Content.VCurrency^);
    vtVariant:
      Result := string(_Content.VVariant^);
    vtWideString:
      Result := string(WideString(_Content.VWideString));
    vtUnicodeString:
      Result := string(UnicodeString(_Content.VUnicodeString));
  else
    Result := EmptyStr;
  end;
end;

function TValue.IsEmpty: Boolean;
begin
  Result := Length(ToString) < 1;
end;

constructor TValue.Create(const Content: TVarRec);
begin
  _Content := CloneVarRec(Content);
end;

destructor TValue.Destroy;
begin
  FreeVarRec(_Content);
  inherited;
end;

class function TValue.New(const Content: TVarRec): IValue;
begin
  Result := Create(Content);
end;

class function TValue.NewByVariant(const Value: Variant): IValue;
var
  VarRec: TVarRec;
begin
  System.New(VarRec.VVariant);
  VarRec.VType := vtVariant;
  VarRec.VVariant^ := Value;
  Result := TValue.New(VarRec);
end;

class function TValue.NewByString(const Value: WideString): IValue;
var
  VarRec: TVarRec;
begin
  System.New(VarRec.VWideString);
  VarRec.VType := vtWideString;
  WideString(VarRec.VWideString) := Value;
  Result := TValue.New(VarRec);
end;

class function TValue.NewByInt(const Value: Int64): IValue;
var
  VarRec: TVarRec;
begin
  System.New(VarRec.VInt64);
  VarRec.VType := vtInt64;
  VarRec.VInt64^ := Value;
  Result := TValue.New(VarRec);
  Dispose(VarRec.VInt64);
end;

class function TValue.NewByFloat(const Value: Extended): IValue;
var
  VarRec: TVarRec;
begin
  System.New(VarRec.VExtended);
  VarRec.VType := vtExtended;
  VarRec.VExtended^ := Value;
  Result := TValue.New(VarRec);
  Dispose(VarRec.VExtended);
end;

class function TValue.NewByBoolean(const Value: Boolean): IValue;
var
  VarRec: TVarRec;
begin
  VarRec.VType := vtBoolean;
  VarRec.VBoolean := Value;
  Result := TValue.New(VarRec);
end;

class function TValue.NewByDateTime(const Value: TDateTime): IValue;
begin
  Result := TValue.NewByFloat(Value);
end;

end.
