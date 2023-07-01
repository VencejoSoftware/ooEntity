unit AutoIncrementFactory;

interface

type
  IAutoIncrementFactory = interface
    ['{323D9555-B1BB-4BA3-BBD5-AC06AE0983A5}']
    function Current: UInt64;
    function Next: UInt64;
    function Reset(const NewValue: UInt64): Boolean;
  end;

implementation

end.
