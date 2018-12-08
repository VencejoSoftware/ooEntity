{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit DataOutput;

interface

uses
  Key;

type
  IDataOutput = interface
    ['{EF379612-0C83-4422-B26D-0D3E146CDE14}']
    procedure WriteNull(const Key: ITextKey);
    procedure WriteInteger(const Key: ITextKey; const Value: Integer);
    procedure WriteBoolean(const Key: ITextKey; const Value: Boolean);
    procedure WriteFloat(const Key: ITextKey; const Value: Extended);
    procedure WriteString(const Key: ITextKey; const Value: String);
    procedure WriteDateTime(const Key: ITextKey; const Value: TDateTime);
    procedure WriteChar(const Key: ITextKey; const Value: Char);
    procedure EnterSection(const Key: ITextKey);
    procedure ExitSection(const Key: ITextKey);
  end;

implementation

end.
