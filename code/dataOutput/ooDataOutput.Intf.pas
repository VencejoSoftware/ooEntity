{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooDataOutput.Intf;

interface

uses
  ooKey.Intf;

type
  IDataOutput = interface
    ['{EF379612-0C83-4422-B26D-0D3E146CDE14}']
    procedure WriteNull(const Key: IKey);
    procedure WriteInteger(const Key: IKey; const Value: Integer);
    procedure WriteBoolean(const Key: IKey; const Value: Boolean);
    procedure WriteFloat(const Key: IKey; const Value: Extended);
    procedure WriteString(const Key: IKey; const Value: String);
    procedure WriteDateTime(const Key: IKey; const Value: TDateTime);
    procedure WriteChar(const Key: IKey; const Value: Char);
  end;

implementation

end.
