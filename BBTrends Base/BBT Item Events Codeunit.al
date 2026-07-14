codeunit 50043 "Item Events"
{
    [EventSubscriber(ObjectType::Table, database::Item, 'OnBeforeModifyEvent', '', false, false)]
    local procedure OnBeforeModifyEvent(RunTrigger: Boolean; var Rec: Record Item; var xRec: Record Item)
    begin
        Rec."Last Date Modified" := TODAY;
        //-PRP-001
        Rec."Modified by User ID" := USERID;
        //+PRP-001
        //>> BBT. 22/05/2025. Intregración Custom CRM Obsoleta.
        //Forzar en el proceso BATCH la actualización del producto en el CRM
        //IF Rec."Integrado CRM" THEN Rec."Ult. Integración":=CurrentDatetime;
        //<<
    end;

    [EventSubscriber(ObjectType::Table, database::Item, 'OnBeforeValidateEvent', 'Item Tracking Code', false, false)]
    local procedure OnBeforeValidateEventItemTrackingCode(CurrFieldNo: Integer; var Rec: Record Item; var xRec: Record Item)
    var
        rCompany: Record Company;
        rAccessControl: Record "Access Control";
        // rUserGroupMember: Record "User Group Member";
        ModifAllowed: Boolean;
    begin
        //>> PCT 30/03/2023. Control de modificación del Item Tracking Code
        ModifAllowed := FALSE;
        rCompany.INIT;
        rCompany.SETRANGE(Name, COMPANYNAME);
        //rCompany.SETRANGE("Is Precintia", TRUE);
        IF rCompany.FINDFIRST THEN BEGIN
            ModifAllowed := TRUE;
            rAccessControl.INIT;
            rAccessControl.SETRANGE("User Name", USERID);
            rAccessControl.SETRANGE(rAccessControl."Role ID", 'SUPER');
            rAccessControl.SETFILTER("Company Name", '= %1', '');
            IF NOT rAccessControl.FINDFIRST THEN BEGIN
                rAccessControl.INIT;
                rAccessControl.SETRANGE("User Name", USERID);
                rAccessControl.SETRANGE(rAccessControl."Role ID", 'SUPER');
                rAccessControl.SETFILTER("Company Name", '= %1', COMPANYNAME);
                IF NOT rAccessControl.FINDFIRST THEN BEGIN
                    // rUserGroupMember.INIT;
                    // rUserGroupMember.SETRANGE("User Name", USERID);
                    // rUserGroupMember.SETRANGE("Company Name", COMPANYNAME);
                    // rUserGroupMember.SETRANGE("User Group Name", 'PCT-NUMERACION');
                    // IF NOT rUserGroupMember.FINDFIRST THEN BEGIN
                    ModifAllowed := FALSE;
                END;
            END;
        END;
        IF ModifAllowed THEN MESSAGE('ATENCION. Los cambios En la configuración de la gestión de lotes pueden generar problemas con pedidos de compra/venta pendientes');
    END;
    //<<
    //end;
    [EventSubscriber(ObjectType::Table, database::Item, 'OnAfterValidateEvent', 'Item Tracking Code', false, false)]
    local procedure OnAfterValidateEventItemTrackingCode(CurrFieldNo: Integer; var Rec: Record Item; var xRec: Record Item)
    var
        rCompany: Record Company;
        rAccessControl: Record "Access Control";
        ModifAllowed: Boolean;
        ItemTrackingCode: Record "Item Tracking Code";
        ItemTrackingCode2: Record "Item Tracking Code";
        Text018: Label '%1 must be %2 in %3 %4 when %5 is %6.';
    begin
        IF NOT ItemTrackingCode.GET(rec."Item Tracking Code") THEN CLEAR(ItemTrackingCode);
        IF NOT ItemTrackingCode2.GET(xRec."Item Tracking Code") THEN CLEAR(ItemTrackingCode2);
        //>> PCT 30/03/2023. Control de modificación del Item Tracking Code
        IF NOT ModifAllowed THEN BEGIN
            IF (ItemTrackingCode."SN Specific Tracking" <> ItemTrackingCode2."SN Specific Tracking") OR (ItemTrackingCode."Lot Specific Tracking" <> ItemTrackingCode2."Lot Specific Tracking") THEN rec.TestNoEntriesExist(rec.FIELDCAPTION("Item Tracking Code"));
            IF rec."Costing Method" = "Costing Method"::Specific THEN BEGIN
                rec.TestNoEntriesExist(rec.FIELDCAPTION("Item Tracking Code"));
                rec.TESTFIELD("Item Tracking Code");
                ItemTrackingCode.GET(rec."Item Tracking Code");
                IF NOT ItemTrackingCode."SN Specific Tracking" THEN ERROR(Text018, ItemTrackingCode.FIELDCAPTION("SN Specific Tracking"), FORMAT(TRUE), ItemTrackingCode.TABLECAPTION, ItemTrackingCode.Code, rec.FIELDCAPTION("Costing Method"), rec."Costing Method");
            END;
            rec.TestNoOpenDocumentsWithTrackingExist(Rec, ItemTrackingCode2);
        END;
    end;

    [EventSubscriber(ObjectType::page, page::"Item Card", 'OnInsertRecordEvent', '', false, false)]
    local procedure OnInsertRecordEvent(BelowxRec: Boolean; var AllowInsert: Boolean; var Rec: Record Item; var xRec: Record Item)
    var
        rCompanyInformation: Record "Company Information";
    begin
        rCompanyInformation.Get();
        if rCompanyInformation.SGA then begin
            // SGA
            rec.ModificadoSGAFunc;
            // SGA
            IF NOT rec.ModificadoSGA THEN rec.ModifUDSGA;
        end;
    end;

    [EventSubscriber(ObjectType::page, page::"Item Card", 'OnModifyRecordEvent', '', false, false)]
    local procedure OnModifyRecordEvent(var AllowModify: Boolean; var Rec: Record Item; var xRec: Record Item)
    var
        rCompanyInformation: Record "Company Information";
    begin
        rCompanyInformation.Get();
        if rCompanyInformation.SGA then begin
            // SGA
            rec.ModificadoSGAFunc;
            // SGA
            IF NOT rec.ModificadoSGA THEN rec.ModifUDSGA;
        end;
    end;

    [EventSubscriber(ObjectType::Table, database::Item, 'OnAfterValidateEvent', 'Description', false, false)]
    local procedure OnAfterValidateEventDescription(CurrFieldNo: Integer; var Rec: Record Item; var xRec: Record Item)
    begin
        // - Recambios
        if Rec.Description <> xRec.Description then Rec."Previous Description" := xRec.Description;
        // + Recambios
    end;
    #region Item Identifier
    //El EAN Code del producto se arrastra desde la tabla Item Identifier
    [EventSubscriber(ObjectType::Table, Database::"Item Identifier", 'OnAfterInsertEvent', '', true, true)]
    local procedure ItemIdentifier_OnAfterInsertEvent(var Rec: Record "Item Identifier"; RunTrigger: Boolean)
    var
        Item: Record Item;
    begin
        if Rec.IsTemporary then exit;
        if not RunTrigger then exit;
        if Item.Get(Rec."Item No.") then
            if Item."Base Unit of Measure" = Rec."Unit of Measure Code" then begin
                Item."EAN Code" := Rec.Code;
                Item.Modify();
            end
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Identifier", 'OnAfterValidateEvent', 'Code', true, true)]
    local procedure ItemIdentifier_OnAfterValidateEvent_Code(var Rec: Record "Item Identifier"; var xRec: Record "Item Identifier"; CurrFieldNo: Integer)
    var
        Item: Record Item;
        LocalText000Lbl: Label 'Item %1 already has %2 reported. Do you want to update it?', comment = 'ESP="El producto %1 ya tiene un %2 informado. ¿Desea actualizarlo?"';
    begin
        if Item.Get(Rec."Item No.") then
            if Item."Base Unit of Measure" = Rec."Unit of Measure Code" then begin
                if Item."EAN Code" <> '' then begin
                    if Confirm(StrSubstNo(LocalText000Lbl, Item."No.", Item.FieldCaption("EAN Code")), true) then begin
                        Item."EAN Code" := Rec.Code;
                        Item.Modify();
                    end;
                end
                else begin
                    Item."EAN Code" := Rec.Code;
                    Item.Modify();
                end;
            end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Identifier", 'OnAfterValidateEvent', 'Unit of Measure Code', true, true)]
    local procedure ItemIdentifier_OnAfterValidateEvent_UnitOfMeasureCode(var Rec: Record "Item Identifier"; var xRec: Record "Item Identifier"; CurrFieldNo: Integer)
    var
        Item: Record Item;
        LocalText000Lbl: Label 'Item %1 already has %2 reported. Do you want to update it?', comment = 'ESP="El producto %1 ya tiene un %2 informado. ¿Desea actualizarlo?"';
    begin
        if Item.Get(Rec."Item No.") then
            if Item."Base Unit of Measure" = Rec."Unit of Measure Code" then begin
                if Item."EAN Code" <> '' then begin
                    if Confirm(StrSubstNo(LocalText000Lbl, Item."No.", Item.FieldCaption("EAN Code")), true) then begin
                        Item."EAN Code" := Rec.Code;
                        Item.Modify();
                    end;
                end
                else begin
                    Item."EAN Code" := Rec.Code;
                    Item.Modify();
                end;
            end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Identifier", 'OnAfterDeleteEvent', '', true, true)]
    local procedure ItemIdentifier_OnAfterDeleteEvent(var Rec: Record "Item Identifier"; RunTrigger: Boolean)
    var
        Item: Record Item;
    begin
        if Rec.IsTemporary then exit;
        if not RunTrigger then exit;
        if Item.Get(Rec."Item No.") then
            if Item."Base Unit of Measure" = Rec."Unit of Measure Code" then begin
                Clear(Item."EAN Code");
                Item.Modify();
            end
    end;
    #endregion Item Identifier
    #region Item Unit Of Measure
    //El peso neto y bruto se rellenarán directarmente de la unidad de medida que coincida con la unidad de medida base del producto
    //Código para el peso bruto en la tabla Item Unit Of Measure -> Validate (es un campo creado)
    [EventSubscriber(ObjectType::Table, Database::"Item Unit of Measure", 'OnAfterInsertEvent', '', true, true)]
    local procedure ItemUnitOfMeasure_OnAfterInsertEvent(var Rec: Record "Item Unit of Measure"; RunTrigger: Boolean)
    var
        Item: Record Item;
    begin
        if Rec.IsTemporary then exit;
        if not RunTrigger then exit;
        if Item.Get(Rec."Item No.") then
            if Item."Base Unit of Measure" = Rec.Code then begin
                Item."Net Weight" := Rec.Weight;
                Item."Gross Weight" := Rec."Gross weight";
                Item.Modify();
            end
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Unit of Measure", 'OnAfterValidateEvent', 'Weight', true, true)]
    local procedure ItemUnitOfMeasure_OnAfterValidateEvent_Weight(var Rec: Record "Item Unit of Measure"; var xRec: Record "Item Unit of Measure"; CurrFieldNo: Integer)
    var
        Item: Record Item;
    begin
        if Item.Get(Rec."Item No.") then
            if Item."Base Unit of Measure" = Rec.Code then begin
                Item."Net Weight" := Rec.Weight;
                Item.Modify();
            end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Unit of Measure", 'OnAfterDeleteEvent', '', true, true)]
    local procedure ItemUnitOfMeasure_OnAfterDeleteEvent(var Rec: Record "Item Unit of Measure"; RunTrigger: Boolean)
    var
        Item: Record Item;
    begin
        if Rec.IsTemporary then exit;
        if not RunTrigger then exit;
        if Item.Get(Rec."Item No.") then
            if Item."Base Unit of Measure" = Rec.Code then begin
                Clear(Item."Net Weight");
                Clear(Item."Gross Weight");
                Item.Modify();
            end
    end;
    #endregion Item Unit Of Measure
}
