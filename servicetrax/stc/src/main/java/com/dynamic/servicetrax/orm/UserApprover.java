package com.dynamic.servicetrax.orm;

// Generated Apr 27, 2006 9:55:28 AM by Hibernate Tools 3.1.0.beta5

/**
 * UserApprover generated by hbm2java
 */
public class UserApprover implements java.io.Serializable
{

	// Fields    

	private Long userApproverId;

	private User user;

	private Customer customer;

	// Constructors

	/** default constructor */
	public UserApprover()
	{
	}

	/** full constructor */
	public UserApprover(User user, Customer customer)
	{
		this.user = user;
		this.customer = customer;
	}

	// Property accessors
	public Long getUserApproverId()
	{
		return this.userApproverId;
	}

	public void setUserApproverId(Long userApproverId)
	{
		this.userApproverId = userApproverId;
	}

	public User getUser()
	{
		return this.user;
	}

	public void setUser(User user)
	{
		this.user = user;
	}

	public Customer getCustomer()
	{
		return this.customer;
	}

	public void setCustomer(Customer customer)
	{
		this.customer = customer;
	}

}
