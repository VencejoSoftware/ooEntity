unit DataFieldFactory;

interface

uses
  SysUtils, DB,
  Sequence, SequenceFactory,
  TextToArray,
  Field, DataField, AutoIncrementDataField;

type
  EDataFieldFactory = class sealed(Exception)
  end;

  IDataFieldFactory = interface
    ['{46073D8B-EE8E-4F09-8AB2-B90A17D09210}']
    function BuildDataField(const Dataset: TDataSet): IDataField;
    function BuildDataFieldList(const Dataset: TDataSet): IDataFieldList;
  end;

  TDataFieldFactory = class sealed(TInterfacedObject, IDataFieldFactory)
  const
    RESERVED_WORD_DELIMITER = '"';
  strict private
    _SequenceFactory: ISequenceFactory;
  private
    function TextToConstraints(const Text: String): TDataFieldConstraintSet;
    function GetFieldName(const BaseName: String): String;
    function IsAReservedWord(const Text: String): Boolean;
    function QuoteReservedWord(const Text: String): String;
// function UnquoteReservedWord(const Text: String): String;
  public
    function BuildDataField(const Dataset: TDataSet): IDataField;
    function BuildDataFieldList(const Dataset: TDataSet): IDataFieldList;
    constructor Create(const SequenceFactory: ISequenceFactory);
    class function New(const SequenceFactory: ISequenceFactory): IDataFieldFactory;
  end;

implementation

function TDataFieldFactory.TextToConstraints(const Text: String): TDataFieldConstraintSet;
var
  TextToArray: ITextToArray;
  ArrayText: TArrayText;
  Item: String;
  Constraint: TDataFieldConstraint;
begin
  Result := [];
  TextToArray := TTextToArray.New;
  ArrayText := TextToArray.Split(Text, ',');
  for Item in ArrayText do
    if Item <> EmptyStr then
    begin
      Constraint := TDataFieldConstraint(StrToInt(Item));
      Include(Result, Constraint);
    end;
end;

function TDataFieldFactory.IsAReservedWord(const Text: String): Boolean;
const
  RESERVED_WORDS: array [0 .. 170] of string = ('ADD', 'ADMIN', 'ALL', 'ALTER', 'AND', 'ANY', 'AS', 'AT', 'AVG',
    'BEGIN', 'BETWEEN', 'BIGINT', 'BIT_LENGTH', 'BLOB', 'BOTH', 'BY', 'CASE', 'CAST', 'CHAR', 'CHAR_LENGTH',
    'CHARACTER', 'CHARACTER_LENGTH', 'CHECK', 'CLOSE', 'COLLATE', 'COLUMN', 'COMMIT', 'CONNECT', 'CONSTRAINT', 'COUNT',
    'CREATE', 'CROSS', 'CURRENT', 'CURRENT_CONNECTION', 'CURRENT_DATE', 'CURRENT_ROLE', 'CURRENT_TIME',
    'CURRENT_TIMESTAMP', 'CURRENT_TRANSACTION', 'CURRENT_USER', 'CURSOR', 'DATE', 'DAY', 'DEC', 'DECIMAL', 'DECLARE',
    'DEFAULT', 'DELETE', 'DELETING', 'DISCONNECT', 'DISTINCT', 'DOUBLE', 'DROP', 'ELSE', 'END', 'ESCAPE', 'EXECUTE',
    'EXISTS', 'EXTERNAL', 'EXTRACT', 'FETCH', 'FILTER', 'FLOAT', 'FOR', 'FOREIGN', 'FROM', 'FULL', 'FUNCTION',
    'GDSCODE', 'GLOBAL', 'GRANT', 'GROUP', 'HAVING', 'HOUR', 'IN', 'INDEX', 'INNER', 'INSENSITIVE', 'INSERT',
    'INSERTING', 'INT', 'INTEGER', 'INTO', 'IS', 'JOIN', 'LEADING', 'LEFT', 'LIKE', 'LONG', 'LOWER', 'MAX',
    'MAXIMUM_SEGMENT', 'MERGE', 'MIN', 'MINUTE', 'MONTH', 'NATIONAL', 'NATURAL', 'NCHAR', 'NO', 'NOT', 'NULL',
    'NUMERIC', 'OCTET_LENGTH', 'OF', 'ON', 'ONLY', 'OPEN', 'OR', 'ORDER', 'OUTER', 'PARAMETER', 'PLAN', 'POSITION',
    'POST_EVENT', 'PRECISION', 'PRIMARY', 'PROCEDURE', 'RDB$DB_KEY', 'REAL', 'RECORD_VERSION', 'RECREATE', 'RECURSIVE',
    'REFERENCES', 'RELEASE', 'RETURNING_VALUES', 'RETURNS', 'REVOKE', 'RIGHT', 'ROLLBACK', 'ROW_COUNT', 'ROWS',
    'SAVEPOINT', 'SECOND', 'SELECT', 'SENSITIVE', 'SET', 'SIMILAR', 'SMALLINT', 'SOME', 'SQLCODE', 'SQLSTATE', 'START',
    'SUM', 'TABLE', 'THEN', 'TIME', 'TIMESTAMP', 'TO', 'TRAILING', 'TRIGGER', 'TRIM', 'UNION', 'UNIQUE', 'UPDATE',
    'UPDATING', 'UPPER', 'USER', 'USING', 'VALUE', 'VALUES', 'VARCHAR', 'VARIABLE', 'VARYING', 'VIEW', 'WHEN', 'WHERE',
    'WHILE', 'WITH', 'YEAR', 'LOCK');
var
  i: Word;
begin
  Result := False;
  for i := Low(RESERVED_WORDS) to High(RESERVED_WORDS) do
    if SameText(Text, RESERVED_WORDS[i]) then
      Exit(True);
end;

function TDataFieldFactory.QuoteReservedWord(const Text: String): String;
begin
  Result := RESERVED_WORD_DELIMITER + Text + RESERVED_WORD_DELIMITER;
end;

// function TDataFieldFactory.UnquoteReservedWord(const Text: String): String;
// begin
// if (Text[1] = RESERVED_WORD_DELIMITER) and (Text[Length(Text)] = RESERVED_WORD_DELIMITER) then
// Result := Copy(Text, 2, Length(Text) - 2)
// else
// Result := Text;
// end;

function TDataFieldFactory.GetFieldName(const BaseName: String): String;
begin
  if IsAReservedWord(BaseName) then
    Result := QuoteReservedWord(BaseName)
  else
    Result := BaseName;
end;

function TDataFieldFactory.BuildDataField(const Dataset: TDataSet): IDataField;
var
  Field: IField;
  Kind: TDataFieldKind;
  Constraints: TDataFieldConstraintSet;
  Required: Boolean;
begin
  Field := TField.New(GetFieldName(Dataset.FieldByName('FIELD_NAME').AsString));
  Kind := TDataFieldKind(Dataset.FieldByName('FIELD_DATA_TYPE').AsInteger);
  Constraints := TextToConstraints(Dataset.FieldByName('FIELD_CONSTRAINT').AsString);
  Required := Dataset.FieldByName('FIELD_REQUIRED').AsInteger <> 0;
  Result := TDataField.New(Field, Kind, Constraints, Required);
end;

function TDataFieldFactory.BuildDataFieldList(const Dataset: TDataSet): IDataFieldList;
var
  DataField: IDataField;
  Sequence: ISequence;
begin
  Result := TDataFieldList.New;
  Dataset.DisableControls;
  try
    Dataset.First;
    while not Dataset.Eof do
    begin
      DataField := BuildDataField(Dataset);
      if Assigned(_SequenceFactory) and not Dataset.FieldByName('SEQUENCE_NAME').IsNull then
      begin
        Sequence := _SequenceFactory.Build(Dataset.FieldByName('SEQUENCE_NAME').AsString);
        Result.Add(TAutoIncrementDataField.New(DataField, Sequence));
      end
      else
        Result.Add(DataField);
      Dataset.Next;
    end;
  finally
    Dataset.EnableControls;
  end;
end;

constructor TDataFieldFactory.Create(const SequenceFactory: ISequenceFactory);
begin
  _SequenceFactory := SequenceFactory;
end;

class function TDataFieldFactory.New(const SequenceFactory: ISequenceFactory): IDataFieldFactory;
begin
  Result := Create(SequenceFactory);
end;

end.
