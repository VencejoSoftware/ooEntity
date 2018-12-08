{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit FilterJoinAnd;

interface

uses
  FilterJoin;

type
  TFilterJoinAnd = class sealed(TInterfacedObject, IFilterJoin)
  public
    function Syntax: String;
    class function New: IFilterJoin;
  end;

implementation

function TFilterJoinAnd.Syntax: String;
begin
  Result := '&';
end;

class function TFilterJoinAnd.New: IFilterJoin;
begin
  Result := TFilterJoinAnd.Create;
end;

end.
