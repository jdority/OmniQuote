global with sharing class SBUtils implements Callable { 

    // Callback for saving the Quote once the Pricing/Calculations finish
    global with sharing class PricingCallback implements SBQQ.CalculateCallback {

        global void callback(String quoteJSON) {

            String savedQuoteJSON = SBQQ.ServiceRouter.save('SBQQ.QuoteAPI.QuoteSaver', quoteJSON);
        }
    }

    public Object call(String action, Map<String, Object> args) {
        
        Map<String,Object> inputMap = (Map<String,Object>)args.get('input');
        Map<String,Object> outputMap = (Map<String,Object>)args.get('output');
        Map<String,Object> options = (Map<String,Object>)args.get('options');
        
        if (action.equalsIgnoreCase('getProduct')) return getProduct(inputMap, outputMap);
        else if (action.equalsIgnoreCase('addProducts')) return addProducts(inputMap, outputMap);
        else if (action.equalsIgnoreCase('price')) return priceQuote(inputMap, outputMap);

        return false;
    }
    
    //https://developer.salesforce.com/docs/atlas.en-us.cpq_dev_api.meta/cpq_dev_api/cpq_api_read_product.htm
    //
    private Boolean getProduct(Map<String, object> input, Map<String, object> output) {

        String productId    = (String)input.get('productId');
        String pricebookId  = (String)input.get('pricebookId');
        String currencyCode = (String)input.get('currencyCode');
        
        // Set the Product Reader Context
        Map<String, Object> ctx = new Map<String, Object>();
        ctx.put('pricebookId', pricebookId);
        ctx.put('currencyCode', currencyCode);

        String productJSON = SBQQ.ServiceRouter.load('SBQQ.ProductAPI.ProductLoader', productId, JSON.serialize(ctx));
        
        output.put('result', (Map<String, object>) JSON.deserializeUntyped(productJSON));
        return true;
    }

    // Adds products to a quote
    private Boolean addProducts(Map<String, object> input, Map<String, object> output) {

        String quoteId             = (String)input.get('quoteId');
        List<Object> productModels = (List<Object>)input.get('productModels');        

        // Get the Quote
        String quoteJSON = SBQQ.ServiceRouter.read('SBQQ.QuoteAPI.QuoteReader', quoteId);

        // Build the "Add Product" context
        Map<String, Object> ctx = new Map<String, Object>();
        ctx.put('quote', JSON.deserializeUntyped(quoteJSON));
        ctx.put('products', productModels);
        ctx.put('groupKey', 0);
        ctx.put('ignoreCalculate', true);

        // Request/Configure the Quote
        String updatedQuoteJSON = SBQQ.ServiceRouter.load('SBQQ.QuoteAPI.QuoteProductAdder', null, JSON.serialize(ctx));

        // Save the Quote
        String savedQuoteJSON = SBQQ.ServiceRouter.save('SBQQ.QuoteAPI.QuoteSaver', updatedQuoteJSON);
        output.put('result', JSON.deserializeUntyped(savedQuoteJSON));

        return true;
    }

    // Run Pricing (Calculate) on the Quote
    // Note: This doesn't need to be called explicitly if the "Calcualte Immediately" configuration is enabled (Setup -> Installed Packages -> Salesforce CPQ (Configure) -> Pricing and Calculation)
    private Boolean priceQuote(Map<String, object> input, Map<String, object> output) {

        String quoteId = (String)input.get('quoteId');

        // Get the Quote
        String quoteJSON = SBQQ.ServiceRouter.read('SBQQ.QuoteAPI.QuoteReader', quoteId);

        // Build the "Calculate" context
        Map<String, Object> ctx = new Map<String, Object>();
        ctx.put('quote', JSON.deserializeUntyped(quoteJSON));
        ctx.put('callbackClass', SBUtils.PricingCallback.class.toString());

        SBQQ.ServiceRouter.load('SBQQ.QuoteAPI.QuoteCalculator', null, JSON.serialize(ctx));

        return true;
    }
}