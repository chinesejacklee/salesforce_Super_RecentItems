@isTest
private class TestRecentItemsFilter {
    
   
    static testMethod void NoID(){
             PageReference pageRef = new PageReference('Page.RecentItemsFilter');
            Test.setCurrentPage(pageRef);
            
            list<RecentItemFilter__c> filters=[select id from RecentItemFilter__c];
	        delete filters;
			
			Integer counter=[select count() from RecentItemFilter__c];
			System.assertEquals(counter,0);
			
             test.startTest();

                RecentItemsFilter afilter=new RecentItemsFilter();
                afilter.save();
   
             test.stopTest();
     }
        
     static testMethod void Cover39(){
             PageReference pageRef = new PageReference('Page.RecentItemsFilter');
            Test.setCurrentPage(pageRef);
            
            list<RecentItemFilter__c> filters=[select id from RecentItemFilter__c];
	        delete filters;

            test.startTest();
              RecentItemFilter__c myFilter=new RecentItemFilter__c(Objects_List__c='Account', No_Of_Displayed_Items__c=20);
             insert myFilter;

             RecentItemsFilter afilter2=new RecentItemsFilter();

            test.stopTest();
     }
        
    static testMethod void withid(){
             PageReference pageRef = new PageReference('Page.RecentItemsFilter');
            Test.setCurrentPage(pageRef);
            
            list<RecentItemFilter__c> filters=[select id from RecentItemFilter__c];
	        delete filters;
            
            RecentItemFilter__c myFilter=new RecentItemFilter__c(Objects_List__c='Account', No_Of_Displayed_Items__c=20);
             insert myFilter;
                
            ApexPages.currentPage().getParameters().put('ID', myFilter.id);

             test.startTest();

                RecentItemsFilter afilter2=new RecentItemsFilter();

             test.stopTest();
   }
}