program Day19;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.Math,
  System.StrUtils,
  System.Generics.Collections,
  WGUtils,
  System.RegularExpressions,
  System.SysUtils;

function GetRegularExpression(ARules: TDictionary<string, string>; ARule: String): String;
begin
  var Reg := ARules[ARule];
  while TRegEx.Match(Reg, '(\d+)').Success do
  begin
    var Match := TRegEx.Match(Reg, '(\d+)');
    var Key := Match.Groups[1].Value;
    var NewKey := ARules[Key];
    NewKey := TRegEx.Replace(NewKey, '(.*)\| (.*)', '(\1|\2)');
    Reg := Reg.Remove(Match.Index-1, Match.Length);
    Reg.Insert(Match.Index-1, NewKey);
  end;
  Result := Reg;
end;


function PartA(AData : string): string;
var
  Total : Int64;
  Words: TList<String>;
  Rules: TDictionary<string, string>;
begin
  Total := 0;
  Words := TList<String>.Create;
  Rules := TDictionary<string, string>.Create;
  try

    var DataArray := AData.Split([#13#10]);
    var StartRules := False;
    for var I := Low(DataArray) to High(DataArray) do
    begin
      if DataArray[I] = '' then
      begin
        StartRules := True
      end else if StartRules then
      begin
        Words.Add(DataArray[I]);
      end else
      begin
        var Match := TRegEx.Match(DataArray[I], '^(\d+): (.*)$');
        if Match.Success and (Match.Groups.Count >= 3) then begin
          Rules.AddOrSetValue(Match.Groups[1].value, Match.Groups[2].value.Replace('"', ''));
        end;
      end;
    end;
    var Reg := GetRegularExpression(Rules, '0');
    Reg := Reg.Replace(' ', '');
    Reg := '^' + Reg + '$';
    for var Word in Words do
    begin
      if TRegEx.Match(Word, Reg).Success then
      begin
        Inc(Total);
      end;
    end;
  finally
    Words.Free;
    Rules.Free;
  end;
  Result := Total.ToString;
end;

function PartB(AData : string): string;
var
  Total : Int64;
  Words: TList<String>;
  Rules: TDictionary<string, string>;
begin
  Total := 0;
  Words := TList<String>.Create;
  Rules := TDictionary<string, string>.Create;
  try

    var DataArray := AData.Split([#13#10]);
    var StartRules := False;
    for var I := Low(DataArray) to High(DataArray) do
    begin
      if DataArray[I] = '' then
      begin
        StartRules := True
      end else if StartRules then
      begin
        Words.Add(DataArray[I]);
      end else
      begin
        var Match := TRegEx.Match(DataArray[I], '^(\d+): (.*)$');
        if Match.Success and (Match.Groups.Count >= 3) then begin
          Rules.AddOrSetValue(Match.Groups[1].value, Match.Groups[2].value.Replace('"', ''));
        end;
      end;
    end;
    var Reg42 := GetRegularExpression(Rules, '42');
    Reg42 := Reg42.Replace(' ', '');

    var Reg31 := GetRegularExpression(Rules, '31');
    Reg31 := Reg31.Replace(' ', '');

    for var I := 1 to 5 do
    begin
        var Reg :=  '';
        for var K := 1 to I do
        begin
          Reg := '('+Reg42+')' + Reg +  '('+Reg31+')';
        end;
        Reg :=  '('+Reg42+')+' + Reg;
        Reg :=  '^' + Reg + '$';
      for var J := Words.Count - 1 downto 0  do
      begin
        if TRegEx.Match(Words[J], Reg).Success then
        begin
          Inc(Total);
          Words.Remove(Words[J]);
        end;
      end;
    end;
  finally
    Words.Free;
    Rules.Free;
  end;
  Result := Total.ToString;
end;

begin
  try
    //!! I calculate rigth RegEx pattern , but it donf find right answers for long pattern. Checked patterns online manually.
    writeln(PartA(T_WGUtils.OpenFile('..\..\day19Test.txt')));
    writeln(PartA(T_WGUtils.OpenFile('..\..\day19.txt')));
    writeln(PartB(T_WGUtils.OpenFile('..\..\day19Test.txt')));
    writeln(PartB(T_WGUtils.OpenFile('..\..\day19.txt')));
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  Readln;
end.
