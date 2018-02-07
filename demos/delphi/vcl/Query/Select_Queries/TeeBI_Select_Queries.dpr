program TeeBI_Select_Queries;

{.$DEFINE FASTMM}
{.$DEFINE LEAKCHECK}

uses
  {$IFDEF LEAKCHECK}
    LeakCheck,
  {$ENDIF }
  Vcl.Forms,
  Unit24 in 'Unit24.pas' {Form24},
  BI.Tests.SelectSamples in '..\..\..\..\..\tests\BI.Tests.SelectSamples.pas',
  BI.Tests.SummarySamples in '..\..\..\..\..\tests\BI.Tests.SummarySamples.pas',
  BI.Queries.Benchmark in 'BI.Queries.Benchmark.pas';

{$R *.res}

begin
  {$IFOPT D+}
  ReportMemoryLeaksOnShutdown:=True;
  {$ENDIF}
  //NeverSleepOnMMThreadContention:=True;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TTestSQLQueries, TestSQLQueries);
  Application.Run;
end.
