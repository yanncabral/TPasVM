{$mode objfpc}
uses pasvm, test, sysutils, strutils, types, crt;

type
    TByteArray = array of byte;
    TPasVMInterpreter = object
        vm: TPasVM;
        input: shortstring;
        function getByteArray(const bytecode: string): TByteArray;
    end;

function TPasVMInterpreter.getByteArray(const bytecode: string): TByteArray;
var
    pos: longint = 0;
    bc: TStringDynArray;
    len: longint;
begin
    bc := SplitString(bytecode, ' ');
    len := Length(bc);
    SetLength(result, len);
    for pos := 0 to pred(len) do 
        result[pos] := StrToInt('$'+bc[pos]);
end;

var
    Interpreter: TPasVMInterpreter;

begin
    Interpreter.VM.Create([]);
    ClrScr;
    WriteLn('Welcome to PasVM!');
    with Interpreter do begin
        repeat
            write('>>> ');
            readLn(input);
            case input of
                '.registers': VM.printRegisters;
                '.program': VM.printCode;
                '.quit': system.halt(0);
                '0'..'F': 
                begin
                    VM.addCode(getByteArray(input));
                    VM.Run();
                end;
            else
                WriteLn('Invalid input');    
            end;
        until input = #0;
    end;
end.