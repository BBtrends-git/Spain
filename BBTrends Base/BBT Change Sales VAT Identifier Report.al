report 50080 "Change Sales VAT Identifier"
{
    ApplicationArea = All;
    Caption = 'Modify VAT identifier (Sales)', comment = 'ESP="Modificar Identificador IVA (Ventas)"';
    UsageCategory = Tasks;
    ProcessingOnly = true;
    Permissions = tabledata "Sales Invoice Line"=rm;

    dataset
    {
        dataitem(SalesInvoiceLine; "Sales Invoice Line")
        {
            trigger OnPreDataItem()
            begin
                SalesInvoiceLine.SetRange(Type, SalesInvoiceLine.Type::Item);
            end;
            trigger OnAfterGetRecord()
            begin
                VATPostingSetup.Get(SalesInvoiceLine."VAT Bus. Posting Group", SalesInvoiceLine."VAT Prod. Posting Group");
                SalesInvoiceLine.Validate("VAT Identifier", VATPostingSetup."VAT Identifier");
                SalesInvoiceLine.Modify();
            end;
        }
    }
    var VATPostingSetup: Record "VAT Posting Setup";
}
