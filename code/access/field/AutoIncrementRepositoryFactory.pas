unit AutoIncrementRepositoryFactory;

interface

uses
  AutoIncrementFactory,
  SequenceRepository;

type
  TAutoIncrementRepositoryFactory = class sealed(TInterfacedObject, IAutoIncrementFactory)
  strict private
    _SequenceName: String;
    _Repository: ISequenceRepository;
  public
    function Current: UInt64;
    function Next: UInt64;
    function Reset(const NewValue: UInt64): Boolean;
    constructor Create(const SequenceName: String; const Repository: ISequenceRepository);
    class function New(const SequenceName: String; const Repository: ISequenceRepository): IAutoIncrementFactory;
  end;

implementation

function TAutoIncrementRepositoryFactory.Current: UInt64;
begin
  Result := _Repository.Current(_SequenceName);
end;

function TAutoIncrementRepositoryFactory.Next: UInt64;
begin
  Result := _Repository.Next(_SequenceName);
end;

function TAutoIncrementRepositoryFactory.Reset(const NewValue: UInt64): Boolean;
begin
  Result := _Repository.Reset(_SequenceName, NewValue);
end;

constructor TAutoIncrementRepositoryFactory.Create(const SequenceName: String; const Repository: ISequenceRepository);
begin
  _SequenceName := SequenceName;
  _Repository := Repository;
end;

class function TAutoIncrementRepositoryFactory.New(const SequenceName: String; const Repository: ISequenceRepository)
  : IAutoIncrementFactory;
begin
  Result := TAutoIncrementRepositoryFactory.Create(SequenceName, Repository);
end;

end.
