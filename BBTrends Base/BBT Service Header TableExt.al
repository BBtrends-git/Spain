TableExtension 50168 "BBT Service Header" extends "Service Header"
{
    fields
    { }
    procedure UpdatePmtDiscDate()
    begin
        if Rec."Payment Discount %" = 0 then
            if Rec."Document Type" <> Rec."document type"::"Credit Memo" then
                Rec."Pmt. Discount Date" := Rec."Due Date";
    end;
}
