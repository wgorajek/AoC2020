program Day2;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.Math,
  System.StrUtils,
  System.Generics.Collections,
  WGUtils,
  System.RegularExpressions,
  System.Variants,
  System.SysUtils;


type

TPasswordPolicy = record
   MinNumber : Integer;
   MaxNumber: Integer;
   Letter : string;
   Text : String;
end;

function IsValid(APolicy: TPasswordPolicy): Boolean;
begin
  var LetterCount := Apolicy.Text.CountChar(Apolicy.Letter[1]);
  Result := (LetterCount >= APolicy.MinNumber) and (LetterCount <= APolicy.MaxNumber);
end;

function IsValid2(APolicy: TPasswordPolicy): Boolean;
begin
  Result := (APolicy.Text[APolicy.MinNumber] = Apolicy.Letter) xor (APolicy.Text[APolicy.MaxNumber] = Apolicy.Letter);
end;

procedure FillPoliciesList(AData: string; AList: TList<TPasswordPolicy>);
begin
  var DataArray := AData.Split([#13#10]);
  for var I := Low(DataArray) to High(DataArray) do
  begin
    var tmpPolicy : TPasswordPolicy;
    var TmpArray := DataArray[I].Split(['-', ' ', ': ']);
    tmpPolicy.MinNumber := TmpArray[0].ToInteger;
    tmpPolicy.MaxNumber := TmpArray[1].ToInteger;
    tmpPolicy.Letter := TmpArray[2];
    tmpPolicy.Text := TmpArray[3];
    AList.Add(tmpPolicy);
  end;
end;

function PartA(AData: string): string;
var
  Total: Integer;
  PasswordPolicies: TList<TPasswordPolicy>;
begin
  Total := 0;

  PasswordPolicies := TList<TPasswordPolicy>.Create;
  try
    FillPoliciesList(AData, PasswordPolicies);
    for var tmpPolicy in PasswordPolicies do
    begin
      if IsValid(tmpPolicy) then
      begin
        Inc(Total);
      end;
    end;
  finally
    PasswordPolicies.Free;
  end;
  Result := Total.ToString;
end;

function PartB(AData: string): string;
var
  Total: Integer;
  PasswordPolicies: TList<TPasswordPolicy>;
begin
  Total := 0;

  PasswordPolicies := TList<TPasswordPolicy>.Create;
  try
    FillPoliciesList(AData, PasswordPolicies);
    for var tmpPolicy in PasswordPolicies do
    begin
      if IsValid2(tmpPolicy) then
      begin
        Inc(Total);
      end;
    end;

  finally
    PasswordPolicies.Free;
  end;
  Result := Total.ToString;

end;

begin
  try
    writeln(PartA(T_WGUtils.OpenFile('..\..\day2Test.txt')));
    writeln(PartA(T_WGUtils.OpenFile('..\..\day2.txt')));
    writeln(PartB(T_WGUtils.OpenFile('..\..\day2Test.txt')));
    writeln(PartB(T_WGUtils.OpenFile('..\..\day2.txt')));

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  Readln;
end.
