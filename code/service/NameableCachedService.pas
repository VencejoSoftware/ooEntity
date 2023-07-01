unit NameableCachedService;

interface

uses
  EntityCached,
  EntityCachedService, NameableEntity,
  NameableEntityService;

type
  TNameableCachedService<I: INameableEntity; IL: INameableEntityList<I> { } > = class(TEntityCachedService<I, IL>,
    INameableEntityService<I, IL>)
  public
    class function New(const Service: INameableEntityService<I, IL>;
      const SecondsToExpire: NativeUInt = TCacheExpireLevel.A_DAY): INameableEntityService<I, IL>;
  end;

implementation

class function TNameableCachedService<I, IL>.New(const Service: INameableEntityService<I, IL>;
  const SecondsToExpire: NativeUInt): INameableEntityService<I, IL>;
begin
  Result := Create(Service, SecondsToExpire);
end;

end.
