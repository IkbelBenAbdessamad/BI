{*********************************************}
{  TeeBI Software Library                     }
{  HTTP Web data access                       }
{  Copyright (c) 2015-2016 by Steema Software }
{  All Rights Reserved                        }
{*********************************************}
unit BI.Web;

interface

uses
  System.Classes, System.Types, System.SysUtils,
  BI.Arrays, BI.Data, BI.Persist, BI.DataSource, BI.Compression;

type
  EHttpAbort=class(Exception);

  TBIHttpProgress=procedure(Sender:TObject; const ACurrent,ATotal:Int64; var Abort:Boolean) of object;

  TBIHttpClass=class of TBIHttp;

  TWebProxy=record
  public
    Host : String;
    Port : Integer;
    User,
    Password : String;
  end;

  TBIFtp=class
  public
    const
      DefaultPort=21;

    Constructor Create(const ADef:TDataDefinition); virtual; abstract;

    procedure Connect; virtual; abstract;
    procedure DisConnect; virtual; abstract;
    function Get(const AFileName:String):TStream; virtual; abstract;
    function IncludedFiles(const AFolder,AIncludeMask:String):TStringDynArray; virtual; abstract;
    function ListFiles(const AFolder,AIncludeMask:String): TStrings; virtual; abstract;
  end;

  TWebURL=record
  private
    procedure RemoveParam(const ATag:String);
  public
    Host : String;
    Port : Integer;
    Params : String;
  end;

  TBIHttp=class abstract
  private
    class var
      FOnProgress : TBIHttpProgress;
  protected
    procedure DoProgress(const ACurrent,ATotal:Int64);
  public
    class var
      Engine : TBIHttpClass;

    Constructor Create(const AOwner:TComponent); virtual; abstract;

    class function FTP(const ADef:TDataDefinition):TBIFtp; virtual; abstract;

    procedure Get(const AURL:String; const AStream:TStream); overload; virtual; abstract;
    function Get(const AURL:String):String; overload; virtual; abstract;
    class function Parse(const AURL:String):TWebURL; virtual; abstract;
    procedure SetProxy(const AProxy:TWebProxy); virtual; abstract;
    procedure SetTimeout(const ATimeout:Integer); virtual; abstract;

    class property OnProgress:TBIHttpProgress read FOnProgress write FOnProgress;
  end;

  TWebCompression=(No,Yes);

  TBIWebClient=class
  private
  class var
    FOnFinish,
    FOnStart : TNotifyEvent;

  var
    FHttp : TBIHttp;

    function GetHttp: TBIHttp;
    procedure TryErrorAsString(const AStream:TStream);
  protected
    function DoFromURL(const AURL:String): TDataItem;
    function GetDataStream(const Data:String; const Children:Boolean; const Compress:TWebCompression): TStream;

  public
  const
    DefaultPort=15015;
    DefaultTimeout=2000;

    class property OnFinish:TNotifyEvent read FOnFinish write FOnFinish;
    class property OnStart:TNotifyEvent read FOnStart write FOnStart;

  var
    Server : String;
    Port : Integer;
    Timeout : Integer;
    Compress : TWebCompression;
    Store : String;

    Proxy : TWebProxy;

    Constructor Create(const AServer:String; const APort:Integer=DefaultPort); overload;
    Constructor Create(const AData:TDataDefinition); overload;

    Destructor Destroy; override;

    class function FromPath(const APath:String):TBIWebClient; static;

    class function FTP(const ADef:TDataDefinition):TBIFtp; static;

    procedure GetData(const Data:String; var Items:TDataArray; const ACompress:TWebCompression); overload;
    procedure GetData(const AData:TDataItem; const Children:Boolean; const ACompress:TWebCompression); overload;
    procedure GetData(const AOrigin:String; const AData:TDataItem; const Children:Boolean; const ACompress:TWebCompression); overload;
    function GetData(const AData:String; const Children:Boolean; const ACompress:TWebCompression):TDataItem; overload;

    function GetData:String; overload;
    function GetMetaData(const S:String; const ACompress:TWebCompression): TDataItem;
    function GetStream(const S:String):TStream;
    function GetString(const S:String):String;

    function Load(const AData: String; const ACompress: TWebCompression=TWebCompression.Yes): TDataItem;

    class function FromURL(const AServer:String;
                           const APort:Integer;
                           const AParams:String;
                           const ACompress: TWebCompression=TWebCompression.Yes): TDataItem; overload; static;

    class function FromURL(const AURL:String;
                           const ACompress: TWebCompression=TWebCompression.Yes): TDataItem; overload; static;

    class function Query(const AStore,AData,ASQL:String):TDataItem; static;

    class function UnZip(const AStream:TStream):TStream; static; inline;
    function URL:String;

    property Http:TBIHttp read GetHttp;
  end;

  TBIWebServer=class
  public
  type
    TVersion=record
    public
      Major,
      Minor : Integer;
      URL : String;

      function ToString:String;
    end;

  const
    Version:TVersion=(Major:1; Minor:0; URL:'');
  end;

  TBIWebHistory=class(TDataItem)
  public
    Constructor Create;

    function Add(const Time:TDateTime; const RemoteIP,Command,Tag:String;
                  const Success:Boolean; const Millisec:Integer; const Size:Int64):TInteger;
  end;

  TSteema=class(TBIWebClient)
  public
    class function CheckNewVersion(out AError:String):Boolean; static;
    class function Download(const Source,Dest:String):Boolean; static;
    class function GetLatestVersion(out V: TBIWebServer.TVersion; out Error:String):Boolean; static;
  end;

  TDelayHandlerWeb=class(TDataDelayProvider)
  protected
    function GetStream(const AData,ANext:TDataItem):TStream; override;
    function GetStream(const AItems:TDataArray):TStream; override;
    procedure Load(const AData:TDataItem; const Children:Boolean); override;
  public
    BIWeb : TBIWebClient;

    Constructor CreateWeb(const ABIWeb:TBIWebClient);
    Destructor Destroy; override;
  end;

  TBIURLSource=class(TBIFileSource)
  protected
    function DoImportFile(const FileName:String):TDataArray; override;
    function ImportURLFile(const FileName:String):TDataArray;
  public
    class function FileFilter:TFileFilters; override;
    class function From(const AURL:String):TDataItem; static;
    function Import(const URL:String):TDataArray;
    class function Supports(const Extension:String):Boolean; override;
  end;

implementation
