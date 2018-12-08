{$REGION 'documentation'}
{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Object to define a criteria filter with a join object
  @created(29/05/2018)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit FilterJoinedCriteria;

interface

uses
  SyntaxFormat,
  Key,
  Statement,
  FilterJoin,
  FilterCriteria;

type
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IStatement))
  Object to define a criteria filter with a join object
}
{$ENDREGION}
  IFilterJoinedCriteria = interface(IStatement)
    ['{A43E1F2B-4124-4A4A-8914-DA19FBD53487}']
  end;

{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IFilterJoinedCriteria))
  @member(Syntax @SeeAlso(IFilterJoinedCriteria.Syntax))
  @member(
    Create Object constructor
    @param(SyntaxFormat @link(ISyntaxFormat syntax formatter))
    @param(Join @link(IFilterJoin join object))
    @param(Criteria @link(IFilterCriteria criteria object))
  )
  @member(
    New Create a new @classname as interface
    @param(SyntaxFormat @link(ISyntaxFormat syntax formatter))
    @param(Join @link(IFilterJoin join object))
    @param(Criteria @link(IFilterCriteria criteria object))
  )
}
{$ENDREGION}

  TFilterJoinedCriteria = class sealed(TInterfacedObject, IFilterJoinedCriteria)
  strict private
    _SyntaxFormat: ISyntaxFormat;
    _Join: IFilterJoin;
    _Criteria: IFilterCriteria;
  public
    function Syntax: String;
    constructor Create(const SyntaxFormat: ISyntaxFormat; const Join: IFilterJoin; const Criteria: IFilterCriteria);
    class function New(const SyntaxFormat: ISyntaxFormat; const Join: IFilterJoin; const Criteria: IFilterCriteria)
      : IFilterJoinedCriteria;
  end;

implementation

function TFilterJoinedCriteria.Syntax: String;
begin
  Result := _SyntaxFormat.ItemsFormat([_Join.Syntax, _Criteria.Syntax], [Spaced]);
end;

constructor TFilterJoinedCriteria.Create(const SyntaxFormat: ISyntaxFormat; const Join: IFilterJoin;
  const Criteria: IFilterCriteria);
begin
  _SyntaxFormat := SyntaxFormat;
  _Join := Join;
  _Criteria := Criteria;
end;

class function TFilterJoinedCriteria.New(const SyntaxFormat: ISyntaxFormat; const Join: IFilterJoin;
  const Criteria: IFilterCriteria): IFilterJoinedCriteria;
begin
  Result := TFilterJoinedCriteria.Create(SyntaxFormat, Join, Criteria);
end;

end.
