{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit FilterJoinNot;

interface

uses
  FilterJoin;

type
  TFilterJoinNot = class sealed(TInterfacedObject, IFilterJoin)
  public
    function Syntax: String;
    class function New: IFilterJoin;
  end;

implementation

function TFilterJoinNot.Syntax: String;
begin
  Result := '!';
end;

class function TFilterJoinNot.New: IFilterJoin;
begin
  Result := TFilterJoinNot.Create;
end;

end.
