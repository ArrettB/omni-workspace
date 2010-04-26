package com.dynamic.charm;

import java.util.Date;

import org.springframework.beans.BeanWrapper;
import org.springframework.beans.BeanWrapperImpl;

import com.dynamic.charm.reflect.ConvertUtils;

public class AuditUtil
{
	private static String dateCreatedProperty = "dateCreated";
	private static String dateModifiedProperty = "dateModified";
	private static String createdByProperty = "createdBy";
	private static String modifiedByProperty = "modifiedBy";

	public static void updateAuditColumns(Object auditMe, Integer userId)
	{

		Date now = new Date();
		BeanWrapper bw = new BeanWrapperImpl(auditMe);
		
		if (bw.isWritableProperty(dateCreatedProperty) && (bw.getPropertyValue(dateCreatedProperty) == null))
		{
			bw.setPropertyValue(dateCreatedProperty, now);
		}
		if (bw.isWritableProperty(createdByProperty) && (bw.getPropertyValue(createdByProperty) == null))
		{
			bw.setPropertyValue(createdByProperty, ConvertUtils.convert(userId, bw.getPropertyType(createdByProperty)));
		}
		if (bw.isWritableProperty(dateModifiedProperty))
		{
			bw.setPropertyValue(dateModifiedProperty, now);
		}
		if (bw.isWritableProperty(modifiedByProperty))
		{
			bw.setPropertyValue(modifiedByProperty,  ConvertUtils.convert(userId, bw.getPropertyType(modifiedByProperty)));
		}

	}
	
	public static void updateAuditColumns(Object auditMe, Long userId)
	{

		Date now = new Date();
		BeanWrapper bw = new BeanWrapperImpl(auditMe);
		
		if (bw.isWritableProperty(dateCreatedProperty) && (bw.getPropertyValue(dateCreatedProperty) == null))
		{
			bw.setPropertyValue(dateCreatedProperty, now);
		}
		if (bw.isWritableProperty(createdByProperty) && (bw.getPropertyValue(createdByProperty) == null))
		{
			bw.setPropertyValue(createdByProperty, ConvertUtils.convert(userId, bw.getPropertyType(createdByProperty)));
		}
		if (bw.isWritableProperty(dateModifiedProperty))
		{
			bw.setPropertyValue(dateModifiedProperty, now);
		}
		if (bw.isWritableProperty(modifiedByProperty))
		{
			bw.setPropertyValue(modifiedByProperty,  ConvertUtils.convert(userId, bw.getPropertyType(modifiedByProperty)));
		}

	}

	public static void updateAuditColumns(Object auditMe, int userId)
	{
		updateAuditColumns(auditMe, new Integer(userId));
	}

	public static void updateAuditColumns(Object auditMe, String userId)
	{
		updateAuditColumns(auditMe, Integer.valueOf(userId));
	}

}
