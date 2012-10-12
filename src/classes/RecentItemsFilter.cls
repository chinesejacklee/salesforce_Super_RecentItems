public with sharing class RecentItemsFilter {
    
    public string mode {get;set;}    
    public RecentItemFilter__c anitem {get; private set;}
    
    //public RecentItemFilter__c getanitem() {
	   //return anitem;
	//}
	    
    public RecentItemsFilter(){

        
        if(ApexPages.currentPage().getParameters().get('id')<>null){
        	//update
        	     Id id = ApexPages.currentPage().getParameters().get('id');
        	     Integer mycounter=[select count() from RecentItemFilter__c where CreatedById=:userinfo.getUserId() and id=:id];
                 
                 if(mycounter==1){
                        anitem = (id == null) ? new RecentItemFilter__c() : [select id,Objects_List__c,CreatedById,No_Of_Displayed_Items__c from RecentItemFilter__c where CreatedById=:userinfo.getUserId()];
                        mode='enable';
                 }
                 else{
                 //there is id, but it either does not exist or belongs to someone else
                  mode='disable';
                 
                 }   

        }
        
        //create new
        else {
        	Integer mycounter=[select count() from RecentItemFilter__c where CreatedById=:userinfo.getUserId() ];
        	if(mycounter==0){
        		     String id = '';
        	        anitem = (id.length() ==0 ) ? new RecentItemFilter__c() : [select id,Objects_List__c,CreatedById,No_Of_Displayed_Items__c from RecentItemFilter__c where id=:id];
                    mode='enable';
        	}
        	else{
        	   mode='disable';
        	}

        }
        
        
        

    }
    
    
    public PageReference save(){
        //Integer mycounter=[select count() from RecentItemFilter__c where CreatedById=:userinfo.getUserId()];
        //if(mycounter==0){
            //RecentItemFilter__c anitem=new RecentItemFilter__c(Objects_List__c=)
            //insert anitem;
        //}
        //else{
            //update anitem;
        //}
        try {
		  upsert(anitem);
		} catch(System.DMLException e) {
		  ApexPages.addMessages(e);
		  return null;
		}
		        
        return null;
    }
    
    
    
}