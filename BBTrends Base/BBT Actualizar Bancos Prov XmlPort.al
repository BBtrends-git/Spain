XmlPort 50098 "Actualizar bcos prov"
{
    FieldDelimiter = '<None>';
    FieldSeparator = '<TAB>';
    Format = VariableText;

    schema
    {
        textelement(roor)
        {
            tableelement("Vendor Bank Account";
            "Vendor Bank Account")
            {
                AutoReplace = false;
                AutoSave = false;
                AutoUpdate = false;
                XmlName = 'VendB';

                fieldelement(Codporv;
                "Vendor Bank Account"."Vendor No.")
                {
                }
                fieldelement(CodBco;
                "Vendor Bank Account".Code)
                {
                }
                fieldelement(cta;
                "Vendor Bank Account".Iban)
                {
                }
                fieldelement(swift;
                "Vendor Bank Account"."SWIFT Code")
                {
                    trigger OnAfterAssignField()
                    begin
                        if Prov.Get("Vendor Bank Account"."Vendor No.") then begin
                            if VendorBank.Get("Vendor Bank Account"."Vendor No.", "Vendor Bank Account".Code) then begin
                                VendorBank.Iban := "Vendor Bank Account".Iban;
                                VendorBank."SWIFT Code" := "Vendor Bank Account"."SWIFT Code";
                                VendorBank.Modify;
                            end
                            else begin
                                VendorBank.Init;
                                VendorBank."Vendor No." := "Vendor Bank Account".Iban;
                                VendorBank."SWIFT Code" := "Vendor Bank Account"."SWIFT Code";
                                VendorBank.Iban := "Vendor Bank Account".Iban;
                                VendorBank."SWIFT Code" := "Vendor Bank Account"."SWIFT Code";
                                VendorBank.Insert;
                            end;
                            Prov."Preferred Bank Account Code" := VendorBank.Code;
                            Prov.Modify;
                        end;
                    end;
                }
                trigger OnAfterModifyRecord()
                begin
                    if Prov.Get("Vendor Bank Account"."Vendor No.") then begin
                        if VendorBank.Get("Vendor Bank Account"."Vendor No.", "Vendor Bank Account".Code) then begin
                            VendorBank.Iban := "Vendor Bank Account".Iban;
                            VendorBank."SWIFT Code" := "Vendor Bank Account"."SWIFT Code";
                            VendorBank.Modify;
                        end
                        else begin
                            VendorBank.Init;
                            VendorBank."Vendor No." := "Vendor Bank Account".Iban;
                            VendorBank."SWIFT Code" := "Vendor Bank Account"."SWIFT Code";
                            VendorBank.Iban := "Vendor Bank Account".Iban;
                            VendorBank."SWIFT Code" := "Vendor Bank Account"."SWIFT Code";
                            VendorBank.Insert;
                        end;
                        Prov."Preferred Bank Account code" := VendorBank.Code;
                        Prov.Modify;
                    end;
                end;
            }
        }
    }
    requestpage
    {
        layout
        {
        }
        actions
        {
        }
    }
    var
        Diario2: Record "Gen. Journal Line";
        VendorBank: Record "Vendor Bank Account";
        Prov: Record Vendor;
}
