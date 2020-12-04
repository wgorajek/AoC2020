program Day4;

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
begin
  Total := 0;
  var ADataArray := Adata.Split([#13#10#13#10]);
  for var I := Low(ADataArray) to High(ADataArray) do
  begin
    var IsValid := True;
    for var str in ['byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid'] do
    begin
      IsValid := IsValid and TRegEx.Match(AdataArray[I], str +':\S+').Success;
    end;
    if IsValid then
      Inc(Total)
  end;
  Result := Total.ToString;
end;


function  CheckIsValid(AType: String; AValue: String) : Boolean;
begin
  Result := False;
  if AType = 'byr' then
  begin
    var CheckedValue: Integer;
    if TryStrToInt(AValue, CheckedValue) then
    begin
      Result := (CheckedValue >= 1920) and (CheckedValue <= 2002)
    end
  end else if AType = 'iyr' then
  begin
    var CheckedValue: Integer;
    if TryStrToInt(AValue, CheckedValue) then
    begin
      Result := (CheckedValue >= 2010) and (CheckedValue <= 2020)
    end
  end else if AType = 'eyr' then
  begin
    var CheckedValue: Integer;
    if TryStrToInt(AValue, CheckedValue) then
    begin
      Result := (CheckedValue >= 2020) and (CheckedValue <= 2030)
    end
  end else if AType = 'hgt' then
  begin
    If TRegEx.IsMatch(Avalue, '[0-9]*[in|cm]') then
    begin
      var IsInch := TRegEx.IsMatch(Avalue, 'in');
      var CheckedValue: Integer;
      if TryStrToInt(AValue.Substring(0, AValue.Length-2), CheckedValue) then
      begin
        if IsInch then
        begin
          Result := (CheckedValue >= 59) and (CheckedValue <= 76)
        end else
        begin
          Result := (CheckedValue >= 150) and (CheckedValue <= 193)
        end;
      end
    end;
  end else if AType = 'hcl' then
  begin
    Result := TRegEx.IsMatch(Avalue, '#[0-9|a-f]{6}') and (AValue.Length = 7);
  end else if AType = 'ecl' then
  begin
    Result := TRegEx.IsMatch(Avalue, '(amb|blu|brn|gry|grn|hzl|oth)');
  end else if AType = 'pid' then
  begin
    Result := TRegEx.IsMatch(Avalue, '[0-9]{9}') and (AValue.Length = 9);
  end
end;

function PartB(AData : string): string;
var
  Total: Integer;
begin

  Total := 0;
  var ADataArray := Adata.Split([#13#10#13#10]);
  for var I := Low(ADataArray) to High(ADataArray) do
  begin
    var IsValid := True;
    for var str in ['byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid'] do
    begin
      var Match := TRegEx.Match(ADataArray[I], str +':(\S+)');
      if Match.Success then
      begin
        var TmpStr3 := (Match.Value.Remove(0, Match.Value.IndexOf(':')+ 1));
        IsValid := IsValid and CheckIsValid(Str, TmpStr3);
      end else
        IsValid := False;
    end;
    if IsValid then
      Inc(Total)
  end;
  Result := Total.ToString;
end;

begin
  try
    writeln(PartA(T_WGUtils.OpenFile('..\..\day4Test.txt')));
    writeln(PartA(T_WGUtils.OpenFile('..\..\day4.txt')));
    writeln(PartB(T_WGUtils.OpenFile('..\..\day4Test.txt')));
    writeln(PartB(T_WGUtils.OpenFile('..\..\day4.txt')));
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  Readln;
end.
