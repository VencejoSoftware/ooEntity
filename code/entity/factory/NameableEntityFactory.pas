unit NameableEntityFactory;

interface

uses
  ObjectNameFactory,
  NameableEntity,
  GenericNameableEntityFactory;

type
  INameableEntityFactory = interface(IGenericNameableEntityFactory < INameableEntity,
    INameableEntityList < INameableEntity >> )
    ['{2DB8D8B8-BD7C-4457-847A-104BDAFC8431}']
  end;

  TNameableEntityFactory = class sealed(TGenericNameableEntityFactory<INameableEntity,
    INameableEntityList<INameableEntity>>, INameableEntityFactory)
  public
    class function New(const ObjectNameFactory: IObjectNameFactory): INameableEntityFactory;
  end;

implementation

class function TNameableEntityFactory.New(const ObjectNameFactory: IObjectNameFactory): INameableEntityFactory;
begin
  Result := Create(ObjectNameFactory);
end;

end.
