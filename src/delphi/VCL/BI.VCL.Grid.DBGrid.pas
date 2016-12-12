{*********************************************}
{  TeeBI Software Library                     }
{  TBIGrid plugin for VCL DBGrid              }
{  Copyright (c) 2015-2016 by Steema Software }
{  All Rights Reserved                        }
{*********************************************}
unit BI.VCL.Grid.DBGrid;

interface

uses
  {$IFDEF MSWINDOWS}
  WinAPI.Windows,
  {$ENDIF}
  {$IFDEF FPC}
  BI.FPC,
  {$ELSE}
  Messages, UITypes,
  System.Types, // <-- due to inlining
  {$ENDIF}
  Classes, SysUtils,
  VCL.Controls, VCL.Grids, VCL.DBGrids, VCL.Graphics, Data.DB,
  VCL.Buttons, VCL.Menus, VCL.StdCtrls, VCL.ExtCtrls,
  BI.VCL.Grid, BI.Data, BI.UI, BI.DataSet, BI.DataSource,
  BI.VCL.Editor.Search;

type
  {$IFDEF FPC}
  TDrawCellEvent=TOnDrawCell;
  {$ENDIF}

  TBIDBGrid=class(TDBGrid)
  private
  const
    OffsetTotals=2;
    function GetSearchEditor: TSearchEditor;

  type
    TGridMenu=record
    public
      Alternate : TMenuItem;
      Button : TSpeedButton;
      Colorize : TMenuItem;
      Detail : TMenuItem;
      Filters : TMenuItem;
      ExportData : TMenuItem;
      GroupBy : TMenuItem;
      Search : TMenuItem;
      Sort : TMenuItem;
      Popup : TPopupMenu;
      RowNumbers : TMenuItem;
    end;

    TGridGroup=record
    private
      procedure CreateGrid(const AGrid:TBIDBGrid);
      function DBGrid:TBIDBGrid;
      procedure ShowGroup(const AData:TDataItem);
    public
      Grid : TBIGrid;
      Split : TSplitter;
      DataSet : TBIDataset;
      GridOf : TBIDBGrid;
      Index : TCursorIndex;
    end;

  var
    FColorizers : TDataColorizers;
    FColumnSort : Boolean;

    FOnAfterDrawCell,
    FOnBeforeDrawCell :  TDrawCellEvent;

    FTotals: Boolean;

    FLastTitle : Integer;
    FLastWidth : Integer;
    FLastFontStyle : TFontStyles;

    IAlternate : TAlternateColor;
    IAssociated : TPanel;
    IHighLight : TSearchEditor;

    IMenu : TGridMenu;

    IDetailGrid : TBIGrid;
    IDetailSplitter : TSplitter;

    IGroup : TGridGroup;

    IWasDragging : Boolean;

    procedure AddDetailMenu;
    procedure AddGroupByMenu;
    class function AddMenuButton(const AParent:TWinControl; const ACaption:String;
                           const AHeight:Integer;
                           const AClick:TNotifyEvent):TSpeedButton; static;
    procedure AlternateChanged(Sender:TObject);
    procedure AlternateClick(Sender:TObject);
    procedure ApplyFilter(const AllowAllRows:Boolean; const ACol:Integer; const Value:String);
    function BIDataset:TBIDataset;
    function CalcSortWidth:Integer;
    function CanColorize:Boolean;
    procedure ChangeDataSet(const ADataSet:TDataSet);
    procedure ChangedFilter(const ACol:Integer; const Value:String);
    procedure ChangedSearch(Sender:TObject);
    procedure CheckDataSource;
    procedure CheckFilterGrid;
    procedure CloseGroup(Sender:TObject);
    function Colorizable:TDataColorizers;
    procedure ColorizeClick(Sender:TObject);
    procedure DestroyMenu;
    function DetailItems:TDataArray;
    procedure DetailClicked(Sender: TObject);
    procedure DoGroupBy(Sender:TObject);
    procedure DoTitleClick(AColumn:TColumn);
    procedure ExportDataClick(Sender:TObject);
    function GetData:TDataItem;
    function GetDetail: TDataItem;
    procedure GroupDataChange(Sender: TObject; Field: TField);
    function HasFilterGrid:Boolean;
    function HasSearchPanel:Boolean;
    procedure MenuClick(Sender:TObject);
    procedure MenuFiltersClick(Sender: TObject);
    procedure MenuPopup(Sender:TObject);
    procedure MenuSearchClick(Sender: TObject);
    procedure MenuSortClick(Sender:TObject);
    function ParentsOf(AField:TField):Integer;
    procedure RepaintTotals;
    procedure ResetFeatures;
    procedure RowNumbersClick(Sender:TObject);
    procedure SetColumnSort(const Value:Boolean);
    procedure SetDetail(const AData:TDataItem);
    function TitleWidth(const AColumn:TColumn):Integer;
    function TryColorize(const ARow,ACol:Integer; const AColumn:TColumn; out AIndex:Integer; out APercent:Double):Boolean;
    function TryFontColor(const AIndex:Integer; const ANewColor,ADefault:TColor):TColor;

    {$IFNDEF FPC}
    procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;
    procedure WMNCPaint(var Message: TMessage); message WM_NCPaint;
    {$ENDIF}
  protected
    function ColumnOf(const X:Integer):TColumn; overload;

    {$IFDEF FPC}
    procedure ColRowMoved(IsColumn: Boolean; FromIndex,ToIndex: Integer); override;
    {$ELSE}
    procedure ColumnMoved(FromIndex, ToIndex: Longint); override;
    {$ENDIF}

    procedure ColWidthsChanged; override;

    function CreateColumns: TDBGridColumns; override;

    {$IFDEF FPC}
    procedure DoPrepareCanvas(aCol,aRow:Integer; aState: TGridDrawState); override;
    {$ENDIF}

    procedure DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState); override;

    function GetClientRect:TRect; override;
    procedure LinkActive(Value: Boolean); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    {$IFDEF FPC}
    procedure HeaderClick(IsColumn: Boolean; index: Integer); override;
    {$ELSE}
    procedure SetColumnAttributes; override;
    procedure TitleClick(Column: TColumn); override;
    {$ENDIF}

    procedure Resize; override;
    procedure SetParent(AParent: TWinControl); override;
    procedure TopLeftChanged; override;
    function TotalWidth:Integer;
    procedure TryClearFilter;
    procedure TryCloseGroup;
  public
    {$IFDEF FPC}
    IndicatorOffset : Integer;
    {$ENDIF}

    ScrollTrack : Boolean;

    Constructor Create(AOwner:TComponent); override;
    Destructor Destroy; override;

    function ColumnOf(const AField:TField):TColumn; overload;
    function ColumnOf(const AData:TDataItem):TColumn; overload;
    procedure Traverse(const AColumn:TColumn; const AProc:TProc<TColumn>);

    property Detail:TDataItem read GetDetail write SetDetail;
    property MenuButton:TSpeedButton read IMenu.Button;
    property SearchEditor:TSearchEditor read GetSearchEditor;
    property TopRow;
  published
    property ColumnSort:Boolean read FColumnSort write SetColumnSort default True;
    property DefaultColWidth;
    property DefaultRowHeight;
    {$IFDEF FPC}
    property Flat default True;
    {$ELSE}
    property DrawingStyle default TGridDrawingStyle.gdsThemed;
    {$ENDIF}
    property GridLineWidth;
    {$IFNDEF FPC}
    property IndicatorOffset;
    {$ENDIF}
    property ReadOnly default True;

    property OnAfterDrawCell:TDrawCellEvent read FOnAfterDrawCell write FOnAfterDrawCell;
    property OnBeforeDrawCell:TDrawCellEvent read FOnBeforeDrawCell write FOnBeforeDrawCell;
  end;

  TBIDBGridPlugin=class(TBIGridPlugin)
  private
    IGrid : TBIDBGrid;
    IPanel : TPanel;
  protected
    procedure AutoWidth; override;
    procedure ChangedAlternate(Sender:TObject); override;
    function GetDataSource: TDataSource; override;
    function GetEditorClass:String; override;
    function GetReadOnly:Boolean; override;
    function GetTotals:Boolean; override;
    procedure SetDataSource(const Value: TDataSource); override;
    procedure SetFilters(const Value:Boolean); override;
    procedure SetReadOnly(const Value:Boolean); override;
    procedure SetRowNumber(const Value:Boolean); override;
    procedure SetSearch(const Value:Boolean); override;
    procedure SetTotals(const Value:Boolean); override;
  public
    Constructor Create(const AOwner:TComponent); override;
    Destructor Destroy; override;

    procedure BindTo(const ADataSet:TDataSet); override;
    procedure Colorize(const AItems:TDataColorizers); override;
    procedure Duplicates(const AData:TDataItem; const Hide:Boolean); override;
    function GetObject:TObject; override;
  end;

implementation
