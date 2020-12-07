program Day7;

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
  TBag = record
    Color: string;
    Contains: TArray<TPair<string, integer>>;
  end;


function ContainShinyBags(ABagsList: TDictionary<string, TBag>; AColor: String; ANumber: Integer): Integer;
begin
  Result := 0;
  if AColor = 'shiny gold' then
    Result := ANumber
  else
  begin    
    for var TmpBag in ABagsList[AColor].Contains do
    begin
      Result := Result + ANumber * ContainShinyBags(ABagsList, TmpBag.Key, TmpBag.Value);
    end;
  end;
end;

function ContainBags(ABagsList: TDictionary<string, TBag>; AColor: String; ANumber: Integer): Integer;
begin
  Result := ANumber;
  for var TmpBag in ABagsList[AColor].Contains do
  begin
    Result := Result + ANumber * ContainBags(ABagsList, TmpBag.Key, TmpBag.Value);
  end;
end;

procedure FillBagList(AData : string; ABagsList: TDictionary<string, TBag>);
begin
  var ADataArray := Adata.Split([#13#10]);
  for var I := Low(ADataArray) to High(ADataArray) do
  begin
    var ABag : TBag;
    ABag.Color := TRegEx.Match(ADataArray[I], '(.*) bags contain').Groups[1].value;
    var TmpStr := TRegEx.Match(ADataArray[I], '(.*) bags contain (.*)').Groups[2].value;
    var TmpArray := TmpStr.Split([',']);
    for var J := Low(TmpArray) to High(TmpArray) do
    begin
      var Number := trim(TRegEx.Match(TmpArray[J], '\s*(\d*) (.*) bag\s*').Groups[1].value);
      var Name := trim(TRegEx.Match(TmpArray[J], '\s*(\d*) (.*) bag\s*').Groups[2].value);
      if Number <> '' then begin
        SetLength(ABag.Contains, Length(ABag.Contains) + 1);
        ABag.Contains[Length(ABag.Contains) - 1] := TPair<string, integer>.Create(Name, Number.ToInteger);
      end;
    end;
    ABagsList.Add(ABag.Color, ABag);
  end;
end;

function PartA(AData : string): string;
var
  Total: Integer;
  BagsList: TDictionary<string, TBag>;
begin
  Total := 0;
  BagsList := TDictionary<string, TBag>.Create;
  try
    FillBagList(AData, Bagslist);

    for var Bag in BagsList do
    begin
      var TmpCount := 0;
      for var TmpBag in Bag.Value.Contains do
      begin
       TmpCount := TmpCount + ContainShinyBags(BagsList, TmpBag.Key, TmpBag.Value);
      end;
      if TmpCount > 0 then begin
        Inc(Total);
      end;
    end;
  finally
    BagsList.Free;
  end;
  Result := Total.ToString;
end;


function PartB(AData : string): string;
var
  Total: Integer;
  BagsList: TDictionary<string, TBag>;
begin
  Total := 0;
  BagsList := TDictionary<string, TBag>.Create;
  try
    FillBagList(AData, Bagslist);

    Total := ContainBags(BagsList, 'shiny gold', 1) - 1;
  finally
    BagsList.Free;
  end;
  Result := Total.ToString;
end;

begin
  try
    writeln(PartA(T_WGUtils.OpenFile('..\..\day7Test.txt')));
    writeln(PartA(T_WGUtils.OpenFile('..\..\day7.txt')));
    writeln(PartB(T_WGUtils.OpenFile('..\..\day7Test.txt')));
    writeln(PartB(T_WGUtils.OpenFile('..\..\day7.txt')));
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  Readln;
end.
