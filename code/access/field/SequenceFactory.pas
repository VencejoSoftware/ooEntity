unit SequenceFactory;

interface

uses
  Sequence, SequenceData,
  SequenceRepository;

type
  ISequenceFactory = interface
    ['{E6AD54CB-5851-4919-AE18-6F610578A380}']
    function Build(const SequenceName: String): ISequence;
  end;

  TSequenceDataFactory = class sealed(TInterfacedObject, ISequenceFactory)
  strict private
    _Repository: ISequenceRepository;
  public
    function Build(const SequenceName: String): ISequence;
    constructor Create(const Repository: ISequenceRepository);
    class function New(const Repository: ISequenceRepository): ISequenceFactory;
  end;

implementation

function TSequenceDataFactory.Build(const SequenceName: String): ISequence;
begin
  Result := TSequenceData.New(SequenceName, _Repository);
end;

constructor TSequenceDataFactory.Create(const Repository: ISequenceRepository);
begin
  _Repository := Repository;
end;

class function TSequenceDataFactory.New(const Repository: ISequenceRepository): ISequenceFactory;
begin
  Result := Create(Repository);
end;

end.
