{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooINI.DataInput;

interface

uses
  SysUtils,
  IniFiles,
  ooKey.Intf,
  ooDataInput.Intf;

type
  TINIDataInput = class sealed(TInterfacedObject, IDataInput)
  strict private
    _Source: TIniFile;
    _Section: String;
  public
    function IsNull(const Key: IKey): Boolean;
    function ReadInteger(const Key: IKey): Integer;
    function ReadBoolean(const Key: IKey): Boolean;
    function ReadFloat(const Key: IKey): Extended;
    function ReadString(const Key: IKey): String;
    function ReadDateTime(const Key: IKey): TDateTime;
    function ReadChar(const Key: IKey): Char;

    constructor Create(const Source: TIniFile; const Section: String);

    class function New(const Source: TIniFile; const Section: String): IDataInput;
  end;

implementation

function TINIDataInput.ReadBoolean(const Key: IKey): Boolean;
begin
  Result := _Source.ReadBool(_Section, Key.AsString, False);
end;

function TINIDataInput.ReadChar(const Key: IKey): Char;
begin
  Result := _Source.ReadString(_Section, Key.AsString, EmptyStr)[1];
end;

function TINIDataInput.ReadDateTime(const Key: IKey): TDateTime;
begin
  Result := _Source.ReadDateTime(_Section, Key.AsString, 0);
end;

function TINIDataInput.ReadFloat(const Key: IKey): Extended;
begin
  Result := _Source.ReadFloat(_Section, Key.AsString, 0);
end;

function TINIDataInput.ReadInteger(const Key: IKey): Integer;
begin
  Result := _Source.ReadInteger(_Section, Key.AsString, 0);
end;

function TINIDataInput.ReadString(const Key: IKey): String;
begin
  Result := _Source.ReadString(_Section, Key.AsString, EmptyStr);
end;

function TINIDataInput.IsNull(const Key: IKey): Boolean;
begin
  Result := not _Source.ValueExists(_Section, Key.AsString);
end;

constructor TINIDataInput.Create(const Source: TIniFile; const Section: String);
begin
  _Source := Source;
  _Section := Section;
end;

class function TINIDataInput.New(const Source: TIniFile; const Section: String): IDataInput;
begin
  Result := TINIDataInput.Create(Source, Section);
end;

end.
