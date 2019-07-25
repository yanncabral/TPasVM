unit tests; {$mode objfpc}

interface

uses instructions, pasvm;

implementation

procedure AssertEq(const ass: boolean; const msg: ShortString = 'in somewhere.');
begin
  if not ass then
    writeLn('Erro: ',msg);
end;
   
procedure test_create_instruction();
var
  instruction: TInstruction;
begin
  instruction.Create(TOpcode.tkExit);
  AssertEq(instruction.Op = TOpcode(0), 'Não inicializou direito saporra');
end;

procedure test_opcode_igl();
var
  test_vm: TPasVM;
const
  test_bytes: TByteArray = (200,0,0,0);
begin
  with test_vm do begin
    Create(test_bytes);
    Run();
    AssertEq(test_vm.Pos = 1);
  end;
end;

procedure test_opcode_load();
var
  test_vm: TPasVM;
const
  test_bytes: TByteArray = (byte(tkStore),1,1,244);
begin
  with test_vm do begin
    Create(test_bytes);
    Run();
    writeLn(test_vm.Registers[1]);
    AssertEq(test_vm.Registers[1] = 500);
  end;
end;

procedure testCompiler();
var
  test_vm: TPasVM;
const
  test_bytes: TByteArray = (byte(tkStore), $1, 0, 40, byte(tkStore), $2, 0, 20, byte(tkAdd),$0,$1,$2);
begin
  with test_vm do begin
    Create(test_bytes);
    Run();
    //printRegisters;
    AssertEq(test_vm.Registers[0] = 60);
  end;
end;

procedure testJump();
var
  test_vm: TPasVM;
const
  test_bytes: TByteArray = (byte(tkJump), 0,0,0);
begin
  with test_vm do begin
    Create(test_bytes);
    Registers[0] := 2;
    runOnce();
    AssertEq(Pos = 4);
  end;
end;

initialization
//testCompiler;
//testJump;
//test_create_instruction;
//test_opcode_igl;
//test_opcode_load;

end.