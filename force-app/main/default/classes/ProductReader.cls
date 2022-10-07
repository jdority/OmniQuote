global with sharing class ProductReader implements omnistudio.VlocityOpenInterface, Callable { 
    
    public Object call(String action, Map<String, Object> args) {
        
        Map<String,Object> inputMap = (Map<String,Object>)args.get('input');
        Map<String,Object> outputMap = (Map<String,Object>)args.get('output');
        Map<String,Object> options = (Map<String,Object>)args.get('options');
        
        return invokeMethod(action, inputMap, outputMap, options);
    }
    
    global boolean invokeMethod(String methodName, Map<String, object> input, Map<String, object> output, Map<String, object> options){
        boolean result=true;
                
        try{
            if(methodName.equalsIgnoreCase('read')){
             //   read(input,output,options);
      
            }else{
                output.put('result','');
            }
            
        }catch(Exception e)
        {return false;
        }
        return result;
    }

    //https://developer.salesforce.com/docs/atlas.en-us.cpq_dev_api.meta/cpq_dev_api/cpq_api_read_product.htm
    //
   //     public void ProductModel read (Map<String, object> input, Map<String, object> output, Map<String, object> options){
   //     String productId=(String)input.get('productId');
   //         String pricebookId=(String)input.get('pricebookIdpricebookId');
   //         String currencyCode=(String)input.get('USD');
    
   //         ProductReaderContext ctx = new ProductReaderContext(pricebookId, currencyCode);
   //         String productJSON = SBQQ.ServiceRouter.load('SBQQ.ProductAPI.ProductLoader', productId, JSON.serialize(ctx));
   //         return (ProductModel) JSON.deserialize(productJSON, ProductModel.class);
   //     }
        
        private class ProductReaderContext {
            private Id pricebookId;
            private String currencyCode;
            
            private ProductReaderContext(Id pricebookId, String currencyCode) {
                this.pricebookId = pricebookId;
                this.currencyCode = currencyCode;
            }
        } 
    	//output.put('result', results);
    }