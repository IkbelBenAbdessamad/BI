{*********************************************}
{  TeeBI Software Library                     }
{  TBIGrid VCL Example                        }
{  Copyright (c) 2015-2016 by Steema Software }
{  All Rights Reserved                        }
{*********************************************}
unit MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls,
  VCLBI.Editor.BIGrid, VCLBI.DataManager, Vcl.DBCtrls,
  VCLBI.DataControl, VCLBI.Grid;

type
  TGridDemoForm = class(TForm)
    PageControl1: TPageControl;
    TabOptions: TTabSheet;
    TabData: TTabSheet;
    Splitter1: TSplitter;
    Panel1: TPanel;
    BIGrid1: TBIGrid;
    Panel2: TPanel;
    DBNavigator1: TDBNavigator;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }

    GridEditor : TBIGridEditor;

    procedure SelectedData(Sender: TObject);
  public
    { Public declarations }
  end;

var
  GridDemoForm: TGridDemoForm;

implementation

{$R *.dfm}

uses
  BI.Persist, BI.DataItem;

procedure TGridDemoForm.FormCreate(Sender: TObject);
begin
  PageControl1.ActivePage:=TabOptions;

  // Editor dialog to customize Grid options
  GridEditor:=TBIGridEditor.Embedd(Self,TabOptions,BIGrid1);

  // Load "Customers" table into Grid
  BIGrid1.Data:=TStore.Load('BISamples','SQLite_Demo')['Customers'];

  // Editor dialog to choose a Data
  TDataManager.Embed(Self,TabData,TDataManagerEmbedMode.Choose,'BISamples',BIGrid1.Data).OnSelect:=SelectedData;

  // Set Navigator control source
  DBNavigator1.DataSource:=BIGrid1.DataSource;

// Several BIGrid features that can be activated:

//  BIGrid1.ShowItems:=TGridShowItems.Automatic; // <-- Yes,No,SubTables
//  BIGrid1.Alternate.Enabled:=True;
//  BIGrid1.Filters.Enabled:=True;
//  BIGrid1.ReadOnly:=False;
//  BIGrid1.RowNumbers.Enabled:=True;
//  BIGrid1.Search.Enabled:=True;
//  BIGrid1.ColumnSort:=True;
end;

// When a new Data is selected, reset Grid:
procedure TGridDemoForm.SelectedData(Sender: TObject);
var tmp : TDataItem;
begin
  tmp:=TDataManager(Sender).SelectedData;

  if tmp<>BIGrid1.Data then
  begin
    BIGrid1.Data:=tmp;
    GridEditor.Refresh(BIGrid1);
  end;
end;

end.
