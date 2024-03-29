const fs = require("fs");
const GlobalCatalogV1 = require("@ibm-cloud/platform-services/global-catalog/v1");

async function retrieveAll() {
  const globalCatalog = GlobalCatalogV1.newInstance({
    authenticator: {
      authenticate: () => {
        return Promise.resolve({});
      },
    },
  });

  function sleep(milliseconds) {
    return new Promise((resolve) => setTimeout(resolve, milliseconds));
  }

  async function fetchAndRetryIfNecessary(callAPIFn) {
    try {
      const response = await callAPIFn();
      return response;
    } catch (error) {
      if (error.status === 429) {
        console.log("throttle in action...");
        await sleep(30000);
        return fetchAndRetryIfNecessary(callAPIFn);
      } else if (error.status === 404) {
        console.log("no pricing for", result.message);
        throw error;
      } else {
        console.log(error);
        throw error;
      }
    }
  }

  async function populateEntries(entries) {
    for (const entry of entries) {
      console.log(entry.id);
      const children = (
        await fetchAndRetryIfNecessary(() =>
          globalCatalog.getChildObjects({
            id: entry.id,
            kind: "*",
            limit: 5000,
            complete: true,
          })
        )
      ).result.resources;

      entry["__children"] = children;

      try {
        const pricing = (
          await fetchAndRetryIfNecessary(() =>
            globalCatalog.getPricing({
              id: entry.id,
            })
          )
        ).result;
        entry.__pricing = pricing;
      } catch (err) {
        // console.log(err);
      }

      await populateEntries(entry.__children);
    }
  }

  const roots = (
    await globalCatalog.listCatalogEntries({
      complete: true,
      //LMA q: "kind:iaas kind:service",
      // Retrieve only active IBM services visible in the Console
      q: "kind:iaas kind:service active:true ui-hidden:false tag:ibm_created geo:us-south",
      limit: 5000,
    })
  ).result.resources;
  await populateEntries(roots);

  return roots;
}

function dumpPrices(parent, entries) {
  let rows = [];
  for (const entry of entries) {
    const pricing = entry.__pricing;
    if (pricing && pricing.metrics) {
      // LMA END
      if (pricing.deployment_location !== 'us-south') {
        continue
      }  
      console.log('lionel', pricing.deployment_location)
      // LMA END
      console.log(entry.id);

      const pricingColumns = {
        parent_id: parent ? parent.id : "",
        parent_name: parent ? parent.name : "",
        id: entry.id,
        name: entry.name,
        deployment_id: pricing.deployment_id,
        deployment_location: pricing.deployment_location
      };

      for (const metric of entry.__pricing.metrics) {
        const metricColumns = {
          ...pricingColumns,
          metric_id: metric.metric_id,
          metric_tier_model: metric.tier_model,
          metric_charge_unit: metric.charge_unit,
        };

        if (!metric.amounts) {
          console.error("no amounts for", entry.id, metric.metric_id);
          continue;
        }

        for (const amount of metric.amounts) {
          const amountColumns = {
            ...metricColumns,
            amount_country: amount.country,
            amount_currency: amount.currency,
          };

          for (const price of amount.prices) {
            // LMA END
            if (pricing.country !== 'USA' &&
                pricing.currency !== 'USD') {
              continue
            }  
            console.log('lionel', pricing.country)
            // LMA END

            const priceColumns = {
              ...amountColumns,
              price_quantity_tier: price.quantity_tier,
              price_price: price.price,
            };

            rows.push(priceColumns);
          }
        }
      }
    }
    if (entry.__children) {
      rows = rows.concat(dumpPrices(parent ? parent : entry, entry.__children, rows));
    }
  }
  return rows;
}

(async () => {
  // get entries
  {
    const entries = await retrieveAll();
    fs.writeFileSync(
      "../docs/generated/pricing.json",
      JSON.stringify(entries, null, 2)
    );
  }

  // export to csv
  {
    const entries = JSON.parse(
      fs.readFileSync("../docs/generated/pricing.json")
    );
    const createCsvWriter = require("csv-writer").createObjectCsvWriter;
    const csvWriter = createCsvWriter({
      path: "../docs/generated/pricing.csv",
      header: [
        { id: "parent_id", title: "Parent ID" },
        { id: "parent_name", title: "Parent Name" },
        { id: "id", title: "ID" },
        { id: "name", title: "Name" },
        { id: "deployment_id", title: "Deployment ID" },
        { id: "deployment_location", title: "Deployment Location" },
        { id: "metric_id", title: "Metric ID" },
        { id: "metric_tier_model", title: "Tier Model" },
        { id: "metric_charge_unit", title: "Charge Unit" },
        { id: "amount_country", title: "Country" },
        { id: "amount_currency", title: "Currency" },
        { id: "price_quantity_tier", title: "Quantity" },
        { id: "price_price", title: "Price" },
      ],
    });
    await csvWriter.writeRecords(dumpPrices(null, entries));
  }
})().catch((e) => {
  console.log(e);
});
