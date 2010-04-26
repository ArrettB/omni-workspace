/*
 *               ApexIT, Inc.
 *
 * This software can only be used with the expressed written
 * consent of ApexIT, Inc. All rights reserved.
 *
 * Copyright 2009 ApexIT, Inc.
 * $Id: NamedQueryDigesterTest.java 412 2009-05-28 21:51:04Z bvonhaden $
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

package com.dynamic.charm.query;

import java.io.IOException;
import java.io.Reader;
import java.io.StringReader;
import java.util.Map;

import junit.framework.TestCase;

import org.xml.sax.SAXException;

import com.dynamic.charm.types.Money;

/**
 * @version $Id: NamedQueryDigesterTest.java 412 2009-05-28 21:51:04Z bvonhaden $
 */
public class NamedQueryDigesterTest extends TestCase
{

	/**
	 * Test method for {@link com.dynamic.charm.query.NamedQueryDigester#parse(java.io.InputStream)}.
	 * @throws SAXException 
	 * @throws IOException 
	 */
	public void testParseReader() throws IOException, SAXException
	{
		String xml = 
			"<namedQueries>"
		+ "<namedQuery>"
		+ "<id>getSkillsParent</id>"
		+ "<service>jdbcService</service>"
		+ "<query>"
		+ "	<![CDATA["
		+ "		select 	skill_id,"
		+ "				name,"
		+ "				(select count(*) from skills where skill_parent_id = skl.skill_id) childs"
		+ "		from skills skl"
		+ "		where skill_parent_id is null"
		+ "		and skl.organization_id = :organizationId"
		+ "	]]>"
		+ "</query>"
		+ "<parameter name=\"organizationId\" type=\"Long\" />"
		+ "</namedQuery>"
		+ "</namedQueries>";
		Reader reader = new StringReader(xml);
		
		NamedQueryDigester digester = new NamedQueryDigester();
		
		NamedQueries q = digester.parse(reader);
		
		assertTrue(q.getNamedQueries().next() != null);
		
		NamedQuery namedQuery = q.findNamedQuery("getSkillsParent");
		
		assertNotNull(namedQuery);
		
		Map parameters = namedQuery.getParameterMap();
		
		assertNotNull(parameters);
		
		assertTrue(parameters.size() == 1);
		
		QueryParameter qp = (QueryParameter)parameters.get("organizationId");
		
		assertNotNull(qp);
		
		assertEquals("organizationId", qp.getName());

		assertEquals("Long", qp.getTypeName());

		
	}

	
	/**
	 * Test method for {@link com.dynamic.charm.query.NamedQueryDigester#parse(java.io.InputStream)}.
	 * @throws SAXException 
	 * @throws IOException 
	 */
	public void testParseElement() throws IOException, SAXException
	{
		String xml = 
			"<namedQueries>"
		+ "<namedQuery>"
		+ "<id>getSkillsParent</id>"
		+ "<service>jdbcService</service>"
		+ "<query>"
		+ "	<![CDATA["
		+ "		select 	skill_id,"
		+ "				name,"
		+ "				(select count(*) from skills where skill_parent_id = skl.skill_id) childs"
		+ "		from skills skl"
		+ "		where skill_parent_id is null"
		+ "		and skl.organization_id = :organizationId"
		+ "	]]>"
		+ "</query>"
		+ "<parameter name=\"organizationId\" type=\"Long\" />"
		+ "<entityType>com.dynamic.charm.types.Money</entityType>"
		+ "</namedQuery>"
		+ "</namedQueries>";
		Reader reader = new StringReader(xml);
		
		NamedQueryDigester digester = new NamedQueryDigester();
		
		NamedQueries q = digester.parse(reader);
		
		assertTrue(q.getNamedQueries().next() != null);
		
		NamedQuery namedQuery = q.findNamedQuery("getSkillsParent");

		assertNotNull(namedQuery);
		
		assertEquals(Money.class, namedQuery.getEntityTypeClass());
		
	}


}
