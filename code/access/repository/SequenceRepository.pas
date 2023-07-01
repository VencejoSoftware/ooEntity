unit SequenceRepository;

interface

uses
  SysUtils;

type
  ESequenceRepository = class sealed(Exception)
  end;

  ISequenceRepository = interface
    ['{56193BA1-F58E-4F74-8B49-0AA263070FAB}']
    function Current(const SequenceName: String): UInt64;
    function Next(const SequenceName: String): UInt64;
    function Reset(const SequenceName: String; const NewValue: UInt64): Boolean;
  end;

implementation

end.
