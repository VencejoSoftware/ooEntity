{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
program test;

uses
  ooRunTest,
  ooEntity.Mock in '..\code\ooEntity.Mock.pas',
  ooEntity_test in '..\code\ooEntity_test.pas',
  ooKeyGUID_test in '..\code\ooKeyGUID_test.pas',
  ooKeyString_test in '..\code\ooKeyString_test.pas',
  ooObjectA.Entity.Mock in '..\code\ooObjectA.Entity.Mock.pas',
  ooObjectB.Entity.Mock in '..\code\ooObjectB.Entity.Mock.pas',
  ooMarshalUnmarshalRelation_test in '..\code\ooMarshalUnmarshalRelation_test.pas';

{R *.RES}

begin
  Run;

end.
