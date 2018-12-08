{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit INIDataOutput;

interface

uses
  SysUtils,
  IniFiles,
  Key,
  DataOutput;

type
  TINIDataOutput = class sealed(TInterfacedObject, IDataOutput)
  strict private
    _Destination: TIniFile;
    _OriginSection, _Section: String;
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
    constructor Create(const Destination: TIniFile; const Section: String);
    class function New(const Destination: TIniFile; const Section: String): IDataOutput; static;
  end;

implementation

procedure TINIDataOutput.WriteBoolean(const Key: ITextKey; const Value: Boolean);
begin
  _Destination.WriteBool(_Section, Key.Value, Value);
end;

procedure TINIDataOutput.WriteChar(const Key: ITextKey; const Value: Char);
begin
  _Destination.WriteString(_Section, Key.Value, Value);
end;

procedure TINIDataOutput.WriteDateTime(const Key: ITextKey; const Value: TDateTime);
begin
  _Destination.WriteDateTime(_Section, Key.Value, Value);
end;

procedure TINIDataOutput.WriteFloat(const Key: ITextKey; const Value: Extended);
begin
  _Destination.WriteFloat(_Section, Key.Value, Value);
end;

procedure TINIDataOutput.WriteInteger(const Key: ITextKey; const Value: Integer);
begin
  _Destination.WriteInteger(_Section, Key.Value, Value);
end;

procedure TINIDataOutput.WriteString(const Key: ITextKey; const Value: String);
begin
  _Destination.WriteString(_Section, Key.Value, Value);
end;

procedure TINIDataOutput.WriteNull(const Key: ITextKey);
begin
  _Destination.DeleteKey(_Section, Key.Value);
end;

procedure TINIDataOutput.EnterSection(const Key: ITextKey);
begin
  _Section := Key.Value;
end;

procedure TINIDataOutput.ExitSection(const Key: ITextKey);
begin
  _Section := _OriginSection;
end;

constructor TINIDataOutput.Create(const Destination: TIniFile; const Section: String);
begin
  _Destination := Destination;
  _Section := Section;
  _OriginSection := Section;
end;

class function TINIDataOutput.New(const Destination: TIniFile; const Section: String): IDataOutput;
begin
  Result := TINIDataOutput.Create(Destination, Section);
end;

end.
