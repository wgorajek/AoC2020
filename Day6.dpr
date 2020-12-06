program Day6;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.Math,
  System.StrUtils,
  System.Generics.Collections,
  WGUtils,
  System.RegularExpressions,
  System.SysUtils;


function PartA(AData : string): string;
var
  Total: Integer;
  Answers: TDictionary<string, integer>;
begin
  Total := 0;
  var ADataArray := Adata.Split([#13#10#13#10]);
  Answers := TDictionary<string, integer>.Create;
  try
    for var I := Low(ADataArray) to High(ADataArray) do
    begin
      Answers.Clear;
      for var MyMatch in TRegEx.Matches(ADataArray[I], '[a-z]') do
      begin
        if Answers.ContainsKey(MyMatch.Value) then
        begin
          Answers.AddOrSetValue(MyMatch.Value, Answers[MyMatch.Value] + 1);
        end else
        begin
          Answers.AddOrSetValue(MyMatch.Value, 1);
        end;
      end;
      inc(Total, Answers.Count);
    end;
  finally
    Answers.Free;
  end;
  Result := Total.ToString;
end;


function PartB(AData : string): string;
var
  Total: Integer;
  Answers: TDictionary<string, integer>;
begin
  Total := 0;
  var ADataArray := Adata.Split([#13#10#13#10]);
  Answers := TDictionary<string, integer>.Create;
  try
    for var I := Low(ADataArray) to High(ADataArray) do
    begin
      Answers.Clear;
      for var MyMatch in TRegEx.Matches(ADataArray[I], '[a-z]') do
      begin
        if Answers.ContainsKey(MyMatch.Value) then
        begin
          Answers.AddOrSetValue(MyMatch.Value, Answers[MyMatch.Value] + 1);
        end else
        begin
          Answers.AddOrSetValue(MyMatch.Value, 1);
        end;
      end;
      var NumberOfPeople := ADataArray[I].CountChar(#13) + 1;

      for var J in Answers.Values do
      begin
        if J = NumberOfPeople then
        begin
          Inc(Total);
        end;
      end;
    end;
  finally
    Answers.Free;
  end;
  Result := Total.ToString;
end;

begin
  try
    writeln(PartA(T_WGUtils.OpenFile('..\..\day6Test.txt')));
    writeln(PartA(T_WGUtils.OpenFile('..\..\day6.txt')));
    writeln(PartB(T_WGUtils.OpenFile('..\..\day6Test.txt')));
    writeln(PartB(T_WGUtils.OpenFile('..\..\day6.txt')));
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  Readln;
end.
