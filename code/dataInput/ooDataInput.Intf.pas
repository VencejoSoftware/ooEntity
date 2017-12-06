{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooDataInput.Intf;

interface

uses
  ooKey.Intf;

type
  IDataInput = interface
    ['{19E43F82-A04B-42A2-9886-C41B08CEBCF6}']
    function IsNull(const Key: IKey): Boolean;
    function ReadInteger(const Key: IKey): Integer;
    function ReadBoolean(const Key: IKey): Boolean;
    function ReadFloat(const Key: IKey): Extended;
    function ReadString(const Key: IKey): String;
    function ReadDateTime(const Key: IKey): TDateTime;
    function ReadChar(const Key: IKey): Char;
  end;

implementation

end.
