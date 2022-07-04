using { sap.ui.riskmanagement as db } from '../db/schema';

@path: 'service/risk' //diz ao CAP para expôr o serviço no URL na pasta servive/risks
 service RiskService {
    entity Risks as projection on db.Risks;
       annotate Risks with @odata.draft.enabled;
    entity Mitigations as projection on db.Mitigations;
       annotate Mitigations with @odata.draft.enabled; 
 }