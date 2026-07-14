reportextension 50008 "BBT Calc. Plan - Plan. Wksh." extends "Calculate Plan - Plan. Wksh."
{
    dataset
    {
        modify(Item)
        {
            RequestFilterFields = "No.", "Search Description", "Item Category Code", "Location Filter";
        }
    }
    requestpage
    {
        layout
        {
            addfirst(Calculate)
            {
                field("Last MRP Calculation"; BBT_MfgSetup."Last MRP Calculation")
                {
                    Caption = 'Last MRP Calculation', comment = 'ESP="Último cálculo MRP"';
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
        trigger OnOpenPage()
        begin
            BBT_MfgSetup.Get();
        end;
    }
    trigger OnPostReport()
    begin
        BBT_MfgSetup."Last MRP Calculation" := CURRENTDATETIME;
        BBT_MfgSetup.Modify();
    end;

    var
        BBT_MfgSetup: Record "Manufacturing Setup";
}
