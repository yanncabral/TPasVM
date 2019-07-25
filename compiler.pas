{$mode objfpc}
uses instructions, sysutils; 

type
    TCompiler = object
        position: byte;
        input: shortstring;
        function nextToken: shortstring;
        function Expr: cardinal;
        procedure Emit(const lexeme: byte; const doubled: boolean = false);
        constructor Compile(const newinput: shortstring);
        function Advance(): ShortString;
        function doubleAdvance(): ShortString;
    end;

constructor TCompiler.Compile(const newinput: shortstring);
begin
  position := 1;
  input:= newinput;
  Expr();
end;

function TCompiler.nextToken(): shortstring;
begin
    result := '';
    repeat
        result += input[position];
        position += 1;
    until input[position] in [' ', ',', LineEnding];
    position += 1;
end;

function TCompiler.Advance(): ShortString;
begin
    result := nextToken;
    if result[1] = '#' then
        result := copy(result, 2);
    result := IntToHex(StrToInt(result), 2);
end;

function TCompiler.doubleAdvance(): ShortString;
type
    PSmallInt = ^smallint;
var
    convert: array[0..1] of byte;
begin
    convert[0] := byte(strtoint('$'+advance));
    convert[1] := byte(strtoint('$'+advance));
    result := IntToHex(PSmallInt(@convert)^, 2);
end;


procedure TCompiler.Emit(const lexeme: byte; const doubled: boolean = false);
begin
    write(IntToHex(lexeme,2), ' ');
    write(Advance);
    if doubled then
      write(' ', doubleAdvance);
    writeLn();
end;

function TCompiler.expr: cardinal;
begin
    result := 1;
    case nextToken of
        'var': emit($01, true);
        '': exit(0);
    end;
end;

var Compiler: TCompiler;
    inpt: shortstring;
begin
    with Compiler do begin
        readLn(inpt);
        Compile(inpt);
    end;
end.