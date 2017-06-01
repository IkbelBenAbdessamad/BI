{*********************************************}
{  TeeBI Software Library                     }
{  TSummary Editor                            }
{  Copyright (c) 2015-2016 by Steema Software }
{  All Rights Reserved                        }
{*********************************************}
unit VCLBI.Editor.Summary;

interface

uses
  {$IFNDEF FPC}
  Winapi.Windows, Winapi.Messages,
  {$ENDIF}
  System.SysUtils, System.Classes,
  Vcl.Graphics, System.Types, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.CheckLst, Vcl.Buttons,
  BI.DataItem, BI.Summary;

type
  TSummaryEditor = class(TForm)
    PageControl1: TPageControl;
    TabMeasure: TTabSheet;
    TabMeasures: TTabSheet;
    TabSheet2: TTabSheet;
    PanelGroups: TPanel;
    LMeasures: TCheckListBox;
    Panel1: TPanel;
    BUp: TSpeedButton;
    BDown: TSpeedButton;
    Button1: TButton;
    BRemoveMeasure: TButton;
    GroupBox1: TGroupBox;
    CBRemoveMissing: TCheckBox;
    CBRemoveCols: TCheckBox;
    TabDimensions: TTabSheet;
    Panel2: TPanel;
    UpDim: TSpeedButton;
    DownDim: TSpeedButton;
    Button3: TButton;
    BRemoveDim: TButton;
    LDimensions: TCheckListBox;
    PageMeasures: TPageControl;
    CBAggregate: TComboBox;
    CBMissingAsZero: TCheckBox;
    TabMeasureInfo: TTabSheet;
    Label4: TLabel;
    LabelMeasureKind: TLabel;
    TabCalc: TTabSheet;
    RGRunning: TRadioGroup;
    CBRunningRows: TCheckBox;
    RGPercentage: TRadioGroup;
    TabFilter: TTabSheet;
    EFilter: TEdit;
    LFilter: TLabel;
    EHaving: TEdit;
    LHaving: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label5: TLabel;
    EMeasureExpression: TEdit;
    LMeasureError: TLabel;
    PageGroups: TPageControl;
    TabGroup: TTabSheet;
    RGLayout: TRadioGroup;
    TabHistogram: TTabSheet;
    CBHistogram: TCheckBox;
    Label1: TLabel;
    EBins: TEdit;
    UDBins: TUpDown;
    TabGroupData: TTabSheet;
    Label3: TLabel;
    LGroupError: TLabel;
    EGroupExpression: TEdit;
    CBMinAuto: TCheckBox;
    CBMaxAuto: TCheckBox;
    EHistoMin: TEdit;
    EHistoMax: TEdit;
    Label2: TLabel;
    Label8: TLabel;
    CBAutoBins: TCheckBox;
    Label9: TLabel;
    EHistFormat: TEdit;
    CBDatePart: TComboBox;
    Label10: TLabel;
    Label11: TLabel;
    EMeasureName: TEdit;
    PanelButtons: TPanel;
    Panel9: TPanel;
    BOK: TButton;
    Button2: TButton;
    Label12: TLabel;
    EGroupName: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure CBAggregateChange(Sender: TObject);
    procedure CBDatePartChange(Sender: TObject);
    procedure CBHistogramClick(Sender: TObject);
    procedure CBMissingAsZeroClick(Sender: TObject);
    procedure EBinsChange(Sender: TObject);
    procedure LMeasuresClick(Sender: TObject);
    procedure LMeasuresClickCheck(Sender: TObject);
    procedure LMeasuresDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure RGLayoutClick(Sender: TObject);
    procedure CBRemoveColsClick(Sender: TObject);
    procedure CBRemoveMissingClick(Sender: TObject);
    procedure LMeasuresDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure LDimensionsDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure LDimensionsClickCheck(Sender: TObject);
    procedure LDimensionsClick(Sender: TObject);
    procedure UpDimClick(Sender: TObject);
    procedure DownDimClick(Sender: TObject);
    procedure BUpClick(Sender: TObject);
    procedure BDownClick(Sender: TObject);
    procedure BRemoveDimClick(Sender: TObject);
    procedure BRemoveMeasureClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure RGRunningClick(Sender: TObject);
    procedure CBRunningRowsClick(Sender: TObject);
    procedure RGPercentageClick(Sender: TObject);
    procedure EFilterChange(Sender: TObject);
    procedure EHavingChange(Sender: TObject);
    procedure EMeasureExpressionChange(Sender: TObject);
    procedure PageMeasuresResize(Sender: TObject);
    procedure EGroupExpressionChange(Sender: TObject);
    procedure PageGroupsResize(Sender: TObject);
    procedure CBMinAutoClick(Sender: TObject);
    procedure CBMaxAutoClick(Sender: TObject);
    procedure EHistoMinChange(Sender: TObject);
    procedure EHistoMaxChange(Sender: TObject);
    procedure CBAutoBinsClick(Sender: TObject);
    procedure EHistFormatChange(Sender: TObject);
    procedure EMeasureNameChange(Sender: TObject);
    procedure EGroupNameChange(Sender: TObject);
  private
    { Private declarations }

    ISummary : TSummary;
    IChanging : Boolean;

    procedure AddFields;
    procedure AddDimension(const ADim:TGroupBy);
    procedure AddMeasure(const AMeasure:TMeasure);
    procedure ChangedGroup;
    procedure ChangedMeasure;
    procedure Recalculate;
    procedure RecalculateHistogram;
    procedure RefreshMeasureInfo;
    function SelectedGroup:TGroupBy;
    function SelectedMeasure:TMeasure;
    procedure SwapMeasures(const A,B:Integer);
    procedure SwapDimensions(const A,B:Integer);
  public
    { Public declarations }
    OnRecalculate : TNotifyEvent;

    class function Edit(const AOwner:TComponent; const ASummary:TSummary):Boolean; static;

    procedure Refresh(const ASummary:TSummary);
  end;

implementation
