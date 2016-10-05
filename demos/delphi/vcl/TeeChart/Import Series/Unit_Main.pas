unit Unit_Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VclTee.TeeGDIPlus, VCLTee.TeEngine,
  VCLTee.Series, BI.VCL.Grid, Vcl.ExtCtrls, VCLTee.TeeProcs, VCLTee.Chart,
  BI.VCL.Chart, BI.VCL.Chart.Plugin, Vcl.StdCtrls, BI.VCL.DataControl;

type
  TSeriesImport = class(TForm)
    BIChart1: TBIChart;
    BIGrid1: TBIGrid;
    Chart1: TChart;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    BITChart1: TBITChart;
    Series1: TPointSeries;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SeriesImport: TSeriesImport;

implementation

{$R *.dfm}

uses Unit_XYTest;

procedure TSeriesImport.Button1Click(Sender: TObject);
begin
  BIChart1.Data:=BIGrid1.Data;
end;

procedure TSeriesImport.Button2Click(Sender: TObject);
begin
  with TFormXYTest.Create(Self) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

procedure TSeriesImport.FormCreate(Sender: TObject);
begin
  // Fill Series1 with random sample values
  Series1.FillSampleValues;

  // Convert Series1 to a TDataItem
  BIGrid1.Data:=TChartData.From(Series1);

  // Convert a TDataItem to a new Series
  Chart1.AddSeries(TChartData.From(BIGrid1.Data, Self, TLineSeries));

  // Free Series1
  Series1.Free;
end;

procedure TSeriesImport.FormDestroy(Sender: TObject);
begin
  BIGrid1.Data.Free;
end;

end.
