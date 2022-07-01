//Imports
const cds = require('@sap/cds');

//lógica
module.exports = cds.service.impl(async function() {
    //definir as constantes para as entidades risk e business partners
    //a partir do ficheiro risk-service.cds
    const { Risks, BusinessPartners } = this.entities;

    //Definir o criticality depois da leitura(READ)
    this.after('READ', 'Risks', (data) => {
        const risks = Array.isArray(data) ? data : [data];

        risks.forEach((risk) => {
            if (risk.impact >= 100000) {
                criticality = 1;                
            } else {
                criticality = 2;                
            }
        });
    });
    //conectar ao serviço remoto
    const BPsrv = await cds.connect.to("API_BUSINESS_PARTNER");

    //leitura da entidade Business Partner
    //Cada solicitação ao API Business Hub necessita da apikey no cabeçalho
    this.on("READ", BusinessPartners, async (req) => {
        //A API sandbox retorna muitos parceiros de negócios com nomes vazios
        //O que não queremos isto na nossa aplicação
        req.query.where("LastName <> '' and FirstName <> ''");

        return await BPsrv.transaction(req).send({
            query: req.query,
            headers: {apikey: process.env.apikey}
        });
    });

    //Envento para devolver os dados do Business Partner
    this.on("READ", Risks, async (req,next) => {
        //Verificar se a solicitação deseja uma expansão do BP. Como não é possível, a entidade Risk e BP
        //estão em sistemas diferentes (BTP e S/4). Se houver expansão remover.
        if (!req.query.SELECT.columns) {
            return next();
        }
        const expandIndex = req.query.SELECT.columns.findIndex(({expand,ref}) => expand && ref[0] === "bp");
        console.log(req.query.SELECT.columns);

        if (!req.query.SELECT.columns.find((column)=>column.ref.find((ref)=>ref === "bp_BusinessPartner"))) {
            req.query.SELECT.columns.push({ref: ["bp_BusinessPartner"]});
        }

        //Em vez de executar a expansão, emite uma solicitação separada para cada parceiro de negócios
        //Podemos otimizar o código: em vez de ter n solicitações de BP apenas temos 1 solicitação em massa
        try {
            res = await next();
            res = Array.isArray(res) ? res : [res];

            await Promise.all(res.map(
                async (risk)=>{
                    const bp = await BPsrv.transaction(req).send({
                        query: SELECT.one(this.entities.BusinessPartners)
                                    .where({BusinessPartners: risk.bp_BusinessPartner})
                                    .columns(["BusinessPartner", "LastName", "FirstName"]),
                        headers: {apikey: process.env.apikey}
                    });
                    risk.bp = bp;
                }
            ));
            
        } catch (error) {}
    });     
});