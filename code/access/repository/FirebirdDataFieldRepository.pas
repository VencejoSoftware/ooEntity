unit FirebirdDataFieldRepository;

interface

uses
  SysUtils,
  DB,
  Statement,
  ExecutionResult, DatasetExecution,
  DatabaseEngine,
  Field, DataField, Value, DataValue,
  SQLParser,
  DataFieldFactory,
  SequenceRepository, SequenceFactory, FirebirdSequenceRepository,
  DataFieldRepository;

type
  TFirebirdDataFieldRepository = class sealed(TInterfacedObject, IDataFieldRepository)
  strict private
    _DatabaseEngine: IDatabaseEngine;
    _SQLParser: ISQLParser;
    _Factory: IDataFieldFactory;
  public
    function GetFields(const DataObjectName: String): IDataFieldList;
    constructor Create(const DatabaseEngine: IDatabaseEngine);
    class function New(const DatabaseEngine: IDatabaseEngine): IDataFieldRepository;
  end;

implementation

function TFirebirdDataFieldRepository.GetFields(const DataObjectName: String): IDataFieldList;
{$REGION 'SQL Syntax'}
const
  SQL_SELECT = //
    'SELECT' + //
    '  TRIM(rf.rdb$field_name) AS FIELD_NAME' + //
    '  , CASE F.RDB$FIELD_TYPE' + //
    '    WHEN 7 THEN' + //
    '      CASE F.RDB$FIELD_SUB_TYPE' + //
    '        WHEN 0 THEN 2' + //
    '        WHEN 1 THEN 3' + //
    '        WHEN 2 THEN 2' + //
    '      END' + //
    '    WHEN 8 THEN' + //
    '      CASE F.RDB$FIELD_SUB_TYPE' + //
    '        WHEN 0 THEN 2' + //
    '        WHEN 1 THEN 3' + //
    '        WHEN 2 THEN 2' + //
    '      END' + //
    '    WHEN 10 THEN 3' + //
    '    WHEN 12 THEN 4' + //
    '    WHEN 13 THEN 5' + //
    '    WHEN 14 THEN 1' + //
    '    WHEN 16 THEN' + //
    '      CASE F.RDB$FIELD_SUB_TYPE' + //
    '        WHEN 0 THEN 2' + //
    '        WHEN 1 THEN 3' + //
    '        WHEN 2 THEN 2' + //
    '      END' + //
    '    WHEN 27 THEN 3' + //
    '    WHEN 35 THEN 6' + //
    '    WHEN 37 THEN 1' + //
    '    WHEN 40 THEN 1' + //
    '    ELSE 0' + //
    '  END AS FIELD_DATA_TYPE' + //
    '  , COALESCE(rf.rdb$null_flag, 0) AS FIELD_REQUIRED' + //
    '  , (SELECT' + //
    '      LIST(CASE' + //
    '        WHEN rc.rdb$constraint_type = ''PRIMARY KEY'' THEN 0' + //
    '        WHEN rc.rdb$constraint_type = ''FOREIGN KEY'' THEN 1' + //
    '        WHEN rc.rdb$constraint_type = ''UNIQUE'' THEN 2' + // '        ELSE 0' +//
    '      END)' + //
    '  FROM rdb$index_segments sg' + //
    '    JOIN rdb$relation_constraints rc ON rc.rdb$index_name = sg.rdb$index_name' + //
    '  WHERE' + //
    '    sg.rdb$field_name = rf.rdb$field_name' + //
    '    AND rc.rdb$relation_name = rf.rdb$relation_name) AS FIELD_CONSTRAINT,' + //
    '  (SELECT TRIM(rdb$generator_name) FROM rdb$generators' + //
    '   WHERE rdb$system_flag IS DISTINCT FROM 1' + //
    '    AND TRIM(rdb$generator_name) SIMILAR TO ''(SEQ_)?'' || TRIM(rf.rdb$relation_name) || ''_'' || TRIM(rf.rdb$field_name)) AS SEQUENCE_NAME '
    + //
    'FROM rdb$relation_fields rf' + //
    '  JOIN RDB$FIELDS f ON rf.RDB$FIELD_SOURCE = f.RDB$FIELD_NAME' + //
    '  JOIN rdb$relations r ON rf.rdb$relation_name = r.rdb$relation_name' + //
    '    AND r.rdb$view_blr IS NULL AND (r.rdb$system_flag IS NULL OR r.rdb$system_flag = 0) ' + //
    'WHERE' + //
    '  rf.rdb$relation_name = REPLACE({{OBJECT_NAME}}, ''"'', '''') ' + //
    'ORDER BY' + //
    '  rf.rdb$field_position';
{$ENDREGION}
var
  SQL: String;
  Params: IDataValueList;
  ExecutionResult: IExecutionResult;
  Dataset: TDataset;
begin
  Result := nil;
  Params := TDataValueList.New;
  Params.Add(TDataValue.New(TDataField.New(TField.New('OBJECT_NAME'), DataField.Text),
    TValue.NewByString(DataObjectName)));
  SQL := _SQLParser.ResolveParam(SQL_SELECT, Params);
  ExecutionResult := _DatabaseEngine.ExecuteReturning(TStatement.New(SQL));
  if Supports(ExecutionResult, IDatasetExecution) then
  begin
    Dataset := (ExecutionResult as IDatasetExecution).Dataset;
    if not Dataset.IsEmpty then
      Result := _Factory.BuildDataFieldList(Dataset);
  end;
end;

constructor TFirebirdDataFieldRepository.Create(const DatabaseEngine: IDatabaseEngine);
var
  SequenceFactory: ISequenceFactory;
begin
  _DatabaseEngine := DatabaseEngine;
  _SQLParser := TSQLParser.New;
  SequenceFactory := TSequenceDataFactory.New(TFirebirdSequenceRepository.New(_DatabaseEngine));
  _Factory := TDataFieldFactory.New(SequenceFactory);
end;

class function TFirebirdDataFieldRepository.New(const DatabaseEngine: IDatabaseEngine): IDataFieldRepository;
begin
  Result := Create(DatabaseEngine);
end;

end.
