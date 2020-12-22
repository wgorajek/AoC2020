program Day21;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.Math,
  System.StrUtils,
  System.Generics.Collections,
  WGUtils,
  System.RegularExpressions,
  Types,
  System.SysUtils;

type
  TRecipe = class
    Indegrents: TList<String>;
    Allergens: TList<String>;

    constructor Create;
    destructor Destroy; override;
  end;

  TIndegrent = class
    Name: String;
    CanContain: TList<string>;
    Contain: String;
    constructor Create(AName: String);
    destructor Destroy; override;
  end;

  TAllergen = class
    Name: String;
    CanContain: TList<string>;
    Contain: String;
    constructor Create(AName: String);
    destructor Destroy; override;
  end;

function PartA(AData : string; IsPartB: Boolean): string;
var
  Total: Integer;
  Recipes: TList<TRecipe>;
  WrongIndegrents: TList<String>;
  AllIndegrents: TDictionary<string, TIndegrent>;
  AllAllergens: TDictionary<string, TAllergen>;
begin
  Total := 0;
  Recipes := TList<TRecipe>.Create;
  WrongIndegrents := TList<string>.Create;
  AllIndegrents := TDictionary<string, TIndegrent>.Create;
  AllAllergens := TDictionary<string, TAllergen>.Create;
  try
    var DataArray := AData.Split([#13#10]);
    for var I := Low(DataArray) to High(DataArray) do
    begin
      var Recipe := TRecipe.create;
      var Match := TRegEx.Match(DataArray[I], '(.*) \(contains (.*)\)');
      for var WordMatch in TRegEx.Matches(Match.Groups[1].Value, '\S+') do
      begin
        Recipe.Indegrents.Add(WordMatch.Value);
      end;
      for var WordMatch in TRegEx.Matches(Match.Groups[2].Value, '[a-z]+') do
      begin
        Recipe.Allergens.Add(WordMatch.Value);
      end;
      Recipes.Add(Recipe);
    end;

    for var Recipe in Recipes do
    begin
      for var Indegrent in Recipe.Indegrents do
      begin
        if not AllIndegrents.ContainsKey(Indegrent) then
        begin
          AllIndegrents.Add(Indegrent, TIndegrent.Create(Indegrent));
        end;
        for var Allergen in Recipe.Allergens do
        begin
          if not AllIndegrents[Indegrent].CanContain.Contains(Allergen) then
          begin
            AllIndegrents[Indegrent].CanContain.Add(Allergen);
          end;
        end;
      end;
    end;
    for var Indegrent in AllIndegrents.Values do
    begin
      for var Recipe in Recipes do
      begin
        if not Recipe.Indegrents.Contains(Indegrent.Name) then
        begin
          for var Allergen in Recipe.Allergens do
          begin
            if Indegrent.CanContain.Contains(Allergen) then
              Indegrent.CanContain.Remove(Allergen);
          end;
        end;
      end;
      if Indegrent.CanContain.Count = 0 then
      begin
        for var Recipe in Recipes do
        begin
          if Recipe.Indegrents.Contains(Indegrent.Name) then
            Inc(Total);
        end;
      end;
    end;
    Result := Total.ToString;
    for var Indegrent in AllIndegrents.Values do
    begin
      for var Allergen in Indegrent.CanContain do
      begin
        if not AllAllergens.ContainsKey(Allergen) then
        begin
          AllAllergens.Add(Allergen, TAllergen.Create(Allergen));
        end;
        if not AllAllergens[Allergen].CanContain.Contains(Indegrent.Name) then
        begin
          AllAllergens[Allergen].CanContain.Add(Indegrent.Name);
        end;
      end;
    end;

    for var I := 0 to AllAllergens.Count do
    begin
      for var Allergen in AllAllergens.Values do
      begin
        if Allergen.CanContain.Count = 1 then
        begin
          for var Allergen2 in AllAllergens.Values do
          begin
            if Allergen <> Allergen2 then
            begin
              Allergen2.CanContain.Remove(Allergen.CanContain[0]);
            end;
          end;
        end;
      end;
    end;
    var FinalAllergenList := TList<string>.Create;

    for var Allergen in AllAllergens.Values do
    begin
      FinalAllergenList.Add(Allergen.Name);
    end;
    FinalAllergenList.Sort;
    var Tmp := '';
    for var Allergen in FinalAllergenList do
    begin
      if not Tmp.IsEmpty then
        Tmp := Tmp + ',';
      Tmp := Tmp + AllAllergens[Allergen].CanContain[0];
    end;
    if IsPartB then
      Result := Tmp;

  finally
    Recipes.Free;
    WrongIndegrents.Free;
    AllIndegrents.Free;
    AllAllergens.Free;
  end;
end;

{ TRecipe }

constructor TRecipe.Create;
begin
  Indegrents := TList<String>.Create;
  Allergens := TList<String>.Create;
end;

destructor TRecipe.Destroy;
begin
  Indegrents.Free;
  Allergens.Free;
  inherited;
end;

{ TIndegrent }

constructor TIndegrent.Create(AName: String);
begin
  CanContain := TList<String>.Create;
  Name := AName;
end;

destructor TIndegrent.Destroy;
begin
  CanContain.Free;
  inherited;
end;

{ TAllergen }

constructor TAllergen.Create(AName: String);
begin
  CanContain := TList<String>.Create;
  Name := AName;
end;

destructor TAllergen.Destroy;
begin
  CanContain.Free;
  inherited;
end;

begin
  try
    writeln(PartA(T_WGUtils.OpenFile('..\..\day21Test.txt'), False));
    writeln(PartA(T_WGUtils.OpenFile('..\..\day21.txt'), False));
    writeln(PartA(T_WGUtils.OpenFile('..\..\day21Test.txt'), True));
    writeln(PartA(T_WGUtils.OpenFile('..\..\day21.txt'), True));
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  Readln;
end.
