/*
 *               ApexIT, Inc.
 *
 * This software can only be used with the expressed written
 * consent of ApexIT, Inc. All rights reserved.
 *
 * Copyright 2009 ApexIT, Inc.
 * $Id: EstimatorConfigTest.java 1576 2009-04-15 19:48:21Z bvonhaden $
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED.  IN NO EVENT SHALL APEXIT, INC
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

package ims.helpers;

import static org.junit.Assert.assertEquals;

import java.io.File;
import java.io.StringReader;

import org.junit.Test;
import org.w3c.dom.Document;
import org.xml.sax.InputSource;

import dynamic.util.xml.XMLUtils;

/**
 * @version $Id: EstimatorConfigTest.java 1576 2009-04-15 19:48:21Z bvonhaden $
 */
public class EstimatorConfigTest
{
	static final String fredText = "fred.txt";
	static final File fred = new File(fredText);
	static final File fred5 = new File(fredText + "5");
	
	/**
	 * Test method for {@link ims.helpers.EstimatorConfig#EstimatorConfig(org.w3c.dom.Document)}.
	 * @throws Exception 
	 */
	@Test
	public void testEstimatorConfigFile() throws Exception
	{
		String xml = "<test><estimator estimatorTemplate2OrgId=\"20\"><parameter name=\"estimatorDir\" >"+fredText+"</parameter> </estimator></test>";
		InputSource is = new InputSource(new StringReader(xml));
		Document doc = XMLUtils.parse(is);
		EstimatorConfig ec = new EstimatorConfig(doc);
		
		assertEquals("fred.txt", ec.estimatorDir);
	}

	@Test
	public void testEstimatorConfigFile_estimatorTemplate() throws Exception
	{
		String xml = "<test><estimator estimatorTemplate2OrgId=\"20\"><parameter name=\"estimatorTemplate\" >"+fredText+"</parameter>"
			+ "<parameter name=\"estimatorDir\" >"+fredText+"</parameter>"
			+ " </estimator></test>";
		InputSource is = new InputSource(new StringReader(xml));
		Document doc = XMLUtils.parse(is);
		EstimatorConfig ec = new EstimatorConfig(doc);
		
		assertEquals(fred5, ec.getEstimatorDir("5"));
	}


	/**
	 * Test method for {@link ims.helpers.EstimatorConfig#EstimatorConfig(org.w3c.dom.Document)}.
	 * @throws Exception 
	 */
	@Test
	public void testEstimatorConfigId() throws Exception
	{
		String xml = "<test><estimator estimatorTemplate2OrgId=\"20\"><parameter name=\"estimatorDir\" >"+fredText+"</parameter> </estimator></test>";
		InputSource is = new InputSource(new StringReader(xml));
		Document doc = XMLUtils.parse(is);
		EstimatorConfig ec = new EstimatorConfig(doc);
		
		assertEquals("20", ec.estimatorTemplate2OrgId);
	}

}
