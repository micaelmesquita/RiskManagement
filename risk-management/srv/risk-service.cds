using { riskmanagement as rm } from '../db/schema';

@path: 'service/risk' //Local onde ficará exposto o serviço
service RiskService {
    //entity Risks as projection on rm.Risks;
    entity Risks @(restrict: [
        {
            grant: ['READ'],
            to: ['RViewer']
        },
        {
            grant: ['*'],
            to: ['RManager']
        }
    ]) as projection on rm.Risks;
        annotate Risks with @odata.draft.enabled; //rascunhos
    //entity Mitigations as projection on rm.Mitigations;
    entity Mitigations @(restrict: [
        {
            grant: ['READ'],
            to: ['RViewer']
        },
        {
            grant: ['*'],
            to: ['RManager']
        }
    ]) as projection on rm.Mitigations;
        annotate Mitigations with @odata.draft.enabled;
    entity BusinessPartners as projection on rm.BusinessPartners;
}