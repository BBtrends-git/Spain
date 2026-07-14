PageExtension 50145 "BBT Posted Purchase CrMemos" extends "Posted Purchase Credit Memos"
{
    layout
    {
        addafter("Applies-to Doc. Type")
        {
            field("Vendor Cr. Memo No."; Rec."Vendor Cr. Memo No.")
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
                    PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
                begin
                    SelectedOption := Dialog.StrMenu(Text001, 1, Text000);
                    Mark_Unmark := (SelectedOption = 1);
                    PurchCrMemoHeader.Reset();
                    CurrPage.SetSelectionFilter(PurchCrMemoHeader);
                    if PurchCrMemoHeader.FindSet() then begin
                        repeat
                            PurchCrMemoHeader."Do Not Send To SII" := Mark_Unmark;
                            CODEUNIT.Run(CODEUNIT::"Purch. Cr. Memo Hdr. - Edit", PurchCrMemoHeader);
                        until PurchCrMemoHeader.Next() = 0;
                    end;
                end;
            }
        }
    }
}
