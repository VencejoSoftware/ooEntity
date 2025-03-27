unit ValueFormat;

interface

uses
  SysUtils,
  Value, ValueArray;

type
  IValueFormat = interface
    ['{1D738539-F210-4421-A6F0-949BFBD5A10A}']
    function Parse(const Value: IValue): String;
  end;

  TValueFormat = class(TInterfacedObject, IValueFormat)
  public
    function Parse(const Value: IValue): String; virtual; abstract;
    class function New: IValueFormat;
  end;

  TUnknownValueFormat = class sealed(TValueFormat, IValueFormat)
  public
    function Parse(const Value: IValue): String; override;
  end;

  TTextValueFormat = class sealed(TValueFormat, IValueFormat)
  public
    function Parse(const Value: IValue): String; override;
  end;

  TNumericValueFormat = class sealed(TValueFormat, IValueFormat)
  public
    function Parse(const Value: IValue): String; override;
  end;

  TFloatValueFormat = class sealed(TValueFormat, IValueFormat)
  public
    function Parse(const Value: IValue): String; override;
  end;

  TDateValueFormat = class sealed(TValueFormat, IValueFormat)
  public
    function Parse(const Value: IValue): String; override;
  end;

  TTimeValueFormat = class sealed(TValueFormat, IValueFormat)
  public
    function Parse(const Value: IValue): String; override;
  end;

  TDateTimeValueFormat = class sealed(TValueFormat, IValueFormat)
  public
    function Parse(const Value: IValue): String; override;
  end;

  TLogicValueFormat = class sealed(TValueFormat, IValueFormat)
  public
    function Parse(const Value: IValue): String; override;
  end;

  TListValueFormat = class sealed(TValueFormat, IValueFormat)
  strict private
    _ValueFormat: IValueFormat;
  public
    function Parse(const Value: IValue): String; override;
    constructor Create(const ValueFormat: IValueFormat);
    class function New(const ValueFormat: IValueFormat): IValueFormat;
  end;

implementation

{ TValueFormat }

class function TValueFormat.New: IValueFormat;
begin
  Result := Create;
end;

{ TUnknownFormat }

function TUnknownValueFormat.Parse(const Value: IValue): String;
begin
  Result := Value.ToString;
end;

{ TTextFormat }

function TTextValueFormat.Parse(const Value: IValue): String;
begin
  Result := QuotedStr(Value.ToString);
end;

{ TNumericFormat }

function TNumericValueFormat.Parse(const Value: IValue): String;
begin
  Result := Value.ToString;
end;

{ TFloatFormat }

function TFloatValueFormat.Parse(const Value: IValue): String;
begin
  Result := Value.ToString;
  Result := StringReplace(Result, FormatSettings.DecimalSeparator, '.', [rfReplaceAll]);
end;

{ TDateFormat }

function TDateValueFormat.Parse(const Value: IValue): String;
var
  DateValue: TDateTime;
begin
  DateValue := StrToFloatDef(Value.ToString, 0);
  Result := FormatDateTime('mm/dd/yyyy', DateValue);
  Result := QuotedStr(Result);
end;

{ TTimeFormat }

function TTimeValueFormat.Parse(const Value: IValue): String;
var
  TimeValue: TDateTime;
begin
  TimeValue := StrToFloatDef(Value.ToString, 0);
  Result := FormatDateTime('hh:mm:ss', TimeValue);
  Result := QuotedStr(Result);
end;

{ TDateTimeFormat }

function TDateTimeValueFormat.Parse(const Value: IValue): String;
var
  DateTimeValue: TDateTime;
begin
  DateTimeValue := StrToFloatDef(Value.ToString, 0);
  Result := FormatDateTime('mm/dd/yyyy hh:mm:ss', DateTimeValue);
  Result := QuotedStr(Result);
end;

{ TLogicFormat }

function TLogicValueFormat.Parse(const Value: IValue): String;
begin
  if Value.Content.VBoolean then
    Result := '-1'
  else
    Result := '0';
end;

{ TValueArrayFormat }

function TListValueFormat.Parse(const Value: IValue): String;
var
  ValueArray: IValueArray;
  Item: IValue;
begin
  if Assigned(_ValueFormat) and Supports(Value, IValueArray) then
  begin
    ValueArray := IValueArray(Value);
    Result := EmptyStr;
    for Item in ValueArray.ValueList do
    begin
      if Result <> EmptyStr then
        Result := Result + ValueArray.Concatenator;
      Result := Result + _ValueFormat.Parse(Item);
    end;
  end
  else
    Result := Value.ToString;
  Result := '(' + Result + ')';
end;

constructor TListValueFormat.Create(const ValueFormat: IValueFormat);
begin
  _ValueFormat := ValueFormat;
end;

class function TListValueFormat.New(const ValueFormat: IValueFormat): IValueFormat;
begin
  Result := Create(ValueFormat);
end;

end.
