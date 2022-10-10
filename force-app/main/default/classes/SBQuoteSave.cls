global with sharing class SBQuoteSave implements Callable {
    
    public Object call(String action, Map<String, Object> args) {
        Map<String,Object> inputMap = (Map<String,Object>)args.get('input');
        Map<String,Object> outputMap = (Map<String,Object>)args.get('output');
        Map<String,Object> options = (Map<String,Object>)args.get('options');
        
        //if action = read, or add, or , etc...
        
        saveQuote(inputMap, outputMap, options);
        return true;
    }
    
    //Retrieves the QuoteModel for Quote added by DataRaptor to ensure it is saved properly for SBQQ
    public void saveQuote (Map<String, object> input, Map<String, object> output, Map<String, object> options){
        String quoteId=(String)input.get('quoteId');
        
        String quoteJSON = SBQQ.ServiceRouter.read('SBQQ.QuoteAPI.QuoteReader', quoteId);
        String savedQuote = SBQQ.ServiceRouter.save('SBQQ.QuoteAPI.QuoteSaver', quoteJSON);
        System.debug(savedQuote);
        output.put('result', (map <String, object>) JSON.deserializeUntyped(quoteJSON));
    }
}