pageextension 50023 "General Journal Batches" extends "General Journal Batches"
{
    procedure GetSelectionFilter(): Text var
        rlGenJournalBatch: Record "Gen. Journal Batch";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
        vJournalBatchName: Text;
    begin
        Clear(vJournalBatchName);
        CurrPage.SetSelectionFilter(rlGenJournalBatch);
        if rlGenJournalBatch.FindFirst()then begin
            if vJournalBatchName = '' then begin
                vJournalBatchName:=Format(rlGenJournalBatch.Name);
                exit(vJournalBatchName);
            end;
        end;
    end;
}
