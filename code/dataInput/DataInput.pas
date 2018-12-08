{$REGION 'documentation'}
{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Data input deserializer
  @created(15/11/2018)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit DataInput;

interface

uses
  Key;

type
{$REGION 'documentation'}
{
  @abstract(Data input deserializer)
  Manage methods to read/deserealize a content data
  @member(
    ExistKey Checks if a specific key exists in the content data
    @param(Key @link(ITextKey Key) to check)
    @returns(@true if the key exists, @false if not)
  )
  @member(
    IsNull Validate if data is null
    @param(Key @link(ITextKey Key) to use)
    @returns(@true if the data is null, @false if not)
  )
  @member(
    ReadInteger Read data from key as integer
    @param(Key @link(ITextKey Key) to use)
    @returns(Integer value)
  )
  @member(
    ReadBoolean Read data from key as boolean
    @param(Key @link(ITextKey Key) to use)
    @returns(@false if value is 0, else @true)
  )
  @member(
    ReadFloat Read data from key as float point
    @param(Key @link(ITextKey Key) to use)
    @returns(Extended value)
  )
  @member(
    ReadString Read data from key as string
    @param(Key @link(ITextKey Key) to use)
    @returns(String value)
  )
  @member(
    ReadDateTime Read data from key as datetime
    @param(Key @link(ITextKey Key) to use)
    @returns(TDateTime value)
  )
  @member(
    ReadChar Read data from key as simple char
    @param(Key @link(ITextKey Key) to use)
    @returns(Char value)
  )
  @member(
    EnterSection Redirect the current section of data content
    @param(Key Section @link(ITextKey key) name)
  )
  @member(
    ExitSection Exit of key entered section
    @param(Key Section @link(ITextKey key) name)
  )
}
{$ENDREGION}
  IDataInput = interface
    ['{19E43F82-A04B-42A2-9886-C41B08CEBCF6}']
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
  end;

implementation

end.
