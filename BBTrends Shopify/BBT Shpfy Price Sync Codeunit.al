codeunit 73103 "BBT Shpfy Price Sync"
{
    Permissions = tabledata "Sales Price" = rdmi,
                tabledata "Shpfy Variant" = rdmi;

    trigger OnRun()
    var
        rItem: Record Item;
        rShpfyVariant: Record "Shpfy Variant";
        rSalesPrice: Record "Sales Price";
        rShpfyProduct: Record "Shpfy Product";
        rShpfyShop: Record "Shpfy Shop";
        vCustPrice: Decimal;
        vCustPriceGroup: Decimal;
    begin
        rShpfyShop.Reset();
        rShpfyShop.SetRange(Enabled, true);
        rShpfyShop.SetRange(MarketPlace, false);
        if rShpfyShop.FindSet() then begin
            repeat
                rShpfyProduct.Reset();
                rShpfyProduct.SetRange(Status, rShpfyProduct.Status::Active);
                rShpfyProduct.SetRange("Shop Code", rShpfyShop.Code);
                if rShpfyProduct.FindSet() then begin
                    repeat
                        rShpfyProduct.CalcFields("Item No.");
                        if rItem.get(rShpfyProduct."Item No.") then begin
                            rShpfyVariant.Reset();
                            rShpfyVariant.SetRange("Product Id", rShpfyProduct.Id);
                            if rShpfyVariant.FindSet() then
                                repeat
                                    Clear(vCustPrice);
                                    Clear(vCustPriceGroup);
                                    rShpfyVariant.CalcFields("Item No.");
                                    /* Se busca el precio valido en las tarifas de precios de los productos de BC   */
                                    FindValidPrices(rShpfyVariant."Shop Code", rShpfyVariant."Item No.", vCustPrice, vCustPriceGroup);

                                    /* Si los precios de comparación y de venta son 0 no se actualizan */
                                    if (vCustPrice <> 0) and (vCustPriceGroup <> 0) then begin

                                        /* Llamada a la actualización de los precios en las variantes de Shopify    */
                                        UpdShpfyVariantPrice(rShpfyVariant, vCustPrice, vCustPriceGroup);

                                        /* llamada a la API para actualizar los precios en Shopify WEB  */
                                        UpdShpfyWebPrice(rShpfyShop, rShpfyVariant);

                                    end;
                                until rShpfyVariant.Next() = 0;
                        end;
                    until rShpfyProduct.Next() = 0;
                end;
            until rShpfyShop.Next() = 0;
        end;
    end;
    /* Busqueda de precio valido en las tablas de precios de los productos de BC   */
    procedure FindValidPrices(pShopCode: Code[20]; pItem: Code[20]; Var pCustPrice: Decimal; Var pCustPriceGroup: Decimal)
    var
        rshpfyShop: record "Shpfy Shop";
        vCustomer: Code[20];
        vCustGroup: Code[10];
        rSalesPrice: Record "Sales Price";
        vToday: date;
    begin
        vToday := WorkDate();
        if rShpfyShop.Get(pShopCode) then begin
            rshpfyShop.Validate("Default Customer No.");
            vCustomer := rshpfyShop."Default Customer No.";
            rshpfyShop.Validate("Customer Price Group");
            vCustGroup := rshpfyShop."Customer Price Group";
            /*  Precio MarketPlace   */
            Clear(pCustpriceGroup);
            rSalesPrice.Reset();
            rSalesPrice.SetRange("Item No.", pItem);
            rSalesPrice.SetRange("Sales Type", rSalesPrice."Sales Type"::"Customer Price Group");
            rSalesPrice.SetRange("Sales Code", vCustGroup);
            rSalesPrice.SetFilter("Starting Date", '<=%1', vToday);
            rSalesPrice.SetFilter("Ending Date", '>=%1', vToday);
            if rSalesPrice.FindFirst() then
                pCustpriceGroup := rSalesPrice."Unit Price"
            else begin
                rSalesPrice.SetFilter("Ending Date", '=%1', 0D);
                if rSalesPrice.FindFirst() then
                    pCustpriceGroup := rSalesPrice."Unit Price"
            end;
            /*  Precio Cliente   */
            Clear(pCustPrice);
            rSalesPrice.Reset();
            rSalesPrice.SetRange("Item No.", pItem);
            rSalesPrice.SetRange("Sales Type", rSalesPrice."Sales Type"::Customer);
            rSalesPrice.SetRange("Sales Code", vCustomer);
            rSalesPrice.SetFilter("Starting Date", '<=%1', vToday);
            rSalesPrice.SetFilter("Ending Date", '>=%1', vToday);
            if rSalesPrice.FindFirst() then
                pCustPrice := rSalesPrice."Unit Price"
            else begin
                rSalesPrice.SetFilter("Ending Date", '=%1', 0D);
                if rSalesPrice.FindFirst() then
                    pCustPrice := rSalesPrice."Unit Price"
            end;

        end;
    end;
    /* Actualización de los precios obtenidos de las tarifas en la tabla de variantes de Shopify    */
    procedure UpdShpfyVariantPrice(var prShpfyVariant: Record "Shpfy Variant"; pCustPrice: Decimal; pCustPriceGroup: Decimal)
    begin

        if pCustPriceGroup <> 0 then begin
            prShpfyVariant."Compare at Price" := pCustPriceGroup;
            prShpfyVariant.Price := pCustPriceGroup;
            if pCustPrice <> 0 then
                prShpfyVariant.Price := pCustPrice;

            prShpfyVariant.Modify();
            Commit();
        end;
    end;
    /*  API para actualizar los precios en Shopify WEB  */
    procedure UpdShpfyWebPrice(pShpfyShop: Record "Shpfy Shop"; ShopifyVariant: Record "Shpfy Variant")
    var
        HttpClient: HttpClient;
        Content: HttpContent;
        HttpResponseMessage: HttpResponseMessage;
        ApiUrl: Text;
        RequestHeaders: HttpHeaders;
        JsonRequestBody: Text;
        Response: HttpResponseMessage;
        ApiToken: Text;
    begin
        Clear(ApiUrl);
        ApiUrl := Format(pShpfyShop."API Shop URL") + 'admin/api/' + Format(pShpfyShop."API Version") + '/variants/' + Format(ShopifyVariant.Id) + '.json';
        ApiToken := pShpfyShop."API Secret";
        JsonRequestBody := '{' + '"variant": {' + '"price": "' + Format(ShopifyVariant.Price) + '",' + '"compare_at_price": "' + Format(ShopifyVariant."Compare at Price") + '"' + '}' + '}';
        Content.Clear();
        Content.WriteFrom(JsonRequestBody);
        Content.GetHeaders(RequestHeaders);
        RequestHeaders.Remove('Content-Type');
        RequestHeaders.Add('X-Shopify-Access-Token', ApiToken);
        RequestHeaders.Add('Content-Type', 'application/json');
        if not HttpClient.Put(ApiUrl, Content, Response) then Error('Error al realizar la solicitud a Shopify.');
        //>> BBT 19/06/2025.    Quitado porque eliminan productos de Shopify pero no los quitan de la vinculación en BC
        //                      El resultado de esto es que el error paraba la actualización de precios
        //if not Response.IsSuccessStatusCode() then Error('Error al actualizar variante: %1', Response.HttpStatusCode());
        //<<
        System.Sleep(1500);
    end;

    local procedure ImportExcelData()
    var
        RowNo: Integer;
        ColNo: Integer;
        LineNo: Integer;
        MaxRowNo: Integer;
        rlSalesPrice: Record "Sales Price";
        rlItem: Record Item;
        rlShpfyShop: Record "Shpfy Shop";
        rlShpfyProduct: Record "Shpfy Product";
        rlShpfyVariant: Record "Shpfy Variant";
        vItemNo: Text;
        vShop: Text;
        vStartingDate: Date;
        vDueDate: Date;
        vEndingDate: Date;
        vMarketPlacePrice: Decimal;
        vCustomerPrice: Decimal;
        ItemMarketPlacePrice: Decimal;
        ItemCustomerPrice: Decimal;
    begin
        RowNo := 0;
        ColNo := 0;
        MaxRowNo := 0;
        TempExcelBuffer.Reset();
        if TempExcelBuffer.FindLast() then
            MaxRowNo := TempExcelBuffer."Row No.";

        for RowNo := 2 to MaxRowNo do begin
            Evaluate(vShop, GetValueAtCell(RowNo, 1));
            Evaluate(vItemNo, GetValueAtCell(RowNo, 2));
            Evaluate(vMarketPlacePrice, GetValueAtCell(RowNo, 3));
            Evaluate(vCustomerPrice, GetValueAtCell(RowNo, 4));
            Evaluate(vStartingDate, GetValueAtCell(RowNo, 5));
            if vStartingDate = 0D then vStartingDate := WorkDate();
            Evaluate(vEndingDate, GetValueAtCell(RowNo, 6));
            if (vShop <> '') and (vItemNo <> '') and (vMarketPlacePrice <> 0) then begin
                rlItem.Reset();
                rlItem.SetRange("No.", vItemNo);
                if rlItem.FindFirst then begin
                    rlShpfyVariant.Reset();
                    rlShpfyVariant.SetRange("Shop Code", vShop);
                    rlShpfyVariant.SetRange("Item No.", vItemNo);
                    if rlShpfyVariant.Count > 1 then
                        Error('En la tienda %1 , el producto %2 está como variente en más de un producto', vShop, vItemNo);
                    if rlShpfyVariant.FindFirst() then begin
                        rlShpfyVariant.CalcFields("Item No.");
                        if rlShpfyShop.Get(rlShpfyVariant."Shop Code") then begin
                            rlshpfyShop.Validate("Customer Price Group");
                            rlshpfyShop.Validate("Default Customer No.");
                            if (vMarketPlacePrice < vCustomerPrice) then    //El precio de comparación (MarketPlace) no puede ser menor que el precio de venta (Cliente)
                                Error('El precio MarketPlace %1 no puede ser menor que el precio de venta al Cliente %2 ', rlShpfyShop."Customer Price Group", rlShpfyShop."Default Customer No.");

                            FindValidPrices(rlShpfyVariant."Shop Code", rlShpfyVariant."Item No.", ItemCustomerPrice, ItemMarketPlacePrice);
                            /*  Comprobamos precio MarketPlace  */
                            // Los precios de MarketPlace NO TIENEN PROMOCIONES
                            // Siempre "Ending Date" = 0D
                            // Si el precio de venta del MarketPlace se mantiene no cambiamos nada.
                            if ItemMarketPlacePrice <> vMarketPlacePrice then begin
                                //Si existe un precio vigente menor al nuevo, lo caducamos
                                rlSalesPrice.Reset();
                                rlSalesPrice.SetRange("Item No.", vItemNo);
                                rlSalesPrice.SetRange("Sales Type", rlSalesPrice."Sales Type"::"Customer Price Group");
                                rlSalesPrice.SetRange("Sales Code", rlShpfyShop."Customer Price Group");
                                rlSalesPrice.SetFilter("Starting Date", '<%1', vStartingDate);
                                //rlSalesPrice.SetFilter("Ending Date", '=%1', 0D);
                                if rlSalesPrice.FindSet() then
                                    repeat
                                        vDueDate := CalcDate('<-1D>', vStartingDate);
                                        rlSalesPrice.Validate("Ending Date", vDueDate);
                                        if rlSalesPrice.Modify() then;
                                    until rlSalesPrice.Next() = 0;
                                //Si existe un precio vigente mayor o igual al nuevo lo eliminamos
                                rlSalesPrice.Reset();
                                rlSalesPrice.SetRange("Item No.", vItemNo);
                                rlSalesPrice.SetRange("Sales Type", rlSalesPrice."Sales Type"::"Customer Price Group");
                                rlSalesPrice.SetRange("Sales Code", rlShpfyShop."Customer Price Group");
                                rlSalesPrice.SetFilter("Starting Date", '>=%1', vStartingDate);
                                //rlSalesPrice.SetFilter("Ending Date", '=%1', 0D);
                                if rlSalesPrice.FindSet() then
                                    repeat
                                        if rlSalesPrice.Delete() then;
                                    until rlSalesPrice.Next() = 0;
                                //Se crea el nuevo registro 
                                Clear(rlSalesPrice);
                                rlSalesPrice.Init();
                                rlSalesPrice.Validate("Item No.", vItemNo);
                                rlSalesPrice.Validate("Sales Type", rlSalesPrice."Sales Type"::"Customer Price Group");
                                rlSalesPrice.Validate("Sales Code", rlShpfyShop."Customer Price Group");
                                rlSalesPrice.Validate("Starting Date", vStartingDate);
                                rlSalesPrice.Validate("Currency Code", '');
                                rlSalesPrice.Validate("Variant Code", '');
                                rlSalesPrice.Validate("Unit of Measure Code", rlItem."Base Unit of Measure");
                                rlSalesPrice.Validate("Minimum Quantity", 0);
                                rlSalesPrice.Validate("Unit Price", vMarketPlacePrice);
                                rlSalesPrice.Validate("Ending Date", 0D);
                                if rlSalesPrice.Insert(true) then;
                            end;

                            /*  Comprobamos precio Cliente  */
                            //Si existe un promoción vigente la caducamos
                            rlSalesPrice.Reset();
                            rlSalesPrice.SetRange("Item No.", vItemNo);
                            rlSalesPrice.SetRange("Sales Type", rlSalesPrice."Sales Type"::Customer);
                            rlSalesPrice.SetRange("Sales Code", rlShpfyShop."Default Customer No.");
                            rlSalesPrice.SetFilter("Starting Date", '<=%1', vStartingDate);
                            rlSalesPrice.SetFilter("Ending Date", '>=%1', vStartingDate);
                            if rlSalesPrice.FindSet() then
                                repeat
                                    if rlSalesPrice."Starting Date" = vStartingDate then begin
                                        vDueDate := CalcDate('<-1D>', vStartingDate);
                                        rlSalesPrice.Validate("Starting Date", vDueDate);
                                        rlSalesPrice.Validate("Ending Date", vDueDate);
                                        if rlSalesPrice.Modify() then;
                                    end
                                    else begin      //"Starting Date" < vStartingDate
                                        vDueDate := CalcDate('<-1D>', vStartingDate);
                                        rlSalesPrice.Validate("Ending Date", vDueDate);
                                        if rlSalesPrice.Modify() then;
                                    end;
                                until rlSalesPrice.Next() = 0;
                            //Por precaución, revisamos si hay promociones futuras a la nueva propuesta
                            //para eliminarlas
                            rlSalesPrice.Reset();
                            rlSalesPrice.SetRange("Item No.", vItemNo);
                            rlSalesPrice.SetRange("Sales Type", rlSalesPrice."Sales Type"::Customer);
                            rlSalesPrice.SetRange("Sales Code", rlShpfyShop."Default Customer No.");
                            rlSalesPrice.SetFilter("Starting Date", '>=%1', vStartingDate);
                            rlSalesPrice.SetFilter("Ending Date", '>=%1', vStartingDate);
                            if rlSalesPrice.FindSet() then
                                repeat
                                    repeat
                                        if rlSalesPrice.Delete() then;
                                    until rlSalesPrice.Next() = 0;
                                until rlSalesPrice.Next() = 0;
                            //Si existe un precio vigente con fecha menor al nuevo sin caducidad, lo caducamos
                            rlSalesPrice.Reset();
                            rlSalesPrice.SetRange("Item No.", vItemNo);
                            rlSalesPrice.SetRange("Sales Type", rlSalesPrice."Sales Type"::Customer);
                            rlSalesPrice.SetRange("Sales Code", rlShpfyShop."Default Customer No.");
                            rlSalesPrice.SetFilter("Starting Date", '<%1', vStartingDate);
                            rlSalesPrice.SetFilter("Ending Date", '=%1', 0D);
                            if rlSalesPrice.FindSet() then
                                repeat
                                    vDueDate := CalcDate('<-1D>', vStartingDate);
                                    rlSalesPrice.Validate("Ending Date", vDueDate);
                                    if rlSalesPrice.Modify() then;
                                until rlSalesPrice.Next() = 0;

                            //Si existe un precio vigente con fecha mayor o igual al nuevo lo eliminamos
                            rlSalesPrice.Reset();
                            rlSalesPrice.SetRange("Item No.", vItemNo);
                            rlSalesPrice.SetRange("Sales Type", rlSalesPrice."Sales Type"::Customer);
                            rlSalesPrice.SetRange("Sales Code", rlShpfyShop."Default Customer No.");
                            rlSalesPrice.SetFilter("Starting Date", '>=%1', vStartingDate);
                            rlSalesPrice.SetFilter("Ending Date", '=%1', 0D);
                            if rlSalesPrice.FindSet() then
                                repeat
                                    if rlSalesPrice.Delete() then;
                                until rlSalesPrice.Next() = 0;

                            //Se crea el nuevo registro 
                            Clear(rlSalesPrice);
                            rlSalesPrice.Init();
                            rlSalesPrice.Validate("Item No.", vItemNo);
                            rlSalesPrice.Validate("Sales Type", rlSalesPrice."Sales Type"::Customer);
                            rlSalesPrice.Validate("Sales Code", rlShpfyShop."Default Customer No.");
                            rlSalesPrice.Validate("Starting Date", vStartingDate);
                            rlSalesPrice.Validate("Currency Code", '');
                            rlSalesPrice.Validate("Variant Code", '');
                            rlSalesPrice.Validate("Unit of Measure Code", rlItem."Base Unit of Measure");
                            rlSalesPrice.Validate("Minimum Quantity", 0);
                            rlSalesPrice.Validate("Unit Price", vCustomerPrice);
                            rlSalesPrice.Validate("Ending Date", vEndingDate);
                            if rlSalesPrice.Insert(true) then;
                            //Añadimos la recuperación del precio vigente si se trata de una promoción.
                            if vEndingDate <> 0D then begin
                                vDueDate := CalcDate('<+1D>', vEndingDate);
                                Clear(rlSalesPrice);
                                rlSalesPrice.Init();
                                rlSalesPrice.Validate("Item No.", vItemNo);
                                rlSalesPrice.Validate("Sales Type", rlSalesPrice."Sales Type"::Customer);
                                rlSalesPrice.Validate("Sales Code", rlShpfyShop."Default Customer No.");
                                rlSalesPrice.Validate("Starting Date", vDueDate);
                                rlSalesPrice.Validate("Ending Date", 0D);
                                rlSalesPrice.Validate("Currency Code", '');
                                rlSalesPrice.Validate("Variant Code", '');
                                rlSalesPrice.Validate("Unit of Measure Code", rlItem."Base Unit of Measure");
                                rlSalesPrice.Validate("Minimum Quantity", 0);
                                rlSalesPrice.Validate("Unit Price", ItemCustomerPrice);    //Precio vigente anterior a la actualización
                                if rlSalesPrice.Insert(true) then;
                            end;

                            FindValidPrices(rlShpfyVariant."Shop Code", rlShpfyVariant."Item No.", ItemCustomerPrice, ItemMarketPlacePrice);
                            if (ItemCustomerPrice <> 0) and (ItemMarketPlacePrice <> 0) then begin
                                UpdShpfyVariantPrice(rlShpfyVariant, ItemCustomerPrice, ItemMarketPlacePrice);
                                UpdShpfyWebPrice(rlShpfyShop, rlShpfyVariant);
                            end;

                        end;
                    end;
                end;
            end;
        end;
        Message(ExcelImportSucess);
    end;

    local procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    begin
        TempExcelBuffer.Reset();
        If TempExcelBuffer.Get(RowNo, ColNo) then
            exit(TempExcelBuffer."Cell Value as Text")
        else
            exit('');
    end;

    procedure BBTReadExcelSheet()
    var
        FileMgt: Codeunit "File Management";
        IStream: InStream;
        FromFile: Text[100];
    begin
        UploadIntoStream(UploadExcelMsg, '', '', FromFile, IStream);
        if FromFile <> '' then begin
            FileName := FileMgt.GetFileName(FromFile);
            SheetName := TempExcelBuffer.SelectSheetsNameStream(IStream);
            TempExcelBuffer.Reset();
            TempExcelBuffer.DeleteAll();
            TempExcelBuffer.OpenBookStream(IStream, SheetName);
            TempExcelBuffer.ReadSheet();
            ImportExcelData();
        end
        else
            Error(NoFileFoundMsg);
    end;

    var
        BatchName: Code[10];
        FileName: Text[100];
        SheetName: Text[100];
        TempExcelBuffer: Record "Excel Buffer" temporary;
        UploadExcelMsg: Label 'Please Choose the Excel file', Comment = 'ESP="Seleccione el archivo de Excel"';
        NoFileFoundMsg: Label 'No Excel file found', Comment = 'ESP="No se encontró ningún archivo de Excel"';
        BatchISBlankMsg: Label 'Batch name is blank', Comment = 'ESP="El nombre está en blanco"';
        ExcelImportSucess: Label 'Excel is successfully imported', Comment = 'ESP="El archivo se importó correctamente"';

}
