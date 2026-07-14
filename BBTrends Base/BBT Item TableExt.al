TableExtension 50111 "BBT Item" extends Item
{
    fields
    {
        /* BBT 01/07/2025. Se admiten todos los caracteres >>100<<
        modify(Description)
        {
            trigger OnBeforeValidate()
            var
                Text001Err: Label 'This field can not have more than 50 characters.', Comment = 'ESP="El campo "Descripción" no puede superar 50 caracteres."';
            begin
                if StrLen(Rec.Description) > 50 then Error(Text001Err);
            end;
        }
        */
        field(50000; "EAN Code"; Text[20]) //Modificamos de Text[13] a Text[20] porque el campo del que se alimenta tiene longitud 20
        {
            Caption = 'EAN Code', comment = 'ESP="Código EAN"';
            Description = '001';
        }
        field(50001; "No SGA management"; Boolean)
        {
            //>> BBT SGA Extension
            ObsoleteState = Pending;
            //<<
            Caption = 'No SGA management';
            Description = 'SGA';
        }
        field(50002; "SGA lot management"; Boolean)
        {
            //>> BBT SGA Extension
            ObsoleteState = Pending;
            //<<
            Caption = 'SGA lot management';
            Description = 'SGA';
        }
        field(50003; "Forced buy SGA"; Boolean)
        {
            //>> BBT SGA Extension
            ObsoleteState = Pending;
            //<<
            Caption = 'Forced buy SGA';
            Description = 'SGA';
        }
        field(50004; "Forced sales SGA"; Boolean)
        {
            //>> BBT SGA Extension
            ObsoleteState = Pending;
            //<<
            Caption = 'Forced sales SGA';
            Description = 'SGA';
        }
        field(50005; ModificadoSGA; Boolean)
        {
            //>> BBT SGA Extension
            ObsoleteState = Pending;
            //<<
            Description = 'SGA';
        }
        field(50006; "Spare Part No."; Code[20])
        {
            Caption = 'Spare Part No.';
            Description = 'PRP-001';
            ObsoleteState = Pending;    // BBT SDA FACTORY 01/07/2025 
        }
        field(50007; "Drawing Part No."; Text[50])
        {
            Caption = 'Drawing Part No.';
            Description = 'PRP-001';
            ObsoleteState = Pending;    // BBT SDA FACTORY 01/07/2025
        }
        field(50008; "Approval Type"; Text[50])
        {
            Caption = 'Approval Type';
            Description = 'PRP-001';
            ObsoleteState = Pending;    // BBT SDA FACTORY 01/07/2025
        }
        field(50009; "Change Document No."; Text[50])
        {
            Caption = 'Change Document No.';
            Description = 'PRP-001';
            ObsoleteState = Pending;    // BBT SDA FACTORY 01/07/2025
        }
        field(50010; "Modified by User ID"; Text[50])
        {
            Caption = 'Modified by User ID';
            Description = 'PRP-001';
            Editable = false;
        }
        field(50011; "No return"; Boolean)
        {
            Caption = 'No return';
            ObsoleteState = Pending;    // BBT SDA FACTORY 01/07/2025
        }
        field(50012; "Importe RAEE"; Decimal)
        {
            ObsoleteState = Pending;            //>> BBT. SMG Extension.
            MinValue = 0;
        }
        field(50013; "Royalty %"; Decimal)
        {
            ObsoleteState = Pending;            //>> BBT. SMG Extension.
            MaxValue = 100;
            MinValue = 0;
        }
        field(50014; "Web Catalog"; Boolean)
        {
            Caption = 'Activo en Prestashop';
            ObsoleteState = Pending;    // BBT 01/07/2025

            //>> BBT 01/07/2025. No se usa PRESTASHOP
            /*
            trigger OnValidate()
            var
                PSHOPIntegrationMgt: Codeunit 50009;
            begin
                // FHS: lo comento por qué no funciona
                //PSHOPIntegrationMgt.CreateFromNAVItem(Rec,FIELDNO("Web Catalog"));
            end;
            */
            //<<
        }
        field(50015; "PSHOP Product Id"; Integer)
        {
            ObsoleteState = Pending;    // BBT 01/07/2025
            Caption = 'Id producto Prestashop';
            Editable = false;
            //>> BBT. PSHOP. Tabla Obsoleta.
            //CalcFormula = lookup("PSHOP - Product".id where("NAV Item No." = field("No.")));
            //FieldClass = FlowField;
            //<<
        }
        field(50016; Clearance; Boolean)
        {
            Caption = 'Liquidación';
            ObsoleteState = Pending;    // BBT 01/07/2025

            //>> BBT 01/07/2025. No se usa PRESTASHOP
            /*
            trigger OnValidate()
            var
                PSHOPIntegrationMgt: Codeunit 50009;
            begin
                // FHS: lo comento por qué no funciona
                //PSHOPIntegrationMgt.CreateFromNAVItem(Rec,FIELDNO("Web Catalog"));
            end;
            */
            //<<
        }
        field(50017; "Activado Web"; Boolean)
        {
            ObsoleteState = Pending;    // BBT 01/07/2025
            //>> BBT 01/07/2025. No se usa PRESTASHOP
            /*
            trigger OnValidate()
            var
                PSHOPIntegrationMgt: Codeunit 50009;
            begin
                // FHS: lo comento por qué no funciona
                //PSHOPIntegrationMgt.CreateFromNAVItem(Rec,FIELDNO("Activado Web"));
            end;
            */
            //<<
        }
        field(50018; "Activado Marketplace"; Boolean)   // Campo reutilizado para indicar la venta en exclusiva para Ecommerce/Marketplace
        { }
        field(50020; "Num. Cintas"; Integer)
        {
            ObsoleteState = Pending;    // BBT 01/07/2025
        }
        field(50021; Material; Text[100])
        {
            //>> BBT. PRECINTIA. Tabla Obsoleta
            //TableRelation = "Atributos basicos".Valor where(Atributo = const(Material));
            //<<
            ObsoleteState = Pending;    // BBT 01/07/2025
        }
        field(50022; Color; Text[100])
        {
            //>> BBT. PRECINTIA. Tabla Obsoleta
            //TableRelation = "Atributos basicos".Valor where(Atributo = const(Color));
            //<<
            ObsoleteState = Pending;    // BBT 01/07/2025
        }
        field(50023; "Tecnología Impresión"; Text[100])
        {
            //>> BBT. PRECINTIA. Tabla Obsoleta
            //TableRelation = "Atributos basicos".Valor where(Atributo = const("Tecnología Impresión"));
            //<<
            ObsoleteState = Pending;    // BBT 01/07/2025
        }
        field(50024; "Garantia %"; Decimal)
        {
            ObsoleteState = Pending;            //>> BBT. SMG Extension.
            MaxValue = 100;
            MinValue = 0;
        }
        field(50025; "Integrado CRM"; Boolean)
        {
            ObsoleteState = Pending;    // BBT. 22/05/2025. Intregración Custom CRM Obsoleta.
        }
        field(50026; "Ult. Integración"; DateTime)
        {
            ObsoleteState = Pending;    // BBT. 22/05/2025. Intregración Custom CRM Obsoleta.
        }
        field(50027; "ID CRM"; Code[40])
        {
            Caption = 'ID CRM';
            ObsoleteState = Pending;    // BBT. 22/05/2025. Intregración Custom CRM Obsoleta.
        }
        field(50028; "Stock alm. PA"; Decimal)
        {
            CalcFormula = sum("Item Ledger Entry".Quantity where("Item No." = field("No."), "Location Code" = const('PA')));
            FieldClass = FlowField;
        }
        field(50029; "Stock alm. FAPA"; Decimal)
        {
            CalcFormula = sum("Item Ledger Entry".Quantity where("Item No." = field("No."), "Location Code" = const('FAPA')));
            FieldClass = FlowField;
        }
        field(50030; "Inventario CRM"; Decimal)
        { }
        field(50031; "BBT Rework"; Boolean)
        {
            Caption = 'Rework', comment = 'ESP="Retrabajo"';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                ReworkTypeByCustItem: Record "BBT Rework Type By Cust./Item";
                LocalText000Lbl: Label 'There are types of rework associated with this product. Do you want to delete them?', comment = 'ESP="Existen tipos de retrabajo asociados a este producto, ¿Desea eliminarlos?"';
            begin
                if not "BBT Rework" then begin
                    ReworkTypeByCustItem.Reset();
                    ReworkTypeByCustItem.SetRange("BTT Rework Item No.", "No.");
                    if ReworkTypeByCustItem.FindSet() then begin
                        if Confirm(LocalText000Lbl, true) then
                            repeat
                                ReworkTypeByCustItem.Delete();
                            until ReworkTypeByCustItem.Next() = 0;
                    end;
                end
            end;
        }
        field(50068; "Inventory to Date"; Decimal)
        {
            CalcFormula = sum("Item Ledger Entry".Quantity where("Item No." = field("No."), "Global Dimension 1 Code" = field("Global Dimension 1 Filter"), "Global Dimension 2 Code" = field("Global Dimension 2 Filter"), "Location Code" = field("Location Filter"), "Drop Shipment" = field("Drop Shipment Filter"), "Variant Code" = field("Variant Filter"), "Lot No." = field("Lot No. Filter"), "Serial No." = field("Serial No. Filter"), "Posting Date" = field("Date Filter")));
            Caption = 'Inventario a fecha';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50069; Embolsado; Boolean)
        {
            ObsoleteState = Pending;    // BBT PRECINTIA 01/07/2025
        }
        field(50070; "Unidades Bolsa"; Integer)
        {
            ObsoleteState = Pending;    // BBT PRECINTIA 01/07/2025
        }
        field(50071; "Generic Item"; Boolean)
        {
            Caption = 'Generic Item';
            ObsoleteState = Pending;    // BBT PRECINTIA 01/07/2025
        }
        field(50072; "Customer Filter"; Code[20])
        {
            FieldClass = FlowFilter;
        }
        field(50073; "Have Customer Rate"; Boolean)
        {
            ObsoleteState = Pending;     // BBT. Nueva version Precios
            /* 
            CalcFormula = exist("Sales Price" where("Item No." = field("No."), "Sales Type" = const(Customer), "Sales Code" = field("Customer Filter")));
            FieldClass = FlowField;
            */
        }
        field(50074; "Creation Date"; Date)
        {
            Caption = 'Creation date';
        }
        field(50080; "Previous Description"; Text[100])
        {
            Caption = 'Previous Description', comment = 'ESP="Descripción Anterior"';
        }
        field(50090; "Cubage Base Unit of Measure"; Decimal)
        {
            Caption = 'Cubage Base Unit of Measure', comment = 'ESP="Volumen unidad medida base"';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Item Unit of Measure".Cubage where("Item No." = field("No."), Code = field("Base Unit of Measure")));
        }
        field(51103; "Item Group"; code[50])
        {
            TableRelation = "Product Families"."Classification Value" where("Classification field" = const("Item Group"));
            Caption = 'Item Group', Comment = 'ESP="Grupo Producto"';
            ValidateTableRelation = true;
            Enabled = true;
            Editable = true;
        }
        field(51104; "Item Family"; code[50])
        {
            TableRelation = "Product Families"."Classification Value" where("Classification field" = const("Item Family"), "Parent Value" = field("Item Group"));
            Caption = 'Item Family', Comment = 'ESP="Familia Producto"';
            ValidateTableRelation = true;
            Enabled = true;
            Editable = true;
        }
        field(51105; "Item Subfamily"; code[50])
        {
            TableRelation = "Product Families"."Classification Value" where("Classification field" = const("Item Subfamily"), "Parent Value" = field("Item Family"));
            Caption = 'Item Subfamily', Comment = 'ESP="Subfamilia Producto"';
            ValidateTableRelation = true;
            Enabled = true;
            Editable = true;
        }
        field(51126; "Standard Cost 2024"; Decimal)
        {
            ObsoleteState = Pending;            //>> BBT. SMG Extension.
            Caption = 'Standard Cost 2024', Comment = 'ESP="Coste Estandar 2024"';
            Enabled = true;
            Editable = true;
        }
        field(51127; "Ecommerce Shipping Cost"; Decimal)
        {
            ObsoleteState = Pending;            //>> BBT. SMG Extension.

            Caption = 'Ecommerce Shipping Cost', Comment = 'ESP="Coste Transporte Ecommerce"';
            Enabled = true;
            Editable = true;
        }
        field(51169; "Scrap Cost"; Decimal)
        {
            Caption = 'Scrap Cost', Comment = 'ESP="Coste Scrap"';
            Enabled = true;
            Editable = false;
            DecimalPlaces = 2 : 5;
            FieldClass = FlowField;
            CalcFormula = lookup("BBT Item Residues"."Scrap Cost" where("Item No." = field("No."), "Residue No." = const('SCRAP')));
        }
        field(51172; "Standard Cost 2025"; Decimal)
        {
            ObsoleteState = Pending;            //>> BBT. SMG Extension.
            Caption = 'Standard Cost 2025', Comment = 'ESP="Coste Estandar 2025"';
            Enabled = true;
            Editable = true;
        }
        field(51175; "Ecommerce Shipping Cost 2025"; Decimal)
        {
            ObsoleteState = Pending;            //>> BBT. SMG Extension.
            Caption = 'Ecommerce Shipping Cost 2025', Comment = 'ESP="Coste Transporte Ecommerce 2025"';
            Enabled = true;
            Editable = true;
        }
        //>> BBT. 11/05/2026. LeadTime de Productos - SCM
        field(51176; "Manufacturing LeadTime"; DateFormula)
        {
            Caption = 'Manufacturing LeadTime', Comment = 'ESP="Tiempo Fabricación"';
            Enabled = true;
            Editable = true;
        }
        field(51177; "Inspection-Transit LeadTime"; DateFormula)
        {
            Caption = 'Inspection-Transit LeadTime', Comment = 'ESP="Tiempo Inspección-Transito"';
            Enabled = true;
            Editable = true;
        }
        field(51178; "Last Mile LeadTime"; DateFormula)
        {
            Caption = 'Last Mile LeadTime', Comment = 'ESP="Tiempo Recogida-Almacén"';
            Enabled = true;
            Editable = true;
        }
        //<<
    }
    procedure DuplicateProduct(NewItemCode: Code[20]): Code[10]
    var
        NewProduct: Record Item;
        Text030: label '¿Do you wish to create a new product based on %1?';
        Text031: label 'The new product %1 has been created \ The new product has been blocked, remember to modify this accordingly';
        Text032: label 'An error has occurred during the creation of the new product';
        UnitOfMeasure: Record "Item Unit of Measure";
        InsertUnitOfM: Record "Item Unit of Measure";
        dlg: Dialog;
        Text033: label 'Introduzca el EAN del nuevo producto #######1#######';
        Text034: label 'Se debe especificar un EAN válido';
        Text035: label 'El EAN %1 ya existe para el producto %2';
        RecItemCategoryCode: Record "Item Category";
        RecVariantCode: Record "Item Variant";
        InsertVariantCode: Record "Item Variant";
        RecDimension: Record "Default Dimension";
        InsertDimension: Record "Default Dimension";
        RecStockkeepingUnit: Record "Stockkeeping Unit";
        InsertStockkeepingUnit: Record "Stockkeeping Unit";
        rAttributeValueMapping1: Record "Item Attribute Value Mapping";
        rAttributeValueMapping2: Record "Item Attribute Value Mapping";
    begin
        if Confirm(StrSubstNo(Text030, Rec."No.", NewItemCode)) then begin
            NewProduct.Init;
            NewProduct := Rec;
            NewProduct.Validate("Item Disc. Group", '');
            NewProduct.Blocked := true;
            NewProduct."Standard Cost" := 0;
            NewProduct."Unit Cost" := 0;
            NewProduct."Last Direct Cost" := 0;
            NewProduct."No." := NewItemCode;
            if NewProduct.Insert(true) then begin
                // Traspasar también las unidades de medida
                UnitOfMeasure.Reset;
                UnitOfMeasure.SetRange("Item No.", Rec."No.");
                if UnitOfMeasure.FindSet then begin
                    repeat
                        InsertUnitOfM.Init;
                        InsertUnitOfM := UnitOfMeasure;
                        InsertUnitOfM.Validate("Item No.", NewProduct."No.");
                        InsertUnitOfM.Insert(true);
                    until UnitOfMeasure.Next = 0;
                end;
                //Traspasamos variantes
                RecVariantCode.Reset;
                RecVariantCode.SetRange(RecVariantCode."Item No.", Rec."No.");
                if RecVariantCode.FindSet then begin
                    repeat
                        InsertVariantCode.Init;
                        InsertVariantCode := RecVariantCode;
                        InsertVariantCode."Item No." := NewProduct."No.";
                        InsertVariantCode.Insert(true);
                    until RecVariantCode.Next = 0;
                end;
                //Traspasamos variantes
                //Traspasamos dimensiones
                RecDimension.Reset;
                RecDimension.SetRange(RecDimension."Table ID", 27);
                RecDimension.SetRange(RecDimension."No.", Rec."No.");
                if RecDimension.FindSet then begin
                    repeat
                        InsertDimension.Init;
                        InsertDimension := RecDimension;
                        InsertDimension."No." := NewProduct."No.";
                        InsertDimension.Insert(true);
                    until RecDimension.Next = 0;
                end;
                //Traspasamos dimensiones
                //Traspasamos unidades de almacenamiento
                RecStockkeepingUnit.Reset;
                RecStockkeepingUnit.SetRange("Item No.", Rec."No.");
                if RecStockkeepingUnit.FindSet then begin
                    repeat
                        InsertStockkeepingUnit.Init;
                        InsertStockkeepingUnit := RecStockkeepingUnit;
                        InsertStockkeepingUnit."Item No." := NewProduct."No.";
                        InsertStockkeepingUnit.Insert(true);
                    until RecStockkeepingUnit.Next = 0;
                end;
                //Traspasamos unidades de almacenamiento
                // FHS: traspasamos los atributos
                rAttributeValueMapping1.Reset();
                rAttributeValueMapping1.SetRange("No.", Rec."No.");
                rAttributeValueMapping1.SetRange("Table ID", 27);
                if rAttributeValueMapping1.FindSet then
                    repeat
                        rAttributeValueMapping2.Init;
                        rAttributeValueMapping2."Table ID" := 27;
                        rAttributeValueMapping2."No." := NewProduct."No.";
                        rAttributeValueMapping2."Item Attribute ID" := rAttributeValueMapping1."Item Attribute ID";
                        rAttributeValueMapping2."Item Attribute Value ID" := rAttributeValueMapping1."Item Attribute Value ID";
                        rAttributeValueMapping2.Insert(true);
                    until rAttributeValueMapping1.Next = 0;
                // FIN FHS
                Message(Text031, NewProduct."No.")
            end
            else
                Message(Text032);
            exit(NewProduct."No.");
        end;
    end;

    procedure TestNoOpenDocumentsWithTrackingExist(Rec: Record Item; ItemTrackingCode2: Record "Item Tracking Code")
    var
        TrackingSpecification: Record "Tracking Specification";
        ReservationEntry: Record "Reservation Entry";
        RecRef: RecordRef;
        SourceType: Integer;
        SourceID: Code[20];
        OpenDocumentTrackingErr: Label 'You cannot change "Item Tracking Code" because there is at least one open document that includes this item with specified tracking: Source Type = %1, Document No. = %2.';
    begin
        IF ItemTrackingCode2.Code = '' THEN EXIT;
        TrackingSpecification.SETRANGE("Item No.", rec."No.");
        IF TrackingSpecification.FINDFIRST THEN BEGIN
            SourceType := TrackingSpecification."Source Type";
            SourceID := TrackingSpecification."Source ID";
        END
        ELSE BEGIN
            ReservationEntry.SETRANGE("Item No.", rec."No.");
            ReservationEntry.SETFILTER("Item Tracking", '<>%1', ReservationEntry."Item Tracking"::None);
            IF ReservationEntry.FINDFIRST THEN BEGIN
                SourceType := ReservationEntry."Source Type";
                SourceID := ReservationEntry."Source ID";
            END;
        END;
        IF SourceType = 0 THEN EXIT;
        RecRef.OPEN(SourceType);
        ERROR(OpenDocumentTrackingErr, RecRef.CAPTION, SourceID);
    end;

    [Obsolete('New SGA Extension')]
    procedure ModificadoSGAFunc()
    var
        _InfoCompany: Record "Company Information";
    begin
        _InfoCompany.GET;
        IF _InfoCompany.SGA THEN BEGIN
            IF rec."No SGA management" THEN
                rec.ModificadoSGA := FALSE
            ELSE
                rec.ModificadoSGA := (rec."No." <> xRec."No.") OR (rec.Description <> xRec.Description) OR (rec."Base Unit of Measure" <> xRec."Base Unit of Measure") OR (rec."Net Weight" <> xRec."Net Weight") OR (rec."Gross Weight" <> xRec."Gross Weight") OR (rec."SGA lot management" <> xRec."SGA lot management") OR (rec."Forced buy SGA" <> xRec."Forced buy SGA") OR (rec."Forced sales SGA" <> xRec."Forced sales SGA") OR (rec."Search Description" <> xRec."Search Description") OR (rec."Unit Volume" <> xRec."Unit Volume") OR (rec."Gen. Prod. Posting Group" <> xRec."Gen. Prod. Posting Group") OR (rec."Item Category Code" <> xRec."Item Category Code") OR (rec."No SGA management" <> xRec."No SGA management") OR ModifIden;
        END
        ELSE
            rec.ModificadoSGA := FALSE;
    end;

    [Obsolete('New SGA Extension')]
    procedure ModifUDSGA()
    var
        _UDMedidaProducto: Record "Item Unit of Measure";
        _ConfigAlmacen: Record "Warehouse Setup";
        _ItemIdentifier: Record "Item Identifier";
        _InfoCompany: Record "Company Information";
    begin
        _InfoCompany.GET;
        IF _InfoCompany.SGA THEN BEGIN
            IF NOT ModificadoSGA THEN BEGIN
                _ConfigAlmacen.GET;
                _UDMedidaProducto.SETRANGE("Item No.", "No.");
                _UDMedidaProducto.SETRANGE(Code, "Base Unit of Measure");
                _UDMedidaProducto.SETRANGE(modificadoSGA, TRUE);
                ModificadoSGA := ModificadoSGA OR _UDMedidaProducto.FINDSET;
            END;
            IF NOT ModificadoSGA THEN BEGIN
                _ConfigAlmacen.GET;
                _UDMedidaProducto.SETRANGE("Item No.", "No.");
                _UDMedidaProducto.SETRANGE(Code, _ConfigAlmacen."Box Unit");
                _UDMedidaProducto.SETRANGE(modificadoSGA, TRUE);
                ModificadoSGA := ModificadoSGA OR _UDMedidaProducto.FINDSET;
            END;
            _UDMedidaProducto.RESET;
            _UDMedidaProducto.SETRANGE("Item No.", "No.");
            _UDMedidaProducto.MODIFYALL(modificadoSGA, FALSE);
        END;
    end;

    [Obsolete('New SGA Extension')]
    procedure SGAVisible()
    var
        _InfoCompany: Record "Company Information";
    begin
        _InfoCompany.GET;
        VisiblecamposSGA := NOT "No SGA management" AND _InfoCompany.SGA;
    end;

    var
        VisiblecamposSGA: Boolean;
        ModifIden: Boolean;
        ItemAttributeValueMapping: Record "Item Attribute Value Mapping";
}
