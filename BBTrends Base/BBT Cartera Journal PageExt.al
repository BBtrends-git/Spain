PageExtension 50248 "BBT Cartera Journal" extends "Cartera Journal"
{
    layout
    {
        addafter("Payment Terms Code")
        {
            field(Deduction; Rec.Deduction)
            {
                ApplicationArea = Basic;
            }
        }
    }
    //Unsupported feature: Code Modification on "OnQueryClosePage".
    //trigger OnQueryClosePage(CloseAction: Action): Boolean
    //>>>> ORIGINAL CODE:
    //begin
    /*
        IF ClosingForbidden THEN BEGIN
          MESSAGE(Text1100000);
          CarteraJnlForm.SetJnlBatchName("Journal Batch Name");
          CarteraJnlForm.SETTABLEVIEW(Rec);
          CarteraJnlForm.SETRECORD(Rec);
          CarteraJnlForm.AllowClosing(TRUE);
          CarteraJnlForm.RUNMODAL;
        END;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
        IF ClosingForbidden THEN BEGIN
          MESSAGE(Text1100000);
        #4..8
        */
    //end;
}
