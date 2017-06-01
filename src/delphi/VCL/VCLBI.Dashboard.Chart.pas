{*********************************************}
{  TeeBI Software Library                     }
{  Charts for Screen Dashboard (VCL and FMX)  }
{  Copyright (c) 2015-2016 by Steema Software }
{  All Rights Reserved                        }
{*********************************************}
unit VCLBI.Dashboard.Chart;
{.$DEFINE FMX}

interface

uses
  {$IFDEF FMX}
  FMX.Controls, FMXBI.Chart, FMXBI.Dashboard,
  {$ELSE}
  VCL.Controls, VCLBI.Chart, VCLBI.Dashboard,
  {$ENDIF}

  System.Classes, BI.Dashboard, System.SysUtils, BI.DataItem;

type
  TScreenChartRender=class(TScreenRender)
  private
    class procedure FinishChart(const AChart:TBIChart; const AItem:TDashboardItem); static;
  protected
    function CanRefreshData(const AControl:TControl):Boolean; override;
    function NewControl(const AKind:TPanelKind; const AItem:TDashboardItem):TControl; override;

    {$IFDEF FMX}
    procedure PostAddControl(const AControl:TControl; const AItem:TDashboardItem); override;
    procedure RadioChange(Sender: TObject); override;
    {$ENDIF}
  public
    class function NewChart(const AOwner:TComponent; const AItem:TDashboardItem;
                            const AData:TDataItem;
                            const AFormat:String):TBIChart; static;
  end;

implementation
