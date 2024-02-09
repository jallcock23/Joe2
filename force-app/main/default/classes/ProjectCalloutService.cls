public class ProjectCalloutService {    
    
    // Invoke Apex class from flow -- get the fields necessary and 
    @invocableMethod
    public static void postOpportunityToPMS(List<Id> OppId){             
        ID jobID = System.enqueueJob(new QueueablePMSCall(OppId));
    }
    
    public class QueueablePMSCall implements Queueable {
        
        // create constructor to add context Id
        Private List<Id> IdstoPushin;
        Public QueueablePMSCall(List<Id> OppId){
            this.IdstoPushin = OppId;
        }
        
        public void execute(QueueableContext context){
            // Call the Opps to Update Class which calls the httpRequest
            OpportunityToUpdate(IdstoPushin);

        }
    }
    
    // method to find Opportunity that gets passed
    public static string OpportunityToUpdate(List<Id> OppId){
        List<Opportunity> OppstoPost = [SELECT Id, Name, Account.Name , CloseDate, Amount FROM Opportunity WHERE ID IN:OppId];
        Map<String, Object> obj = new Map<String, Object>(); 
        For(Opportunity opp: OppstoPost){
            obj.put('opportunityId', opp.Id);
            obj.put('opportuntyName', opp.Name);
            obj.put('accountName', opp.Account.Name);
            obj.put('closeDate', opp.CloseDate);
            obj.put('amount', opp.Amount);  
        }
        // Create String to push to callout
        string JsontoPost = JSON.serialize(obj);
        CreateCallout(JsontoPost); 
        return JsontoPost;
        
    }

    // Method to create Http Callout 
    Public static void CreateCallout(String JsontoPost){
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:ProjectService/some_path');
        req.setMethod('POST');
        req.setBody(JsontoPost);
        Http http = new Http();
        HTTPResponse response = http.send(req);
        
        if(response.getStatusCode() == 200){
            // set the variable that is sent back to the Flow as submitted 
            
            
        }
    
        
    }
    
    
    
}