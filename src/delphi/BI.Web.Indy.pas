{*********************************************}
{  TeeBI Software Library                     }
{  HTTP Web data access using Indy TIdHttp    }
{  Copyright (c) 2015-2017 by Steema Software }
{  All Rights Reserved                        }
{*********************************************}
unit BI.Web.Indy;

interface

uses
  System.Classes, System.SysUtils,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  BI.Web, BI.Persist;

type
  TBIIndy=class(TBIHttp)
  private
    FHttp : TIdHttp; // Indy

    IMaxWork : Int64;

    procedure WorkBegin(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Int64);
    procedure WorkEnd(ASender: TObject; AWorkMode: TWorkMode);
    procedure Work(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
  public
    Constructor Create(const AOwner:TComponent); override;
    Destructor Destroy; override;

    class function FTP(const ADef:TDataDefinition):TBIFtp; override;

    procedure Get(const AURL:String; const AStream:TStream); overload; override;
    function Get(const AURL:String):String; overload; override;
    class function Parse(const AURL:String):TWebURL; override;
    procedure SetProxy(const AProxy:TWebProxy); override;
    procedure SetTimeout(const ATimeout:Integer); override;

    property Http:TIdHTTP read FHttp;
  end;

implementation
