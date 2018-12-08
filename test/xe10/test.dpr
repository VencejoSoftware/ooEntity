{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
program test;

uses
  RunTest,
  KeyGUID_test in '..\code\key\KeyGUID_test.pas',
  Key_test in '..\code\key\Key_test.pas',
  SortOrder_test in '..\code\sort\SortOrder_test.pas',
  SortOrderList_test in '..\code\sort\SortOrderList_test.pas',
  EntityMock in '..\code\EntityMock.pas',
  Entity_test in '..\code\Entity_test.pas',
  MarshalUnmarshalRelation_test in '..\code\MarshalUnmarshalRelation_test.pas',
  ObjectAEntityMock in '..\code\ObjectAEntityMock.pas',
  ObjectBEntityMock in '..\code\ObjectBEntityMock.pas',
  SyntaxFormatSymbol_test in '..\code\SyntaxFormatSymbol_test.pas',
  SyntaxFormat_test in '..\code\SyntaxFormat_test.pas',
  FilterJoin_test in '..\code\filter\FilterJoin_test.pas',
  FilterJoinedCriteria_test in '..\code\filter\FilterJoinedCriteria_test.pas',
  FilterCriteria_test in '..\code\filter\FilterCriteria_test.pas',
  SymbolListMock in '..\code\SymbolListMock.pas',
  SortOrderAscending in '..\code\sort\stub\SortOrderAscending.pas',
  SortOrderDescending in '..\code\sort\stub\SortOrderDescending.pas',
  SortOrderNone in '..\code\sort\stub\SortOrderNone.pas',
  FilterCriteriaBetween in '..\code\filter\stub\FilterCriteriaBetween.pas',
  FilterCriteriaEqual in '..\code\filter\stub\FilterCriteriaEqual.pas',
  FilterCriteriaList in '..\code\filter\stub\FilterCriteriaList.pas',
  FilterCriteriaNull in '..\code\filter\stub\FilterCriteriaNull.pas',
  FilterJoinAnd in '..\code\filter\stub\FilterJoinAnd.pas',
  FilterJoinNot in '..\code\filter\stub\FilterJoinNot.pas',
  FilterJoinOr in '..\code\filter\stub\FilterJoinOr.pas',
  XMLDataInput_test in '..\code\dataInput\XMLDataInput_test.pas',
  DatasetDataInput_test in '..\code\dataInput\DatasetDataInput_test.pas',
  INIDataInput_test in '..\code\dataInput\INIDataInput_test.pas',
  TStringsDataInput_test in '..\code\dataInput\TStringsDataInput_test.pas',
  Identificable in '..\..\code\Identificable.pas',
  Nameable in '..\..\code\Nameable.pas',
  Entity in '..\..\code\Entity.pas',
  Formatter in '..\..\code\Formatter.pas',
  FormatterElements in '..\..\code\FormatterElements.pas',
  Statement in '..\..\code\Statement.pas',
  SyntaxFormat in '..\..\code\SyntaxFormat.pas',
  SyntaxFormatSymbol in '..\..\code\SyntaxFormatSymbol.pas',
  DataInput in '..\..\code\dataInput\DataInput.pas',
  DatasetDataInput in '..\..\code\dataInput\DatasetDataInput.pas',
  INIDataInput in '..\..\code\dataInput\INIDataInput.pas',
  TStringsDataInput in '..\..\code\dataInput\TStringsDataInput.pas',
  XMLDataInput in '..\..\code\dataInput\XMLDataInput.pas',
  DataOutput in '..\..\code\dataOutput\DataOutput.pas',
  DatasetDataOutput in '..\..\code\dataOutput\DatasetDataOutput.pas',
  INIDataOutput in '..\..\code\dataOutput\INIDataOutput.pas',
  TStringsDataOutput in '..\..\code\dataOutput\TStringsDataOutput.pas',
  Filter in '..\..\code\filter\Filter.pas',
  FilterCriteria in '..\..\code\filter\FilterCriteria.pas',
  FilterJoin in '..\..\code\filter\FilterJoin.pas',
  FilterJoinedCriteria in '..\..\code\filter\FilterJoinedCriteria.pas',
  FilterParameter in '..\..\code\filter\FilterParameter.pas',
  GUIDKey in '..\..\code\key\GUIDKey.pas',
  Key in '..\..\code\key\Key.pas',
  SortOrder in '..\..\code\sort\SortOrder.pas',
  SortOrderList in '..\..\code\sort\SortOrderList.pas';

{R *.RES}

begin
  Run;

end.
