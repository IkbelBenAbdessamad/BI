{*********************************************}
{  TeeBI Software Library                     }
{  CART algorithm                             }
{  Copyright (c) 2015-2016 by Steema Software }
{  All Rights Reserved                        }
{*********************************************}
unit BI.Algorithm.CART;

interface

uses
  System.Classes, BI.DataItem, BI.Arrays, BI.Algorithm.Model, BI.Plugins.R;

type
  TBICART=class(TRSupervisedModel)
  protected
    procedure BuildScript; override;
  end;

implementation
