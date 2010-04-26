package com.dynamic.charm.exception;

public class PropertyNotSetException extends CharmException
{

	public PropertyNotSetException(String propertyName, Object target)
	{
		super("The " + propertyName + " property was not set on " + target + " instance of " + target.getClass().getName());;
	}

}
