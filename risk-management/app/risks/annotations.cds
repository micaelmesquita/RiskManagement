using RiskService as service from '../../srv/risk-service';

//Risk List Report Page
annotate RiskService.Risks with @(UI: {
    //Cabeçalho
    HeaderInfo : {
        //$Type : 'UI.HeaderInfoType',
        TypeName : 'Risk',
        TypeNamePlural : 'Risks',
        Title: {
            $Type: 'UI.DataField',
            Value: title
        },
        Description: {
            $Type: 'UI.DataField',
            Value: descr
        }
    },
    SelectionFields : [prio], //Campos que vão ser usados para os filtros na barra de pesquisa do cabeçalho
    Identification : [{Value: title}],

    //Definir as colunas
    LineItem  : [
        {Value: title},
        {Value: miti_ID},
        {Value: owner},
        {Value: bp_BusinessPartner},
        {
            Value: prio,
            Criticality: criticality
        },
        {
            Value: impact,
            Criticality: criticality
        }
    ],
});

//Risk Object Page
annotate RiskService.Risks with @(UI: {
    
    Facets : [{
        $Type: 'UI.ReferenceFacet',
        Label: 'Main',
        Target: '@UI.FieldGroup#Main'        
    }],

    //Campos do formulário, ou seja, são os campos que aparecem no detalhe de cada linha
    FieldGroup #Main : {Data: [
        {Value: miti_ID},
        {Value: owner},
        {Value: bp_BusinessPartner},
        {
            Value: prio,
            Criticality: criticality
        },
        {
            Value: impact,
            Criticality: criticality
        }
    ]},
});
