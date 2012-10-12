public with sharing class RecentItem { 
    public String URL {get;set;}
    private String RecordID ='';
    private integer NoPerUser =0;
    public List<RecentItem__c> RIList=new List<RecentItem__c>();
    public String myname {get;set;}
    public String FilterID{get;set;}
    public String ShowFilter{get;set;}
    public List<String> ObjectNameList=new List<String>();
    private set<string> ObjectNameMap =new Set<String>{};
    private boolean IsRecentItemOrFilterRecord;
    
    public List<RecentItem__c> getRIList(){
        return RIList;
    }
    
    public List<String> getObjectNameList(){
        return ObjectNameList;
    }
    
     public class myrecentitems {
        
        public String ObjectName {get;set;}
        public String RecordName {get;set;}
        public String RecordLink {get;set;}
        public String RecordID {get;set;}
         
        
        public myrecentitems(string s1,string s2,string s3,string s4){

            ObjectName=s1;
            RecordName = s2;
            RecordLink = s3;
            RecordID= s4;
        }
        
    }
    
    public List<myrecentitems> myrecentitemsList=new List<myrecentitems>();
    
    public List<myrecentitems> getmyrecentitemsList(){
        return myrecentitemsList;
    }
    
    

    public RecentItem(){
        URL=ApexPages.currentPage().getHeaders().get('Referer');
        NoPerUser=200;
        IsRecentItemOrFilterRecord=false;
        //ShowFilter=ApexPages.currentPage().getParameters().get('ShowFilter');
        
        //check if the current user has customized setting
        List<RecentItemFilter__c> aFilter=[select No_Of_Displayed_Items__c,Objects_List__c from RecentItemFilter__c where createdbyid=:userinfo.getUserId()];
        if(aFilter.size()>0){
            if(aFilter[0].No_Of_Displayed_Items__c==null && aFilter[0].Objects_List__c==null){
                RIList=[select link__c,object__c,record_name__c from RecentItem__c where user__c=:userinfo.getUserId() order by name desc limit: NoPerUser];
            }
            if(aFilter[0].No_Of_Displayed_Items__c!=null && aFilter[0].Objects_List__c==null){
                RIList=[select link__c,object__c,record_name__c from RecentItem__c where user__c=:userinfo.getUserId() order by name desc limit: aFilter[0].No_Of_Displayed_Items__c.intValue()];
            }
            if(aFilter[0].No_Of_Displayed_Items__c!=null && aFilter[0].Objects_List__c!=null){
                RunCustomizedFilter(aFilter[0].No_Of_Displayed_Items__c.intValue(),aFilter[0].Objects_List__c);
            }
            if(aFilter[0].No_Of_Displayed_Items__c==null && aFilter[0].Objects_List__c!=null){
                RunCustomizedFilter(NoPerUser,aFilter[0].Objects_List__c);
            }
            
        }
        if(aFilter.size()==0){
            RIList=[select link__c,object__c,record_name__c from RecentItem__c where user__c=:userinfo.getUserId() order by name desc limit: NoPerUser];
        }
        
        
        
        myname='Record Name';
        if(RIList.size()>0){
            PopulateTreeView();
        }
        
        Integer mycounter=[select count() from RecentItemFilter__c where CreatedById=:userinfo.getUserId()];
        FilterID='recentitemsfilter';
        if(mycounter>0){
            RecentItemFilter__c filterlinkid=[select id from RecentItemFilter__c where CreatedById=:userinfo.getUserId()];
            FilterID=FilterID+'?id='+filterlinkid.id;
        }

    }
    
    public void RunCustomizedFilter(Integer NoOfDisplay,String ObjectList){
        List<String> myObjectList=ObjectList.split(';');
        RIList=[select link__c,object__c,record_name__c from RecentItem__c where user__c=:userinfo.getUserId() and object__c in: myObjectList order by name desc limit: NoOfDisplay];
    }
    
    public void PopulateTreeView(){
        for(RecentItem__c anitem:RIList){
                 if(!ObjectNameMap.contains(anitem.object__c)){
                      ObjectNameMap.add(anitem.object__c);
                      ObjectNameList.add(anitem.object__c);
                      //system.debug('ObjectNameList.add:'+anitem.object__c);
                      //system.debug(ObjectNameList.size());
                  }
                  myrecentitems item = new myrecentitems(anitem.object__c,anitem.record_name__c,anitem.Link__c,anitem.Id);
                  myrecentitemsList.add(item);
        }
    }
    
    private void GenerateRecordID(){
                
                //capture ideas
                if(URl.contains('ideas/viewIdea.apexp?id=')){
                      RecordID=URL.substring(URl.indexof('=')+1, url.length());
                }
                else{
                    RecordID=url.replace('//','');
                    RecordID=RecordID.substring(RecordID.indexof('/')+1, RecordID.length());
                    
                    if(RecordID.contains('/')){
                         RecordID=RecordID.substring(0, RecordID.indexof('/'));
                    }
                    //capture the URL like https://ap1.salesforce.com/00U90000001MIei?retURL=%2F00190000002aGJI
                    else  if(RecordID.contains('?')){
                         RecordID=RecordID.substring(0, RecordID.indexof('?'));
                    }
                }

    }
    
    public void GetRecentItem(){
        
        GenerateRecordID();
        
        /* if(ApexPages.currentPage().getParameters().get('OrgID')!=null){
           if(cryp(ApexPages.currentPage().getParameters().get('OrgID'))){
            //system.debug('paied version');
        */   
            //system.debug('RecordID:'+RecordID);
                if(RecordID.length()==15 || RecordID.Length()==18){
         
                    CreateNewRecord();
               }
           /* 
           }
         */  
           //test version
           /*
           else {
            //system.debug('test version');
                
                if(RecordID.length()==15 || RecordID.Length()==18){
                    //for test verion, total 9 records for all users
                    integer RecordCounter=[select count() from RecentItem__c];
                    if(RecordCounter<=60){
                        //system.debug('test TestCreateNewRecord');
                        TestCreateNewRecord();
                    }

                }

           }
           
         }
         */
}
 
    private void CreateNewRecord(){
        /* integer Noofuser=[select count() from RecentItem__c where user__c=:userinfo.getUserId() ]; */
        /* if(Noofuser<=NoPerUser-1){ */
            //has not accessed the record before, create new
            integer counter=[select count() from RecentItem__c where recordid__c=:RecordID and OwnerId=:userinfo.getUserId() ];
            String objectname=ReturnObjectLabelByRecordID(RecordID);
            if(counter<=0){
                if(!IsRecentItemOrFilterRecord){
                    RecentItem__c aRecord=new RecentItem__c(no_of_access__c=1,user__c=userinfo.getUserId(),recordid__c=RecordID,link__c=url,object__c=objectname, Record_Name__c=myname);
                    insert aRecord;
                }

            }
            //has accessed the record before, add the counter
            else{
                RecentItem__c myRecentItem=[select No_Of_Access__c,Record_Name__c from RecentItem__c where recordid__c=:RecordID and OwnerId=:userinfo.getUserId()];
                
                if(myRecentItem.No_Of_Access__c==null){
                        myRecentItem.No_Of_Access__c=1;
                        //update record name
                        myRecentItem.Record_Name__c=myname;
                        update myRecentItem;
                }
                else{
                   myRecentItem.No_Of_Access__c=myRecentItem.No_Of_Access__c+1;
                    //update record name
                   myRecentItem.Record_Name__c=myname;
                        update myRecentItem;
                }

            }
            
       /* }  */
            //max no of record per user reached
            //start replace the oldest record
            
            /*
         else{
                RecycleNewRecord();
         }
         */
    }
    /*
    private void RecycleNewRecord(){
        
        integer counter=[select count() from RecentItem__c where recordid__c=:RecordID ];
        if(counter<=0){
             RecentItem__c OldRecord=[select id from RecentItem__c where user__c=:userinfo.getUserId() order by name limit 1];
             delete OldRecord;
             
             RecentItem__c newRecord=new RecentItem__c(user__c=userinfo.getUserId(),recordid__c=RecordID,link__c=url,object__c=ReturnObjectLabelByRecordID(RecordID), Record_Name__c=myname);
             insert newRecord;
             
             //system.debug('RecycleNewRecord');
        }
        
    }
    
    
    
    private void TestCreateNewRecord(){
        
        integer Noofuser=[select count() from RecentItem__c where user__c=:userinfo.getUserId() ];
        //test version, max 3 records per user
        if(Noofuser<=17){
            //***
            integer counter=[select count() from RecentItem__c where recordid__c=:RecordID ];
            if(counter<=0){
                RecentItem__c aRecord=new RecentItem__c(user__c=userinfo.getUserId(),recordid__c=RecordID,link__c=url,object__c=ReturnObjectLabelByRecordID(RecordID), Record_Name__c=myname);
                insert aRecord;
            }
        }
        else{
            RecycleNewRecord();
        }
        
    }
    */
    
    public String ReturnObjectLabelByRecordID(String RecordID){
        String Label='N/A';
    
        String Prefix=RecordID.substring(0,3);
        
        //system.debug('Prefix:'+Prefix);
        //remove 02v which is home component
        if(Prefix.equalsIgnoreCase('02V')){
            IsRecentItemOrFilterRecord=true;                  
        }
    
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        //system.debug('gd size:'+gd.size());
        for(SObjectType s:gd.values()) {
              DescribeSObjectResult r = s.getDescribe();
              

              if(r.getKeyPrefix()!=null){
                      //system.debug('r.getKeyPrefix():'+r.getKeyPrefix());
                      //system.debug('select id from '+r.getName()+' where id=\''+recordid+'\'');
                      //remove recentitem and RecentItemFilter
                      if(r.getName()!=null && r.getKeyPrefix().equals(Prefix)){
                           //system.debug('r.getName():'+r.getName());
                           
                            if(r.getName().equalsIgnoreCase('S4SRecentItems__RecentItem__c') || r.getName().equalsIgnoreCase('S4SRecentItems__RecentItemFilter__c')){
                                IsRecentItemOrFilterRecord=true;
                               
                            }
                           
                           //********
                           //manually handle following standard object cause they are not using standard name field
                           
                            //case: case number
                            //campaign member: contact, lead
                            //idea :title
                            //task: subject
                            //event: subject
                            //solution:  solutionname
                            //note: title
                            //OpportunityCompetitor: CompetitorName
                            //Contract: ContractNumber,Account.Name
                            //OpportunityLineItem: PricebookEntry.Name
                            //Approval : Parent.ContractNumber
                            //CaseComment : CommentBody 
                            //QuoteLineItem : no name, only id
                            //AccountContactRole: no name
                            //Content Delivery: can't run query on this obj
                           if(r.getName().equalsIgnoreCase('solution')){
                                solution asolutions=[select solutionname from solution where id=:recordid];
                                myname=String.valueof(asolutions.solutionname);
                               

                           }
                           
                           else if(r.getName().equalsIgnoreCase('note')){
                                note an=[select title from note where id=:recordid];
                                myname=String.valueof(an.title);
                               

                           }
                            
                           else if(r.getName().equalsIgnoreCase('task')){
                                //system.debug('find a task:'+recordid);
                                task at=[select subject from task where id=:recordid];
                                myname=String.valueof(at.subject);
                               

                           }
                           
                           else if(r.getName().equalsIgnoreCase('event')){
                               //system.debug('find an event:'+recordid);
                                event ae=[select subject from event where id=:recordid];
                                myname=String.valueof(ae.subject);
                               

                           }
                           
                           else if(r.getName().equalsIgnoreCase('idea')){
                                idea anidea=[select title from idea where id=:recordid];
                                myname=String.valueof(anidea.title);
                               

                           }
                           
                           else if(r.getName().equalsIgnoreCase('Case')){
                                case acase=[select casenumber from case where id=:recordid];
                                myname=String.valueof(acase.casenumber);
                               

                           }
                           
                           else if(r.getName().equalsIgnoreCase('OpportunityCompetitor')){
                                OpportunityCompetitor Competitor=[select CompetitorName from OpportunityCompetitor where id=:recordid];
                                 myname=String.valueof(Competitor.CompetitorName);
                                

                           }
                           
                           else if(r.getName().equalsIgnoreCase('OpportunityLineItem')){
                                OpportunityLineItem lineitem=[Select PricebookEntry.Name From OpportunityLineItem where id=:recordid];
                                 myname=String.valueof(lineitem.PricebookEntry.Name);
                              

                           }
                           
                           else if(r.getName().equalsIgnoreCase('Approval')){
                                Approval myApproval=[Select Parent.ContractNumber From Approval where id=:recordid];
                                 myname=String.valueof(myApproval.Parent.ContractNumber);
                                

                           }
                           
                           else if(r.getName().equalsIgnoreCase('CaseComment')){
                                CaseComment myCaseComment=[Select CommentBody From CaseComment where id=:recordid];
                                if(myCaseComment.CommentBody.length()>20){
                                    myname=myCaseComment.CommentBody.substring(0,16)+'...';
                                   
                                }
                                else{
                                    myname=myCaseComment.CommentBody;
                                 
                                }
                           }
                           
                           else if(r.getName().equalsIgnoreCase('Contract')){
                                Contract aContract=[select ContractNumber,Account.Name From Contract where id=:recordid];
                                if(aContract.ContractNumber!=null){
                                    myname=String.valueof(aContract.ContractNumber);
                                  
                                }
                                else{
                                    myname=String.valueof(aContract.Account.Name);
          
                                }
                                 

                           }
                           
                           else if(r.getName().equalsIgnoreCase('campaignmember')){
                                campaignmember amem=[select contact.firstname,contact.lastname,lead.firstname,lead.LastName from campaignmember where id=:recordid];
                                if(amem.contact.firstname!=null && amem.contact.lastname!=null){
                                    myname=String.valueof(amem.contact.firstname+' '+amem.contact.lastname);
                             
                                }
                                if(amem.lead.firstname!=null && amem.lead.lastname!=null){
                                    myname=String.valueof(amem.lead.firstname+' '+amem.lead.lastname);

                                }
                                

                           }
                           
                           else if(r.getName().equalsIgnoreCase('QuoteLineItem')){
                                QuoteLineItem qli=[select linenumber,quote.name,PricebookEntry.Name from QuoteLineItem where id=:recordid];
                               myname=String.valueof(qli.quote.name+', '+qli.PricebookEntry.Name+', '+qli.linenumber);

                           } 
                           
                           else if(r.getName().equalsIgnoreCase('AccountContactRole')){
                                AccountContactRole acr=[Select a.Role, a.Contact.Name, a.ContactId, a.Account.Name, a.AccountId From AccountContactRole a where id=:recordid];
                               myname=String.valueof(acr.Account.Name+', '+acr.Contact.Name+', '+acr.role);

                           } 
                           
                           
                           // automaticlly handle object name field
                           else {
                           
                               ////system.debug('select id from '+r.getName()+' where id=\''+recordid+'\'');
                              SObject myobj=database.query('select Name from '+r.getName()+' where id=\''+recordid+'\'');
    
                              //Object o = myobj.get('Name');
                              myname=String.valueof(myobj.get('Name'));
                              //system.debug('myname:'+myname);

                              
                                //if(myname.length()>20){
                                    //myname=myname.substring(0,17)+'...';
                                //}
                           }
                      }
                      
                      //system.debug('r.getKeyPrefix():'+r.getKeyPrefix());
                      //system.debug('Prefix:'+Prefix);
                      if(r.getKeyPrefix().equals(Prefix)){
                          Label=r.getLabel();
                          return Label;
                          break;
                      }
             }
        }
        
        //handle Content Delivery as it does not have getname()
        if(Prefix=='05D'){
        	myname=string.valueof(recordid);
        	Label='Content Delivery';
        }
        
        
        return Label;
    }
/*
    private Boolean Cryp(String OrgID){
    
        string currentorgid=UserInfo.getOrganizationId();
        currentorgid=currentorgid.substring(0,15);
        
       String algorithmName = 'HMacSHA1';
        Blob mac = Crypto.generateMac(algorithmName, Blob.valueOf(currentorgid),Blob.valueOf('%2F6SQShTfKKEd9pQMn6yBdBeHx7A%3D'));
        String macUrl = EncodingUtil.urlEncode(EncodingUtil.base64Encode(mac), 'UTF-8');
        macUrl=macUrl.replace('&', '');
        macUrl=macUrl.replace('?', '');
        macUrl=macUrl.replace('/', '');
        macUrl=macUrl.replace('%', '');
        if(macUrl.equals(OrgID)){
          return true;
        }
        else{
          return false;
        }
        
        return true;
    }
    */
}