Autocompleter.DWR = Class.create();
Autocompleter.DWR.prototype = Object.extend(new Autocompleter.Base(), 	{
	   initialize: function(element, update, DWRFunction, onComplete, options) 
	   {
	        this.baseInitialize(element, update, options);
	        this.DWRFunction           = DWRFunction;
	        this.onComplete            = onComplete;
	        this.options               = options || {}; // none yet
	        
	    },
	    
	    getUpdatedChoices: function() 
	    {
	       this.DWRFunction(this.element.value, this.onCompleteFunction());
	    },
	    
	    onCompleteFunction: function() 
	    {
	        var t=this;
	        return function(data) 
	        {
	        	var result = t.onComplete(data);
	            t.updateChoices(result);
	        }
	       
	        
	        
	    }
	});
	