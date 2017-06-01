﻿{*********************************************}
{  TeeBI Software Library                     }
{  TChart Geographic Maps                     }
{  Copyright (c) 2015-2016 by Steema Software }
{  All Rights Reserved                        }
{*********************************************}
unit VCLBI.Chart.Geo;
{.$DEFINE FMX}

interface

uses
  {$IFDEF FMX}
  FMXBI.Chart.Plugin, FMXTee.Series.World,
  {$ELSE}
  VCLBI.Chart.Plugin, VCLTee.TeeWorldSeries,
  {$ENDIF}

  BI.DataItem;

type
  TGeoContext=record
  public
    Map : TWorldMap;
    ByCode,
    IsMulti : Boolean;
  end;

  TGeoChart=record
  private
    class function AreEntities(const Text:TDataItem; out AContext:TGeoContext):Boolean; static;
  public
    class function CanReuse(const AChart:TBITChart;
                            const AContext:TGeoContext):Boolean; static;

    class procedure Fill(const AChart:TBITChart;
                         const AValues,AText:TDataItem;
                         const AContext:TGeoContext); static;

    class function Guess(const X,Text:TDataItem;
                         out AContext:TGeoContext):Boolean; static;
  end;

implementation
