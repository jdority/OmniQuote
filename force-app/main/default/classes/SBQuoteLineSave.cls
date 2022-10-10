global with sharing class SBQuoteLineSave implements Callable {
    
    public Object call(String action, Map<String, Object> args) {
        Map<String,Object> inputMap = (Map<String,Object>)args.get('input');
        Map<String,Object> outputMap = (Map<String,Object>)args.get('output');
        Map<String,Object> options = (Map<String,Object>)args.get('options');
        
        //if action = read, or add, or , etc...
        
        saveQuoteLine(inputMap, outputMap, options);
        return true;
    }
    
    //Retrieves the QuoteModel for Quote added by DataRaptor to ensure it is saved properly for SBQQ
    public void saveQuoteLine (Map<String, object> input, Map<String, object> output, Map<String, object> options){
        String productId=(String)input.get('productId');
        String pricebookId=(String)input.get('pricebookId');
        String currencyCode=(String)input.get('currencyCode');
        
        ProductReaderContext ctx = new ProductReaderContext(pricebookId, currencyCode);
        String productJSON = SBQQ.ServiceRouter.load('SBQQ.ProductAPI.ProductLoader', productId, JSON.serialize(ctx));
        //return (ProductModel) JSON.deserialize(productJSON, ProductModel.class);
        output.put('result', (map <String, object>) JSON.deserializeUntyped(productJSON));    }
    
    private class ProductReaderContext {
        private Id pricebookId;
        private String currencyCode;
        
        private ProductReaderContext(Id pricebookId, String currencyCode) {
            this.pricebookId = pricebookId;
            this.currencyCode = currencyCode;
        }
    } 
}