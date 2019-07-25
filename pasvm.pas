unit pasvm;{$mode objfpc}

interface

uses instructions, stack;

type TByteArray = array of byte;
type TPasVM = object // TODO: Object
  Registers: array[0..31] of integer;
  Stack: TStack;
  Pos: longint;
  Code: TByteArray; 
  len: longint;
  rest: longint;
  ifFlag: boolean;
  function Advance(): byte;
  function doubleAdvance(): DWord;
  constructor Create(const buffer: TByteArray);
  function nextOpcode(): TOpcode;
  procedure runOnce();
  function runInstruction: boolean;
  function DivideOp(const y, x: longint; var output: longint): longint;
  procedure Run();
  procedure printRegisters();
  procedure printCode();
  procedure addCode(const new: TByteArray);
end;

implementation
uses sysutils;

procedure TPasVM.addCode(const new: TByteArray);
begin
  Code := Concat(Code, New);
  Len += Length(new);
end;

procedure TPasVM.printRegisters();
var
  i, j: byte;
begin
  for i := 0 to 31 div 4 do begin
    for j := 0 to 3 do
      write('#',i*4+j,': ',Registers[i*4+j],^I);
    writeLn();
  end;
end;

procedure TPasVM.printCode();
var
  i,j: byte;
begin
  for i := 0 to len div 4 do begin
    for j := 0 to 3 do 
      write('$', IntToHex(Code[i+j],2),' ');
    writeLn();
  end;
end;

constructor TPasVM.Create(const buffer: TByteArray);
var
  i: longint;
begin
  //Initialize all registers;
  for i := 0 to Pred(Length(Registers)) do
    Registers[i] := 0;
  Pos := 0;
  len := 0;
  Code := [];
  addCode(buffer);
  Stack.Create();
end;

function TPasVM.doubleAdvance: DWord;
begin
  //result := Code[Pos+1] or Code[Pos] shl 8;
  result := PWord(@Code[Pos])^; // Eu acho que os bytes ficam melhor dispostos assim.
  inc(Pos, 2);
end;

function TPasVM.Advance: byte;
begin
  result := Code[Pos];
  inc(Pos);
end;

function TPasVM.nextOpcode: TOpcode;
begin
  result := (TOpcode(Advance));
  //writeLn(result); // debug
end;

function TPasVM.DivideOp(const y, x: longint; var output: longint): longint;
begin
  result := x div y;
  output := x mod y;
end;

function ifThen(const value: boolean; const x,y: integer): integer;
begin
  if value then
    exit(x);
  exit(y);
end;

function TPasVM.runInstruction: boolean;
begin
  result := true;
  if Pos < len then
    case nextOpcode of
      tkExit: begin WriteLn('Exit bytecode encountered!'); exit(false); end;
      tkEqual: ifFlag := Registers[Advance] = Registers[Advance];
      tkGreater: ifFlag := Registers[Advance] > Registers[Advance];
      tkLess: ifFlag := Registers[Advance] < Registers[Advance];
      tkGreaterEqual: ifFlag := Registers[Advance] >= Registers[Advance];
      tkLessEqual: ifFlag := Registers[Advance] >= Registers[Advance];      
      tkAdd: Registers[Advance] := Registers[Advance] + Registers[Advance];
      tkSub: Registers[Advance] := Registers[Advance] - Registers[Advance];
      tkMul: Registers[Advance] := Registers[Advance] * Registers[Advance];
      tkDiv: Registers[Advance] := DivideOp(Registers[Advance],Registers[Advance], rest);
      tkJumpTo: Pos := Registers[advance];
      tkJump: Pos += Registers[advance];
      tkIllegal: exit(false);
      tkStore: Registers[advance] := doubleAdvance; 
      tkIfJump: Pos := ifThen(ifFlag, Registers[advance], pos);
      tkIfNotJump: Pos := ifThen(not ifFlag, Registers[advance], pos);
      tkPrint: writeLn(Registers[Advance]);
      tkPush: Stack.Push(Registers[Advance]);
      tkPop: Registers[Advance] := Stack.Pop;
      else begin
        writeLn('Unrecognized opcode found! Terminating!');
        exit(false);
      end;
    end
  else exit(false);
end;

procedure TPasVM.runOnce;
begin
  runInstruction;
end;

procedure TPasVM.Run;
begin
  repeat until not runInstruction();
end;
  
end.