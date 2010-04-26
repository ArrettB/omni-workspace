/*
 *               ApexIT, Inc.
 *
 * This software can only be used with the expressed written
 * consent of ApexIT, Inc. All rights reserved.
 *
 * Copyright 2009 ApexIT, Inc.
 * $Id: QuoteExcelHandlerTest.java 1565 2009-03-31 22:30:02Z bvonhaden $
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

package ims.handlers.estimator;

import static org.junit.Assert.*;

import java.io.IOException;
import java.io.StringReader;

import javax.xml.parsers.ParserConfigurationException;

import org.junit.Test;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import dynamic.util.xml.XMLUtils;

/**
 * @version $Id: QuoteExcelHandlerTest.java 1565 2009-03-31 22:30:02Z bvonhaden $
 */
public class QuoteExcelHandlerTest
{

	/**
	 * Test method for {@link ims.handlers.estimator.QuoteExcelHandler#getValuesSetDatabase(java.io.File, java.lang.String, dynamic.dbtk.connection.ConnectionWrapper)}.
	 * @throws IOException 
	 * @throws SAXException 
	 * @throws ParserConfigurationException 
	 */
	@Test
	public void testGetValuesSetDatabase() throws ParserConfigurationException, SAXException, IOException
	{
		String xml = "<excel><sheet><parameter name=\"estimatorDir\" >silly stuff</parameter>"
    		+ "<set>"
    		+ "<parameter name=\"twoface\"></parameter>"
    		+ "</set>"
			+ "</sheet></excel>";
		InputSource is = new InputSource(new StringReader(xml));
		Document doc = XMLUtils.parse(is);

		NodeList sheets = doc.getElementsByTagName("sheet");
		Node sheet = sheets.item(0);

		NodeList items = XMLUtils.getElementsByTagName(sheet, "parameter");

		assertEquals(2, items.getLength());
		
		assertSame(sheet, items.item(0).getParentNode());
		assertNotSame(sheet, items.item(1).getParentNode());

	}

}
