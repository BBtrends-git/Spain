codeunit 50023 "ItemJournal Events"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInitItemLedgEntry', '', false, false)]
    local procedure OnAfterInitItemLedgEntry(ItemJournalLine: Record "Item Journal Line"; var ItemLedgEntryNo: Integer; var NewItemLedgEntry: Record "Item Ledger Entry")
    begin
        //01/07/19 TC-001 Incluir Usuario, Hora y Turno de Trabajo
        NewItemLedgEntry."Work Shift Code" := ItemJournalLine."Work Shift Code";
        NewItemLedgEntry."User ID" := USERID;
        NewItemLedgEntry."Hora Registro" := CURRENTDATETIME;
        //01/07/19 TC-001 Incluir Usuario, Hora y Turno de Trabajo
    end;

    [EventSubscriber(ObjectType::Table, database::"Item Journal Line", 'OnBeforeValidateEvent', 'Concurrent Capacity', false, false)]
    local procedure OnBeforeValidateEventConcurrentCapacity(CurrFieldNo: Integer; var Rec: Record "Item Journal Line"; var xRec: Record "Item Journal Line")
    var
        TotalTime: Integer;
        vTime: Time;
        cDuration: Duration;
        gDec_Value: Decimal;
        d1: DateTime;
        d2: DateTime;
        rWorkCenter: Record "Work Center";
        rCalenPlanta: Record "Shop Calendar Working Days";
        DayOfWeek: Integer;
    begin
        //FHS
        //IF Rec."Cap. Unit of Measure Code"='HORA' THEN BEGIN
        IF Rec."Starting Time" < Rec."Ending Time" THEN BEGIN
            gDec_Value := Rec."Ending Time" - Rec."Starting Time";
            gDec_Value := gDec_Value / 3600000;
            Rec.VALIDATE("Run Time", gDec_Value);
        END
        ELSE BEGIN
            d1 := CREATEDATETIME(TODAY, Rec."Starting Time");
            d2 := CREATEDATETIME(CALCDATE('+1D', TODAY), Rec."Ending Time");
            cDuration := d2 - d1;
            gDec_Value := (d2 - d1) / 1000 / 60 / 60;
            Rec.VALIDATE("Run Time", gDec_Value);
        END;
        //END;
        //FIN FHS
        DayOfWeek := DATE2DWY(Rec."Posting Date", 1);
        rWorkCenter.RESET;
        IF rWorkCenter.GET(Rec."Work Center No.") THEN BEGIN
            rCalenPlanta.SETRANGE("Shop Calendar Code", rWorkCenter."Shop Calendar Code");
            rCalenPlanta.SETFILTER("Starting Time", '<=%1', Rec."Starting Time");
            rCalenPlanta.SETFILTER("Ending Time", '>=%1', Rec."Starting Time");
            IF Rec."Starting Time" < Rec."Ending Time" THEN BEGIN
                //rCalenPlanta.SETFILTER("Starting Time",'%1..',Rec."Starting Time");
                //rCalenPlanta.SETFILTER("Ending Time",'>=%1',Rec."Ending Time");
                rCalenPlanta.SETRANGE(Day, DayOfWeek - 1);
            END
            ELSE BEGIN
                IF DayOfWeek = 7 THEN
                    DayOfWeek := 1
                ELSE
                    DayOfWeek := DayOfWeek + 1;
                rCalenPlanta.SETRANGE(Day, DayOfWeek - 1);
            END;
            IF rCalenPlanta.FINDSET() THEN Rec."Work Shift Code" := rCalenPlanta."Work Shift Code";
        END;
        EXIT;
    end;

    [EventSubscriber(ObjectType::page, page::"Item Journal", 'OnBeforeActionEvent', 'Post', false, false)]
    local procedure OnBeforeActionEventPost(var Rec: Record "Item Journal Line")
    var
        rCompanyInformation: Record "Company Information";
        InterfaceSga: Codeunit "Interface SGA";
    begin
        rCompanyInformation.Get();
        if rCompanyInformation.SGA then begin
            Clear(InterfaceSga);
            IF InterfaceSga.AlmRegManualDiario(Rec) THEN ERROR(Text50000);
        end;
    end;

    [EventSubscriber(ObjectType::page, page::"Item Journal", 'OnBeforeActionEvent', 'Post and &Print', false, false)]
    local procedure OnBeforeActionEventPostAndPrint(var Rec: Record "Item Journal Line")
    var
        rCompanyInformation: Record "Company Information";
        InterfaceSga: Codeunit "Interface SGA";
    begin
        rCompanyInformation.Get();
        if rCompanyInformation.SGA then begin
            Clear(InterfaceSga);
            IF InterfaceSga.AlmRegManualDiario(Rec) THEN ERROR(Text50000);
        end;
    end;

    var
        Text50000: Label 'Existen líneas con almacén SGA.', comment = 'ESP="Existen líneas con almacén SGA."';
}
