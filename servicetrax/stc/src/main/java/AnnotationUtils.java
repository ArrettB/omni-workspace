import java.lang.annotation.Annotation;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.List;





public class AnnotationUtils
{
	public void getAnnottedFields(Class clazz, Class annotation)
	{
	
	}
	
	
	public static void getAnnottedMethods(Class clazz, Class<?> annotationClass)
	{
		List<Method>  methodList = new ArrayList<Method>();
		Method[] methods = clazz.getMethods();
		for (Method method : methods)
		{
			Annotation[] annotations = method.getAnnotations();
			for (Annotation annotation : annotations)
			{
				if (annotation.annotationType().isAssignableFrom(annotationClass))
				{
					methodList.add(method);
				}
			}
				
		}
		
	}
}
