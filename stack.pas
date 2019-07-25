unit stack;

interface

type
    TStack = object
    private
        Pos: longint;
        Stacks: array[1..1024] of integer;
    public
        constructor Create;
        procedure Push(const x: integer);
        function Pop: integer;
    end;

implementation

constructor TStack.Create;
var
    i: integer;
begin
    for i := 1 to 1024 do
        Stacks[i] := 0;
    Pos := 1;
end;

procedure TStack.Push(const x: integer);
begin
    Stacks[Pos] := x;
    inc(Pos);
end;

function TStack.Pop: integer;
begin
    Stacks[Pos] := 0;
    dec(Pos);
    Pop := Stacks[Pos];
end;

end.