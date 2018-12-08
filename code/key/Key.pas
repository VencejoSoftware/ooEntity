{$REGION 'documentation'}
{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Object to define a key
  @created(29/05/2018)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit Key;

interface

uses
  SysUtils;

type
{$REGION 'documentation'}
{
  Base class for key error object
}
{$ENDREGION}
  EKey = class(Exception)
  end;

{$REGION 'documentation'}
{
  @abstract(Key interface)
  Object to define a key
  @member(Value Generic value to implement)
}
{$ENDREGION}

  IKey<T> = interface
    ['{59CFCBBA-B675-42D7-835B-B4AC6545133E}']
    function Value: T;
  end;

{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IKey) as string data)
  @member(Value Text value of key)
}
{$ENDREGION}

  ITextKey = interface(IKey<String>)
    ['{E7EF61F2-4014-4C59-B5A8-B2FFDEB6924D}']
  end;

{$REGION 'documentation'}
{
  @abstract(Implementation of @link(ITextKey))
  Text key object
  @member(Value @SeeAlso(ITextKey.Value))
  @member(
    Create Object constructor
    @param(Value Value for the key)
  )
  @member(
    New Create a new @classname as interface
    @param(Value Value for the key)
  )
}
{$ENDREGION}

  TTextKey = class sealed(TInterfacedObject, ITextKey)
  strict private
    _Value: String;
  public
    function Value: String;
    constructor Create(const Value: String);
    class function New(const Value: String): ITextKey;
  end;

implementation

function TTextKey.Value: String;
begin
  Result := _Value;
end;

constructor TTextKey.Create(const Value: String);
begin
  if Length(Value) = 0 then
    raise EKey.Create('Text key can not be empty');
  _Value := Value;
end;

class function TTextKey.New(const Value: String): ITextKey;
begin
  Result := TTextKey.Create(Value);
end;

end.
