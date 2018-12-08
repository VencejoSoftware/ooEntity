{$REGION 'documentation'}
{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Object statement
  @created(29/05/2018)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit Statement;

interface

type
{$REGION 'documentation'}
{
  @abstract(Statement interface)
  @member(
    Syntax Resolve as text
    @return(String with syntax)
  )
}
{$ENDREGION}
  IStatement = interface
    ['{5293668F-F38E-4170-AC79-EB9AE7A7F663}']
    function Syntax: String;
  end;

implementation

end.
