PageExtension 50101 "BBT Company Information" extends "Company Information"
{
    layout
    {
        addafter("CNAE Description")
        {
            field(SGA; Rec.SGA)
            {
                ApplicationArea = Basic;
            }
        }
        addafter(Shipping)
        {
            group("Impreso factura")
            {
                Caption = 'Sales Invoice Layout';

                field("Commercial Register Text"; Rec."Commercial Register Text")
                {
                    ApplicationArea = Basic;
                    MultiLine = true;
                }
                field("Cost Recicling Text"; Rec."Cost Recicling Text")
                {
                    ApplicationArea = Basic;
                    MultiLine = true;
                }
                field("Texto pie  protecc. de datos 1"; Rec."Texto pie  protecc. de datos 1")
                {
                    ApplicationArea = Basic;
                    MultiLine = true;
                }
                field("Texto pie  protecc. de datos 2"; Rec."Texto pie  protecc. de datos 2")
                {
                    ApplicationArea = Basic;
                    MultiLine = true;
                }
                field("Texto pie  protecc. de datos 3"; Rec."Texto pie  protecc. de datos 3")
                {
                    ApplicationArea = Basic;
                    MultiLine = true;
                }
                field("Texto pie  protecc. de datos 4"; Rec."Texto pie  protecc. de datos 4")
                {
                    ApplicationArea = Basic;
                    MultiLine = true;
                }
                field("Texto pie  protecc. de datos 5"; Rec."Texto pie  protecc. de datos 5")
                {
                    ApplicationArea = Basic;
                    MultiLine = true;
                }
                field(Text_ISO_ESP; Rec.Text_ISO_ESP)
                {
                    ApplicationArea = Basic;
                }
                field(Text_ISO_ENG; Rec.Text_ISO_ENG)
                {
                    ApplicationArea = Basic;
                }
            }
        }
        addafter("System Indicator")
        {
            group(EDI)
            {
                Caption = 'EDI';

                field("EDI ID"; Rec."EDI ID")
                {
                    ApplicationArea = Basic;
                }
                field("EDI ID PL"; Rec."EDI ID PL")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }
}
