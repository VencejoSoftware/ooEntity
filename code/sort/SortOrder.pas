{$REGION 'documentation'}
{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Object to define a sort order
  @created(29/05/2018)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit SortOrder;

interface

uses
  Key,
  Statement;

type
{$REGION 'documentation'}
{
  Enum for sort order direction
  @value None Direction is not setted
  @value Ascending Ascending direction
  @value Descending Descending direction
}
{$ENDREGION}
  TSortDirection = (None, Ascending, Descending);

{$REGION 'documentation'}
{
  @abstract(Sort order interface)
  Object to define a sort order
  @member(Key @link(ITextKey key to use when parse sort order))
  @member(Direction Indicates the order direction)
}
{$ENDREGION}

  ISortOrder = interface(IStatement)
    ['{2355162C-BE6C-4FC8-B4D6-D747F2FD7AEC}']
    function Key: ITextKey;
    function Direction: TSortDirection;
  end;

{$REGION 'documentation'}
{
  @abstract(Implementation of @link(ISortOrder))
  @member(Key @SeeAlso(ISortOrder.Key))
  @member(Direction @SeeAlso(ISortOrder.Direction))
  @member(Syntax @SeeAlso(IStatement.Syntax))
  @member(
    Create Object constructor
    @param(Key @link(ITextKey key to use when parse sort order))
    @param(Direction Indicates the order direction)
  )
  @member(
    New Create a new @classname as interface
    @param(Key @link(ITextKey key to use when parse sort order))
    @param(Direction Indicates the order direction)
  )
}
{$ENDREGION}

  TSortOrder = class sealed(TInterfacedObject, ISortOrder)
  strict private
    _Key: ITextKey;
    _Direction: TSortDirection;
  public
    function Key: ITextKey;
    function Direction: TSortDirection;
    function Syntax: String;
    constructor Create(const Key: ITextKey; const Direction: TSortDirection);
    class function New(const Key: ITextKey; const Direction: TSortDirection): ISortOrder;
  end;

implementation

function TSortOrder.Key: ITextKey;
begin
  Result := _Key;
end;

function TSortOrder.Direction: TSortDirection;
begin
  Result := _Direction;
end;

function TSortOrder.Syntax: String;
begin
  Result := '';
end;

constructor TSortOrder.Create(const Key: ITextKey; const Direction: TSortDirection);
begin
  _Key := Key;
  _Direction := Direction;
end;

class function TSortOrder.New(const Key: ITextKey; const Direction: TSortDirection): ISortOrder;
begin
  Result := TSortOrder.Create(Key, Direction);
end;

end.
