public class TransferOwner {  
/*
    private final TransferOwner__c Cam;
    public Integer TaskCount {get;set;}
    public Integer EventCount {get;set;}
    public Integer OppoCount {get;set;}
    public String NoAction {get;set;}
    public Boolean ShowCounter{get;set;}
    public List<String> ParentEventIDList=new List<String>();
    public List<String> ParentTaskIDList=new List<String>();
 

    public TransferOwner(ApexPages.StandardController stdController){
    
        Cam=(TransferOwner__c)stdController.getRecord();
        TaskCount=0;
        EventCount=0;
        OppoCount=0; 
        NoAction='';
        ShowCounter=false;
        

        
    }
    
    //maximum two transfer owner history records
    public String StringHistroy(String OldHistory,String AppendedWord){
    	String TransferringHistory='';
    	if(OldHistory==null || OldHistory.length()==0){
    	       TransferringHistory=AppendedWord;
    	}
    	else{
	    	   If(OldHistory.indexOf('||')==OldHistory.lastIndexOf('||') && OldHistory.lastIndexOf('||')<>-1){
	           //there are two histories,then remove the first one, and append the new one
	           TransferringHistory=OldHistory.substring(OldHistory.indexOf('||')+2,OldHistory.length())+'||'+AppendedWord;
		        }
		        else if(OldHistory.length()>0){
		           //there is ONLY a history ,append the new one
		           TransferringHistory=OldHistory+'||'+AppendedWord;
		        }
    	}

        return TransferringHistory;
    }
    
public void CheckPastChildEvents(list<event> ParentEventIDList,String oldOwnerID,String NewOwnerID){
        datetime myDateTime = datetime.now();
        Datetime myStartDateTime;
            Datetime myEndDateTime;
        if(Cam.Start_Date__c <> null && Cam.End_Date__c <> null){
                myStartDateTime = datetime.newInstance(Cam.Start_Date__c.year(), Cam.Start_Date__c.month(), Cam.Start_Date__c.day(),10,00,00);
                myEndDateTime = datetime.newInstance(Cam.End_Date__c.year(), Cam.End_Date__c.month(), Cam.End_Date__c.day(),10,00,00);
            }
            
        Boolean UpdateParentOnly=false;   
        system.debug('Parent Event Id List size:'+ParentEventIDList.size()) ;
        for(event ParentEvent:ParentEventIDList){
        	//if from date is => now();
        	//then just update parent event
        	if(myStartDateTime>=datetime.now()){
        		UpdateParentOnly=true;
        	   //update parnet events only
        	   //update transferring history field on the event obj
                    ParentEvent.Transferring_History__c=StringHistroy(ParentEvent.Transferring_History__c,'OldOwnerID:'+ParentEvent.ownerid+' ; OldOwnerName:'+ParentEvent.Owner.Name+' ; Transfer Date:'+Date.today());
                    //update parent event owner
                    ParentEvent.ownerid=NewOwnerID;
        	}
        	//change past child events dates,update parent event,change back past child events dates
        	else{
	        	   //find all past child event whose startdatetime fills in the mystartdatetime<startdatetime<now()
	                        Map<String,String> changetimeevents=new Map<String,String>{};
	                        
	                        //the list to hold all past child events whose dates will be changed to the current datetime.now()+1day
	                        list<event> eventsToUpdate =new list<event>();
	                
	                        for(event e:[select id,startdatetime,enddatetime from event where recurrenceactivityid=:ParentEvent.ID and isrecurrence=false and StartDateTime>=:myStartDateTime and StartDateTime<=:myEndDateTime and ownerid=:oldOwnerID]){
	                                //save the event id with the original dates
	                                changetimeevents.put(e.id,e.startdatetime+';'+e.enddatetime);

	                                //change the date to the current datetime+1 day
	                                e.startdatetime=myDateTime.adddays(1);
	                                e.enddatetime=myDateTime.adddays(1);
	                                eventsToUpdate.add(e);
	                                if(eventsToUpdate.size()==99){
	                                  update eventsToUpdate;
	                                  eventsToUpdate.clear();
	                                }
	                
	                        }
	                        if(eventsToUpdate.size()>0){
	                                  update eventsToUpdate;
	                                  eventsToUpdate.clear();
	                        }
	
	                        //update transferring history field on the event obj
	                        ParentEvent.Transferring_History__c=StringHistroy(ParentEvent.Transferring_History__c,'OldOwnerID:'+ParentEvent.ownerid+' ; OldOwnerName:'+ParentEvent.Owner.Name+' ; Transfer Date:'+Date.today());
	                        //update parent event owner
	                        ParentEvent.ownerid=NewOwnerID;
	                        //update ParentEvent;
	                        update ParentEvent;
	                        
	                        //past child events list, used to hold all past child events whose dates need to be changed back to original
	                        list<event> changetimeeventsBack=new list<event>();
	                        String ChildEventIDs='';
	                         if(changetimeevents.size()>0){
	                                    //loop through all past child events map, and get all child events IDs
	                                    
	                                    for(String s:changetimeevents.keyset()){
	                                        //system.debug('s:'+s);
	                                        //make up the ('','',...) string used in the query
	                                       ChildEventIDs=ChildEventIDs+'\''+s+'\',';
	                                        
	                                    }
	                                    //remove the last ','
	                                    ChildEventIDs=ChildEventIDs.substring(0,ChildEventIDs.lastindexof(','));

	                        //change all past child events back to the old dates
	                        for(event e:Database.query('select ownerid,RecurrenceActivityId,IsRecurrence,Transferring_History__c,Owner.name,startdatetime,enddatetime from Event where id in ('+ChildEventIDs+')')){
	                            
	                            //make up the original dates
	                            String mystart=changetimeevents.get(e.id).substring(0,changetimeevents.get(e.id).indexof(';')-1);
	                            String myend=changetimeevents.get(e.id).substring(changetimeevents.get(e.id).indexof(';')+1,changetimeevents.get(e.id).length()-1);
	                
	                            Datetime oldStart=Datetime.valueof(mystart).addhours(10);
	                            Datetime oldend=Datetime.valueof(myend).addhours(10);
	                            //change the dates back to the original
	                             e.startdatetime=oldstart;
	                                e.enddatetime=oldend;
	                                
	                                
	                                changetimeeventsBack.add(e);
	                                
	                                 if(changetimeeventsBack.size()==99){
	                                  update changetimeeventsBack;
	                                  changetimeeventsBack.clear();
	                                }
	                                
	                        }
	                        
	                        if(changetimeeventsBack.size()>0){
	                                  update changetimeeventsBack;
	                                  changetimeeventsBack.clear();
	                        }
	                    
	                    }

        	}
		        if(UpdateParentOnly==true){
		          update ParentEventIDList;
		          
		        }
        }//for parent list loop ends   
        ParentEventIDList.clear();
}
      

    public PageReference ShowCounters(){
        //create save point
            ShowCounter=true;
            TaskCount=0;
	        EventCount=0;
	        OppoCount=0;
            ParentEventIDList.clear();
            ParentTaskIDList.clear();
            
            Datetime myStartDateTime;
            Datetime myEndDateTime;

             if(Cam.Start_Date__c <> null && Cam.End_Date__c <> null){
	            myStartDateTime = datetime.newInstance(Cam.Start_Date__c.year(), Cam.Start_Date__c.month(), Cam.Start_Date__c.day(),10,00,00);
	            myEndDateTime = datetime.newInstance(Cam.End_Date__c.year(), Cam.End_Date__c.month(), Cam.End_Date__c.day(),10,00,00);
	        }
            
                 //events
                Boolean IsEventUpdated = false;
                //if the activity has been checked
                if(Cam.Activities__c==true){
                    system.debug('Cam.Original_Owner:'+Cam.Original_Owner__c);
                    system.debug('Cam.Original_Owner__r.id:'+Cam.Original_Owner__r.id);
                    system.debug('Cam.New_Owner__r.id:'+Cam.New_Owner__r.id);
                     system.debug('Cam.Start_Date__c:'+Cam.Start_Date__c);
                      system.debug('Cam.End_Date__c:'+Cam.End_Date__c);
                      
                      
        
                           List<Event> anEventList=new List<Event>();
                           Set<String> ParentEventIDSet = new Set<String>{};
                           
                           Integer Counter=0;
                           
                           //select all old owner events
                           if (myStartDateTime <> null && myEndDateTime <> null){
                           	     system.debug('myStartDateTime:'+myStartDateTime);
                                system.debug('myEndDateTime:'+myEndDateTime);
                                
                                //find all past child events fills in the dates range and all future events
                                for(Event anEvent:[select ownerid,RecurrenceActivityId,IsRecurrence,Transferring_History__c,Owner.name from Event where StartDateTime>=:myStartDateTime and StartDateTime<=:myEndDateTime and ownerid=:Cam.Original_Owner__c]){

                                       
                                        //handle child event of recurrence parent event
                                    //if it is a recurrence event
                                    if(anEvent.IsRecurrence ==false && anEvent.RecurrenceActivityId!=null){
                                    	
                                            //count child event
                                            system.debug('a child event:'+anEvent.id);
                                            
                                        EventCount=EventCount+1;
                                        system.debug('Event Count:'+EventCount);
                                        
                                        // check has the parent event has been updated
                                        if(!ParentEventIDSet.contains(anEvent.RecurrenceActivityId)){
                                            //find the parent event, and add the parent event into the update list


                                            system.debug('a parent event:'+anEvent.RecurrenceActivityId);
                                          
                                            //add the parent evevt id into the list
                                           ParentEventIDSet.add(anEvent.RecurrenceActivityId);
                                           ParentEventIDList.add(anEvent.RecurrenceActivityId);
                                        }
                                        
                                         //handle normal non-recurrence event ONLY (child event of recurrence parent event handled in the above code)
                                        if(anEvent.RecurrenceActivityId==null && anEvent.IsRecurrence ==false){
                                           
                                            //normal event count
                                            system.debug('a normal event:'+anEvent.Id);
                                            
                                            EventCount=EventCount+1;
                                            system.debug('Event Count:'+EventCount);

                                        }

                                }//for ends

                           }//select all od owner events ends
                           
                            
                }
                
                                //find all child events which startdatetime>=now(), but its parent event is going to be changed
                String eventParentids='';
                List<event> UpdateParentevents =new list<event>();
                if(ParenteventIDList.size()>0){
                    
                    for(String s:ParenteventIDList){
                        //system.debug('s:'+s);
                       eventParentids=eventParentids+'\''+s+'\',';
                        
                    }
                    //system.debug('eventParentids:'+eventParentids);
                    eventParentids=eventParentids.substring(0,eventParentids.lastindexof(','));
                    //system.debug('eventParentids:'+eventParentids);
                    List<event> Parentevents=new List<event>();
                    
                        //make up datetime as database.query acceptable format yyyy-mm-ddTHH-MM-SSZ
                        string hour=String.valueof(datetime.now().hour());
                        if(hour.length()==1){
                            hour='0'+hour;
                        }
                        string min=String.valueof(datetime.now().minute());
                        if(min.length()==1){
                            min='0'+min;
                        }
                        string sec=String.valueof(datetime.now().second());
                        if(sec.length()==1){
                            sec='0'+sec;
                        }
                        String datetimenow=String.valueOf(date.today())+'T'+hour+':'+min+':'+sec+'Z';

                          for(event Myevent:Database.query('select ownerid,RecurrenceActivityId,IsRecurrence,Transferring_History__c,Owner.name from event where startdatetime>='+datetimenow+' and IsRecurrence =false and  RecurrenceActivityId in ('+eventParentids+')')){
                            
                                //count future open events
                                system.debug('a future child event:'+Myevent.id);
                                eventcount=eventcount+1; 
                                system.debug('Event Count:'+EventCount);
                                
                          }
                    
                    
                      
                 }
                
                }

                if(Cam.Activities__c==true){
              //select all task from the old owner
                           List<Task> aTaskList=new List<Task>();
                           ParentTaskIDList.clear();
                           Set<String> ParentTaskIDSet = new Set<String>{};
                           
                           if (Cam.Start_Date__c <> null && Cam.End_Date__c <> null ){
                                for(task atask:[select ownerid,RecurrenceActivityId,IsRecurrence,Transferring_History__c,Owner.name,activitydate from task where (activitydate>=:Cam.Start_Date__c and activitydate<=:Cam.End_Date__c) and ownerid=:Cam.Original_Owner__c and isclosed=false]){

                                        //find all parent id
                                        if(atask.IsRecurrence ==false && atask.RecurrenceActivityId!=null){
                                             // check has the parent task has been updated
                                             system.debug('child task ID:'+aTask.id); 
	                                        if(!ParenttaskIDSet.contains(aTask.RecurrenceActivityId)){
	                                            //find the parent task, and add the parent task into the update list
	                                            //system.debug('task Counter:'+TaskCounter); 
	                                              
	                                            system.debug('Parent task ID:'+aTask.RecurrenceActivityId);                               
	                                            //system.debug('Transferred task Count:'+taskCount);
	                                            system.debug('ParenttaskIDSet Count:'+ParenttaskIDSet.size());


	                                            system.debug('list size:'+aTaskList.size());
	                                          
	                                            //add the parent evevt id into the list
	                                           ParenttaskIDSet.add(aTask.RecurrenceActivityId);
	                                           ParenttaskIDList.add(aTask.RecurrenceActivityId);
	                                        }
                                        }
                                        
                                        //normal task
                                        if(atask.IsRecurrence ==false && atask.RecurrenceActivityId==null){
                                            //count normal task
                                            system.debug('normal task ID:'+aTask.id); 
                                                taskCount=taskCount+1;
                                        }
                                        

                                    }//for ends
                        
                           }        
                }
                
                //find all child open tasks which activity date out of selected date range, but its parent task is going to be changed
                String TaskParentids='';
                List<task> UpdateParenttasks =new list<task>();
                if(ParenttaskIDList.size()>0){
                    
                    for(String s:ParenttaskIDList){
                        //system.debug('s:'+s);
                       TaskParentids=TaskParentids+'\''+s+'\',';
                        
                    }
                    //system.debug('TaskParentids:'+TaskParentids);
                    TaskParentids=TaskParentids.substring(0,TaskParentids.lastindexof(','));
                    //system.debug('TaskParentids:'+TaskParentids);
                    List<task> Parenttasks=new List<task>();
                    //Parenttasks=Database.query('select ownerid,RecurrenceActivityId,IsRecurrence,Transferring_History__c,Owner.name from task where (activitydate<='+String.valueof(Cam.Start_Date__c)+' or activitydate>='+string.valueof(Cam.end_Date__c)+') and IsRecurrence =false and isclosed=false and  RecurrenceActivityId in ('+TaskParentids+')');
                    Parenttasks=Database.query('select ownerid,RecurrenceActivityId,IsRecurrence,Transferring_History__c,Owner.name from task where IsRecurrence =false and isclosed=false and RecurrenceActivityId in ('+TaskParentids+')');
                    
                      for(task Mytask:Parenttasks){
                        
                            //count all open tasks
                            system.debug('a open child task:'+Mytask.id);
                            taskcount=taskcount+1; 
                            
                      }
                      
               }

                //oppo
                //if the oppo has been checked
                if(Cam.Opportunities__c==true){
                    List<Opportunity> anOppoList=new List<Opportunity>();
                           //select all old owner's oppo
                            for(Opportunity anOppo:[select ownerid,Transferring_History__c,Owner.name from Opportunity where IsClosed=false and ownerid=:Cam.Original_Owner__c]){
                                OppoCount=OppoCount+1;
                            }
                }
                

                return null;

    }
    
    public PageReference Save(){
    	//get the counters
    	ShowCounters();
    	ShowCounter=false;
        ParentEventIDList.clear();
    	//create save point
    	Savepoint sp=Database.setSavepoint();

                 
          try{
          	    
          	   Datetime myStartDateTime;
                Datetime myEndDateTime;

	             if(Cam.Start_Date__c <> null && Cam.End_Date__c <> null){
	                myStartDateTime = datetime.newInstance(Cam.Start_Date__c.year(), Cam.Start_Date__c.month(), Cam.Start_Date__c.day(),10,00,00);
	                myEndDateTime = datetime.newInstance(Cam.End_Date__c.year(), Cam.End_Date__c.month(), Cam.End_Date__c.day(),10,00,00);
	            }
          	
          	     //events
                Boolean IsEventUpdated = false; 
                //if the activity has been checked
                if(Cam.Activities__c==true){
                    system.debug('Cam.Original_Owner:'+Cam.Original_Owner__c);
                    system.debug('Cam.Original_Owner__r.id:'+Cam.Original_Owner__r.id);
                    system.debug('Cam.New_Owner__r.id:'+Cam.New_Owner__r.id);
        
                    ParentEventIDList.clear();
                           List<Event> anEventList=new List<Event>();
                           Set<String> ParentEventIDSet = new Set<String>{};

                           if (myStartDateTime <> null && myEndDateTime <> null){
                                
                            for(Event anEvent:[select ownerid,RecurrenceActivityId,IsRecurrence,Transferring_History__c,Owner.name from Event where StartDateTime>=:myStartDateTime and StartDateTime<=:myEndDateTime and ownerid=:Cam.Original_Owner__c]){

                                    //handle child event of recurrence parent event
                                    //if it is a recurrence event
                                    if(anEvent.IsRecurrence ==false && anEvent.RecurrenceActivityId!=null){
                                        // check has the parent event has been updated
                                        if(!ParentEventIDSet.contains(anEvent.RecurrenceActivityId)){
                                            //find the parent event, and add the parent event into the update list
                                            system.debug('Event ID:'+anEvent.id);   
                                            system.debug('Parent Event ID:'+anEvent.RecurrenceActivityId);                               
                                            system.debug('Transferred Event Count:'+EventCount);
                                            system.debug('ParentEventIDSet Count:'+ParentEventIDSet.size());

                                            system.debug('list size:'+anEventList.size());
                                          
                                            //add the parent evevt id into the list
                                           ParentEventIDSet.add(anEvent.RecurrenceActivityId);
                                           ParentEventIDList.add(anEvent.RecurrenceActivityId);
                                        }
    
    
                                        
                                    }
                                    //handle recurrence parent event or normal non-recurrence event ONLY (child event of recurrence parent event handled in the above code)
                                    if(anEvent.RecurrenceActivityId==null && anEvent.IsRecurrence ==false){
                                       
                                        //event count
                                        //EventCount=EventCount+1;
                                        //update transferring history field on the event obj
                                        anEvent.Transferring_History__c=StringHistroy(anEvent.Transferring_History__c,'OldOwnerID:'+anEvent.ownerid+' ; OldOwnerName:'+anEvent.Owner.Name+' ; Transfer Date:'+Date.today());
                                        //update owner
                                        anEvent.OwnerId=Cam.New_Owner__c;
                                        anEventList.add(anEvent);
                                        system.debug('list size:'+anEventList.size());
    
                                       
                                    }
                                    
                                  //bulk update normal event list
                                    if(anEventList.size()==99){
                                        IsEventUpdated=true;
                                        update anEventList;
                                        anEventList.clear();
                                    }

                                }//foe ends
                           
                           }
                           if(anEventList.size()>0){
                                      IsEventUpdated=true;
                                    //update anEventList;
                                    anEventList.clear();
                           }
                           
                          
                }
                
                
                //handle parents events
                String ParentIDs='';
                List<Event> UpdateParentEvents =new list<Event>();
                if(ParentEventIDList.size()>0){
                    
                    for(String s:ParentEventIDList){
                        //system.debug('s:'+s);
                       ParentIDs=ParentIDs+'\''+s+'\',';
                        
                    }
                    //system.debug('ParentIDs:'+ParentIDs);
                    ParentIDs=ParentIDs.substring(0,ParentIDs.lastindexof(','));
                    //system.debug('ParentIDs:'+ParentIDs);
                    List<Event> ParentEvents=new List<Event>();
                    ParentEvents=Database.query('select ownerid,RecurrenceActivityId,IsRecurrence,Transferring_History__c,Owner.name from Event where id in ('+ParentIDs+')');
                      for(Event MyEvent:ParentEvents){
                        
                             //event count
                             //update the parnet event only when it's owner is not the new owner
                            //if(MyEvent.OwnerId<>Cam.New_Owner__c){
                             
                                //update transferring history field on the event obj
                                MyEvent.Transferring_History__c=StringHistroy(MyEvent.Transferring_History__c,'OldOwnerID:'+MyEvent.ownerid+' ; OldOwnerName:'+MyEvent.Owner.Name+' ; Transfer Date:'+Date.today());
                                //update owner
                                MyEvent.OwnerId=Cam.New_Owner__c;
                                UpdateParentEvents.add(MyEvent);
                                system.debug('UpdateParentEvents size:'+UpdateParentEvents.size());
                            //}  
                            //update parent event list
                            if(UpdateParentEvents.size()==99){
                                        IsEventUpdated=true;
                                        //update UpdateParentEvents;
                                        CheckPastChildEvents(UpdateParentEvents,Cam.Original_Owner__c,Cam.New_Owner__c);
                                        UpdateParentEvents.clear();
                            }
                            
                      }
                      if(UpdateParentEvents.size()>=1){
                            IsEventUpdated=true;
                            //update UpdateParentEvents;
                            CheckPastChildEvents(UpdateParentEvents,Cam.Original_Owner__c,Cam.New_Owner__c);
                            UpdateParentEvents.clear();
                        }
                                        
                }
          	
          	
                //tasks
                
                ParentTaskIDList.clear();
                Boolean IsTaskUpdated = false;

                 system.debug('Cam.Activities__c:'+Cam.Activities__c);
                 //if the activity has been checked
                if(Cam.Activities__c==true){
                    system.debug('Cam.Original_Owner:'+Cam.Original_Owner__c);
                    system.debug('Cam.Original_Owner__r.id:'+Cam.Original_Owner__r.id);
                    system.debug('Cam.New_Owner__r.id:'+Cam.New_Owner__r.id);
                              
                              //select all task from the old owner
                           List<Task> aTaskList=new List<Task>();
                           
                           Set<String> ParentTaskIDSet = new Set<String>{};
                           //Integer TaskCounter=0;
                           
                           if (Cam.Start_Date__c <> null && Cam.End_Date__c <> null){
                                for(Task aTask:[select ownerid,Transferring_History__c,Owner.name,IsRecurrence,RecurrenceActivityId from Task where ActivityDate>:Cam.Start_Date__c and ActivityDate<:Cam.End_Date__c and isclosed=false and ownerid=:Cam.Original_Owner__c]){
                                        //handle child task of recurrence parent task
                                    //if it is a recurrence task
                                    if(aTask.IsRecurrence ==false && aTask.RecurrenceActivityId!=null){
                                        // check has the parent task has been updated
                                        if(!ParenttaskIDSet.contains(aTask.RecurrenceActivityId)){
                                            //find the parent task, and add the parent task into the update list
                                            system.debug('task Counter:'+TaskCount); 
                                            system.debug('task ID:'+aTask.id);   
                                            system.debug('Parent task ID:'+aTask.RecurrenceActivityId);                               
                                            system.debug('Transferred task Count:'+TaskCount);
                                            system.debug('ParenttaskIDSet Count:'+ParenttaskIDSet.size());

                                          
                                            //add the parent evevt id into the list
                                           ParenttaskIDSet.add(aTask.RecurrenceActivityId);
                                           ParenttaskIDList.add(aTask.RecurrenceActivityId);
                                        }

                                    }
                                    
                                    //normal task
                                    if(aTask.RecurrenceActivityId==null && aTask.IsRecurrence ==false){
	                                    //task count
	                                    //TaskCount=TaskCount+1;
	                                    //update transferring history field on the task obj
	                                    aTask.Transferring_History__c=StringHistroy(aTask.Transferring_History__c,'OldOwnerID:'+aTask.ownerid+' ; OldOwnerName:'+aTask.Owner.Name+' ; Transfer Date:'+Date.today());
	                                    //update owner
	                                    aTask.OwnerId=Cam.New_Owner__c;
	                                    system.debug('normal task update:'+atask.id);
	                                    aTaskList.add(aTask);
	                                    system.debug('list size:'+atasklist.size());
	                                    //bulk update task list
	                                    if(aTasklist.size()==99){
	                                        IsTaskUpdated=true;
	                                        update aTasklist;
	                                        aTasklist.clear();
	                                    }
                                        
                                    }
                                }//for ends
                           }
                           
                            //here double check all normal tasks have been updated
                            if(aTasklist.size()>0){
                                      IsTaskUpdated=true;
                                    update aTasklist;
                                    aTasklist.clear();
                            }
                           
                          
                }
                
                //handle parents tasks
                String TaskParentids='';
                List<task> UpdateParenttasks =new list<task>();
                if(ParenttaskIDList.size()>0){
                    
                    for(String s:ParenttaskIDList){
                        //system.debug('s:'+s);
                       TaskParentids=TaskParentids+'\''+s+'\',';
                        
                    }
                    //system.debug('TaskParentids:'+TaskParentids);
                    TaskParentids=TaskParentids.substring(0,TaskParentids.lastindexof(','));
                    //system.debug('TaskParentids:'+TaskParentids);
                    List<task> Parenttasks=new List<task>();
                    Parenttasks=Database.query('select ownerid,RecurrenceActivityId,IsRecurrence,Transferring_History__c,Owner.name from task where id in ('+TaskParentids+')');
                      for(task Mytask:Parenttasks){
                             
                                //update transferring history field on the task obj
                                Mytask.Transferring_History__c=StringHistroy(Mytask.Transferring_History__c,'OldOwnerID:'+Mytask.ownerid+' ; OldOwnerName:'+Mytask.Owner.Name+' ; Transfer Date:'+Date.today());
                                //update owner
                                Mytask.OwnerId=Cam.New_Owner__c;
                                system.debug('parent task update:'+Mytask.id);
                                UpdateParenttasks.add(Mytask);
                                system.debug('UpdateParenttasks size:'+UpdateParenttasks.size());
                            //}  
                            if(UpdateParenttasks.size()==99){
                                        IstaskUpdated=true;
                                        update UpdateParenttasks;
                                        UpdateParenttasks.clear();
                            }
                            
                      }
                      if(UpdateParenttasks.size()>=1){
                            IstaskUpdated=true;
                            update UpdateParenttasks;
                            UpdateParenttasks.clear();
                        }
                                        
                }
                
                
                //oppo
                Boolean IsOppoUpdated = false;
                //if the oppo has been checked
                if(Cam.Opportunities__c==true){
                    List<Opportunity> anOppoList=new List<Opportunity>();
                           //select all old owner's oppo
                            for(Opportunity anOppo:[select ownerid,Transferring_History__c,Owner.name from Opportunity where IsClosed=false and ownerid=:Cam.Original_Owner__c]){
                                OppoCount=OppoCount+1;
                                anOppo.Transferring_History__c=StringHistroy(anOppo.Transferring_History__c,'OldOwnerID:'+anOppo.ownerid+' ; OldOwnerName:'+anOppo.Owner.Name+' ; Transfer Date:'+Date.today());
                                    //update owner
                                anOppo.OwnerId=Cam.New_Owner__c;
                                anOppoList.add(anOppo);
                                system.debug('list size:'+anOppoList.size());
                                //bulk update oppo list
                                if(anOppoList.size()==99){
                                    IsOppoUpdated=true;
                                    update anOppoList;
                                    anOppoList.clear();
                                }
                            }
                            if(anOppoList.size()>0){
                                      IsOppoUpdated=true;
                                    update anOppoList;
                                }
                }
                

                //if any of task/event/oppo has been updated, then insert new transferowner record
                if(IsTaskUpdated==true || IsEventUpdated==true || IsOppoUpdated==true){
                  cam.No_of_Events_Transfered__c=EventCount;
                  cam.No_of_Tasks_Transfered__c=TaskCount;
                  cam.No_of_Opportunities_Transfered__c=OppoCount;

                  insert cam;
                  return (new ApexPages.StandardController(Cam)).view();
                }
                //else, do nothing and show following msg
                else{
                  NoAction='There is no open Activity/Opportunity belongs to the Original Owner';
                }
                
        }
        catch(System.DMLException e){

	           Database.rollback(sp);

            ApexPages.addMessages(e);
            NoAction='Error: No Activity/Opportunity owner has been transfered.';
        }
        return null;
    }
    
static testMethod void eventsTest() {
    
           Profile p = [SELECT Id FROM profile WHERE name='System Administrator'];
           
           User me = new User(alias = 'Trans', email='TransferOwneruser@mydomain.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, 
            timezonesidkey='America/Los_Angeles', username='TransferOwneruser@mydomain.com');
            
             insert me;
           
           //create parent recurrence event
           TransferOwner__c aTransferOwner=new TransferOwner__c();
           insert aTransferOwner;
           system.debug('aTransferOwner id:'+aTransferOwner.id);
           Event aParentEvent=new Event(whatid=aTransferOwner.id,
           IsRecurrence=true,
           subject='test',
            ownerid=me.id,
            RecurrenceEndDateOnly = date.today().addYears(2),
		    RecurrenceStartDateTime = datetime.now().addYears(-2),
		    RecurrenceType = 'RecursMonthly',
		    RecurrenceDayofMonth=1,
		    RecurrenceInterval= 1,
		    DurationInMinutes=60
           );
           
           insert aParentEvent;
           
          
         
            //start to call vf page and controller code
            TransferOwner__c aTOa=new TransferOwner__c(Original_Owner__c=me.id,
            New_Owner__c=UserInfo.getuserid(),Opportunities__c=true,
            Activities__c=true,
            start_date__c=date.today().addyears(-3),
            end_date__c=date.today().addyears(3));
        
            test.startTest();
        
            PageReference pageRef = new PageReference('Page.Transferowner');
            test.setCurrentPage(pageRef);

            ApexPages.StandardController stda = new ApexPages.StandardController(aTOa);
            
            TransferOwner controllera = new TransferOwner(stda);
            controllera.save();

           test.stopTest();
    }
    
    static testMethod void tasksTest() {
    
           Profile p = [SELECT Id FROM profile WHERE name='System Administrator'];
           
           User me = new User(alias = 'Trans', email='TransferOwneruser@mydomain.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, 
            timezonesidkey='America/Los_Angeles', username='TransferOwneruser@mydomain.com');
            
             insert me;
           
           //create parent recurrence event
           TransferOwner__c aTransferOwner=new TransferOwner__c();
           insert aTransferOwner;

            //Tasks
            Task aParentTask=new Task(whatid=aTransferOwner.id,
	           IsRecurrence=true,
	           subject='test',
	            ownerid=me.id,
	            RecurrenceEndDateOnly = date.today().addYears(2),
	            RecurrenceStartDateOnly = date.today().addYears(-2),
	            RecurrenceType = 'RecursMonthly',
	            RecurrenceDayofMonth=1,
	            RecurrenceInterval= 1
           );
           
           insert aParentTask;
       
            //start to call vf page and controller code
            TransferOwner__c aTOa=new TransferOwner__c(Original_Owner__c=me.id,
            New_Owner__c=UserInfo.getuserid(),Opportunities__c=true,
            Activities__c=true,
            start_date__c=date.today().addyears(-3),
            end_date__c=date.today().addyears(3));
        
            test.startTest();
        
            PageReference pageRef = new PageReference('Page.Transferowner');
            test.setCurrentPage(pageRef);

            ApexPages.StandardController stda = new ApexPages.StandardController(aTOa);
            
            TransferOwner controllera = new TransferOwner(stda);
            controllera.save();

           test.stopTest();
    }
    
    static testMethod void oppsTest() {
    
           Profile p = [SELECT Id FROM profile WHERE name='System Administrator'];
           
           User me = new User(alias = 'Trans', email='TransferOwneruser@mydomain.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, 
            timezonesidkey='America/Los_Angeles', username='TransferOwneruser@mydomain.com');
            
             insert me;
           
           //create parent recurrence event
           TransferOwner__c aTransferOwner=new TransferOwner__c();
           insert aTransferOwner;

            ///Opportunities
            list<Opportunity> Opportunities=new list<Opportunity>();
            OpportunityStage stageName=[Select MasterLabel From OpportunityStage where IsActive=true limit 1];
            for(integer i=0;i<100;i++){
                Opportunity anOppo=new Opportunity(name='test',closedate=date.today().addDays(-i),stagename=stageName.MasterLabel);
               Opportunities.add(anOppo);
           }
           for(integer i=0;i<100;i++){
                Opportunity anOppo=new Opportunity(name='test',closedate=date.today().addDays(i),stagename=stageName.MasterLabel);
               Opportunities.add(anOppo);
           }
            insert Opportunities;
            
                     
            //start to call vf page and controller code
            TransferOwner__c aTOa=new TransferOwner__c(Original_Owner__c=me.id,
            New_Owner__c=UserInfo.getuserid(),Opportunities__c=true,
            Activities__c=true,
            start_date__c=date.today().addyears(-3),
            end_date__c=date.today().addyears(3));
        
            test.startTest();
        
            PageReference pageRef = new PageReference('Page.Transferowner');
            test.setCurrentPage(pageRef);

            ApexPages.StandardController stda = new ApexPages.StandardController(aTOa);
            
            TransferOwner controllera = new TransferOwner(stda);
            controllera.save();

           test.stopTest();
    }
    */
}