package com.dynamic.charm.security;

import junit.framework.TestCase;

public class PasswordTest extends TestCase
{
	
	public void testCreatePassword()
	{
		int length = 8;
		String password = Password.createRandomPassword(length);
		assertEquals(length, password.length());
	}
	
	public void testPassword()
	{
		String password= "mypassword";
		String badPassword = "notmypassword";
		
		String salt = "42";
		String badSalt = "21";
		
		Password pw;
		
		pw = new Password();
		pw.setPassword(password);
		pw.setSalt(salt);
		String hash = pw.computeSaltedHash();		
		assertTrue(pw.isValid(hash));
		
		pw.setPassword(badPassword);
		pw.setSalt(salt);
		assertFalse(pw.isValid(hash));

		pw.setPassword(password);
		pw.setSalt(badSalt);
		assertFalse(pw.isValid(hash));

		
	}

}
