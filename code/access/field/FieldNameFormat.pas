unit FieldNameFormat;

interface

uses
  SysUtils;

type
  IFieldNameFormat = interface
    ['{16D21145-F887-463C-ACC8-60F9790B7040}']
    function GetName(const FieldName: String): String;
  end;

  TFieldNameFormat = class sealed(TInterfacedObject, IFieldNameFormat)
  strict private
    _ReservedFields: array of string;
    _NameDelimiter: String;
  public
    function GetName(const FieldName: String): String;
    constructor Create(const ReservedFields: array of string; const NameDelimiter: String);
    class function New: IFieldNameFormat;
  end;

implementation

function TFieldNameFormat.GetName(const FieldName: String): String;
var
  ReservedField: String;
begin
  Result := FieldName;
  for ReservedField in _ReservedFields do
    if SameText(Result, ReservedField) then
      Exit(_NameDelimiter + Result + _NameDelimiter);
end;

constructor TFieldNameFormat.Create(const ReservedFields: array of string; const NameDelimiter: String);
var
  i: Integer;
begin
  SetLength(_ReservedFields, Length(ReservedFields));
  for i := 0 to high(_ReservedFields) do
    _ReservedFields[i] := ReservedFields[i];
  _NameDelimiter := NameDelimiter;
end;

class function TFieldNameFormat.New: IFieldNameFormat;
const
  RESERVED_FIELDS: array [0 .. 1] of string = ('USER', 'PASSWORD');
begin
  Result := Create(RESERVED_FIELDS, '"');
end;

end.
