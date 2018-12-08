{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit FilterJoinOr;

interface

uses
  FilterJoin;

type
  TFilterJoinOr = class sealed(TInterfacedObject, IFilterJoin)
  public
    function Syntax: String;
    class function New: IFilterJoin;
  end;

implementation

function TFilterJoinOr.Syntax: String;
begin
  Result := 'O';
end;

class function TFilterJoinOr.New: IFilterJoin;
begin
  Result := TFilterJoinOr.Create;
end;

end.
