package com.dynamic.charm.security;

import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Random;

import org.acegisecurity.providers.encoding.Md5PasswordEncoder;
import org.acegisecurity.providers.encoding.PasswordEncoder;
import org.springframework.beans.factory.InitializingBean;
/**
 * The password class is designed to assist developers in creating passwords and computing salted hashes for each password. 
 * A salted hash is thwart attacks that precompute "rainbow" tables with digest.   
 * see http://en.wikipedia.org/wiki/Salt_%28cryptography%29
 * 
 * This class is made final for security reasons, so third party code can not extend the class.
 * 
 * Getters and setters and not provided, to eliminate the possibility of echoing the password in plain text.
 * 
 * Sample use to login a user
 * 
 * <pre>
 * 
 * String login = getStringParameter(request, "login");
 * String password = getStringParameter(request, "password");
 * User userObject = getUserObject(login);
 * int storedSalt = userObject.getSalt();
 * String storedHash = userObject.getPassword();
 * Password pw = new Password("password", storedSalt);
 * if (pw.isValid(storedHash))
 * {
 * 	// login the user
 * }
 * else
 * {
 * 	// display error page
 * }
 * 
 * </pre>
 * 
 * Here is how you would store the user object in the database
 * 
 * <pre>
 * String login = getStringParameter(request, "login");
 * String newPassword = getStringParameter(request, "password");
 * int salt = Password.createRandomSalt();
 * 
 * Password password = new Password(newPassword, salt);
 * 
 * User userObject = new User();
 * user.setLogin(login);
 * user.setSalt(salt);
 * user.setPassword(password.computeSaltedHash());
 * 
 * queryService.save(user);
 * </pre>
 * 
 * @author gcase
 *
 */
public final class Password implements InitializingBean
{
	private String password;
	private String salt;
	private PasswordEncoder passwordEncoder;

	private final static String _allowedChars = "abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNOPQRSTUVWXYZ23456789";
	
	public final static String DEFAULT_BEAN_NAME = "password";
	
	
	public Password()
	{
		this.passwordEncoder = new Md5PasswordEncoder();
	}
	
	public Password(PasswordEncoder passwordEncoder)
	{
		this.passwordEncoder = passwordEncoder;
	}
 
	public void afterPropertiesSet() throws Exception
	{
	}
	
	public String computeSaltedHash()
	{
		return passwordEncoder.encodePassword(password, salt);
	}

	/**
	 * Compares a the supplied hash to the computed one for this password/salt combination
	 * @param databaseHash
	 * @return true if the hash is valid
	 */
	public boolean isValid(String databaseHash)
	{
		return passwordEncoder.isPasswordValid(databaseHash, password, salt);
	}
	
	/**
	 * Returns a randomly created salt.  A SecureRandom is used to generate the salt
	 * 
	 * @see SecureRandom
	 */
	public static String createRandomSalt()
    {
		try
		{
			SecureRandom sr = SecureRandom.getInstance ("SHA1PRNG");
			return Integer.toString(Math.abs(sr.nextInt()));
		} 
		catch (NoSuchAlgorithmException e)
		{
			Random r = new Random();
			return Integer.toString(Math.abs(r.nextInt()));
		}
   }
	
	/**
	 * Generates a random password of the given length.  The password is composed of the upper and lowercase letters a through z, and the numbers 0 through 9
	 * @param length the length of the password to be generated
	 */
	public static String createRandomPassword(int length)
	{

		int allowedCharCount = _allowedChars.length();
		char[] passwordChars = new char[length];

		try
		{
			SecureRandom sr = SecureRandom.getInstance("SHA1PRNG");
			for (int i = 0; i < length; i++)
			{
				int randomInt =Math.abs(sr.nextInt());
				passwordChars[i] = _allowedChars.charAt(randomInt % allowedCharCount);
			}
		} 
		catch (NoSuchAlgorithmException e)
		{
			Random random = new Random();
			for (int i = 0; i < length; i++)
			{
				int randomInt = random.nextInt();
				passwordChars[i] = _allowedChars.charAt(randomInt % allowedCharCount);
			}
		}

		return new String(passwordChars);

	}
		
	public PasswordEncoder getPasswordEncoder()
	{
		return passwordEncoder;
	}

	public void setPasswordEncoder(PasswordEncoder passwordEncoder)
	{
		this.passwordEncoder = passwordEncoder;
	}


	public String getPassword()
	{
		return password;
	}

	public void setPassword(String password)
	{
		this.password = password;
	}

	public String getSalt()
	{
		return salt;
	}

	public void setSalt(String salt)
	{
		this.salt = salt;
	}

	
	

	
	
}
