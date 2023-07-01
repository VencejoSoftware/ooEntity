unit NameableRepository;

interface

uses
  EntityRepository,
  NameableEntity;

type
  INameableRepository<I: INameableEntity; IL: INameableEntityList<I> { } > = interface(IEntityRepository<I, IL>)
    ['{261D254A-354C-44BB-A197-4365761FC277}']
  end;

  TNameableRepository<I: INameableEntity; IL: INameableEntityList<I> { } > = class(TEntityRepository<I, IL>,
    INameableRepository<I, IL>)
  end;

implementation

end.
