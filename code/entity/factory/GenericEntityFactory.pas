unit GenericEntityFactory;

interface

uses
  DB,
  Entity;

type
  IGenericEntityFactory<I: IEntity; IL: IEntityList<I> { } > = interface
    ['{620FD42B-A161-426B-8510-F8DFD217A041}']
    function Build(const Dataset: TDataSet): I;
    function BuildList(const Dataset: TDataSet; const List: IL): Boolean;
  end;

implementation

end.
