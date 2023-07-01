unit NameableEntityService;

interface

uses
  EntityService,
  NameableEntity, NameableRepository;

type
  INameableEntityService<I: INameableEntity; IL: INameableEntityList<I> { } > = interface(IEntityService<I, IL>)
    ['{CEAAAC66-939B-411F-9313-01B1CA9B7B1E}']
  end;

  TNameableEntityService<I: INameableEntity; IL: INameableEntityList<I> { } > = class(TEntityService<I, IL>,
    INameableEntityService<I, IL>)
  public
    class function New(const Repository: INameableRepository<I, IL>): INameableEntityService<I, IL>;
  end;

implementation

class function TNameableEntityService<I, IL>.New(const Repository: INameableRepository<I, IL>)
  : INameableEntityService<I, IL>;
begin
  Result := Create(Repository);
end;

end.
