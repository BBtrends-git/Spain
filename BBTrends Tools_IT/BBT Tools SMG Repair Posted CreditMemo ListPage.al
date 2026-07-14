page 59035 "Tools Posted CrMemos List"
{
    AdditionalSearchTerms = 'posted bill';
    ApplicationArea = Basic, Suite;
    CardPageID = "Tools Posted Sales Cr.Memo";
    Editable = false;
    PageType = List;
    QueryCategory = 'Posted Credit Memos';
    SourceTable = "Sales Cr.Memo Header";
    SourceTableView = sorting("Posting Date")
                      order(descending);
    UsageCategory = History;


    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                    AboutTitle = 'The final invoice number (No.)';
                    AboutText = 'This is the invoice number uniquely identifying each posted sale. Your customers see this number on the invoices they receive from you.';
                    ToolTip = 'Specifies the posted sales invoice number. Each posted sales invoice gets a unique number. Typically, the number is generated based on a number series.';
                }

                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Customer No.';
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Customer Name';
                    ToolTip = 'Specifies the name of the customer that you shipped the items on the invoice to.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the currency code of the invoice.';
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the date on which the invoice is due for payment.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the total, in the currency of the invoice, of the amounts on all the invoice lines. The amount does not include VAT.';
                }
                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the total of the amounts, including VAT, on all the lines on the document.';
                }
                field("Remaining Amount"; Rec."Remaining Amount")
                {
                    ApplicationArea = Basic, Suite;
                    AboutTitle = 'What remains to be paid';
                    AboutText = 'This column shows you what is not yet paid on each invoice. When full payment is registered, an invoice is marked as *Closed*.';
                    ToolTip = 'Specifies the amount that remains to be paid for the posted sales invoice.';
                }
            }
        }
    }

}

