package com.dynamic.servicetrax.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.support.JdbcDaoSupport;

import com.dynamic.servicetrax.support.LoginCrediantials;

public class LoginDao extends JdbcDaoSupport
{
	private String selectKey = "SELECT ak.user_id, ak.organization_id, o.pay_code_table FROM authentication_keys ak, organizations o WHERE ak.auth = ? AND ak.organization_id = o.organization_id";
	private String deleteKey = "DELETE FROM authentication_keys WHERE auth =?";
	private String deleteStaleKeys = "DELETE FROM authentication_keys WHERE expire_date < GETDATE()";
		
	private final static Logger logger = Logger.getLogger(LoginDao.class);
	
	public LoginCrediantials attempLogin(String key)
	{
		List results = getJdbcTemplate().query(selectKey, new Object[] { key }, new RowMapper()
		{

			public Object mapRow(ResultSet rs, int rowNum) throws SQLException
			{
				LoginCrediantials lc = new LoginCrediantials();
				lc.setOrganizationId(rs.getInt("organization_id"));
				lc.setUserId(rs.getInt("user_id"));
				lc.setPaycodeTable(rs.getString("pay_code_table"));
				return lc;
			}

		});
		
		getJdbcTemplate().update(deleteKey, new Object[] { key });

		if (results.size() == 0)
		{
			return null;
		}
		else if (results.size() == 1)
		{
			return (LoginCrediantials) results.get(0);
		}
		else
		{
			return null;
		}
		
	}
	
	
	
	public void removeStaleKeys()
	{
		int deleted = getJdbcTemplate().update(deleteStaleKeys);
		if (deleted > 0)
		{
			logger.info("Deleted " + deleted + " stale keys");
		}
	}
	
}