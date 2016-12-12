{*********************************************}
{  TeeBI Software Library                     }
{  TBIGrid control for VCL                    }
{  Copyright (c) 2015-2016 by Steema Software }
{  All Rights Reserved                        }
{*********************************************}
unit BI.VCL.Grid;

interface

uses
  System.Classes, System.SysUtils, System.Types,
  {$IFNDEF FPC}
  System.UITypes,
  {$ENDIF}
  VCL.Controls, VCL.Forms, Data.DB, BI.Data,
  BI.DataSource, BI.Dataset, VCL.Graphics, Vcl.ComCtrls,
  BI.UI, BI.VCL.DataControl, BI.Expression;

type
  TBIGridPluginClass=class of TBIGridPlugin;

  // Pending: Try to merge VCL and FMX TBIGridPlugin classes into a single one.

  // Abstract class to define Grid control classes as "plugins" of TBIGrid.
  // See BI.VCL.Grid.DBGrid unit for an example, using the VCL TDBGrid.
  TBIGridPlugin=class abstract
  protected
    IAlternate : TAlternateColor;

    procedure AutoWidth; virtual; abstract;
    procedure ChangedAlternate(Sender:TObject); virtual; abstract;
    function GetDataSource: TDataSource; virtual; abstract;
    function GetEditorClass:String; virtual; abstract;
    function GetReadOnly:Boolean; virtual; abstract;
    function GetTotals:Boolean; virtual; abstract;
    procedure SetDataSource(const Value: TDataSource); virtual; abstract;
    procedure SetFilters(const Value:Boolean); virtual; abstract;
    procedure SetReadOnly(const Value:Boolean); virtual; abstract;
    procedure SetRowNumber(const Value:Boolean); virtual; abstract;
    procedure SetSearch(const Value:Boolean); virtual; abstract;
    procedure SetTotals(const Value:Boolean); virtual; abstract;
  public
    class var
      Engine : TBIGridPluginClass;

    Constructor Create(const AOwner:TComponent); virtual; abstract;

    procedure Colorize(const AItems:TDataColorizers); virtual; abstract;
    procedure BindTo(const ADataSet:TDataSet); virtual; abstract;
    procedure Duplicates(const AData:TDataItem; const Hide:Boolean); virtual; abstract;
    function GetObject:TObject; virtual; abstract;

    property DataSource:TDataSource read GetDataSource write SetDataSource;
    property EditorClass:String read GetEditorClass;
    property ReadOnly:Boolean read GetReadOnly write SetReadOnly;
    property Totals:Boolean read GetTotals write SetTotals;
  end;

  TBIGrid=class;

  TBaseEnabled=class(TPersistent)
  private
    FEnabled : Boolean;

    IGrid : TBIGrid;
  protected
    procedure SetEnabled(const Value: Boolean); virtual; abstract;
  published
    property Enabled:Boolean read FEnabled write SetEnabled default False;
  end;

  TRowNumbers=class(TBaseEnabled)
  protected
    procedure SetEnabled(const Value: Boolean); override;
  end;

  TGridFilters=class(TBaseEnabled)
  protected
    procedure SetEnabled(const Value: Boolean); override;
  end;

  TGridShowItems=(Automatic, Yes, No); //, SubTables);

  TGridSearch=class(TBaseEnabled)
  protected
    procedure SetEnabled(const Value: Boolean); override;
  end;

  // Generic Grid control that "links" a TDataItem with a Grid.
  TBIGrid = class(TBIDataControl)
  private
    IDataSet : TBIDataset;
    IPlugin : TBIGridPlugin;

    IDataSetRight : TBIDataset;
    IPluginRight : TBIGridPlugin;

    FAlternate : TAlternateColor;
    FGridFilters : TGridFilters;
    FOnDataChange : TNotifyEvent;
    FOnUpdateData : TNotifyEvent;
    FRowNumbers : TRowNumbers;
    FSearch : TGridSearch;
    FShowItems : TGridShowItems;

    procedure ChangedRow(Sender: TObject; Field: TField);
    procedure ControlDblClick(Sender:TObject);
    function GetCurrentRow: Integer;
    function GetDataSource: TDataSource;
    function GetFilter: TExpression;
    function GetReadOnly: Boolean;
    function GetTotals:Boolean;
    function HasSubItem: Boolean;
    procedure HideShowItems;
    function PluginControl:TWinControl;

    procedure SetAlternate(const Value: TAlternateColor);
    procedure SetCurrentRow(const Value: Integer);
    procedure SetDataSource(const Value: TDataSource);
    procedure SetFilter(const AFilter:TExpression);
    procedure SetGridFilters(const Value: TGridFilters);
    procedure SetPlugin(const Value: TBIGridPlugin);
    procedure SetReadOnly(const Value: Boolean);
    procedure SetRowNumbers(const Value: TRowNumbers);
    procedure SetSearch(const Value: TGridSearch);
    procedure SetShowItems(const Value: TGridShowItems);
    procedure SetTotals(const Value: Boolean);

    procedure UpdatedData(DataSet: TDataSet);

    procedure TryShowItems;
  protected
    procedure SetDataDirect(const Value: TDataItem); override;

    function SubItem:TDataItem;
    function SubGrid:TBIGridPlugin;

    procedure UpdatedDataValues; override;
  public
    Constructor Create(AOwner:TComponent); override;
    Destructor Destroy; override;

    procedure BindTo(const AData:TDataItem);
    procedure Colorize(const AItems:TDataColorizers);
    procedure Duplicates(const AData:TDataItem; const Hide:Boolean);
    procedure Invalidate; override;

    property CurrentRow:Integer read GetCurrentRow write SetCurrentRow;
    property Filter:TExpression read GetFilter write SetFilter;
    property Plugin:TBIGridPlugin read IPlugin write SetPlugin;
  published
    property Alternate:TAlternateColor read FAlternate write SetAlternate;
    property DataSource:TDataSource read GetDataSource write SetDataSource;
    property Filters:TGridFilters read FGridFilters write SetGridFilters;
    property ReadOnly:Boolean read GetReadOnly write SetReadOnly default True;
    property RowNumbers:TRowNumbers read FRowNumbers write SetRowNumbers;
    property Search:TGridSearch read FSearch write SetSearch;
    property ShowItems:TGridShowItems read FShowItems write SetShowItems default TGridShowItems.Automatic;
    property Totals:Boolean read GetTotals write SetTotals default False;

    property OnDataChange:TNotifyEvent read FOnDataChange write FOnDataChange;
    property OnUpdateData:TNotifyEvent read FOnUpdateData write FOnUpdateData;
  end;

  // See global TUICommon.Diagram property
  TDiagramEvent=procedure(const AOwner:TComponent; const AData:TDataItem);

  // Helper methods for VCL:
  TUICommon=record
  public
    const
      AlignNone=TAlign.alNone;
      AlignClient=TAlign.alClient;
      AlignLeft=TAlign.alLeft;
      AlignTop=TAlign.alTop;
      AlignRight=TAlign.alRight;
      AlignBottom=TAlign.alBottom;

    // This event is initialized by BI.VCL.LinkDiagram unit (when used).
    class var Diagram : TDiagramEvent;

    class procedure AddForm(const AForm: TCustomForm; const AParent: TWinControl); static;
    class function AutoTest:Boolean; static;
    class function EditColor(const AOwner:TComponent; const AColor:TColor; out ANew:TColor):Boolean; static;
    class procedure GotoURL(const AOwner:TWinControl; const AURL:String); static;
    class function Input(const ATitle,ACaption,ADefault:String; out ANew:String):Boolean; static;
    class procedure LoadPosition(const AForm:TCustomForm; const Key:String); static;
    class function Point(const X,Y:Integer):TPoint; static; inline;
    class procedure SavePosition(const AForm:TCustomForm; const Key:String); static;
    class function SelectFolder(var AFolder:String):Boolean; static;
    class procedure ShowUnique(const ATab:TTabSheet); static;
    class function YesNo(const Message:String):Boolean; static;
  end;

implementation
