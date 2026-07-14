PageExtension 50144 "BBT Posted Purchase Invoices" extends "Posted Purchase Invoices"
{
    layout
    {
        addafter("Shipment Method Code")
        {
            field("Base DUA"; Rec."Base DUA")
            {
                ApplicationArea = Basic;
            }
        }
    }
    actions
    {
        addafter(Navigate)
        { }
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
                    PurchInvHeader: Record "Purch. Inv. Header";
                begin
                    SelectedOption := Dialog.StrMenu(Text001, 1, Text000);
                    Mark_Unmark := (SelectedOption = 1);
                    PurchInvHeader.Reset();
                    CurrPage.SetSelectionFilter(PurchInvHeader);
                    if PurchInvHeader.FindSet() then begin
                        repeat
                            PurchInvHeader."Do Not Send To SII" := Mark_Unmark;
                            CODEUNIT.Run(CODEUNIT::"Purch. Inv. Header - Edit", PurchInvHeader);
                        until PurchInvHeader.Next() = 0;
                    end;
                end;
            }
        }
    }
}
