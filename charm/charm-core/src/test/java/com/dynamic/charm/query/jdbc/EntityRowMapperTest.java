/*
 *               ApexIT, Inc.
 *
 * This software can only be used with the expressed written
 * consent of ApexIT, Inc. All rights reserved.
 *
 * Copyright 2009 ApexIT, Inc.
 * $Id: EntityRowMapperTest.java 412 2009-05-28 21:51:04Z bvonhaden $
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED.  IN NO EVENT SHALL APEXIT, INC.
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
 * USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
 * OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 * ====================================================================
 */

package com.dynamic.charm.query.jdbc;

import java.lang.reflect.InvocationTargetException;

import org.apache.commons.beanutils.BeanUtils;

import junit.framework.TestCase;

import com.dynamic.charm.types.Money;

/**
 * @version $Id: EntityRowMapperTest.java 412 2009-05-28 21:51:04Z bvonhaden $
 */
public class EntityRowMapperTest extends TestCase
{

	/**
	 * Test method for {@link com.dynamic.charm.query.jdbc.EntityRowMapper#toGetter(java.lang.String)}.
	 */
	public void testToCamelCase()
	{
		EntityRowMapper map = new EntityRowMapper(Money.class);
		
		String txt = map.toParameter("MONEY_ID");
		
		assertEquals("moneyId", txt);
	}

	public void testToCamelCaseDouble()
	{
		EntityRowMapper map = new EntityRowMapper(Money.class);
		
		String txt = map.toParameter("GOOD_MONEY_ID");
		
		assertEquals("goodMoneyId", txt);
	}

	public void testToCamelCaseTrouble()
	{
		EntityRowMapper map = new EntityRowMapper(Money.class);
		
		String txt = map.toParameter("GOOD_MONEY_ID_");
		
		assertEquals("goodMoneyId", txt);
	}

	public void testToCamelCaseDoubleTrouble()
	{
		EntityRowMapper map = new EntityRowMapper(Money.class);
		
		String txt = map.toParameter("GOOD__MONEY_ID_");
		
		assertEquals("goodMoneyId", txt);
	}


	
	public void testSetValue() throws IllegalAccessException, InvocationTargetException
	{
		EntityRowMapper map = new EntityRowMapper(Dummy.class);
		
		String paramName = map.toParameter("DUMMY_ID");
		Dummy dummy = new Dummy();
		Long val = new Long(1);
		BeanUtils.copyProperty(dummy, paramName, val );

		assertEquals(val, dummy.getDummyId());
	}

	
}
