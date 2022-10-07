global with sharing class SBUtils implements Callable { 
    
    public Object call(String action, Map<String, Object> args) {
        
        Map<String,Object> inputMap = (Map<String,Object>)args.get('input');
        Map<String,Object> outputMap = (Map<String,Object>)args.get('output');
        Map<String,Object> options = (Map<String,Object>)args.get('options');
        
        //if action = read, or add, or , etc...
        
        read(inputMap, outputMap, options);
        return true;
    }
    
    
    //https://developer.salesforce.com/docs/atlas.en-us.cpq_dev_api.meta/cpq_dev_api/cpq_api_read_product.htm
    //
    public void read (Map<String, object> input, Map<String, object> output, Map<String, object> options){
        String productId=(String)input.get('productId');
        String pricebookId=(String)input.get('pricebookId');
        String currencyCode=(String)input.get('currencyCode');
        
        ProductReaderContext ctx = new ProductReaderContext(pricebookId, currencyCode);
        String productJSON = SBQQ.ServiceRouter.load('SBQQ.ProductAPI.ProductLoader', productId, JSON.serialize(ctx));
        //return (ProductModel) JSON.deserialize(productJSON, ProductModel.class);
        output.put('result', (map <String, object>) JSON.deserializeUntyped(productJSON));
    }
    
    private class ProductReaderContext {
        private Id pricebookId;
        private String currencyCode;
        
        private ProductReaderContext(Id pricebookId, String currencyCode) {
            this.pricebookId = pricebookId;
            this.currencyCode = currencyCode;
        }
    } 

}

/* Debug 
 * 
SBUtils reader = new SBUtils();
Map<String,Object> inputMap = new Map<String,Object>();
Map<String,Object> outputMap = new Map<String,Object>();
Map<String,Object> options = new Map<String,Object>();
inputmap.put('productId', '01t4x000006gnLWAAY');
inputmap.put('pricebookId', '01s4x000009pMFeAAM');
inputmap.put('currencyCode', 'USD');
reader.read(inputmap, outputmap, options);
System.debug(JSON.serialize(outputmap)); */