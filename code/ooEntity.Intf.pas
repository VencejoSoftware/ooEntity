{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooEntity.Intf;

interface

uses
  SysUtils,
  ooDataInput.Intf, ooDataOutput.Intf;

type
  EEntity = class(Exception)
  end;

  IEntity = interface
    ['{63A96518-FB37-4B3E-9B6E-2937196DA74E}']
    function Marshal(const DataOutput: IDataOutput): Boolean;
    function Unmarshal(const DataInput: IDataInput): Boolean;
  end;

implementation

end.
