package com.dynamic.cf;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.servlet.mvc.SimpleFormController;

import com.dynamic.charm.common.StringUtils;
import com.dynamic.charm.query.hibernate.HibernateService;

public class ChormController extends SimpleFormController
{
	private HibernateService hibernateService;

	public ChormController()
	{
		setSessionForm(true);
	}
	
	@Override
	protected Object formBackingObject(HttpServletRequest request) throws Exception
	{
		Class commandClazz = getCommandClass();
		String idName = hibernateService.getIdentifierName(commandClazz);
		String idParam = request.getParameter(idName);
		if (StringUtils.isNotBlank(idParam))
		{
			return hibernateService.get(commandClazz, idParam);
		}
		else
		{
			return super.formBackingObject(request);
			
		}
	}
	
	@Override
	protected void doSubmitAction(Object command) throws Exception
	{
		hibernateService.save(command);
	}
	
	
}
