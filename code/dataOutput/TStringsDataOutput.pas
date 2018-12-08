{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit TStringsDataOutput;

interface

uses
  Classes, SysUtils,
  Key,
  DataOutput;

type
  TTStringsDataOutput = class sealed(TInterfacedObject, IDataOutput)
  strict private
    _Destination: TStrings;
    _Section: String;
  public
    procedure WriteNull(const Key: ITextKey);
    procedure WriteInteger(const Key: ITextKey; const Value: Integer);
    procedure WriteBoolean(const Key: ITextKey; const Value: Boolean);
    procedure WriteFloat(const Key: ITextKey; const Value: Extended);
    procedure WriteString(const Key: ITextKey; const Value: String);
    procedure WriteDateTime(const Key: ITextKey; const Value: TDateTime);
    procedure WriteChar(const Key: ITextKey; const Value: Char);
    procedure EnterSection(const Key: ITextKey);
    procedure ExitSection(const Key: ITextKey);
    constructor Create(const Destination: TStrings);
    class function New(const Destination: TStrings): IDataOutput;
  end;

implementation

procedure TTStringsDataOutput.WriteBoolean(const Key: ITextKey; const Value: Boolean);
const
  BOOL_VALUE: array [Boolean] of Char = ('0', '1');
begin
  WriteString(Key, BOOL_VALUE[Value]);
end;

procedure TTStringsDataOutput.WriteChar(const Key: ITextKey; const Value: Char);
begin
  WriteString(Key, Value);
end;

procedure TTStringsDataOutput.WriteDateTime(const Key: ITextKey; const Value: TDateTime);
begin
  WriteString(Key, DateTimeToStr(Value));
end;

procedure TTStringsDataOutput.WriteFloat(const Key: ITextKey; const Value: Extended);
begin
  WriteString(Key, FloatToStr(Value));
end;

procedure TTStringsDataOutput.WriteInteger(const Key: ITextKey; const Value: Integer);
begin
  WriteString(Key, IntToStr(Value));
end;

procedure TTStringsDataOutput.WriteString(const Key: ITextKey; const Value: String);
var
  ExistIndex: Integer;
begin
  ExistIndex := _Destination.IndexOfName(_Section + Key.Value);
  if ExistIndex = - 1 then
    _Destination.Append(_Section + Key.Value + '=' + Value)
  else
    _Destination.ValueFromIndex[ExistIndex] := Value;
end;

procedure TTStringsDataOutput.WriteNull(const Key: ITextKey);
begin
  WriteString(Key, #0);
end;

procedure TTStringsDataOutput.EnterSection(const Key: ITextKey);
begin
  _Section := _Section + Key.Value + '.';
end;

procedure TTStringsDataOutput.ExitSection(const Key: ITextKey);
begin
  _Section := Copy(_Section, 1, Pred(Length(_Section) - Length(Key.Value)));
end;

constructor TTStringsDataOutput.Create(const Destination: TStrings);
begin
  _Destination := Destination;
  _Section := EmptyStr;
end;

class function TTStringsDataOutput.New(const Destination: TStrings): IDataOutput;
begin
  Result := TTStringsDataOutput.Create(Destination);
end;

end.
