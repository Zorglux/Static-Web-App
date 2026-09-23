const { CosmosClient } = require("@azure/cosmos");

// La chaîne de connexion sera lue depuis la configuration Azure
const endpoint = process.env.COSMOS_DB_ENDPOINT;
const key = process.env.COSMOS_DB_KEY;

const client = new CosmosClient({ endpoint, key });

module.exports = async function (context, req) {
    try {
        const database = client.database("database-static-app");
        const container = database.container("Counter");

        // Récupérer le document du compteur (ou le créer s'il n'existe pas)
        let { resource: item } = await container.item("vistors", "vistors").read().catch(() => ({ resource: null }));

        if (!item) {
            item = { id: "vistors", count: 1 };
            await container.items.create(item);
        } else {
            item.count += 1;
            await container.item("vistors", "vistors").replace(item);
        }

        context.res = {
            status: 200,
            headers: { "Content-Type": "application/json" },
            body: { count: item.count }
        };
    } catch (error) {
        context.res = {
            status: 500,
            body: `Erreur serveur: ${error.message}`
        };
    }
};