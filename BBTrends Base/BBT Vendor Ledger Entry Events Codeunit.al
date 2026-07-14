codeunit 50051 "BBT Vendor Ledger Entry Events"
{
    #region Codeunit Events
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Vend. Entry-SetAppl.ID", 'OnAfterUpdateVendLedgerEntry', '', true, true)]
    local procedure VendEntrySetApplID_OnAfterUpdateVendLedgerEntry(var VendorLedgerEntry: Record "Vendor Ledger Entry"; var TempVendLedgEntry: Record "Vendor Ledger Entry" temporary; ApplyingVendLedgEntry: Record "Vendor Ledger Entry"; AppliesToID: Code[50])
    begin
        if VendorLedgerEntry."BBT Settlement From CSV" then begin
            VendorLedgerEntry."Amount to Apply":=VendorLedgerEntry."BBT Amount To Apply From CSV";
            VendorLedgerEntry."BBT Settlement From CSV":=false;
            VendorLedgerEntry."BBT Amount To Apply From CSV":=0;
            VendorLedgerEntry.Modify();
        end;
    end;
#endregion Codeunit Events
}
