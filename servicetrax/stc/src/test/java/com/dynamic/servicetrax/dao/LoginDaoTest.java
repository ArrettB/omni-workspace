package com.dynamic.servicetrax.dao;

import java.util.Date;

import org.springframework.test.AbstractTransactionalDataSourceSpringContextTests;

import com.dynamic.servicetrax.support.LoginCrediantials;

public class LoginDaoTest extends AbstractTransactionalDataSourceSpringContextTests
{
	private LoginDao loginDao;
	
	
	public void testBadLogin()
	{
		LoginCrediantials lc = loginDao.attempLogin("badKey");
		assertNull(lc);
	}
	
	public void testGoodLogin()
	{
		String authKey = "myAuth";
		int userId = 580;
		int orgId = 2;
		Date expireDate = new Date();

		Object[] paramValues = new Object[] { authKey, new Integer(userId), new Integer(orgId), expireDate };
		jdbcTemplate.update("INSERT INTO authentication_keys (auth, user_id, organization_id, expire_date) VALUES (?, ?, ?, ?)", paramValues);
		
		String payCodeTable = (String) jdbcTemplate.queryForObject("SELECT pay_code_table FROM organizations WHERE organization_id  = " + orgId , String.class);
		
		LoginCrediantials lc = loginDao.attempLogin(authKey);
		assertNotNull(lc);
		assertEquals(userId, lc.getUserId());
		assertEquals(orgId, lc.getOrganizationId());
		assertEquals(payCodeTable, lc.getPaycodeTable());
	
		//make sure the auth key gets deleted
		assertNull( loginDao.attempLogin(authKey));
		
	}
	
	@Override
	protected String[] getConfigLocations()
	{
		
		return new String[] {"applicationContext-test.xml"};
	}



	public LoginDao getLoginDao()
	{
		return loginDao;
	}



	public void setLoginDao(LoginDao loginDao)
	{
		this.loginDao = loginDao;
	}


}
