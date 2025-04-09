unit SQLParser;

interface

uses
  SysUtils, StrUtils,
  KeyValue,
  Token, TokenFactory, HashedToken, HashedTokenFactory,
  FieldNameFormat,
  DataField,
  DataFilter, DataFilterSQL,
  DataSort, DataSortSQL,
  ValueSyntax,
  DataValue;

type
  ISQLParser = interface
    ['{12E3E4CE-CA96-49C0-8DB5-AB495BD050EB}']
    function ResolveSyntax(const SQL: String; const DataObjectName: String;
      const DataFieldList: IDataFieldList): String;
    function ResolveParam(const SQL: String; const DataValueList: IDataValueList): String;
    function ResolveFilter(const SQL: String; const DataFilterList: IDataFilterList): String;
    function ResolveSort(const SQL: String; const DataSortList: IDataSortList): String;
  end;

  TSQLParser = class sealed(TInterfacedObject, ISQLParser)
  const
    ITEM_SEPARATOR = ',';
    ITEM_COMBINATOR = ' AND ';
    FILTER_OPERATOR_OR = '|';
    FILTER_NULLABLE_CONDITION = 'NullableConditional';
    FILTER_CONDITION = 'Conditional';
    SPACE = ' ';
    ORDER_BY = 'ORDER BY';
    WHERE = 'WHERE';
    RESERVED_WORD_DELIMITER = '"';
  strict private
    _TokenFactory: ITokenFactory;
    _HashedTokenFactory: IHashedTokenFactory;
    _ValueSyntax: IValueSyntax;
    _DataFilterSQL: IDataFilterSQL;
    _DataSortSQL: IDataSortSQL;
  private
    function BuildOrderBy(const DataFieldList: IDataFieldList; const Token: IHashedToken;
      const FieldNameFormat: IFieldNameFormat): String;
    function BuildWhere(const DataFieldList: IDataFieldList; const Token: IHashedToken;
      const FieldNameFormat: IFieldNameFormat): String;
    function BuildFieldAsParameters(const DataFieldList: IDataFieldList): String;
    function BuildFieldParameters(const DataFieldList: IDataFieldList; const FieldNameFormat: IFieldNameFormat): String;
    function BuildDataFieldFilter(const DataField: IDataField; const Conditional, NullableConditional: IKeyValue;
      const FieldNameFormat: IFieldNameFormat): String;
    function ResolveConditionableParam(const SQL: String; const Token: IHashedToken; const DataValue: IDataValue;
      const Conditional: IKeyValue): String;
    function ResolveNullabelParam(const SQL: String; const Token: IHashedToken; const DataValue: IDataValue;
      const NullableConditional: IKeyValue): String;
    function FindOrderByPosition(const SQL: String): Integer;
    function GetLastSubSelect(const SQL: string): Integer;
    function FindWherePosition(const SQL: String): Integer;
    function UnquoteReservedWord(const Text: String): String;
  public
    function ResolveSyntax(const SQL: String; const DataObjectName: String;
      const DataFieldList: IDataFieldList): String;
    function ResolveParam(const SQL: String; const DataValueList: IDataValueList): String;
    function ResolveFilter(const SQL: String; const DataFilterList: IDataFilterList): String;
    function ResolveSort(const SQL: String; const DataSortList: IDataSortList): String;
    constructor Create;
    class function New: ISQLParser;
  end;

implementation

function TSQLParser.BuildOrderBy(const DataFieldList: IDataFieldList; const Token: IHashedToken;
  const FieldNameFormat: IFieldNameFormat): String;
var
  DataField: IDataField;
  Sort: String;
begin
  Result := EmptyStr;
  Sort := ' ' + Token.Attributes.ItemByKey('Sort').Value;
  for DataField in DataFieldList do
    if Length(Result) < 1 then
      Result := FieldNameFormat.GetName(DataField.Name) + Sort
    else
      Result := Result + ITEM_SEPARATOR + FieldNameFormat.GetName(DataField.Name) + Sort;
end;

function TSQLParser.BuildDataFieldFilter(const DataField: IDataField; const Conditional, NullableConditional: IKeyValue;
  const FieldNameFormat: IFieldNameFormat): String;
begin
  if Assigned(NullableConditional) then
    Result := TToken.TAG_START //
      + THashedToken.NAME_KEY + TKeyValue.ASSIGNMENT_CHAR + FieldNameFormat.GetName(DataField.Name) //
      + ITEM_SEPARATOR + Conditional.AsString //
      + ITEM_SEPARATOR + NullableConditional.AsString //
      + TToken.TAG_END
  else
    Result := Conditional.Value + TToken.TAG_START + FieldNameFormat.GetName(DataField.Name) + TToken.TAG_END;
end;

function TSQLParser.BuildWhere(const DataFieldList: IDataFieldList; const Token: IHashedToken;
  const FieldNameFormat: IFieldNameFormat): String;
var
  DataField: IDataField;
  Conditional, NullableConditional: IKeyValue;
begin
  Result := EmptyStr;
  Conditional := Token.Attributes.ItemByKey(FILTER_CONDITION);
  NullableConditional := Token.Attributes.ItemByKey(FILTER_NULLABLE_CONDITION);
  for DataField in DataFieldList do
  begin
    if Length(Result) > 1 then
      Result := Result + ITEM_COMBINATOR;
    Result := Result + FieldNameFormat.GetName(DataField.Name) + BuildDataFieldFilter(DataField, Conditional,
      NullableConditional, FieldNameFormat);
  end;
end;

function TSQLParser.BuildFieldAsParameters(const DataFieldList: IDataFieldList): String;
var
  DataField: IDataField;
begin
  Result := EmptyStr;
  for DataField in DataFieldList do
  begin
    if Length(Result) > 1 then
      Result := Result + ITEM_SEPARATOR;
    Result := Result + TToken.TAG_START + UnquoteReservedWord(DataField.Name) + TToken.TAG_END;
  end;
end;

function TSQLParser.UnquoteReservedWord(const Text: String): String;
begin
  if (Text[1] = RESERVED_WORD_DELIMITER) and (Text[Length(Text)] = RESERVED_WORD_DELIMITER) then
    Result := Copy(Text, 2, Length(Text) - 2)
  else
    Result := Text;
end;

function TSQLParser.BuildFieldParameters(const DataFieldList: IDataFieldList;
  const FieldNameFormat: IFieldNameFormat): String;
var
  DataField: IDataField;
begin
  Result := EmptyStr;
  for DataField in DataFieldList do
  begin
    if Length(Result) > 1 then
      Result := Result + ITEM_SEPARATOR;
    Result := Result + FieldNameFormat.GetName(DataField.Name) + '=' + TToken.TAG_START +
      UnquoteReservedWord(DataField.Name) + TToken.TAG_END;
  end;
end;

function TSQLParser.ResolveSyntax(const SQL: String; const DataObjectName: String;
  const DataFieldList: IDataFieldList): String;
var
  TokenList, WhereTokens, OrderByTokens: IHashedTokenList;
  FieldNameFormat: IFieldNameFormat;
  Token: IHashedToken;
begin
  Result := SQL;
  FieldNameFormat := TFieldNameFormat.New;
  TokenList := _HashedTokenFactory.ParseText(SQL);
  Token := TokenList.ItemByName('ObjectName');
  if Assigned(Token) then
    Result := Token.Parse(Result, DataObjectName);

  Token := TokenList.ItemByName('Fields');
  if Assigned(Token) then
    Result := Token.Parse(Result, DataFieldList.ToString(FieldNameFormat));

  Token := TokenList.ItemByName('PKFields');
  if Assigned(Token) then
    Result := Token.Parse(Result, DataFieldList.FilterByConstraint(PrimaryKey).ToString(FieldNameFormat));

  Token := TokenList.ItemByName('ParametrizedFields');
  if Assigned(Token) then
    Result := Token.Parse(Result, BuildFieldAsParameters(DataFieldList));

  Token := TokenList.ItemByName('FieldParameters');
  if Assigned(Token) then
    Result := Token.Parse(Result, BuildFieldParameters(DataFieldList, FieldNameFormat));

  WhereTokens := TokenList.FilterByAttribute(TKeyValue.New('Kind', 'Where'));
  for Token in WhereTokens do
    Result := Token.Parse(Result, BuildWhere(DataFieldList.FilterByConstraint(PrimaryKey), Token, FieldNameFormat));

  OrderByTokens := TokenList.FilterByAttribute(TKeyValue.New('Kind', 'OrderBy'));
  for Token in OrderByTokens do
    Result := Token.Parse(Result, BuildOrderBy(DataFieldList.FilterByConstraint(PrimaryKey), Token, FieldNameFormat));
end;

function TSQLParser.ResolveConditionableParam(const SQL: String; const Token: IHashedToken; const DataValue: IDataValue;
  const Conditional: IKeyValue): String;
begin
  if Assigned(Conditional) then
    Result := Token.Parse(SQL, Conditional.Value + SPACE + _ValueSyntax.Parse(DataValue.DataField, DataValue.Value))
  else
    Result := Token.Parse(SQL, _ValueSyntax.Parse(DataValue.DataField, DataValue.Value));
end;

function TSQLParser.ResolveNullabelParam(const SQL: String; const Token: IHashedToken; const DataValue: IDataValue;
  const NullableConditional: IKeyValue): String;
begin
  if Assigned(NullableConditional) then
    Result := Token.Parse(SQL, SPACE + NullableConditional.Value)
  else
    Result := Token.Parse(SQL, _ValueSyntax.Parse(nil, nil));
end;

function TSQLParser.ResolveParam(const SQL: String; const DataValueList: IDataValueList): String;
var
  TokenList: IHashedTokenList;
  Token: IHashedToken;
  DataValue: IDataValue;
begin
  Result := SQL;
  TokenList := _HashedTokenFactory.ParseText(SQL);
  for Token in TokenList do
  begin
    DataValue := DataValueList.ItemByFieldName(Token.Name);
    if Assigned(DataValue) then
      Result := ResolveConditionableParam(Result, Token, DataValue, Token.Attributes.ItemByKey(FILTER_CONDITION))
    else
      Result := ResolveNullabelParam(Result, Token, DataValue, Token.Attributes.ItemByKey(FILTER_NULLABLE_CONDITION));
  end;
end;

function TSQLParser.GetLastSubSelect(const SQL: string): Integer;
const
  SQL_PRM_QUOTE1 = '(';
  SQL_PRM_QUOTE2 = ')';
  SQL_SELECT = 'SELECT';
var
  iOccPos1, iOccPos2: Integer;
  bExit: boolean;
begin
  bExit := False;
  iOccPos2 := 1;
  while not bExit do
  begin
    iOccPos1 := PosEx(SQL, SQL_PRM_QUOTE1 + SQL_SELECT, iOccPos2);
    if (iOccPos1 < 1) then
      Break;
    iOccPos2 := PosEx(SQL, SQL_PRM_QUOTE2, iOccPos1);
    if (iOccPos2 < 1) then
      Break;
  end;
  Result := iOccPos2;
end;

function TSQLParser.FindWherePosition(const SQL: String): Integer;
begin
  Result := PosEx(WHERE, SQL, GetLastSubSelect(SQL));
end;

function TSQLParser.ResolveFilter(const SQL: String; const DataFilterList: IDataFilterList): String;
var
  FilterSQL: String;
  OrderByPosition, WherePosition: Integer;
begin
  Result := SQL;
  FilterSQL := _DataFilterSQL.ParseList(DataFilterList);
  if Length(FilterSQL) < 1 then
    Exit;
  WherePosition := FindWherePosition(Result);
  if WherePosition > 0 then
  begin
    Inc(WherePosition, Length(WHERE));
    Result := Copy(Result, 1, Pred(WherePosition)) + SPACE + FilterSQL + ITEM_COMBINATOR +
      Copy(Result, Succ(WherePosition));
// TODO: revisar,ver como resolver multiples union
// PosSQL := PosEx(SQL_UNION, Result, PosSQL);
// if PosSQL > 1 then
// Result := AddDynamicWhere(Result, WHERE, PosSQL);
  end
  else
  begin
    OrderByPosition := FindOrderByPosition(Result);
    if OrderByPosition > 0 then
      Result := Copy(Result, 1, Pred(OrderByPosition)) + SPACE + WHERE + SPACE + FilterSQL + SPACE +
        Copy(Result, OrderByPosition)
    else
      Result := Result + SPACE + WHERE + SPACE + FilterSQL
  end;
end;

function TSQLParser.FindOrderByPosition(const SQL: String): Integer;
begin
  Result := PosEx(ORDER_BY, SQL, GetLastSubSelect(SQL));
end;

function TSQLParser.ResolveSort(const SQL: String; const DataSortList: IDataSortList): String;
var
  SortSQL: String;
  OrderByPosition: Integer;
begin
  Result := SQL;
  SortSQL := _DataSortSQL.ParseList(DataSortList);
  if Length(SortSQL) < 1 then
    Exit;
  OrderByPosition := FindOrderByPosition(SQL);
  if OrderByPosition > 0 then
    Result := Result + ITEM_SEPARATOR + SortSQL
  else
    Result := Result + SPACE + ORDER_BY + SPACE + SortSQL
end;

constructor TSQLParser.Create;
begin
  _ValueSyntax := TValueSyntax.New;
  _TokenFactory := TTokenFactory.New;
  _HashedTokenFactory := THashedTokenFactory.New;
  _DataFilterSQL := TDataFilterSQL.New;
  _DataSortSQL := TDataSortSQL.New;
end;

class function TSQLParser.New: ISQLParser;
begin
  Result := Create;
end;

end.
