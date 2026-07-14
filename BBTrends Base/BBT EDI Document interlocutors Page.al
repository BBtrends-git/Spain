Page 50035 "EDI - Document interlocutors"
{
    Caption = 'EDI - Partes';
    PageType = List;
    SourceTable = 50011;
    UsageCategory = Documents;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Interlocutor type"; Rec."Interlocutor type")
                {
                    ApplicationArea = Basic;
                }
                field("Interlocutor No."; Rec."Interlocutor No.")
                {
                    ApplicationArea = Basic;
                }
                field("Code responsible agency"; Rec."Code responsible agency")
                {
                    ApplicationArea = Basic;
                }
                field("Name 1"; Rec."Name 1")
                {
                    ApplicationArea = Basic;
                }
                field("Name 2"; Rec."Name 2")
                {
                    ApplicationArea = Basic;
                }
                field("Name 3"; Rec."Name 3")
                {
                    ApplicationArea = Basic;
                }
                field("Name 4"; Rec."Name 4")
                {
                    ApplicationArea = Basic;
                }
                field("Name 5"; Rec."Name 5")
                {
                    ApplicationArea = Basic;
                }
                field("Street and number 1"; Rec."Street and number 1")
                {
                    ApplicationArea = Basic;
                }
                field("Street and number 2"; Rec."Street and number 2")
                {
                    ApplicationArea = Basic;
                }
                field("Street and number 3"; Rec."Street and number 3")
                {
                    ApplicationArea = Basic;
                }
                field("Street and number 4"; Rec."Street and number 4")
                {
                    ApplicationArea = Basic;
                }
                field(City; Rec.City)
                {
                    ApplicationArea = Basic;
                }
                field(County; Rec.County)
                {
                    ApplicationArea = Basic;
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = Basic;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = Basic;
                }
                field("Reference type 1"; Rec."Reference type 1")
                {
                    ApplicationArea = Basic;
                }
                field("Reference 1"; Rec."Reference 1")
                {
                    ApplicationArea = Basic;
                }
                field("Contact function"; Rec."Contact function")
                {
                    ApplicationArea = Basic;
                }
                field("Dept. or employee ID"; Rec."Dept. or employee ID")
                {
                    ApplicationArea = Basic;
                }
                field("Dept. or employee"; Rec."Dept. or employee")
                {
                    ApplicationArea = Basic;
                }
                field("Reference type 2"; Rec."Reference type 2")
                {
                    ApplicationArea = Basic;
                }
                field("Reference 2"; Rec."Reference 2")
                {
                    ApplicationArea = Basic;
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    ApplicationArea = Basic;
                }
                field("Fax No."; Rec."Fax No.")
                {
                    ApplicationArea = Basic;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = Basic;
                }
                field(Iban; Rec.Iban)
                {
                    ApplicationArea = Basic;
                }
                field(Swift; Rec.Swift)
                {
                    ApplicationArea = Basic;
                }
                field("Issuer Commercial Register"; Rec."Issuer Commercial Register")
                {
                    ApplicationArea = Basic;
                }
                field("Social Capital"; Rec."Social Capital")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }
    actions
    { }
}
