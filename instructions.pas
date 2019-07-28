unit instructions;

interface

type
    TOpcode = (
      tkExit = $0, tkStore, tkPrint, tkToString, tkRandom, 
      tkJumpTo = $10, tkIfJump, tkIfNotJump, tkJump,
      tkIllegal, 
      tkXor = $20, tkAdd, tkSub, tkMul, tkDiv, tkInc, tkDec, tkAnd, tkOr,
      tkEqual = $40, tkGreater, tkLess, tkGreaterEqual, tkLessEqual,
      tkPush = $70, tkPop, tkRet, tkCall,
      tkMem, tkFree
    );
    TInstruction = object 
        op: TOpcode;
        constructor Create(const opcode: TOpcode);
    end;

implementation

constructor TInstruction.Create(const opcode: TOpcode);
begin
  self.op := opcode;
end;


end.