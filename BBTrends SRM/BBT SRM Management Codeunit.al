codeunit 51351 "SRM Management"
{
    trigger OnRun();
    begin
    end;

    procedure IsSRMEnabled(): Boolean
    var
        rSRMSetup: record "SRM Setup";
    begin
        rSRMSetup.Reset();
        if not rSRMSetup.Get() then begin
            rSRMSetup.Init();
            rSRMSetup.Insert();
        end;
        if rSRMSetup."SRM Enabled" then
            exit(true)
        else
            exit(false);
    end;

    procedure InitializeSRMConfiguration(var pSRMSetUp: Record "SRM Setup")
    begin
        pSRMSetUp.Reset();
        pSRMSetUp.Get();
    end;

    procedure FindLastComment(pVendor: Record Vendor): Text[80];
    var
        rVendorComments: Record "Comment Line";
    begin
        rVendorComments.Reset();
        rVendorComments.SetRange("Table Name", rVendorComments."Table Name"::Vendor);
        rVendorComments.SetRange("No.", pVendor."No.");

        rVendorComments.SetCurrentKey(SystemCreatedAt, "Line No.");
        rVendorComments.Ascending(true);

        if rVendorComments.FindLast() then
            exit(rVendorComments.Comment)
        else
            exit('')
    end;

    procedure CountCategories(pVendor: Record Vendor): Integer;
    var
        SRMVendorItemCategories: Record "SRM Vendor Item Categories";
    begin
        SRMVendorItemCategories.Reset();
        SRMVendorItemCategories.SetRange("Vendor No.", pVendor."No.");

        exit(SRMVendorItemCategories.Count);
    end;
}