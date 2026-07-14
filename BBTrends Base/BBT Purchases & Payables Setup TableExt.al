TableExtension 50144 "BBT Purchases & Payables Setup" extends "Purchases & Payables Setup"
{
    fields
    {
        field(50000; "Delivery Period"; DateFormula)
        {
            Caption = 'Delivery Period', comment = 'ESP="Período entrega"';
            DataClassification = ToBeClassified;
        }
        field(50001; "Warehouse Receipt Nos."; Code[10])
        {
            Caption = 'Warehouse Receipt Nos.', comment = 'ESP="Nº serie certificado deposito"';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50002; "Expense Note Nos."; Code[10])
        {
            Caption = 'Expense Note Nos.', comment = 'ESP="Nº serie nota de gastos"';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50003; "BBT Vend. Post. Gr. Imp. Ord."; Code[20])
        {
            Caption = 'Vendor Posting Group Importation Orders', comment = 'ESP="Grupo registro proveedor pedidos importación"';
            TableRelation = "Vendor Posting Group";
            DataClassification = ToBeClassified;
        }
        field(50004; "Item Cat Code Filt. Imp Order"; Code[20])
        {
            Caption = 'Item Cat Code Filt. Imp Order', comment = 'ESP="Filtro categoria producto"';
            TableRelation = "Item Category";
            DataClassification = ToBeClassified;
        }
    }
}
