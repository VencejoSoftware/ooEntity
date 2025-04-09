unit SequenceData;

interface

uses
  Sequence,
  SequenceRepository;

type
  ISequenceData = interface(ISequence)
    ['{D9507B69-AEB4-46F6-8355-F168C182A208}']
    function SequenceName: String;
  end;

  TSequenceData = class sealed(TInterfacedObject, ISequenceData)
  strict private
    _SequenceName: String;
    _Repository: ISequenceRepository;
  public
    function Current: UInt64;
    function Next: UInt64;
    function Reset(const NewValue: UInt64): Boolean;
    function SequenceName: String;
    constructor Create(const SequenceName: String; const Repository: ISequenceRepository);
    class function New(const SequenceName: String; const Repository: ISequenceRepository): ISequenceData;
  end;

implementation

function TSequenceData.Current: UInt64;
begin
  Result := _Repository.Current(_SequenceName);
end;

function TSequenceData.Next: UInt64;
begin
  Result := _Repository.Next(_SequenceName);
end;

function TSequenceData.Reset(const NewValue: UInt64): Boolean;
begin
  Result := _Repository.Reset(_SequenceName, NewValue);
end;

function TSequenceData.SequenceName: String;
begin
  Result := _SequenceName;
end;

constructor TSequenceData.Create(const SequenceName: String; const Repository: ISequenceRepository);
begin
  _SequenceName := SequenceName;
  _Repository := Repository;
end;

class function TSequenceData.New(const SequenceName: String; const Repository: ISequenceRepository): ISequenceData;
begin
  Result := Create(SequenceName, Repository);
end;

end.
