package com.dynamic.charm.security;

import java.util.regex.Pattern;

public class InputCleanser
{
	private final static Pattern evilChars = Pattern.compile("[^a-zA-Z0-9]");

	public static String stripNonAlphaNumeric(String input)
	{
		return evilChars.matcher(input).replaceAll("");
	}
	
}
