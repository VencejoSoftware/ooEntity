{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooTStrings.DataInput;

interface

uses
  Classes, SysUtils,
  ooKey.Intf,
  ooDataInput.Intf;

type
  TTStringsDataInput = class sealed(TInterfacedObject, IDataInput)
  strict private
    _Source: TStrings;
  public
    function IsNull(const Key: IKey): Boolean;
    function ReadInteger(const Key: IKey): Integer;
    function ReadBoolean(const Key: IKey): Boolean;
    function ReadFloat(const Key: IKey): Extended;
    function ReadString(const Key: IKey): String;
    function ReadDateTime(const Key: IKey): TDateTime;
    function ReadChar(const Key: IKey): Char;

    constructor Create(const Source: TStrings);
    class function New(const Source: TStrings): IDataInput;
  end;

implementation

function TTStringsDataInput.ReadBoolean(const Key: IKey): Boolean;
begin
  Result := (ReadString(Key) <> '0');
end;

function TTStringsDataInput.ReadChar(const Key: IKey): Char;
begin
  Result := _Source.Values[Key.AsString][1];
end;

function TTStringsDataInput.ReadDateTime(const Key: IKey): TDateTime;
begin
  Result := StrToDateTime(ReadString(Key));
end;

function TTStringsDataInput.ReadFloat(const Key: IKey): Extended;
begin
  Result := StrToFloat(ReadString(Key));
end;

function TTStringsDataInput.ReadInteger(const Key: IKey): Integer;
begin
  Result := StrToInt(ReadString(Key));
end;

function TTStringsDataInput.ReadString(const Key: IKey): String;
begin
  Result := _Source.Values[Key.AsString];
end;

function TTStringsDataInput.IsNull(const Key: IKey): Boolean;
begin
  Result := ReadString(Key) = #0;
end;

constructor TTStringsDataInput.Create(const Source: TStrings);
begin
  _Source := Source;
end;

class function TTStringsDataInput.New(const Source: TStrings): IDataInput;
begin
  Result := TTStringsDataInput.Create(Source);
end;

end.
