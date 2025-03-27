unit EntityRepository;

interface

uses
  SysUtils, DB,
  Entity, ObjectId,
  Field, DataField, Value, DataValue,
  DatabaseEngine, Statement, ExecutionResult, DatasetExecution,
  AutoIncrementDataField,
  SQLParser,
  SequenceRepository, FirebirdSequenceRepository,
  SQLTableCommand,
  DataSort,
  GenericEntityFactory;

type
  EEntityRepository = class(Exception);

  IEntityRepository<I: IEntity; IL: IEntityList<I> { } > = interface
    ['{0504E82C-8324-4819-BEC8-73479B08D27D}']
    function SelectOne(const ID: IObjectId): I;
    function SelectMany(const List: IL; const DataSortList: IDataSortList = nil): Boolean;
    function ExistsById(const ID: IObjectId): Boolean;
    function Exists(const Entity: I): Boolean;
    function Delete(const ID: IObjectId): Boolean;
    function Update(const Entity: I): I;
    function Insert(const Entity: I): I;
    function Upsert(const Entity: I): I;
    function InsertMany(const List: IL): Boolean;
    function UpdateMany(const List: IL): Boolean;
    function UpsertMany(const List: IL): Boolean;
  end;

  TEntityRepository<I: IEntity; IL: IEntityList<I> { } > = class(TInterfacedObject, IEntityRepository<I, IL>)
  public const
    ID_FIELD_NAME = 'ID';
  strict private
    _DatabaseEngine: IDatabaseEngine;
    _SQLParser: ISQLParser;
    _DataFieldList: IDataFieldList;
    _SQLList: ISQLTableCommandList;
    _Factory: IGenericEntityFactory<I, IL>;
    _SequenceRepository: ISequenceRepository;
  protected
    function DatabaseEngine: IDatabaseEngine;
    function SQLParser: ISQLParser;
    function Factory: IGenericEntityFactory<I, IL>;
    function SequenceRepository: ISequenceRepository;
    function ParseEntityParams(const Entity: I; const Kind: TSQLTableCommandKind; const DataFieldList: IDataFieldList;
      const SQL: String): String; virtual; abstract;
    procedure UpdateAutoIncrementId(const Entity: I);
  public
    function SelectOne(const ID: IObjectId): I; virtual;
    function SelectMany(const List: IL; const DataSortList: IDataSortList = nil): Boolean; virtual;
    function ExistsById(const ID: IObjectId): Boolean; virtual;
    function Exists(const Entity: I): Boolean; virtual;
    function Delete(const ID: IObjectId): Boolean; virtual;
    function Update(const Entity: I): I; virtual;
    function Insert(const Entity: I): I; virtual;
    function Upsert(const Entity: I): I; virtual;
    function InsertMany(const List: IL): Boolean; virtual;
    function UpdateMany(const List: IL): Boolean; virtual;
    function UpsertMany(const List: IL): Boolean; virtual;
    constructor Create(const DatabaseEngine: IDatabaseEngine; const SQLList: ISQLTableCommandList;
      const DataFieldList: IDataFieldList; const Factory: IGenericEntityFactory<I, IL>);
    class function New(const DatabaseEngine: IDatabaseEngine; const SQLList: ISQLTableCommandList;
      const DataFieldList: IDataFieldList; const Factory: IGenericEntityFactory<I, IL>): IEntityRepository<I, IL>;
  end;

implementation

function TEntityRepository<I, IL>.DatabaseEngine: IDatabaseEngine;
begin
  Result := _DatabaseEngine;
end;

function TEntityRepository<I, IL>.SQLParser: ISQLParser;
begin
  Result := _SQLParser;
end;

function TEntityRepository<I, IL>.Factory: IGenericEntityFactory<I, IL>;
begin
  Result := _Factory;
end;

function TEntityRepository<I, IL>.SequenceRepository: ISequenceRepository;
begin
  Result := _SequenceRepository;
end;

function TEntityRepository<I, IL>.SelectOne(const ID: IObjectId): I;
var
  Params: IDataValueList;
  SQL: String;
  ExecutionResult: IExecutionResult;
  Dataset: TDataSet;
begin
  Result := nil;
  Params := TDataValueList.New;
  Params.Add(TDataValue.New(TDataField.New(TField.New(ID_FIELD_NAME), DataField.Numeric), TValue.NewByInt(ID.Value)));
  SQL := _SQLParser.ResolveParam(_SQLList.ItemByKind(TSQLTableCommandKind.Read).SQL, Params);
  ExecutionResult := _DatabaseEngine.ExecuteReturning(TStatement.New(SQL));
  if Supports(ExecutionResult, IDatasetExecution) then
  begin
    Dataset := (ExecutionResult as IDatasetExecution).Dataset;
    if not Dataset.IsEmpty then
      Result := _Factory.Build(Dataset);
  end;
end;

function TEntityRepository<I, IL>.SelectMany(const List: IL; const DataSortList: IDataSortList): Boolean;
var
  SQL: String;
  ExecutionResult: IExecutionResult;
  Dataset: TDataSet;
begin
  SQL := _SQLList.ItemByKind(TSQLTableCommandKind.ReadList).SQL;
  if Assigned(DataSortList) then
    SQL := _SQLParser.ResolveSort(SQL, DataSortList);
  ExecutionResult := _DatabaseEngine.ExecuteReturning(TStatement.New(SQL));
  if Supports(ExecutionResult, IDatasetExecution) then
  begin
    Dataset := (ExecutionResult as IDatasetExecution).Dataset;
    if not Dataset.IsEmpty then
      _Factory.BuildList(Dataset, List);
    Result := True;
  end;
end;

function TEntityRepository<I, IL>.ExistsById(const ID: IObjectId): Boolean;
var
  SQL: String;
  Params: IDataValueList;
  ExecutionResult: IExecutionResult;
  Dataset: TDataSet;
begin
  Result := False;
  Params := TDataValueList.New;
  Params.Add(TDataValue.New(TDataField.New(TField.New(ID_FIELD_NAME), DataField.Numeric), TValue.NewByInt(ID.Value)));
  SQL := _SQLParser.ResolveParam(_SQLList.ItemByKind(TSQLTableCommandKind.Exists).SQL, Params);
  ExecutionResult := _DatabaseEngine.ExecuteReturning(TStatement.New(SQL));
  if Supports(ExecutionResult, IDatasetExecution) then
  begin
    Dataset := (ExecutionResult as IDatasetExecution).Dataset;
    Result := not Dataset.IsEmpty;
  end;
end;

function TEntityRepository<I, IL>.Exists(const Entity: I): Boolean;
begin
  if Assigned(Entity.ID) then
    Result := ExistsById(Entity.ID)
  else
    Result := False;
end;

function TEntityRepository<I, IL>.Delete(const ID: IObjectId): Boolean;
var
  SQL: String;
  Params: IDataValueList;
begin
  Result := False;
  Params := TDataValueList.New;
  Params.Add(TDataValue.New(TDataField.New(TField.New(ID_FIELD_NAME), DataField.Numeric), TValue.NewByInt(ID.Value)));
  SQL := _SQLParser.ResolveParam(_SQLList.ItemByKind(TSQLTableCommandKind.Delete).SQL, Params);
  Result := not _DatabaseEngine.Execute(TStatement.New(SQL)).Failed;
end;

function TEntityRepository<I, IL>.Update(const Entity: I): I;
var
  SQL: String;
begin
  SQL := ParseEntityParams(Entity, TSQLTableCommandKind.Update, _DataFieldList,
    _SQLList.ItemByKind(TSQLTableCommandKind.Update).SQL);
  _DatabaseEngine.Execute(TStatement.New(SQL));
  Result := Entity;
end;

procedure TEntityRepository<I, IL>.UpdateAutoIncrementId(const Entity: I);
var
  IDField: IDataField;
  ID: Int64;
begin
  if not Entity.HasId then
  begin
    IDField := _DataFieldList.ItemByName(ID_FIELD_NAME);
    if not Supports(IDField, IAutoIncrementDataField) then
      raise EEntityRepository.Create('No sequence found');
    ID := IAutoIncrementDataField(IDField).Sequence.Next;
    Entity.UpdateId(TObjectId.New(ID));
  end;
end;

function TEntityRepository<I, IL>.Insert(const Entity: I): I;
var
  SQL: String;
begin
  UpdateAutoIncrementId(Entity);
  SQL := ParseEntityParams(Entity, TSQLTableCommandKind.Create, _DataFieldList,
    _SQLList.ItemByKind(TSQLTableCommandKind.Create).SQL);
  _DatabaseEngine.Execute(TStatement.New(SQL));
  Result := Entity;
end;

function TEntityRepository<I, IL>.Upsert(const Entity: I): I;
begin
  if Exists(Entity) then
    Result := Update(Entity)
  else
    Result := Insert(Entity);
end;

function TEntityRepository<I, IL>.InsertMany(const List: IL): Boolean;
var
  Index: Integer;
  Item: I;
begin
  for Index := 0 to Pred(List.Count) do
    Insert(List.ItemByIndex(Index));
  Result := True;
end;

function TEntityRepository<I, IL>.UpdateMany(const List: IL): Boolean;
var
  Index: Integer;
begin
  for Index := 0 to Pred(List.Count) do
    Update(List.ItemByIndex(Index));
  Result := True;
end;

function TEntityRepository<I, IL>.UpsertMany(const List: IL): Boolean;
var
  Index: Integer;
begin
  for Index := 0 to Pred(List.Count) do
    Upsert(List.ItemByIndex(Index));
  Result := True;
end;

constructor TEntityRepository<I, IL>.Create(const DatabaseEngine: IDatabaseEngine; const SQLList: ISQLTableCommandList;
  const DataFieldList: IDataFieldList; const Factory: IGenericEntityFactory<I, IL>);
begin
  _DatabaseEngine := DatabaseEngine;
  _SQLList := SQLList;
  _DataFieldList := DataFieldList;
  _Factory := Factory;
  _SQLParser := TSQLParser.New;
  _SequenceRepository := TFirebirdSequenceRepository.New(DatabaseEngine);
end;

class function TEntityRepository<I, IL>.New(const DatabaseEngine: IDatabaseEngine; const SQLList: ISQLTableCommandList;
  const DataFieldList: IDataFieldList; const Factory: IGenericEntityFactory<I, IL>): IEntityRepository<I, IL>;
begin
  Result := Create(DatabaseEngine, SQLList, DataFieldList, Factory);
end;

end.
