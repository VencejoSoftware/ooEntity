unit Sequence;

interface

type
  ISequence = interface
    ['{04257149-BA03-4EAB-99F2-9967B1C413C5}']
    function Current: UInt64;
    function Next: UInt64;
    function Reset(const NewValue: UInt64): Boolean;
  end;

implementation

end.
