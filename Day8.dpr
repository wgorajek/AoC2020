program Day8;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.Math,
  System.StrUtils,
  System.Generics.Collections,
  WGUtils,
  System.RegularExpressions,
  System.SysUtils;

type
  TConsole = class
    Instructions: TArray<TPair<string, integer>>;
    Pointer: Integer;
    Value : Integer;
    procedure Execute;
    function Run: Integer;
    function RunB: Integer;
    constructor Create(AData: String); overload;
  end;


procedure FixConsole(AConsole: TConsole; APointer: Integer);
begin
  if AConsole.Instructions[APointer].Key = 'jmp' then
  begin
    AConsole.Instructions[APointer].Key := 'nop'
  end else if AConsole.Instructions[APointer].Key = 'nop' then
  begin
    AConsole.Instructions[APointer].Key := 'jmp';
  end;
end;

function PartA(AData : string): string;
begin
  var Console := TConsole.Create(AData);
  Result := Console.Run.ToString;
end;


function PartB(AData : string): string;
var
  Total: Integer;
begin
  Total := 0;

  var Console := TConsole.Create(AData);
  for var I := Low(Console.Instructions) to High(Console.Instructions) do
  begin
    FixConsole(Console, I);
    Total := Console.RunB;
    if Console.Pointer = length(Console.Instructions) then
    begin
      break;
    end;
    FixConsole(Console, I); //revert change
    Console.Pointer := 0;
    Console.Value := 0;
  end;

  Result := Total.ToString;
end;

{ TConsole }

constructor TConsole.Create(AData: String);
begin
  var DataArray := AData.Split([#13#10]);
  setLength(Instructions, length(DataArray));
  for var I := Low(DataArray) to High(DataArray) do
  begin
    var Key := DataArray[I].Substring(0, 3);
    var Value := StrToInt(DataArray[I].Substring(4));
    Instructions[I] := TPair<string, integer>.Create(Key, Value);
  end;
  Pointer := 0;
  Value := 0;
end;

procedure TConsole.Execute;
begin
  var InstructionCode := Instructions[Pointer].Key;
  var InstrValue := Instructions[Pointer].Value;

  if InstructionCode = 'acc' then
  begin
    Inc(Value, InstrValue);
    Inc(Pointer);
  end else if InstructionCode = 'jmp' then
  begin
    Inc(Pointer, InstrValue);
  end else if InstructionCode = 'nop' then
  begin
    Inc(Pointer);
  end;
end;

function TConsole.Run: Integer;
var ExecutedCommands: TList<Integer>;
begin
  ExecutedCommands := TList<Integer>.Create;
  try
    while not ExecutedCommands.Contains(Pointer) do
    begin
      ExecutedCommands.Add(Pointer);
      Execute;
    end;
    Result := Value;
  finally
    ExecutedCommands.Free;
  end;
end;

function TConsole.RunB: Integer;
var ExecutedCommands: TList<Integer>;
begin
  ExecutedCommands := TList<Integer>.Create;
  try
    while not ExecutedCommands.Contains(Pointer) do
    begin
      ExecutedCommands.Add(Pointer);
      Execute;
    end;
    Result := Value;
  finally
    ExecutedCommands.Free;
  end;
end;

begin
  try
    writeln(PartA(T_WGUtils.OpenFile('..\..\day8Test.txt')));
    writeln(PartA(T_WGUtils.OpenFile('..\..\day8.txt')));
    writeln(PartB(T_WGUtils.OpenFile('..\..\day8Test.txt')));
    writeln(PartB(T_WGUtils.OpenFile('..\..\day8.txt')));
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  Readln;
end.
