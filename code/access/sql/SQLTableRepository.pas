unit SQLTableRepository;

interface

uses
  SysUtils,
  AppLog,
  DB,
  Statement,
  ExecutionResult, FailedExecution, SuccededExecution, DatasetExecution,
  DatabaseEngine,
  SQLTableCommand,
  SQLTable,
  DataField,
  DataRow, DataRowFactory,
  DataFilter,
  SQLParser;

type
  ISQLTableRepository = interface
    ['{A5C6BBB8-A16C-427D-9D00-F6AF78534DF7}']
    function Select(const Entity: ISQLTable; const Filter: IDataFilter = nil): IDataRow;
    function Exists(const Entity: ISQLTable; const DataRow: IDataRow): Boolean;
    function Insert(const Entity: ISQLTable; const DataRow: IDataRow; const UseGlobalTransaction: Boolean = False)
      : IDataRow;
    function Update(const Entity: ISQLTable; const DataRow: IDataRow; const UseGlobalTransaction: Boolean = False)
      : IDataRow;
    function Save(const Entity: ISQLTable; const DataRow: IDataRow; const UseGlobalTransaction: Boolean = False)
      : IDataRow;
    function Delete(const Entity: ISQLTable; const DataRow: IDataRow;
      const UseGlobalTransaction: Boolean = False): Boolean;
    function SelectList(const Entity: ISQLTable; const Filter: IDataFilter = nil): IDataRowList;
    function InsertList(const Entity: ISQLTable; const DataRowList: IDataRowList): IDataRowList;
    function UpdateList(const Entity: ISQLTable; const DataRowList: IDataRowList): IDataRowList;
    function SaveList(const Entity: ISQLTable; const DataRowList: IDataRowList): IDataRowList;
    function DeleteList(const Entity: ISQLTable; const DataRowList: IDataRowList): Boolean;
  end;

  TSQLTableRepository = class sealed(TInterfacedObject, ISQLTableRepository)
  strict private
    _DatabaseEngine: IDatabaseEngine;
    _SQLParser: ISQLParser;
    _DataRowFactory: IDataRowFactory;
    _AppLog: IAppLog;
  public
    function Select(const Entity: ISQLTable; const Filter: IDataFilter = nil): IDataRow;
    function Exists(const Entity: ISQLTable; const DataRow: IDataRow): Boolean;
    function Insert(const Entity: ISQLTable; const DataRow: IDataRow; const UseGlobalTransaction: Boolean = False)
      : IDataRow;
    function Update(const Entity: ISQLTable; const DataRow: IDataRow; const UseGlobalTransaction: Boolean = False)
      : IDataRow;
    function Save(const Entity: ISQLTable; const DataRow: IDataRow; const UseGlobalTransaction: Boolean = False)
      : IDataRow;
    function Delete(const Entity: ISQLTable; const DataRow: IDataRow;
      const UseGlobalTransaction: Boolean = False): Boolean;
    function SelectList(const Entity: ISQLTable; const Filter: IDataFilter = nil): IDataRowList;
    function InsertList(const Entity: ISQLTable; const DataRowList: IDataRowList): IDataRowList;
    function UpdateList(const Entity: ISQLTable; const DataRowList: IDataRowList): IDataRowList;
    function SaveList(const Entity: ISQLTable; const DataRowList: IDataRowList): IDataRowList;
    function DeleteList(const Entity: ISQLTable; const DataRowList: IDataRowList): Boolean;
    constructor Create(const DatabaseEngine: IDatabaseEngine; const AppLog: IAppLog);
    class function New(const DatabaseEngine: IDatabaseEngine; const AppLog: IAppLog): ISQLTableRepository;
  end;

implementation

function TSQLTableRepository.Select(const Entity: ISQLTable; const Filter: IDataFilter = nil): IDataRow;
var
  SQL: String;
  Dataset: TDataset;
  ExecutionResult: IExecutionResult;
begin
  try
    SQL := Entity.Commands.ItemByKind(SQLTableCommand.Read).SQL;
    _AppLog.WriteDebug(Format('Select SQL: "%s"', [SQL]), 'SQLTableRepository.Select');
    ExecutionResult := _DatabaseEngine.ExecuteReturning(TStatement.New(SQL));
    if Supports(ExecutionResult, IDatasetExecution) then
    begin
      Dataset := (ExecutionResult as IDatasetExecution).Dataset;
      Result := _DataRowFactory.BuildByDataset(Dataset);
    end
    else
      Result := nil;
  except
    on Error: Exception do
    begin
      _AppLog.ErrorByException('SQLTableRepository.Select', Error, False);
      raise;
    end;
  end;
end;

function TSQLTableRepository.Exists(const Entity: ISQLTable; const DataRow: IDataRow): Boolean;
var
  SQL: String;
  Dataset: TDataset;
  ExecutionResult: IExecutionResult;
begin
  try
    SQL := Entity.Commands.ItemByKind(SQLTableCommand.Exists).SQL;
    SQL := _SQLParser.ResolveParam(SQL, DataRow.DataValueList);
    _AppLog.WriteDebug(Format('Exists SQL: "%s"', [SQL]), 'SQLTableRepository.Exists');
    ExecutionResult := _DatabaseEngine.ExecuteReturning(TStatement.New(SQL));
    if Supports(ExecutionResult, IDatasetExecution) then
    begin
      Dataset := (ExecutionResult as IDatasetExecution).Dataset;
      Result := not Dataset.IsEmpty;
    end
    else
      Result := False;
  except
    on Error: Exception do
    begin
      _AppLog.ErrorByException('SQLTableRepository.Exists', Error, False);
      raise;
    end;
  end;
end;

function TSQLTableRepository.Insert(const Entity: ISQLTable; const DataRow: IDataRow;
  const UseGlobalTransaction: Boolean): IDataRow;
var
  SQL: String;
  ExecutionResult: IExecutionResult;
  Dataset: TDataset;
begin
  try
    SQL := Entity.Commands.ItemByKind(SQLTableCommand.Create).SQL;
    SQL := _SQLParser.ResolveParam(SQL, DataRow.DataValueList);
    _AppLog.WriteDebug(Format('Insert SQL: "%s"', [SQL]), 'SQLTableRepository.Insert');
    ExecutionResult := _DatabaseEngine.ExecuteReturning(TStatement.New(SQL), True, UseGlobalTransaction);
    if ExecutionResult.Failed then
      raise (ExecutionResult as IFailedExecution).ToException
    else if Supports(ExecutionResult, IDatasetExecution) then
    begin
      Dataset := (ExecutionResult as IDatasetExecution).Dataset;
      Result := _DataRowFactory.BuildByDataset(Dataset);
    end;
  except
    on Error: Exception do
    begin
      _AppLog.ErrorByException('SQLTableRepository.Insert', Error, False);
      raise;
    end;
  end;
end;

function TSQLTableRepository.Update(const Entity: ISQLTable; const DataRow: IDataRow;
  const UseGlobalTransaction: Boolean): IDataRow;
var
  SQL: String;
  ExecutionResult: IExecutionResult;
begin
  try
    SQL := Entity.Commands.ItemByKind(SQLTableCommand.Update).SQL;
    SQL := _SQLParser.ResolveParam(SQL, DataRow.DataValueList);
    _AppLog.WriteDebug(Format('Update SQL: "%s"', [SQL]), 'SQLTableRepository.Update');
    ExecutionResult := _DatabaseEngine.Execute(TStatement.New(SQL), UseGlobalTransaction);
    if ExecutionResult.Failed then
      raise (ExecutionResult as IFailedExecution).ToException
    else
      Result := DataRow;
  except
    on Error: Exception do
    begin
      _AppLog.ErrorByException('SQLTableRepository.Update', Error, False);
      raise;
    end;
  end;
end;

function TSQLTableRepository.Save(const Entity: ISQLTable; const DataRow: IDataRow; const UseGlobalTransaction: Boolean)
  : IDataRow;
begin
  if Exists(Entity, DataRow) then
    Result := Update(Entity, DataRow, UseGlobalTransaction)
  else
    Result := Insert(Entity, DataRow, UseGlobalTransaction);
end;

function TSQLTableRepository.Delete(const Entity: ISQLTable; const DataRow: IDataRow;
  const UseGlobalTransaction: Boolean): Boolean;
var
  SQL: String;
  ExecutionResult: IExecutionResult;
begin
  try
    SQL := Entity.Commands.ItemByKind(SQLTableCommand.Delete).SQL;
    SQL := _SQLParser.ResolveParam(SQL, DataRow.DataValueList);
    _AppLog.WriteDebug(Format('Delete SQL: "%s"', [SQL]), 'SQLTableRepository.Delete');
    ExecutionResult := _DatabaseEngine.Execute(TStatement.New(SQL), UseGlobalTransaction);
    if ExecutionResult.Failed then
      raise (ExecutionResult as IFailedExecution).ToException;
    Result := not ExecutionResult.Failed;
  except
    on Error: Exception do
    begin
      _AppLog.ErrorByException('SQLTableRepository.Delete', Error, False);
      raise;
    end;
  end;
end;

function TSQLTableRepository.SelectList(const Entity: ISQLTable; const Filter: IDataFilter = nil): IDataRowList;
begin
  // Revisar: Todo
end;

function TSQLTableRepository.InsertList(const Entity: ISQLTable; const DataRowList: IDataRowList): IDataRowList;
var
  Item, InsertedItem: IDataRow;
begin
  Result := TDataRowList.New;
  for Item in DataRowList do
  begin
    InsertedItem := Insert(Entity, Item, True);
    if not Assigned(InsertedItem) then
      raise Exception.Create('Error inserting list');
    Result.Add(InsertedItem);
  end;
end;

function TSQLTableRepository.UpdateList(const Entity: ISQLTable; const DataRowList: IDataRowList): IDataRowList;
var
  Item, UpdateItem: IDataRow;
begin
  Result := TDataRowList.New;
  for Item in DataRowList do
  begin
    UpdateItem := Update(Entity, Item, True);
    if not Assigned(UpdateItem) then
      raise Exception.Create('Error updating list');
    Result.Add(UpdateItem);
  end;
end;

function TSQLTableRepository.SaveList(const Entity: ISQLTable; const DataRowList: IDataRowList): IDataRowList;
var
  Item, UpdateItem: IDataRow;
begin
  Result := TDataRowList.New;
  for Item in DataRowList do
  begin
    UpdateItem := Save(Entity, Item, True);
    if not Assigned(UpdateItem) then
      raise Exception.Create('Error saving list');
    Result.Add(UpdateItem);
  end;
end;

function TSQLTableRepository.DeleteList(const Entity: ISQLTable; const DataRowList: IDataRowList): Boolean;
var
  Item: IDataRow;
begin
  Result := False;
  for Item in DataRowList do
  begin
    Result := Delete(Entity, Item, True);
    if not Result then
      raise Exception.Create('Error deleting list');
  end;
end;

constructor TSQLTableRepository.Create(const DatabaseEngine: IDatabaseEngine; const AppLog: IAppLog);
begin
  _DatabaseEngine := DatabaseEngine;
  _SQLParser := TSQLParser.New;
  _DataRowFactory := TDataRowFactory.New;
  _AppLog := AppLog;
end;

class function TSQLTableRepository.New(const DatabaseEngine: IDatabaseEngine; const AppLog: IAppLog)
  : ISQLTableRepository;
begin
  Result := TSQLTableRepository.Create(DatabaseEngine, AppLog);
end;

end.
