program Day16;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.Math,
  System.StrUtils,
  System.Generics.Collections,
  WGUtils,
  System.RegularExpressions,
  System.SysUtils;

type TRule = class
  FirstMin: Integer;
  FirstMax: Integer;
  SecondMin: Integer;
  SecondMax: Integer;
  Name: String;
  FieldNumber: Integer;
end;

function CheckRule(ANumber:Integer; ARule: TRule): Boolean;
begin
  Result := ((ARule.FirstMin <= ANumber) and (ARule.FirstMax >= ANumber)) or 
       ((ARule.SecondMin <= ANumber) and (ARule.SecondMax >= ANumber))
end;

function CheckRules(ANumber:Integer; ARules: TList<TRule>): Boolean;
begin
  Result := False;
  for var Rule in ARules do
  begin
    if CheckRule(ANumber, Rule) then
    begin
      Result := True;
      Break;
    end;   
  end;    
end;

function PartA(AData : string): string;
var
  Total : Integer;
  Rules: TList<TRule>;
begin
  Total := 0;
  Rules := TList<TRule>.Create;
  try
    var DataArray := AData.Split([#13#10]);
    var NearbyTickets := false;
    for var I := Low(DataArray) to High((DataArray)) do
    begin

      var Match := TRegEx.Match(DataArray[I], '.*: (\d+)-(\d+) or (\d+)-(\d+)');
      if not NearbyTickets and Match.Success then
      begin
        var Rule := TRule.Create;;
        Rule.FirstMin := Match.Groups[1].value.ToInteger;
        Rule.FirstMax := Match.Groups[2].value.ToInteger;        
        Rule.SecondMin := Match.Groups[3].value.ToInteger;        
        Rule.SecondMax := Match.Groups[4].value.ToInteger;        
        
        Rules.Add(Rule);
      end else if NearbyTickets then
      begin
        var NumbersArray := DataArray[I].Split([',']);
        for var J := Low(NumbersArray) to High(NumbersArray) do
        begin
          var Number := NumbersArray[J].ToInteger;
          if not CheckRules(Number, Rules) then
          begin  
            Inc(Total, Number);
          end;          
        end;
      end;
      if DataArray[I] = 'nearby tickets:' then
      begin
        NearbyTickets := True;
      end;
    end;
  finally
    Rules.Free;
  end;

  Result := Total.ToString;
end;


function FindRightField(ARule: TRule; AValidTickets: TList<TArray<Integer>>; APossibleFields: TList<Integer>): Integer;
begin
  Result := -1;
  var NumberOfValidFields := 0;
  for var I in APossibleFields do
  begin   
    var ValidRule := True; 
    for var J := 0 to AValidTickets.Count - 1 do
    begin
      if not CheckRule(AValidTickets[J][I], ARule) then
      begin
        ValidRule := False;
        break;
      end;            
    end;
    if ValidRule then
    begin
      Result := I;
      Inc(NumberOfValidFields);
    end;
    if NumberOfValidFields > 1 then
    begin
      Result := -1;
    end;
  end;
end;

function AllRulesFound(ARules: TList<TRule>): Boolean;
begin
  Result := True;
  for var I := 0 to ARules.Count - 1 do
  begin
    Result := Result and (ARules[I].FieldNumber <> -1);
  end;
end;

function PartB(AData : string): string;
var
  Total : Int64;
  Rules: TList<TRule>;
  ValidTickets: TList<TArray<Integer>>;
  MyTicket: TArray<Integer>;
begin
  Total := 1;
  Rules := TList<TRule>.Create;
  ValidTickets := TList<TArray<Integer>>.Create;
  try
    var DataArray := AData.Split([#13#10]);
    var NearbyTickets := false;
    var IsMyTicket := false;
    for var I := Low(DataArray) to High((DataArray)) do
    begin

      var Match := TRegEx.Match(DataArray[I], '(.*): (\d+)-(\d+) or (\d+)-(\d+)');
      if not NearbyTickets and Match.Success then
      begin
        var Rule := TRule.Create;
        Rule.Name := Match.Groups[1].value;
        Rule.FirstMin := Match.Groups[2].value.ToInteger;
        Rule.FirstMax := Match.Groups[3].value.ToInteger;        
        Rule.SecondMin := Match.Groups[4].value.ToInteger;        
        Rule.SecondMax := Match.Groups[5].value.ToInteger;        
        Rule.FieldNumber := -1;
        Rules.Add(Rule);
      end else if NearbyTickets then
      begin
        var NumbersArray := DataArray[I].Split([',']);
        var IsTicketValid := True;
        for var J := Low(NumbersArray) to High(NumbersArray) do
        begin
          var Number := NumbersArray[J].ToInteger;
          If not CheckRules(Number, Rules) then
          begin  
            IsTicketValid := False;
            Break;
          end;          
        end;
        var Ticket: TArray<Integer>;
        SetLEngth(Ticket, Length(NumbersArray));
        if IsTicketValid then
        begin
          for var J :=  Low(NumbersArray) to High(NumbersArray) do
          begin  
            Ticket[J] := NumbersArray[J].ToInteger;
          end;
          ValidTickets.Add(Ticket);
        end;
      end;
      if IsMyTicket then begin
        var NumbersArray := DataArray[I].Split([',']);
        SetLength(MyTicket, Length(NumbersArray));
        for var J :=  Low(NumbersArray) to High(NumbersArray) do
        begin
          MyTicket[J] := NumbersArray[J].ToInteger;
        end;
        IsMyTicket := False;
      end;

      if DataArray[I] = 'nearby tickets:' then
      begin
        NearbyTickets := True;
        IsMyTicket := False;
      end;
      if DataArray[I] = 'your ticket:' then
      begin
        IsMyTicket := True;
      end;

    end;

    var PossibleFields := TList<Integer>.Create;
    for var I := 0 to Rules.Count - 1 do
    begin
      PossibleFields.Add(I);
    end;
      
    try
      while not AllRulesFound(Rules) do
      begin
        for var I := 0 to Rules.Count - 1 do
        begin
          var Rule := Rules[I];
          var RightField := FindRightField(Rules[I], ValidTickets, PossibleFields);
          if RightField <> -1 then    
          begin
            Rule.FieldNumber := RightField;
            PossibleFields.Remove(RightField);
          end;
        end;
      end;
      for var Rule in Rules do begin
        if Rule.Name.Contains('departure') then
        begin
          Total := Total * MyTicket[Rule.FieldNumber];
        end;
      end;

    finally
      PossibleFields.Free;
    end;
    
  finally
    Rules.Free;
    ValidTickets.Free;
  end;

  Result := Total.ToString;
end;

begin
  try
    writeln(PartA(T_WGUtils.OpenFile('..\..\day16Test.txt')));
    writeln(PartA(T_WGUtils.OpenFile('..\..\day16.txt')));
//    writeln(PartB(T_WGUtils.OpenFile('..\..\day16Test.txt')));
    writeln(PartB(T_WGUtils.OpenFile('..\..\day16.txt')));
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  Readln;
end.
