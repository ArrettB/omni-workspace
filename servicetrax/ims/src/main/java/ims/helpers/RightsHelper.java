package ims.helpers;

import ims.Constants;
import ims.dataobjects.Function;
import ims.dataobjects.User;

import java.util.Map;

import dynamic.intraframe.engine.InvocationContext;

public class RightsHelper
{
	public static Function getFunction(InvocationContext ic, String rightCode)
	{
		User currentUser = (User) ic.getSessionDatum(Constants.SESSION_USER);
		Map rights = currentUser.getRights();		
		Function function = (Function) rights.get(rightCode);
		return function;
	}
	
	public static boolean hasUpdateRight(InvocationContext ic, String rightCode)
	{
		Function function = getFunction(ic, rightCode);
		return function != null && function.update;	
	}

	public static boolean hasInsertRight(InvocationContext ic, String rightCode)
	{
		Function function = getFunction(ic, rightCode);
		return function != null && function.insert;	
	}

	public static boolean hasViewRight(InvocationContext ic, String rightCode)
	{
		Function function = getFunction(ic, rightCode);
		return function != null && function.view;	
	}

	public static boolean hasDeleteRight(InvocationContext ic, String rightCode)
	{
		Function function = getFunction(ic, rightCode);
		return function != null && function.delete;	
	}

}
