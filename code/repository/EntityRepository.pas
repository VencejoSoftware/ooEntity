unit EntityRepository;

interface

uses
  SysUtils, DB,
  Entity, ObjectId,
  Field, DataField, Value, DataValue,
  DatabaseEngine, Statement, ExecutionResult, DatasetExecution,
  SQLParser,
  SequenceRepository, FirebirdSequenceRepository,
  SQLTableCommand,
  GenericEntityFactory;

type
  IEntityRepository<I: IEntity; IL: IEntityList<I> { } > = interface
    ['{0504E82C-8324-4819-BEC8-73479B08D27D}']
    function SelectOne(const ID: IObjectId): I;
    function SelectMany(const List: IL): Boolean;
    function ExistsById(const ID: IObjectId): Boolean;
    function Exists(const Entity: I): Boolean;
    function Delete(const ID: IObjectId): Boolean;
    function Update(const Entity: I): Boolean;
    function Insert(const Entity: I): Boolean;
    function Upsert(const Entity: I): Boolean;
  end;

  TEntityRepository<I: IEntity; IL: IEntityList<I> { } > = class(TInterfacedObject, IEntityRepository<I, IL>)
  strict private
    _DatabaseEngine: IDatabaseEngine;
    _SQLParser: ISQLParser;
    _SQLList: ISQLTableCommandList;
    _Factory: IGenericEntityFactory<I, IL>;
    _SequenceRepository: ISequenceRepository;
  protected
    function DatabaseEngine: IDatabaseEngine;
    function SQLParser: ISQLParser;
    function Factory: IGenericEntityFactory<I, IL>;
    function SequenceRepository: ISequenceRepository;
  public
    function SelectOne(const ID: IObjectId): I; virtual;
    function SelectMany(const List: IL): Boolean; virtual;
    function ExistsById(const ID: IObjectId): Boolean; virtual;
    function Exists(const Entity: I): Boolean; virtual;
    function Delete(const ID: IObjectId): Boolean; virtual;
    function Update(const Entity: I): Boolean; virtual;
    function Insert(const Entity: I): Boolean; virtual;
    function Upsert(const Entity: I): Boolean; virtual;
    constructor Create(const DatabaseEngine: IDatabaseEngine; const SQLList: ISQLTableCommandList;
      const Factory: IGenericEntityFactory<I, IL>);
    class function New(const DatabaseEngine: IDatabaseEngine; const SQLList: ISQLTableCommandList;
      const Factory: IGenericEntityFactory<I, IL>): IEntityRepository<I, IL>;
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
  SQL: String;
  Params: IDataValueList;
  ExecutionResult: IExecutionResult;
  Dataset: TDataSet;
begin
  Result := nil;
  Params := TDataValueList.New;
  Params.Add(TDataValue.New(TDataField.New(TField.New('ID'), DataField.Numeric), TValue.NewByInt(ID.Value)));
  SQL := _SQLParser.ResolveParam(_SQLList.ItemByKind(TSQLTableCommandKind.Read).SQL, Params);
  ExecutionResult := _DatabaseEngine.ExecuteReturning(TStatement.New(SQL));
  if Supports(ExecutionResult, IDatasetExecution) then
  begin
    Dataset := (ExecutionResult as IDatasetExecution).Dataset;
    if not Dataset.IsEmpty then
      Result := _Factory.Build(Dataset);
  end;
end;

function TEntityRepository<I, IL>.SelectMany(const List: IL): Boolean;
var
  ExecutionResult: IExecutionResult;
  Dataset: TDataSet;
begin
  ExecutionResult := _DatabaseEngine.ExecuteReturning
    (TStatement.New(_SQLList.ItemByKind(TSQLTableCommandKind.ReadList).SQL));
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
  Params.Add(TDataValue.New(TDataField.New(TField.New('ID'), DataField.Numeric), TValue.NewByInt(ID.Value)));
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
  ExecutionResult: IExecutionResult;
  Dataset: TDataSet;
begin
  Result := False;
  Params := TDataValueList.New;
  Params.Add(TDataValue.New(TDataField.New(TField.New('ID'), DataField.Numeric), TValue.NewByInt(ID.Value)));
  SQL := _SQLParser.ResolveParam(_SQLList.ItemByKind(TSQLTableCommandKind.Delete).SQL, Params);
  ExecutionResult := _DatabaseEngine.ExecuteReturning(TStatement.New(SQL));
  if Supports(ExecutionResult, IDatasetExecution) then
  begin
    Dataset := (ExecutionResult as IDatasetExecution).Dataset;
    Result := not Dataset.IsEmpty;
  end;
end;

function TEntityRepository<I, IL>.Update(const Entity: I): Boolean;
begin
end;

function TEntityRepository<I, IL>.Insert(const Entity: I): Boolean;
begin
end;

function TEntityRepository<I, IL>.Upsert(const Entity: I): Boolean;
begin
  if Exists(Entity) then
    Result := Update(Entity)
  else
    Result := Insert(Entity);
end;

constructor TEntityRepository<I, IL>.Create(const DatabaseEngine: IDatabaseEngine; const SQLList: ISQLTableCommandList;
  const Factory: IGenericEntityFactory<I, IL>);
begin
  _DatabaseEngine := DatabaseEngine;
  _SQLList := SQLList;
  _Factory := Factory;
  _SQLParser := TSQLParser.New;
  _SequenceRepository := TFirebirdSequenceRepository.New(DatabaseEngine);
end;

class function TEntityRepository<I, IL>.New(const DatabaseEngine: IDatabaseEngine; const SQLList: ISQLTableCommandList;
  const Factory: IGenericEntityFactory<I, IL>): IEntityRepository<I, IL>;
begin
  Result := Create(DatabaseEngine, SQLList, Factory);
end;

end.
