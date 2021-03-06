package com.dynamic.servicetrax.orm;

// Generated Apr 27, 2006 9:55:28 AM by Hibernate Tools 3.1.0.beta5

import java.util.Date;

/**
 * AuthenticationKey generated by hbm2java
 */
public class AuthenticationKey implements java.io.Serializable
{

	// Fields    

	private Long authenticationKeyId;

	private String auth;

	private long userId;

	private long organizationId;

	private Date expireDate;

	// Constructors

	/** default constructor */
	public AuthenticationKey()
	{
	}

	/** full constructor */
	public AuthenticationKey(String auth, long userId, long organizationId, Date expireDate)
	{
		this.auth = auth;
		this.userId = userId;
		this.organizationId = organizationId;
		this.expireDate = expireDate;
	}

	// Property accessors
	public Long getAuthenticationKeyId()
	{
		return this.authenticationKeyId;
	}

	public void setAuthenticationKeyId(Long authenticationKeyId)
	{
		this.authenticationKeyId = authenticationKeyId;
	}

	public String getAuth()
	{
		return this.auth;
	}

	public void setAuth(String auth)
	{
		this.auth = auth;
	}

	public long getUserId()
	{
		return this.userId;
	}

	public void setUserId(long userId)
	{
		this.userId = userId;
	}

	public long getOrganizationId()
	{
		return this.organizationId;
	}

	public void setOrganizationId(long organizationId)
	{
		this.organizationId = organizationId;
	}

	public Date getExpireDate()
	{
		return this.expireDate;
	}

	public void setExpireDate(Date expireDate)
	{
		this.expireDate = expireDate;
	}

}
