program Day18;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.Math,
  System.StrUtils,
  System.Generics.Collections,
  WGUtils,
  System.RegularExpressions,
  System.SysUtils;

function Evaluate(AExpression: String): String;
begin
  var Match: TMatch;
  var Expression := AExpression;

  while (Expression.Contains('+') or Expression.Contains('*')) or Expression.Contains('(') do begin
    Match := TRegEx.Match(Expression, '(.*)\((.*?)\)(.*)');
    if Match.Success then
    begin
      var NewValue := Match.Groups[1].Value + Evaluate(Match.Groups[2].Value) + Match.Groups[3].Value;
      Expression := NewValue;
    end else
    begin
      Match := TRegEx.Match(Expression, '^(\d*) \+ (\d*)(.*)');
      if Match.Success then
      begin
        var NewValue := (Match.Groups[1].Value.ToInt64 + Match.Groups[2].Value.ToInt64).ToString;
        Expression := TRegEx.Replace(Expression, '^(\d*) \+ (\d*)(.*)', NewValue + Match.Groups[3].Value );
      end;
      Match := TRegEx.Match(Expression, '^(\d*) \* (\d*)(.*)');
      if Match.Success then
      begin
        var NewValue := (Match.Groups[1].Value.ToInt64 * Match.Groups[2].Value.ToInt64).ToString;
        Expression := TRegEx.Replace(Expression, '^(\d*) \* (\d*)(.*)', NewValue + Match.Groups[3].Value );
      end;
    end;
    Result := Trim(Expression);
  end;
end;

function Evaluate2(AExpression: String): String;
begin
  var Match: TMatch;
  var Expression := AExpression;


  while (Expression.Contains('+') or Expression.Contains('*')) or Expression.Contains('(') do begin
    Match := TRegEx.Match(Expression, '(.*)\((.*?)\)(.*)');
    if Match.Success then
    begin
      var NewValue := Match.Groups[1].Value + Evaluate2(Match.Groups[2].Value) + Match.Groups[3].Value;
      Expression := NewValue;
//      TRegEx.Replace
    end else
    begin
      Match := TRegEx.Match(Expression, '(\d*) \+ (\d*)(.*)');
      if Match.Success then
      begin
        var NewValue := (Match.Groups[1].Value.ToInt64 + Match.Groups[2].Value.ToInt64).ToString;
        Expression := TRegEx.Replace(Expression, '(\d*) \+ (\d*)(.*)', NewValue + Match.Groups[3].Value );
      end else
      begin
        Match := TRegEx.Match(Expression, '^(\d*) \* (\d*)(.*)');
        if Match.Success then
        begin
          var NewValue := (Match.Groups[1].Value.ToInt64 * Match.Groups[2].Value.ToInt64).ToString;
          Expression := TRegEx.Replace(Expression, '^(\d*) \* (\d*)(.*)', NewValue + Match.Groups[3].Value );
        end;
      end;
    end;
    Result := Trim(Expression);
  end;
end;

function PartA(AData : string): string;
var
  Total : Int64;
begin
  Total := 0;
  var DataArray := AData.Split([#13#10]);
  for var I := Low(DataArray) to High(DataArray) do
  begin
    var Match: TMatch;
    var Expression := DataArray[I];
    Expression := Evaluate(Expression);
    Inc(Total, Expression.ToInt64);
  end;

  Result := Total.ToString;
end;

function PartB(AData : string): string;
var
  Total : Int64;
begin
  Total := 0;
  var DataArray := AData.Split([#13#10]);
  for var I := Low(DataArray) to High(DataArray) do
  begin
    var Match: TMatch;
    var Expression := DataArray[I];
    Expression := Evaluate2(Expression);
    Inc(Total, Expression.ToInt64);
  end;

  Result := Total.ToString;
end;

begin
  try
    writeln(PartA(T_WGUtils.OpenFile('..\..\day18Test.txt')));
    writeln(PartA(T_WGUtils.OpenFile('..\..\day18.txt')));
    writeln(PartB(T_WGUtils.OpenFile('..\..\day18Test.txt')));
    writeln(PartB(T_WGUtils.OpenFile('..\..\day18.txt')));
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  Readln;
end.
