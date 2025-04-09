unit NameableRepository;

interface

uses
  DataField, DataValue, Field, Value, SQLTableCommand,
  EntityRepository,
  NameableEntity;

type
  INameableRepository<I: INameableEntity; IL: INameableEntityList<I> { } > = interface(IEntityRepository<I, IL>)
    ['{261D254A-354C-44BB-A197-4365761FC277}']
  end;

  TNameableRepository<I: INameableEntity; IL: INameableEntityList<I> { } > = class(TEntityRepository<I, IL>,
    INameableRepository<I, IL>)
  public const
    ID_FIELD_NAME = 'ID';
    NAME_FIELD_NAME = 'NAME';
  protected
    function ParseEntityParams(const Entity: I; const Kind: TSQLTableCommandKind; const DataFieldList: IDataFieldList;
      const SQL: String): String; override;
  end;

implementation

{ TNameableRepository<I, IL> }

function TNameableRepository<I, IL>.ParseEntityParams(const Entity: I; const Kind: TSQLTableCommandKind;
  const DataFieldList: IDataFieldList; const SQL: String): String;
var
  Params: IDataValueList;
begin
  Params := TDataValueList.New;
  Params.Add(TDataValue.New(TDataField.New(TField.New(ID_FIELD_NAME), DataField.Numeric),
    TValue.NewByInt(Entity.ID.Value)));
  Params.Add(TDataValue.New(TDataField.New(TField.New(NAME_FIELD_NAME), DataField.Text),
    TValue.NewByString(Entity.Name.Text)));
  Result := SQLParser.ResolveParam(SQL, Params);
end;

end.
