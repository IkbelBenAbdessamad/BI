{*********************************************}
{  TeeBI Software Library                     }
{  Data Import Definition Editor dialog       }
{  Copyright (c) 2015-2016 by Steema Software }
{  All Rights Reserved                        }
{*********************************************}
unit BI.VCL.Editor.Data;

interface

uses
  {$IFNDEF FPC}
  Winapi.Windows, Winapi.Messages,
  {$ENDIF}
  System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons,
  BI.Data, BI.Persist, BI.DataSource, BI.VCL.Editor.Items;

type
  TDataEditor = class(TForm)
    TabSources: TPageControl;
    TabFiles: TTabSheet;
    TabDatabase: TTabSheet;
    TabWeb: TTabSheet;
    PanelButtons: TPanel;
    Panel1: TPanel;
    BOK: TButton;
    Button2: TButton;
    TabUnknown: TTabSheet;
    LabelUnknown: TLabel;
    PageControlFile: TPageControl;
    TabFile: TTabSheet;
    TabFolder: TTabSheet;
    Label2: TLabel;
    EFile: TEdit;
    Button3: TButton;
    LFileMissing: TLabel;
    OpenDialog1: TOpenDialog;
    Label3: TLabel;
    EFolder: TEdit;
    Button4: TButton;
    LFolderMissing: TLabel;
    CBAllFolder: TCheckBox;
    CBRecursive: TCheckBox;
    EFileMask: TEdit;
    CBFileType: TComboBox;
    Button5: TButton;
    PageControlDBItems: TPageControl;
    TabConnection: TTabSheet;
    SQL: TTabSheet;
    PageControl3: TPageControl;
    TabItemAllDB: TTabSheet;
    TabSQL: TTabSheet;
    Label7: TLabel;
    CBDBDriver: TComboBox;
    BDBTest: TButton;
    Label8: TLabel;
    EDBServer: TEdit;
    EDBDatabase: TEdit;
    Label9: TLabel;
    EDBUser: TEdit;
    Label10: TLabel;
    EDBPassword: TEdit;
    Label11: TLabel;
    CBLogin: TCheckBox;
    CBAllItems: TCheckBox;
    MemoSQL: TMemo;
    MemoDBTest: TMemo;
    Label12: TLabel;
    EExcluded: TEdit;
    EDBInclude: TEdit;
    LDBExclude: TLabel;
    EDBExclude: TEdit;
    LDBInclude: TLabel;
    Button1: TButton;
    LayoutWebData: TPanel;
    Label6: TLabel;
    CBWebData: TComboBox;
    PageControlWeb: TPageControl;
    TabHttpServer: TTabSheet;
    TabHttpProxy: TTabSheet;
    BWebTest: TButton;
    CBZip: TCheckBox;
    EPort: TEdit;
    EWebServer: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    LWebTest: TLabel;
    UDPort: TUpDown;
    Label13: TLabel;
    EProxyHost: TEdit;
    Label14: TLabel;
    EProxyPort: TEdit;
    UDProxyPort: TUpDown;
    Label15: TLabel;
    EProxyUser: TEdit;
    Label16: TLabel;
    EProxyPassword: TEdit;
    Label17: TLabel;
    EDBPort: TEdit;
    CBDBSystem: TCheckBox;
    TabFTP: TTabSheet;
    BFTPTest: TButton;
    Label18: TLabel;
    EFTPServer: TEdit;
    Label19: TLabel;
    EFTPPort: TEdit;
    UDFTPPort: TUpDown;
    Label20: TLabel;
    EFTPUser: TEdit;
    Label21: TLabel;
    EFTPPassword: TEdit;
    LFTPStatus: TLabel;
    Button6: TButton;
    OpenDialogDatabase: TOpenDialog;
    Label1: TLabel;
    EWebURL: TEdit;
    RGKind: TRadioGroup;
    Label22: TLabel;
    ETimeout: TEdit;
    UDTimeout: TUpDown;
    Label23: TLabel;
    TabDBOptions: TTabSheet;
    CBParallel: TCheckBox;
    CBStats: TCheckBox;
    CBDBViews: TCheckBox;
    TabManual: TTabSheet;
    Panel2: TPanel;
    procedure FormDestroy(Sender: TObject);
    procedure EFileChange(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure EFolderChange(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure CBAllFolderClick(Sender: TObject);
    procedure CBRecursiveClick(Sender: TObject);
    procedure CBFileTypeChange(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure EWebServerChange(Sender: TObject);
    procedure EPortChange(Sender: TObject);
    procedure CBZipClick(Sender: TObject);
    procedure BWebTestClick(Sender: TObject);
    procedure CBWebDataChange(Sender: TObject);
    procedure CBWebDataDropDown(Sender: TObject);
    procedure CBDBDriverChange(Sender: TObject);
    procedure BDBTestClick(Sender: TObject);
    procedure EDBServerChange(Sender: TObject);
    procedure EDBDatabaseChange(Sender: TObject);
    procedure EDBUserChange(Sender: TObject);
    procedure EDBPasswordChange(Sender: TObject);
    procedure CBLoginClick(Sender: TObject);
    procedure CBAllItemsClick(Sender: TObject);
    procedure MemoSQLChange(Sender: TObject);
    procedure EFileMaskChange(Sender: TObject);
    procedure EExcludedChange(Sender: TObject);
    procedure EDBIncludeChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EProxyHostChange(Sender: TObject);
    procedure EProxyUserChange(Sender: TObject);
    procedure EProxyPasswordChange(Sender: TObject);
    procedure EProxyPortChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure EDBPortChange(Sender: TObject);
    procedure CBDBSystemClick(Sender: TObject);
    procedure EFTPServerChange(Sender: TObject);
    procedure EFTPPortChange(Sender: TObject);
    procedure BFTPTestClick(Sender: TObject);
    procedure EFTPUserChange(Sender: TObject);
    procedure EFTPPasswordChange(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure LayoutWebDataResize(Sender: TObject);
    procedure EWebURLChange(Sender: TObject);
    procedure RGKindClick(Sender: TObject);
    procedure BOKClick(Sender: TObject);
    procedure ETimeoutChange(Sender: TObject);
    procedure CBParallelClick(Sender: TObject);
    procedure CBStatsClick(Sender: TObject);
    procedure CBDBViewsClick(Sender: TObject);
  private
    { Private declarations }
    FOnChangeWeb : TNotifyEvent;

    OwnsData,
    IChanging : Boolean;

    IStore : String;

    procedure CheckFileFilter(const ADialog:TOpenDialog);
    procedure CheckDBFileFilter(const ADialog:TOpenDialog);
    procedure DatabaseSettings;
    function DBDriverID:String;
    procedure DoTest;
    procedure EnableTestButton;
    procedure FileSettings;
    procedure FilesSettings;
    function FileTypeExtension(const Index:Integer):String;
    procedure FillDBDrivers;
    procedure FinishAddFilter(const ADialog:TOpenDialog; const AFilter,All:String);
    procedure ManualSettings;
    procedure RefreshSettings;
    procedure ResetWebTest;
    procedure ShowSingleTab(const ATab:TTabSheet);
    procedure TryChange(const ATag,AText:String);
    procedure TryChangeMultiLine(const ATag,AText:String);
    procedure TryWebChange(const ATag, AText: String);
    procedure TryFillWebData;
    procedure TrySetHostPort;
    procedure WebSettings;
    function WebURL:String;
  protected
    ITabFormats : TTabSheet;
    ItemsEditor : TItemsEditor;

    procedure ClearWeb;
    procedure SetWebPath(const APath:String);
    function WebPath:String;
  public
    { Public declarations }
    Data : TDataDefinition;

    function Description:String;

    class function Edit(const AOwner:TComponent; const AData:TDataDefinition):Boolean; static;

    class function NewDefinition(const AOwner:TComponent;
                       const ADataOwner:TComponent;
                       const AKind:TDataDefinitionKind;
                       out AName:String):TDataDefinition; static;
    procedure Select(const AStore,AName:String); overload;
    procedure Select(const AData:TDataDefinition); overload;

    property OnChangeWeb:TNotifyEvent read FOnChangeWeb write FOnChangeWeb;
  end;

implementation
