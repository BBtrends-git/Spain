PageExtension 50142 "BBT Posted Sales Credit Memos" extends "Posted Sales Credit Memos"
{
    layout
    {
        addafter("Sell-to Customer No.")
        {
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Salesperson Code")
        {
            field("Sales Person Name"; Rec."Sales Person Name")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Document Exchange Status")
        {
            field("Service Zone Code"; Rec."Service Zone Code")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Currency Code")
        {
            field("Corrected Invoice No."; Rec."Corrected Invoice No.")
            {
                ApplicationArea = All;
            }
        }
        addbefore(Paid)
        {
            field("Your Reference"; Rec."Your Reference")
            {
                ApplicationArea = Basic;
            }
        }
        addlast(Control1)
        {
            field("Reason Code"; Rec."Reason Code")
            {
                ApplicationArea = Basic;
            }
        }
    }
    actions
    {
        addafter("Update Document")
        {
            action(ChangeSII)
            {
                Caption = 'Mark/Unmark "Do Not Send To SII"', comment = 'ESP="Marcar/Desmarcar "No enviar a SII""';
                ToolTip = 'Change de "Do Not Send To SII" value field on selected records.', comment = 'ESP="Cambia el valor del campo "No enviar al SII" en los registros seleccionados."';
                Image = CheckList;
                ApplicationArea = Basic;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    Text000: label 'Choose an options to selected records:', comment = 'ESP="Elija una opción para los registros seleccionados:"';
                    Text001: label 'Check "Do Not Send To SII",Uncheck "Do Not Send To SII"', comment = 'ESP="Marcar "No enviar a SII",Desmarcar "No enviar a SII""';
                    SelectedOption: Integer;
                    Mark_Unmark: Boolean;
                    SalesCrMemoHeader: Record "Sales Cr.Memo Header";
                begin
                    SelectedOption := Dialog.StrMenu(Text001, 1, Text000);
                    Mark_Unmark := (SelectedOption = 1);
                    SalesCrMemoHeader.Reset();
                    CurrPage.SetSelectionFilter(SalesCrMemoHeader);
                    if SalesCrMemoHeader.FindSet() then begin
                        repeat
                            SalesCrMemoHeader."Do Not Send To SII" := Mark_Unmark;
                            CODEUNIT.Run(CODEUNIT::"Sales Credit Memo Hdr. - Edit", SalesCrMemoHeader);
                        until SalesCrMemoHeader.Next() = 0;
                    end;
                end;
            }
        }
    }
}
