package charm.hibernate.tools;

import java.util.HashMap;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.springframework.beans.BeanWrapperImpl;

public class BeanWrapperTest
{
	public static void main(String[] args)
	{
		Map testMap = new HashMap();
		testMap.put("foo", "bar");

//		BeanWrapperImpl bw = new BeanWrapperImpl(testMap);
	//	System.out.println(bw.getPropertyValue("foo"));

		String fooID = "foo_id";
		Pattern pattern = Pattern.compile("^foo_id$");
		Matcher matcher = pattern.matcher(fooID);
		
		
		 while(matcher.find()) {
	            System.out.println("I found the text \"" + matcher.group() +
	                               "\" starting at index " + matcher.start() +
	                               " and ending at index " + matcher.end() + ".");
	            
	        }
	}
}
