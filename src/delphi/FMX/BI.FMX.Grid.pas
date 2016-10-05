{*********************************************}
{  TeeBI Software Library                     }
{  TBIGrid control for FireMonkey             }
{  Copyright (c) 2015-2016 by Steema Software }
{  All Rights Reserved                        }
{*********************************************}
unit BI.FMX.Grid;

interface

uses
  System.Classes, System.UITypes,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Layouts, BI.FMX.DataControl,
  Data.DB, BI.DataSet, BI.Data, BI.DataSource, FMX.Menus, BI.UI;

type
  TBIGridPluginClass=class of TBIGridPlugin;

  // Pending: Try to merge VCL and FMX TBIGridPlugin classes into a single one.

  // Abstract class to define Grid control classes as "plugins" of TBIGrid.
  // See BI.FMX.Grid.Grid unit for an example, using the standard FMX TGrid.
  TBIGridPlugin=class abstract
  protected
    IAlternate : TAlternateColor;

    procedure AutoWidth; virtual; abstract;
    procedure ChangedAlternate(Sender:TObject); virtual; abstract;
    function GetDataSource: TDataSource; virtual; abstract;
    function GetReadOnly:Boolean; virtual; abstract;
    function GetTotals:Boolean; virtual; abstract;
    procedure SetDataSource(const Value: TDataSource); virtual; abstract;
    procedure SetOnRowChanged(const AEvent:TNotifyEvent); virtual; abstract;
    procedure SetReadOnly(const Value:Boolean); virtual; abstract;
    procedure SetTotals(const Value:Boolean); virtual; abstract;
  public
    class var
      Engine : TBIGridPluginClass;

    Constructor Create(const AOwner:TComponent); virtual; abstract;

    procedure BindTo(const ADataSet:TDataSet); virtual; abstract;
    procedure Colorize(const AItems:TDataColorizers); virtual; abstract;
    procedure Duplicates(const AData:TDataItem; const Hide:Boolean); virtual; abstract;
    function GetControl:TControl; virtual; abstract;
    function GetObject:TObject; virtual; abstract;

    property DataSource:TDataSource read GetDataSource write SetDataSource;
    property ReadOnly:Boolean read GetReadOnly write SetReadOnly;
    property Totals:Boolean read GetTotals write SetTotals;
  end;

  TGridShowItems=(Automatic, Yes, No); //, SubTables);

  // Generic Grid control that "links" a TDataItem with a Grid.
  {$IF CompilerVersion>=23}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32
              {$IF CompilerVersion>=25}or pidiOSSimulator or pidiOSDevice{$ENDIF}
              {$IF CompilerVersion>=26}or pidAndroid{$ENDIF}
              {$IF CompilerVersion>=29}or pidiOSDevice64{$ENDIF}
              )]
  {$ENDIF}
  TBIGrid = class(TBIDataControl)
  private
    FAlternate : TAlternateColor;
    FOnDataChange : TNotifyEvent;
    FShowItems : TGridShowItems;

    IDataSet : TBIDataSet;
    IPlugin : TBIGridPlugin;

    IDataSetRight : TBIDataset;
    IPluginRight : TBIGridPlugin;

    procedure ControlDblClick(Sender: TObject);
    function GetCurrentRow: Integer;
    function GetReadOnly: Boolean;
    function HasSubItem: Boolean;
    procedure HideShowItems;
    function PluginControl:TControl;
    procedure RowChanged(Sender: TObject);

    procedure SetAlternate(const Value: TAlternateColor);
    procedure SetPlugin(const Value: TBIGridPlugin);
    procedure SetDataSet(const Value: TBIDataSet);
    procedure SetReadOnly(const Value: Boolean);
    procedure SetShowItems(const Value: TGridShowItems);
    procedure TryShowItems;
  protected
    procedure SetDataDirect(const Value: TDataItem); override;
    procedure UpdatedDataValues; override;
  public
    Constructor Create(AOwner:TComponent); override;
    Destructor Destroy; override;

    procedure BindTo(const AData: TDataItem);

    procedure Colorize; overload;
    procedure Colorize(const AItems:TDataColorizers); overload;

    procedure Duplicates(const AData:TDataItem; const Hide:Boolean);

    class function Embedd(const AOwner:TComponent; const AParent:TFmxObject):TBIGrid; static;

    property DataSet:TBIDataSet read IDataSet write SetDataSet;
    property Plugin:TBIGridPlugin read IPlugin write SetPlugin;
    property CurrentRow:Integer read GetCurrentRow;
  published
    property Alternate:TAlternateColor read FAlternate write SetAlternate;
    property ReadOnly:Boolean read GetReadOnly write SetReadOnly default True;
    property ShowItems:TGridShowItems read FShowItems write SetShowItems default TGridShowItems.Automatic;

    property OnDataChange:TNotifyEvent read FOnDataChange write FOnDataChange;
  end;

  {$IF CompilerVersion<27} // Cannot use FireMonkeyVersion<21 (or 21_0)
  {$DEFINE HASFMX20}
  {$ENDIF}

  // Helper methods for Firemonkey:
  TUICommon=record
  public
    const
      AlignNone=TAlignLayout.{$IFDEF HASFMX20}alNone{$ELSE}None{$ENDIF};
      AlignClient=TAlignLayout.{$IFDEF HASFMX20}alClient{$ELSE}Client{$ENDIF};
      AlignLeft=TAlignLayout.{$IFDEF HASFMX20}alLeft{$ELSE}Left{$ENDIF};
      AlignTop=TAlignLayout.{$IFDEF HASFMX20}alTop{$ELSE}Top{$ENDIF};
      AlignRight=TAlignLayout.{$IFDEF HASFMX20}alRight{$ELSE}Right{$ENDIF};
      AlignBottom=TAlignLayout.{$IFDEF HASFMX20}alBottom{$ELSE}Bottom{$ENDIF};

    class procedure AddForm(const AForm: TCommonCustomForm; const AParent: TFmxObject); static;
    class function AutoTest:Boolean; static;
    class procedure GotoURL(const AOwner:TControl; const AURL:String); static;
    class function Input(const ATitle,ACaption,ADefault:String; out AValue:String):Boolean; static;
    class procedure LoadPosition(const AForm:TCommonCustomForm; const Key:String); static;
    class procedure Popup(const APopup:TPopupMenu; const AControl:TControl); static;
    class procedure SavePosition(const AForm:TCommonCustomForm; const Key:String); static;
    class function YesNo(const AMessage:String):Boolean; static;
  end;

implementation
