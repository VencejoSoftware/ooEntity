{$REGION 'documentation'}
{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Data input deserializer based on TStrings object
  @created(15/11/2018)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit TStringsDataInput;

interface

uses
  Classes, SysUtils,
  Key,
  DataInput;

type
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IDataInput))
  Use TStrings object as data input
  @member(ExistKey @seealso(IDataInput.ExistKey))
  @member(IsNull @seealso(IDataInput.IsNull))
  @member(ReadInteger @seealso(IDataInput.ReadInteger))
  @member(ReadBoolean @seealso(IDataInput.ReadBoolean))
  @member(ReadFloat @seealso(IDataInput.ReadFloat))
  @member(ReadString @seealso(IDataInput.ReadString))
  @member(ReadDateTime @seealso(IDataInput.ReadDateTime))
  @member(ReadChar @seealso(IDataInput.ReadChar))
  @member(EnterSection @seealso(IDataInput.EnterSection))
  @member(ExitSection @seealso(IDataInput.ExitSection))
  @member(
    Create Object constructor
    @param(Strings TStrings object to deserialize)
  )
  @member(Destroy Object destructor to free parameter list)
  @member(
    New Create a new @classname as interface
    @param(Strings TStrings object to deserialize)
  )
}
{$ENDREGION}
  TTStringsDataInput = class sealed(TInterfacedObject, IDataInput)
  const
    NULL = #0;
  strict private
    _Strings: TStrings;
    _Section: String;
  public
    function ExistKey(const Key: ITextKey): Boolean;
    function IsNull(const Key: ITextKey): Boolean;
    function ReadInteger(const Key: ITextKey): Integer;
    function ReadBoolean(const Key: ITextKey): Boolean;
    function ReadFloat(const Key: ITextKey): Extended;
    function ReadString(const Key: ITextKey): String;
    function ReadDateTime(const Key: ITextKey): TDateTime;
    function ReadChar(const Key: ITextKey): Char;
    procedure EnterSection(const Key: ITextKey);
    procedure ExitSection(const Key: ITextKey);
    constructor Create(const Strings: TStrings);
    class function New(const Strings: TStrings): IDataInput;
  end;

implementation

function TTStringsDataInput.ExistKey(const Key: ITextKey): Boolean;
begin
  Result := _Strings.IndexOfName(Key.Value) > - 1;
end;

function TTStringsDataInput.ReadBoolean(const Key: ITextKey): Boolean;
begin
  Result := (ReadString(Key) <> '0');
end;

function TTStringsDataInput.ReadChar(const Key: ITextKey): Char;
begin
  Result := _Strings.Values[Key.Value][1];
end;

function TTStringsDataInput.ReadDateTime(const Key: ITextKey): TDateTime;
begin
  Result := StrToDateTime(ReadString(Key));
end;

function TTStringsDataInput.ReadFloat(const Key: ITextKey): Extended;
var
  Text: String;
begin
  Text := ReadString(Key);
  Text := StringReplace(Text, ',', FormatSettings.DecimalSeparator, [rfReplaceAll]);
  Text := StringReplace(Text, '.', FormatSettings.DecimalSeparator, [rfReplaceAll]);
  Result := StrToFloat(Text);
end;

function TTStringsDataInput.ReadInteger(const Key: ITextKey): Integer;
begin
  Result := StrToInt(ReadString(Key));
end;

function TTStringsDataInput.ReadString(const Key: ITextKey): String;
begin
  Result := _Strings.Values[_Section + Key.Value];
end;

function TTStringsDataInput.IsNull(const Key: ITextKey): Boolean;
begin
  Result := ReadString(Key) = NULL;
end;

procedure TTStringsDataInput.EnterSection(const Key: ITextKey);
begin
  _Section := _Section + Key.Value + '.';
end;

procedure TTStringsDataInput.ExitSection(const Key: ITextKey);
begin
  _Section := Copy(_Section, 1, Pred(Length(_Section) - Length(Key.Value)));
end;

constructor TTStringsDataInput.Create(const Strings: TStrings);
begin
  _Strings := Strings;
  _Section := EmptyStr;
end;

class function TTStringsDataInput.New(const Strings: TStrings): IDataInput;
begin
  Result := TTStringsDataInput.Create(Strings);
end;

end.
