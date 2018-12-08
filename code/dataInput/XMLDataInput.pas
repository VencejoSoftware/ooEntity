{$REGION 'documentation'}
{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Data input deserializer based on XML file
  @created(15/11/2018)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit XMLDataInput;

interface

uses
  SysUtils,
  XMLTag, XMLItem, XMLParser,
  Key,
  DataInput;

type
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IDataInput))
  Use XML file as data input
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
    FieldByKey Find field in dataset by key
    @parm(Key @link(ITextKey Key) to find)
    @returns(TField object or exception)
  )
  @member(
    Create Object constructor
    @param(Parser @link(IXMLParser XML parser))
    @parm(Tag @link(IXMLTag XML tag section))
  )
  @member(Destroy Object destructor to free parameter list)
  @member(
    New Create a new @classname as interface
    @param(Parser @link(IXMLParser XML parser))
    @parm(Tag @link(IXMLTag XML tag section))
  )
}
{$ENDREGION}
  TXMLDataInput = class sealed(TInterfacedObject, IDataInput)
  const
    NULL = '<NULL>';
  strict private
    _Parser: IXMLParser;
    _Tag: IXMLTag;
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
    constructor Create(const Parser: IXMLParser; const Tag: IXMLTag);
    class function New(const Parser: IXMLParser; const Tag: IXMLTag): IDataInput;
  end;

implementation

function TXMLDataInput.ExistKey(const Key: ITextKey): Boolean;
begin
  Result := _Parser.SubItem(TXMLTag.New(Key.Value)).Founded;
end;

function TXMLDataInput.ReadBoolean(const Key: ITextKey): Boolean;
begin
  Result := ReadInteger(Key) <> 0;
end;

function TXMLDataInput.ReadChar(const Key: ITextKey): Char;
begin
  Result := ReadString(Key)[1];
end;

function TXMLDataInput.ReadDateTime(const Key: ITextKey): TDateTime;
begin
  Result := StrToDateTime(ReadString(Key));
end;

function TXMLDataInput.ReadFloat(const Key: ITextKey): Extended;
begin
  Result := StrToFloat(ReadString(Key));
end;

function TXMLDataInput.ReadInteger(const Key: ITextKey): Integer;
begin
  Result := StrToInt(ReadString(Key));
end;

function TXMLDataInput.ReadString(const Key: ITextKey): String;
begin
  Result := _Parser.SubItem(TXMLTag.New(Key.Value)).Value;
end;

function TXMLDataInput.IsNull(const Key: ITextKey): Boolean;
begin
  Result := ReadString(Key) = NULL;
end;

procedure TXMLDataInput.EnterSection(const Key: ITextKey);
begin
// _Section := Key.Value;
end;

procedure TXMLDataInput.ExitSection(const Key: ITextKey);
begin
// _Section := _OriginSection;
end;

constructor TXMLDataInput.Create(const Parser: IXMLParser; const Tag: IXMLTag);
begin
  _Parser := Parser;
  _Tag := Tag;
end;

class function TXMLDataInput.New(const Parser: IXMLParser; const Tag: IXMLTag): IDataInput;
begin
  Result := TXMLDataInput.Create(Parser, Tag);
end;

end.
