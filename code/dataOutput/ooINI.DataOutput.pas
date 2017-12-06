{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooINI.DataOutput;

interface

uses
  SysUtils,
  IniFiles,
  ooKey.Intf,
  ooDataOutput.Intf;

type
  TINIDataOutput = class sealed(TInterfacedObject, IDataOutput)
  strict private
    _Destination: TIniFile;
    _Section: String;
  public
    procedure WriteNull(const Key: IKey);
    procedure WriteInteger(const Key: IKey; const Value: Integer);
    procedure WriteBoolean(const Key: IKey; const Value: Boolean);
    procedure WriteFloat(const Key: IKey; const Value: Extended);
    procedure WriteString(const Key: IKey; const Value: String);
    procedure WriteDateTime(const Key: IKey; const Value: TDateTime);
    procedure WriteChar(const Key: IKey; const Value: Char);

    constructor Create(const Destination: TIniFile; const Section: String);

    class function New(const Destination: TIniFile; const Section: String): IDataOutput; static;
  end;

implementation

procedure TINIDataOutput.WriteBoolean(const Key: IKey; const Value: Boolean);
begin
  _Destination.WriteBool(_Section, Key.AsString, Value);
end;

procedure TINIDataOutput.WriteChar(const Key: IKey; const Value: Char);
begin
  _Destination.WriteString(_Section, Key.AsString, Value);
end;

procedure TINIDataOutput.WriteDateTime(const Key: IKey; const Value: TDateTime);
begin
  _Destination.WriteDateTime(_Section, Key.AsString, Value);
end;

procedure TINIDataOutput.WriteFloat(const Key: IKey; const Value: Extended);
begin
  _Destination.WriteFloat(_Section, Key.AsString, Value);
end;

procedure TINIDataOutput.WriteInteger(const Key: IKey; const Value: Integer);
begin
  _Destination.WriteInteger(_Section, Key.AsString, Value);
end;

procedure TINIDataOutput.WriteString(const Key: IKey; const Value: String);
begin
  _Destination.WriteString(_Section, Key.AsString, Value);
end;

procedure TINIDataOutput.WriteNull(const Key: IKey);
begin
  _Destination.DeleteKey(_Section, Key.AsString);
end;

constructor TINIDataOutput.Create(const Destination: TIniFile; const Section: String);
begin
  _Destination := Destination;
  _Section := Section;
end;

class function TINIDataOutput.New(const Destination: TIniFile; const Section: String): IDataOutput;
begin
  Result := TINIDataOutput.Create(Destination, Section);
end;

end.
