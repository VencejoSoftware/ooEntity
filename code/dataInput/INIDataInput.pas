{$REGION 'documentation'}
{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Data input deserializer based on INI file
  @created(15/11/2018)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit INIDataInput;

interface

uses
  SysUtils,
  IniFiles,
  Key,
  DataInput;

type
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IDataInput))
  Use INI file as data input
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
    @param(INI TIniFile object)
    @param(Section Initial section)
  )
  @member(Destroy Object destructor to free parameter list)
  @member(
    New Create a new @classname as interface
    @param(INI TIniFile object)
    @param(Section Initial section)
  )
}
{$ENDREGION}
  TINIDataInput = class sealed(TInterfacedObject, IDataInput)
  const
    NULL = '<NULL>';
  strict private
    _INI: TIniFile;
    _OriginSection, _Section: String;
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
    constructor Create(const INI: TIniFile; const Section: String);
    class function New(const INI: TIniFile; const Section: String): IDataInput;
  end;

implementation

function TINIDataInput.ExistKey(const Key: ITextKey): Boolean;
begin
  Result := _INI.ValueExists(_Section, Key.Value);
end;

function TINIDataInput.ReadBoolean(const Key: ITextKey): Boolean;
begin
  Result := _INI.ReadBool(_Section, Key.Value, False);
end;

function TINIDataInput.ReadChar(const Key: ITextKey): Char;
begin
  Result := _INI.ReadString(_Section, Key.Value, EmptyStr)[1];
end;

function TINIDataInput.ReadDateTime(const Key: ITextKey): TDateTime;
begin
  Result := _INI.ReadDateTime(_Section, Key.Value, 0);
end;

function TINIDataInput.ReadFloat(const Key: ITextKey): Extended;
begin
  Result := _INI.ReadFloat(_Section, Key.Value, 0);
end;

function TINIDataInput.ReadInteger(const Key: ITextKey): Integer;
begin
  Result := _INI.ReadInteger(_Section, Key.Value, 0);
end;

function TINIDataInput.ReadString(const Key: ITextKey): String;
begin
  Result := _INI.ReadString(_Section, Key.Value, EmptyStr);
end;

function TINIDataInput.IsNull(const Key: ITextKey): Boolean;
begin
  Result := ReadString(Key) = NULL;
end;

procedure TINIDataInput.EnterSection(const Key: ITextKey);
begin
  _Section := Key.Value;
end;

procedure TINIDataInput.ExitSection(const Key: ITextKey);
begin
  _Section := _OriginSection;
end;

constructor TINIDataInput.Create(const INI: TIniFile; const Section: String);
begin
  _INI := INI;
  _Section := Section;
  _OriginSection := Section;
end;

class function TINIDataInput.New(const INI: TIniFile; const Section: String): IDataInput;
begin
  Result := TINIDataInput.Create(INI, Section);
end;

end.
