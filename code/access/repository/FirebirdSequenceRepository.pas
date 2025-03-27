unit FirebirdSequenceRepository;

interface

uses
  SysUtils,
  DB,
  Statement,
  ExecutionResult, DatasetExecution,
  DatabaseEngine,
  Field, DataField, Value, DataValue,
  SQLParser,
  SequenceRepository;

type
  TFirebirdSequenceRepository = class sealed(TInterfacedObject, ISequenceRepository)
  strict private
    _DatabaseEngine: IDatabaseEngine;
    _SQLParser: ISQLParser;
  public
    function Current(const SequenceName: String): UInt64;
    function Next(const SequenceName: String): UInt64;
    function Reset(const SequenceName: String; const NewValue: UInt64): Boolean;
    constructor Create(const DatabaseEngine: IDatabaseEngine);
    class function New(const DatabaseEngine: IDatabaseEngine): ISequenceRepository;
  end;

implementation

function TFirebirdSequenceRepository.Current(const SequenceName: String): UInt64;
const
  SQL_SELECT = 'SELECT GEN_ID({{SEQUENCE_NAME}}, 0) FROM RDB$DATABASE';
var
  SQL: String;
  Params: IDataValueList;
  ExecutionResult: IExecutionResult;
  Dataset: TDataset;
begin
  Params := TDataValueList.New;
  Params.Add(TDataValue.New(TDataField.New(TField.New('SEQUENCE_NAME'), DataField.Unknown),
    TValue.NewByString(SequenceName)));
  SQL := _SQLParser.ResolveParam(SQL_SELECT, Params);
  ExecutionResult := _DatabaseEngine.ExecuteReturning(TStatement.New(SQL));
  if Supports(ExecutionResult, IDatasetExecution) then
  begin
    Dataset := (ExecutionResult as IDatasetExecution).Dataset;
    if Dataset.IsEmpty then
      raise ESequenceRepository.Create(Format('Cant get current sequence value from "%s"', [SequenceName]))
    else
      Result := Dataset.Fields[0].Value;
  end
  else
    raise ESequenceRepository.Create(Format('Cant get current sequence value from "%s"', [SequenceName]))
end;

function TFirebirdSequenceRepository.Next(const SequenceName: String): UInt64;
const
  SQL_SELECT = 'SELECT NEXT VALUE FOR {{SEQUENCE_NAME}} FROM RDB$DATABASE';
var
  SQL: String;
  Params: IDataValueList;
  ExecutionResult: IExecutionResult;
  Dataset: TDataset;
begin
  Params := TDataValueList.New;
  Params.Add(TDataValue.New(TDataField.New(TField.New('SEQUENCE_NAME'), DataField.Unknown),
    TValue.NewByString(SequenceName)));
  SQL := _SQLParser.ResolveParam(SQL_SELECT, Params);
  ExecutionResult := _DatabaseEngine.ExecuteReturning(TStatement.New(SQL));
  if Supports(ExecutionResult, IDatasetExecution) then
  begin
    Dataset := (ExecutionResult as IDatasetExecution).Dataset;
    if Dataset.IsEmpty then
      raise ESequenceRepository.Create(Format('Cant get next sequence value from "%s"', [SequenceName]))
    else
      Result := Dataset.Fields[0].Value;
  end
  else
    raise ESequenceRepository.Create(Format('Cant get next sequence value from "%s"', [SequenceName]));
end;

function TFirebirdSequenceRepository.Reset(const SequenceName: String; const NewValue: UInt64): Boolean;
const
  SQL_RESET = 'ALTER SEQUENCE {{SEQUENCE_NAME}} RESTART WITH {{VALUE}}';
var
  SQL: String;
  Params: IDataValueList;
begin
  Params := TDataValueList.New;
  Params.Add(TDataValue.New(TDataField.New(TField.New('SEQUENCE_NAME'), DataField.Text),
    TValue.NewByString(SequenceName)));
  Params.Add(TDataValue.New(TDataField.New(TField.New('VALUE'), DataField.Numeric), TValue.NewByInt(NewValue)));
  SQL := _SQLParser.ResolveParam(SQL_RESET, Params);
  Result := _DatabaseEngine.Execute(TStatement.New(SQL)).Failed;
end;

constructor TFirebirdSequenceRepository.Create(const DatabaseEngine: IDatabaseEngine);
begin
  _DatabaseEngine := DatabaseEngine;
  _SQLParser := TSQLParser.New;
end;

class function TFirebirdSequenceRepository.New(const DatabaseEngine: IDatabaseEngine): ISequenceRepository;
begin
  Result := Create(DatabaseEngine);
end;

end.
