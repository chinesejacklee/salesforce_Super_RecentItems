@isTest
private class TestRecentItem {

	static testMethod void TestRecentItemExistingItem(){
	         PageReference pageRef = new PageReference('Page.RecentItem');
	        Test.setCurrentPage(pageRef);
	 
	         list<RecentItemFilter__c> filters=[select id from RecentItemFilter__c];
	        delete filters;
	
	        test.startTest();
	
	                 account myaccount=new account(name='recent item test 764411');
		            insert myaccount;
		           String MytestrecordID=myaccount.id;
		            String MytestLink='https://ap1.salesforce.com/'+myaccount.id;
	                
	                RecentItem__c aRecord=new RecentItem__c(user__c=userinfo.getUserId(),recordid__c=MytestrecordID,link__c=MytestLink,object__c='Account', Record_Name__c='test record name');
	                insert aRecord;
	                
	                ApexPages.currentPage().getHeaders().put('Referer',MytestLink);
	                RecentItem controller = new RecentItem();
	
	                
	                controller.URL=MytestLink;
	                controller.GetRecentItem();
	                controller.getmyrecentitemsList();
	                controller.getRIList();
	                controller.getObjectNameList();
	           
	              test.stopTest();
	    }
	    
	static testMethod void TestRecentItemNewItem(){
	
	        
	         PageReference pageRef = new PageReference('Page.RecentItem');
	        Test.setCurrentPage(pageRef);
	       list<RecentItemFilter__c> filters=[select id from RecentItemFilter__c];
	        delete filters;
	
	                test.startTest();
	                   account myaccount=new account(name='recent item test 764411');
				    insert myaccount;
				     String MytestrecordID=myaccount.id;
			            String MytestLink='https://ap1.salesforce.com/'+myaccount.id+'?retURL=123';
	                ApexPages.currentPage().getHeaders().put('Referer',MytestLink);
	                RecentItem controller = new RecentItem();
	                controller.URL=MytestLink;
	                controller.GetRecentItem();
	           
	              test.stopTest();
	    }
	    
	static testMethod void TestRecentItemCoverNoofAccess(){
	
	        
	         PageReference pageRef = new PageReference('Page.RecentItem');
	        Test.setCurrentPage(pageRef);
	       list<RecentItemFilter__c> filters=[select id from RecentItemFilter__c];
	        delete filters;
	
	                test.startTest();
	                   account myaccount=new account(name='recent item test 764411');
					    insert myaccount;
					     String MytestrecordID=myaccount.id;
					            String MytestLink='https://ap1.salesforce.com/'+myaccount.id;
	                //cover No_Of_Access__c//
	                RecentItem__c aRecord=new RecentItem__c(No_Of_Access__c=1,user__c=userinfo.getUserId(),recordid__c=MytestrecordID,link__c=MytestLink,object__c='Account', Record_Name__c='test record name');
	                insert aRecord;
	                
	                ApexPages.currentPage().getHeaders().put('Referer',MytestLink);
	                RecentItem controller = new RecentItem();
	
	                
	                controller.URL=MytestLink;
	                controller.GetRecentItem();
	           
	              test.stopTest();
	    }
	    
	 static testMethod void CoverFilterBothObjectandNoDisplay(){
	
	        
	         PageReference pageRef = new PageReference('Page.RecentItem');
	        Test.setCurrentPage(pageRef);
	       list<RecentItemFilter__c> filters=[select id from RecentItemFilter__c];
	        delete filters;
	
	                test.startTest();
	                   account myaccount=new account(name='recent item test 764411');
					    insert myaccount;
					     String MytestrecordID=myaccount.id;
					            String MytestLink='https://ap1.salesforce.com/'+myaccount.id;
	                RecentItemFilter__c aF=new RecentItemFilter__c(Objects_List__c='Account',No_Of_Displayed_Items__c=20);
	                insert af;
	                
	                //cover No_Of_Access__c//
	                RecentItem__c aRecord=new RecentItem__c(No_Of_Access__c=1,user__c=userinfo.getUserId(),recordid__c=MytestrecordID,link__c=MytestLink,object__c='Account', Record_Name__c='test record name');
	                insert aRecord;
	                
	                ApexPages.currentPage().getHeaders().put('Referer',MytestLink);
	                RecentItem controller = new RecentItem();
	
	                
	                controller.URL=MytestLink;
	                controller.GetRecentItem();
	           
	              test.stopTest();
	    }
	    
	           
     static testMethod void CoverFilterNoDisplay(){
    
            
             PageReference pageRef = new PageReference('Page.RecentItem');
            Test.setCurrentPage(pageRef);
           list<RecentItemFilter__c> filters=[select id from RecentItemFilter__c];
	        delete filters;
                  
                  test.startTest();
                       account myaccount=new account(name='recent item test 764411');
					    insert myaccount;
					     String MytestrecordID=myaccount.id;
					            String MytestLink='https://ap1.salesforce.com/'+myaccount.id;
                    RecentItemFilter__c aF2=new RecentItemFilter__c(No_Of_Displayed_Items__c=20);
                    insert af2;
                    
                    //cover No_Of_Access__c//
                    RecentItem__c aRecord2=new RecentItem__c(No_Of_Access__c=1,user__c=userinfo.getUserId(),recordid__c=MytestrecordID,link__c=MytestLink,object__c='Account', Record_Name__c='test record name');
                    insert aRecord2;
                    
                    ApexPages.currentPage().getHeaders().put('Referer',MytestLink);
                    RecentItem controller2 = new RecentItem();
    
                    
                    controller2.URL=MytestLink;
                    controller2.GetRecentItem();
               
                  test.stopTest();
        }
        
    static testMethod void CoverNeitherFilter(){
    
            
             PageReference pageRef = new PageReference('Page.RecentItem');
            Test.setCurrentPage(pageRef);
            list<RecentItemFilter__c> filters=[select id from RecentItemFilter__c];
	        delete filters;
                  
                  test.startTest();
                       account myaccount=new account(name='recent item test 764411');
				    insert myaccount;
				    String MytestrecordID=myaccount.id;
				            String MytestLink='https://ap1.salesforce.com/'+myaccount.id;
                    RecentItemFilter__c aF2=new RecentItemFilter__c();
                    insert af2;
                    
                    //cover No_Of_Access__c//
                    RecentItem__c aRecord2=new RecentItem__c(No_Of_Access__c=1,user__c=userinfo.getUserId(),recordid__c=MytestrecordID,link__c=MytestLink,object__c='Account', Record_Name__c='test record name');
                    insert aRecord2;
                    
                    ApexPages.currentPage().getHeaders().put('Referer',MytestLink);
                    RecentItem controller2 = new RecentItem();
    
                    
                    controller2.URL=MytestLink;
                    controller2.GetRecentItem();
               
                  test.stopTest();
        }
        
     static testMethod void CoverFilterObject(){
    
            
             PageReference pageRef = new PageReference('Page.RecentItem');
            Test.setCurrentPage(pageRef);
           
                  list<RecentItemFilter__c> filters=[select id from RecentItemFilter__c];
	        delete filters;
                  test.startTest();
                       account myaccount=new account(name='recent item test 764411');
					    insert myaccount;
					     String MytestrecordID=myaccount.id;
					            String MytestLink='https://ap1.salesforce.com/'+myaccount.id;
                    RecentItemFilter__c aF2=new RecentItemFilter__c(Objects_List__c='Account');
                    insert af2;
                    
                    //cover No_Of_Access__c//
                    RecentItem__c aRecord2=new RecentItem__c(No_Of_Access__c=1,user__c=userinfo.getUserId(),recordid__c=MytestrecordID,link__c=MytestLink,object__c='Account', Record_Name__c='test record name');
                    insert aRecord2;
                    
                    ApexPages.currentPage().getHeaders().put('Referer',MytestLink);
                    RecentItem controller2 = new RecentItem();
    
                    
                    controller2.URL=MytestLink;
                    controller2.GetRecentItem();
               
                  test.stopTest();
        }
        
      static testMethod void Coveridea(){
    
            
             PageReference pageRef = new PageReference('Page.RecentItem');
            Test.setCurrentPage(pageRef);
                list<RecentItemFilter__c> filters=[select id from RecentItemFilter__c];
	        delete filters;
                  
                  test.startTest();
                    
                    community c=[select id from community limit 1];
                  idea a=new idea(title='recent item idea test 764411',communityid=c.id);  
                    insert a;
                              String MytestrecordID=a.id;
           				 String MytestLink='https://ap1.salesforce.com/ideas/viewIdea.apexp?id='+a.id;
                    
                    //cover No_Of_Access__c//
                    RecentItem__c aRecord2=new RecentItem__c(No_Of_Access__c=1,user__c=userinfo.getUserId(),recordid__c=MytestrecordID,link__c=MytestLink,object__c='Idea', Record_Name__c='test record name');
                    insert aRecord2;
                    
                    ApexPages.currentPage().getHeaders().put('Referer',MytestLink);
                    RecentItem controller2 = new RecentItem();
    
                    
                    controller2.URL=MytestLink;
                    controller2.GetRecentItem();
               
                  test.stopTest();
        }
        
    static testMethod void CoverRecentItemandFilter(){
    
            
             PageReference pageRef = new PageReference('Page.RecentItem');
            Test.setCurrentPage(pageRef);
  				list<RecentItemFilter__c> filters=[select id from RecentItemFilter__c];
	        delete filters;
                  
                  test.startTest();
                    
                  RecentItem__c a=new RecentItem__c(user__c=userinfo.getUserId(),recordid__c='123',link__c='123',object__c='RecentItem', Record_Name__c='123');
                    insert a;
                              String MytestLink='https://ap1.salesforce.com/'+a.id;
                    
                    ApexPages.currentPage().getHeaders().put('Referer',MytestLink);
                    RecentItem controller = new RecentItem();
                    controller.URL=MytestLink;
                    controller.GetRecentItem();
               
                  test.stopTest();
        }
        
    static testMethod void CoverNote(){
    
            
             PageReference pageRef = new PageReference('Page.RecentItem');
            Test.setCurrentPage(pageRef);
 				 list<RecentItemFilter__c> filters=[select id from RecentItemFilter__c];
	        delete filters;
                  
                  test.startTest();
                    
                    account myaccount=new account(name='recent item test 764411');
            		insert myaccount;
                 note a=new note(parentid=myaccount.id,body='123',title='123');

                    insert a;
                              String MytestLink='https://ap1.salesforce.com/'+a.id;
                    
                    ApexPages.currentPage().getHeaders().put('Referer',MytestLink);
                    RecentItem controller = new RecentItem();
                    controller.URL=MytestLink;
                    controller.GetRecentItem();
               
                  test.stopTest();
        }
        
     static testMethod void CoverCase(){
    
            
             PageReference pageRef = new PageReference('Page.RecentItem');
            Test.setCurrentPage(pageRef);
  					list<RecentItemFilter__c> filters=[select id from RecentItemFilter__c];
	        			delete filters;
                  
                  test.startTest();
                    
                    account myaccount=new account(name='recent item test 764411');
            		insert myaccount;
                 case a=new case(status='new',Origin='web' );

                    insert a;
                              String MytestLink='https://ap1.salesforce.com/'+a.id;
                    
                    ApexPages.currentPage().getHeaders().put('Referer',MytestLink);
                    RecentItem controller = new RecentItem();
                    controller.URL=MytestLink;
                    controller.GetRecentItem();
               
                  test.stopTest();
        }
        
    static testMethod void Coversolution(){
    
            
             PageReference pageRef = new PageReference('Page.RecentItem');
            Test.setCurrentPage(pageRef);
  				list<RecentItemFilter__c> filters=[select id from RecentItemFilter__c];
	        		delete filters;
                  
                  test.startTest();

                 solution a=new solution(SolutionName='123');

                    insert a;
                              String MytestLink='https://ap1.salesforce.com/'+a.id;
                    
                    ApexPages.currentPage().getHeaders().put('Referer',MytestLink);
                    RecentItem controller = new RecentItem();
                    controller.URL=MytestLink;
                    controller.GetRecentItem();
               
                  test.stopTest();
        }
        
    static testMethod void CoverContract(){
    
            
             PageReference pageRef = new PageReference('Page.RecentItem');
            Test.setCurrentPage(pageRef);
  			list<RecentItemFilter__c> filters=[select id from RecentItemFilter__c];
	        delete filters;
                  
                  test.startTest();
				 account myaccount=new account(name='recent item test 764411');
				            insert myaccount;
                 Contract a=new Contract(StartDate=date.today(), ContractTerm=10, AccountId=myaccount.id);

                    insert a;
                              String MytestLink='https://ap1.salesforce.com/'+a.id;
                    
                    ApexPages.currentPage().getHeaders().put('Referer',MytestLink);
                    RecentItem controller = new RecentItem();
                    controller.URL=MytestLink;
                    controller.GetRecentItem();
               
                  test.stopTest();
        }
}