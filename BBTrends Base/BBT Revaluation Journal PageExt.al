PageExtension 50022 "BBT Revaluation Journal" extends "Revaluation Journal"
{
    actions
    {
        modify("Calculate Inventory Value")
        {
            Visible = true;
        }
        addafter("Calculate Inventory Value")
        {
            action("Calculate Inventory Value ITK")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Calculate Inventory Value';
                Ellipsis = true;
                Image = Calculate;
                Scope = Repeater;
                ToolTip = 'Calculate the inventory value for posting date that you specify.';

                trigger OnAction()
                var
                    ObjTransl: Record "Object Translation";
                begin
                    if Confirm(StrSubstNo(Text001, ObjTransl.TranslateObject(ObjTransl."Object Type"::Report, REPORT::"Adjust Cost - Item Entries")), false) then begin
                        CalcInvtValue.SetItemJnlLine(Rec);
                        CalcInvtValue.RunModal();
                        Clear(CalcInvtValue);
                    end;
                end;
                //Iniciamos proceso para recalculo de % de perdida
            }
        }
    }
    var
        CalcInvtValue: Report "BBT Calculate Inventory Value";
        Text001: Label 'To make sure that all items are adjusted before you start the revaluation, you should run the %1 batch job first.\Do you want to continue with the revaluation?';
}
