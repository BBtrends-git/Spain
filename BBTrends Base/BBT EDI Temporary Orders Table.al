Table 50015 "EDI - Temporary Orders"
{
    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(100; Type; Text[6])
        { }
        field(101; "RECTL TipodeMensaje"; Text[6])
        { }
        field(102; "RECTL CodigoEmisor"; Text[35])
        { }
        field(103; "RECTL CodigoReceptor"; Text[35])
        { }
        field(104; "RECTL IdentificacionMensaje"; Text[40])
        { }
        field(105; "RECTL FechaHoraMensaje"; DateTime)
        { }
        field(200; "ERE1C TipoDocumento"; Text[3])
        { }
        field(201; "ERE1C NumeroPedido"; Text[17])
        { }
        field(202; "ERE1C FuncionMensaje"; Text[3])
        { }
        field(203; "ERE1C FechaHoraDocumento"; DateTime)
        { }
        field(204; "ERE1C CalificadorFechaHora1"; Text[3])
        { }
        field(205; "ERE1C FechaHora1"; DateTime)
        { }
        field(206; "ERE1C CalificadorFechaHora2"; Text[3])
        { }
        field(207; "ERE1C FechaHora2"; DateTime)
        { }
        field(208; "ERE1C InformacionAdicional"; Text[3])
        { }
        field(209; "ERE1C NumeroPedidoAbierto"; Text[17])
        { }
        field(210; "ERE1C NumeroListaPrecios"; Text[17])
        { }
        field(211; "ERE1C NumeroPedidoProveedor"; Text[17])
        { }
        field(212; "ERE1C CalificadorReferenciaAdi"; Text[3])
        { }
        field(213; "ERE1C NumeroReferenciaAdi"; Text[17])
        { }
        field(214; "ERE1C CodigoMoneda"; Text[3])
        { }
        field(215; "ERE1C FechaVencimientoUnico"; Date)
        { }
        field(216; "ERE1C MetodoPagoCostesTransp"; Text[3])
        { }
        field(217; "ERE1C CondicionesEntrega"; Text[3])
        { }
        field(218; "ERE1C ImporteTotalNeto"; Decimal)
        { }
        field(219; "ERE1C ImporteTotalDtosCargos"; Decimal)
        { }
        field(220; "ERE1C BaseImponible"; Decimal)
        { }
        field(221; "ERE1C ImporteTotalImpuestos"; Decimal)
        { }
        field(222; "ERE1C ImporteAPagar"; Decimal)
        { }
        field(223; "ERE1C ImporteTotalBruto"; Decimal)
        { }
        field(224; "ERE1C ExpedienteDeContratSAS"; Text[17])
        { }
        field(300; "ERE1T CalificadorTemaTexto"; Text[6])
        { }
        field(301; "ERE1T Texto1"; Text[70])
        { }
        field(302; "ERE1T Texto2"; Text[70])
        { }
        field(303; "ERE1T Texto3"; Text[70])
        { }
        field(304; "ERE1T Texto4"; Text[70])
        { }
        field(305; "ERE1T Texto5"; Text[70])
        { }
        field(400; "ERE1V CalificadorDelInterl"; Text[3])
        { }
        field(401; "ERE1V CodigoInterlocutor"; Text[17])
        { }
        field(402; "ERE1V AgenciaResponsableLista"; Text[3])
        { }
        field(403; "ERE1V Nombre1"; Text[35])
        { }
        field(404; "ERE1V Nombre2"; Text[35])
        { }
        field(405; "ERE1V Nombre3"; Text[35])
        { }
        field(406; "ERE1V Nombre4"; Text[35])
        { }
        field(407; "ERE1V Nombre5"; Text[35])
        { }
        field(408; "ERE1V CalleNumero1"; Text[35])
        { }
        field(409; "ERE1V CalleNumero2"; Text[35])
        { }
        field(410; "ERE1V CalleNumero3"; Text[35])
        { }
        field(411; "ERE1V CalleNumero4"; Text[35])
        { }
        field(412; "ERE1V Poblacion"; Text[35])
        { }
        field(413; "ERE1V Provincia"; Text[9])
        { }
        field(414; "ERE1V CodigoPostal"; Text[9])
        { }
        field(415; "ERE1V CodigoPais"; Text[3])
        { }
        field(416; "ERE1V CalificadorReferencia1"; Text[3])
        { }
        field(417; "ERE1V Referencia1"; Text[35])
        { }
        field(418; "ERE1V FuncionContacto"; Text[3])
        { }
        field(419; "ERE1V DepartIdentEmpl"; Text[17])
        { }
        field(420; "ERE1V DepartamentoOEmpleado"; Text[35])
        { }
        field(421; "ERE1V CalificadorReferencia2"; Text[3])
        { }
        field(422; "ERE1V Referencia2"; Text[17])
        { }
        field(500; "ERE1I NumeroLineaImpuesto"; Integer)
        { }
        field(501; "ERE1I CalificadorTipoImpuesto"; Text[6])
        { }
        field(502; "ERE1I PorImpuesto"; Decimal)
        { }
        field(503; "ERE1I ImporteImpuesto"; Decimal)
        { }
        field(504; "ERE1I BaseImponible"; Decimal)
        { }
        field(600; "ERE1V ContadorVencimiento"; Integer)
        { }
        field(601; "ERE1V ReferenciaTiempoPagoCod"; Text[3])
        { }
        field(602; "ERE1V RelacionTiempoCodificado"; Text[3])
        { }
        field(603; "ERE1V TipoPeriodoCodificado"; Text[3])
        { }
        field(604; "ERE1V NumeroPeriodos"; Integer)
        { }
        field(605; "ERE1V FechaVencimiento"; Date)
        { }
        field(606; "ERE1V ImporteVencimiento"; Decimal)
        { }
        field(700; "ERE1L NumeroLineaArticulo"; Integer)
        { }
        field(701; "ERE1L CodigoEAN13DUN14Articulo"; Text[15])
        { }
        field(702; "ERE1L TipoCodigoArticulo"; Text[3])
        { }
        field(703; "ERE1L TipoIdentificacionArt"; Text[17])
        { }
        field(704; "ERE1L Descripcion1Articulo"; Text[70])
        { }
        field(705; "ERE1L Descripcion2Articulo"; Text[70])
        { }
        field(706; "ERE1L TipoArticulo"; Text[1])
        { }
        field(707; "ERE1L NumeroArticuloProveedor"; Text[35])
        { }
        field(708; "ERE1L NumeroArticuloComprador"; Text[35])
        { }
        field(709; "ERE1L VariablePromocional"; Text[35])
        { }
        field(710; "ERE1L CodigoEANDelArticuloAdic"; Text[35])
        { }
        field(711; "ERE1L CantidadPedida"; Decimal)
        { }
        field(712; "ERE1L CantidadBonificada"; Decimal)
        { }
        field(713; "ERE1L CalificadorUnidadMedida"; Text[6])
        { }
        field(714; "ERE1L NumeroUnidDeConsEnUExped"; Decimal)
        {
            Description = 'NumeroUnidDeConsEnUExped';
        }
        field(715; "ERE1L CalificadorFechaHora1"; Text[30])
        { }
        field(716; "ERE1L FechaHora1"; DateTime)
        { }
        field(717; "ERE1L CalificadorFechaHora2"; Text[30])
        { }
        field(718; "ERE1L FechaHora2"; DateTime)
        { }
        field(719; "ERE1L ImporteNetoLinea"; Decimal)
        { }
        field(720; "ERE1L PrecioBrutoUnitario"; Decimal)
        { }
        field(721; "ERE1L PrecioNetoUnitario"; Decimal)
        { }
        field(722; "ERE1L PrecioATituloInformativo"; Decimal)
        { }
        field(723; "ERE1L CalifiUDeMedidaPrecio"; Text[6])
        {
            Description = 'CalifiUDeMedidaPrecio';
        }
        field(724; "ERE1L CalificadorIVAIGIC"; Text[6])
        { }
        field(725; "ERE1L PorcentajeIVAIGIC"; Decimal)
        { }
        field(726; "ERE1L ImporteIVAIGIC"; Decimal)
        { }
        field(727; "ERE1L PorRecargoEquivalencia"; Decimal)
        { }
        field(728; "ERE1L ImporteRecargoEquiv"; Decimal)
        { }
        field(729; "ERE1L CalificadorOtroTipoDeImp"; Text[6])
        { }
        field(730; "ERE1L PorOtroTipoDeImpuesto"; Decimal)
        { }
        field(731; "ERE1L ImporteOtroTipoDeImp"; Decimal)
        { }
        field(732; "ERE1L PesoNeto"; Decimal)
        { }
        field(733; "ERE1L CalificadorUDeMedidaPeso"; Text[6])
        {
            Description = 'CalificadorUDeMedidaPeso';
        }
        field(734; "ERE1L DescripcionDelModelo"; Text[25])
        { }
        field(735; "ERE1L Color"; Text[25])
        { }
        field(736; "ERE1L AnchuraOTalla"; Text[25])
        { }
        field(737; "ERE1L PresentacionCantidadForm"; Text[25])
        {
            Description = 'PresentacionCantidadForm';
        }
        field(738; "ERE1L CodigoGrupoArticuloCompr"; Text[35])
        {
            Description = 'CodigoGrupoArticuloCompr';
        }
        field(739; "ERE1L NumeroSerieArticulo"; Text[35])
        { }
        field(740; "ERE1L NumeroArticuloFabricante"; Text[35])
        { }
        field(741; "ERE1L NumeroLote"; Text[35])
        { }
        field(742; "ERE1L CalificadorFechaHora3"; Text[3])
        { }
        field(743; "ERE1L FechaHora3"; DateTime)
        { }
        field(744; "ERE1L ImporteLíneaConImpuestos"; Decimal)
        { }
        field(745; "ERE1L BasePrecioNetoUnitario"; Integer)
        { }
        field(746; "ERE1L PrecioArticuloConImp"; Decimal)
        {
            Description = 'recioArticuloConImp';
        }
        field(747; "ERE1L BasePrecioArticuloConImp"; Integer)
        {
            Description = 'BasePrecioArticuloConImp';
        }
        field(748; "ERE1L NumeroAlbaran"; Text[17])
        { }
        field(749; "ERE1L FechaAlbaran"; Date)
        { }
        field(750; "ERE1L CodigoClienteFinal"; Text[17])
        { }
        field(751; "ERE1L NombreClienteFinal"; Text[70])
        { }
        field(752; "ERE1L DireccionClienteFinal"; Text[70])
        {
        }
        field(753; "ERE1L PoblacionClienteFinal"; Text[35])
        { }
        field(754; "ERE1L CodigoPostalClienteFinal"; Text[9])
        { }
        field(755; "ERE1L IdentificadorProdLinPed"; Text[15])
        {
            Description = 'IdentificadorProdLinPed';
        }
        field(800; "ERE1P CalificadorDelInterloc"; Text[3])
        { }
        field(801; "ERE1P CodigoInterlocutor"; Text[17])
        { }
        field(802; "ERE1P AgenciaResponsableListaC"; Text[3])
        { }
        field(803; "ERE1P Nombre1"; Text[35])
        { }
        field(804; "ERE1P Nombre2"; Text[35])
        { }
        field(805; "ERE1P Nombre3"; Text[35])
        { }
        field(806; "ERE1P Nombre4"; Text[35])
        { }
        field(807; "ERE1P CalleNumero1"; Text[35])
        { }
        field(808; "ERE1P CalleNumero2"; Text[35])
        { }
        field(809; "ERE1P CalleNumero3"; Text[35])
        { }
        field(810; "ERE1P CalleNumero4"; Text[35])
        { }
        field(811; "ERE1P Poblacion"; Text[35])
        { }
        field(812; "ERE1P Provincia"; Text[9])
        { }
        field(813; "ERE1P CodigoPostal"; Text[9])
        { }
        field(814; "ERE1P CodigoPais"; Text[3])
        { }
        field(815; "ERE1P CalificadorReferencia1"; Text[3])
        { }
        field(816; "ERE1P Referencia1"; Text[35])
        { }
        field(817; "ERE1P FuncionContacto"; Text[3])
        { }
        field(818; "ERE1P DepartamentoOIdentific"; Text[17])
        { }
        field(819; "ERE1P DepartamentoOEmpleado"; Text[35])
        { }
        field(820; "ERE1P CalificadorReferencia2"; Text[3])
        { }
        field(821; "ERE1P Referencia2"; Text[17])
        { }
        field(822; "ERE1P Nombre5"; Text[35])
        { }
        field(900; "ERE1E NumeroDescuentoCargo"; Integer)
        { }
        field(901; "ERE1E IndicadorDescuentoCargo"; Text[1])
        { }
        field(902; "ERE1E IndicadorSecuenciaCalcul"; Text[3])
        { }
        field(903; "ERE1E TipoDescuentoCargo"; Text[3])
        { }
        field(904; "ERE1E DescripcionDescuentoCarg"; Text[70])
        { }
        field(905; "ERE1E PorcentajeDescuentoCargo"; Decimal)
        { }
        field(906; "ERE1E ImporteDescuentoCargo"; Decimal)
        { }
        field(907; "ERE1E ImporteTotalSujetoAAplic"; Decimal)
        { }
        field(908; "ERE1E DtoMonetariosPorUnidad"; Decimal)
        { }
        field(909; "ERE1E UnidadMedida"; Text[6])
        { }
        field(910; "ERE1E CantidadDescuentoCargo"; Decimal)
        { }
        field(918; "SINCC Mododepago"; Text[6])
        { }
        field(919; "SINCC RazonDeCargoOAbono"; Text[3])
        { }
        field(920; "SINCC CriterioDeModificacion"; Text[3])
        { }
        field(921; "SINCC NumeroDePedido"; Text[17])
        { }
        field(922; "SINCC NumeroDeAlbaran"; Text[17])
        { }
        field(923; "SINCC CalificadorDocRectificad"; Text[3])
        { }
        field(924; "SINCC DocumentoRectificado"; Text[17])
        { }
        field(925; "SINCC NumeroDeContratoAcuerdoC"; Text[17])
        { }
        field(926; "SINCC NumeroRelacionEntrega"; Text[17])
        { }
        field(927; "SINCC SubvencionesVinculadasAl"; Decimal)
        { }
        field(928; "SINCC TotalIncrementosDelImpor"; Decimal)
        { }
        field(929; "SINCC TotalMinoracionesDelImpo"; Decimal)
        { }
        field(930; "SINCC PeriodoImposicionesFactu"; Decimal)
        { }
        field(931; "SINCC FechaPedido"; Date)
        { }
        field(932; "SINCC FechaHoraEfectivaDelServ"; DateTime)
        { }
        field(933; "SINCC NumeroConfirmacionEntreg"; Text[17])
        { }
        field(934; "SINCC NumeroFacturaRefAmpliada"; Text[35])
        { }
        field(935; "SINCC ImporteRetenido"; Decimal)
        { }
        field(1000; "SINCP TipoInterlocutor"; Text[3])
        { }
        field(1001; "SINCP NumeroDeIdentificacionFi"; Text[35])
        { }
        field(1002; "SINCP CodigoAdicional"; Text[35])
        { }
        field(1003; "SINCP Telefono"; Text[35])
        { }
        field(1004; "SINCP Fax"; Text[35])
        { }
        field(1005; "SINCP NumeroCuentaIBAN"; Text[35])
        { }
        field(1006; "SINCP RegistroMercantilEmisor"; Text[70])
        { }
        field(1007; "SINCP CapitalSocial"; Text[35])
        { }
        field(51146; "ERE1L CantidadDevuelta"; Decimal)
        { }
    }
    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }
}
