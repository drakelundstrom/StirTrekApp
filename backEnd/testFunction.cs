using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Microsoft.Azure.Cosmos;
using System.Text.Json;
using System.Collections.Generic;

namespace Company.Function
{
    public static class CreateContactsForCountries
    {
        [FunctionName("testFunction")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", Route = "test")] HttpRequest req,
            ILogger log)
        {
       // get secrets to access cosmos db and set up cosmos db client
            var cosmosConnectionString = Environment.GetEnvironmentVariable("databaseConnectionString");
            var cosmos = new CosmosClient(cosmosConnectionString);
            var emailsContainer = cosmos.GetContainer("EmailForwarding", "ContactInfoAndRequests");
            try
            {
                // Get the contacts for the district.  Resturn 404 if none are found.
                var query = new QueryDefinition("SELECT TOP 1 * FROM c WHERE c.Type='Message'");
                var messages = await emailsContainer.GetItemQueryIterator<Message>(query).ReadNextAsync();
                if (messages.Count == 0)
                {
                    return new NotFoundResult();
                } 
                return new OkObjectResult(messages);
            }
            catch (Exception e)
            {
                return new StatusCodeResult(500);
            }
        }
    }

    public class Message {
        public string text { get; set; }
    }
    
}
