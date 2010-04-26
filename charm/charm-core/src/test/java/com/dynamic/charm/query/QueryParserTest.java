/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: QueryParserTest.java 11 2005-10-19 21:27:59Z gcase $

* THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
* OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED.  IN NO EVENT SHALL DYNAMIC INFORMATIONS SYTEMS, LLC
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

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import junit.framework.TestCase;

import com.dynamic.charm.exception.CharmException;
import com.dynamic.charm.query.jdbc.QueryParser;


/**
 * @author gcase
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class QueryParserTest extends TestCase
{

    private ArrayList positionNone;
    private ArrayList position1;
    private ArrayList position2;
    private ArrayList position12;
    private ArrayList position13;
    private Map emptyMap;
    private Map xyzMap;
    private Map xyzabcMap;
    private String typeStringString="String,String";
   
    protected void setUp() throws Exception
    {
        positionNone = new ArrayList();
        position1 = new ArrayList();
        position1.add(new Integer(1));
        
        position2 = new ArrayList();
        position2.add(new Integer(2));
        
        position12 = new ArrayList();
        position12.add(new Integer(1));
        position12.add(new Integer(2));
        
        position13 = new ArrayList();
        position13.add(new Integer(1));
        position13.add(new Integer(3));
        
        emptyMap = new HashMap();
    
        xyzMap = new HashMap();
        xyzMap.put("xyz", "String");
        
        xyzabcMap = new HashMap();
        xyzabcMap.put("xyz", "String");
        xyzabcMap.put("abc", "String");
        
    }

    public void testParse()
    {

        QueryParser psc = null;

        try
        {
            psc = new QueryParser("SELECT foo FROM bar");
            
            assertEquals(0, psc.getParameterCount());
            assertEquals("SELECT foo FROM bar", psc.getSql());
            assertNull(psc.getParameterPositions("notfound"));
            assertEquals(0, psc.getDistinctParameterCount());
            assertEquals(0, psc.getParameterCount());
           
            psc = new QueryParser("SELECT foo FROM bar WHERE xyz = :xyz");
            assertEquals(1, psc.getParameterCount());
            assertEquals("SELECT foo FROM bar WHERE xyz = ?", psc.getSql());
            assertEquals(position1, psc.getParameterPositions("xyz"));
            assertEquals(1, psc.getDistinctParameterCount());
            assertEquals(1, psc.getParameterCount());
            
            //need to test with underscores (be sure our test includes any other special characters that should be allowed)
            psc = new QueryParser("SELECT foo FROM bar WHERE xyz = :xyz_id");
            assertEquals(1, psc.getParameterCount());
            assertEquals("SELECT foo FROM bar WHERE xyz = ?", psc.getSql());
            assertEquals(position1, psc.getParameterPositions("xyz_id"));
            assertEquals(1, psc.getDistinctParameterCount());
            assertEquals(1, psc.getParameterCount());
            
           
            psc = new QueryParser("SELECT foo FROM bar WHERE xyz = :xyz AND abc = :abc");
            assertEquals(2, psc.getParameterCount());
            assertEquals("SELECT foo FROM bar WHERE xyz = ? AND abc = ?", psc.getSql());
            assertEquals(position1, psc.getParameterPositions("xyz"));
            assertEquals(position2, psc.getParameterPositions("abc"));
            assertEquals(2, psc.getDistinctParameterCount());
            assertEquals(2, psc.getParameterCount());

            psc = new QueryParser("SELECT foo FROM bar WHERE xyz = ':xyz'");
            assertEquals(0, psc.getParameterCount());
            assertEquals("SELECT foo FROM bar WHERE xyz = ':xyz'", psc.getSql());
            assertNull(psc.getParameterPositions("xyz"));
            assertEquals(0, psc.getDistinctParameterCount());
            assertEquals(0, psc.getParameterCount());

            psc = new QueryParser("SELECT foo FROM bar WHERE xyz = '\":xyz'\"");
            assertEquals(0, psc.getParameterCount());
            assertEquals("SELECT foo FROM bar WHERE xyz = '\":xyz'\"", psc.getSql());
            assertNull(psc.getParameterPositions("xyz"));
            assertEquals(0, psc.getDistinctParameterCount());
            assertEquals(0, psc.getParameterCount());

            psc = new QueryParser("SELECT foo FROM bar WHERE xyz = :xyz AND xyz2 = :xyz");
            assertEquals(2, psc.getParameterCount());
            assertEquals("SELECT foo FROM bar WHERE xyz = ? AND xyz2 = ?", psc.getSql());
            assertEquals(position12, psc.getParameterPositions("xyz"));
            assertEquals(1, psc.getDistinctParameterCount());
            assertEquals(2, psc.getParameterCount());

            psc = new QueryParser("SELECT foo FROM bar WHERE xyz = :xyz AND abc = :abc AND xyz2 = :xyz");
            assertEquals(3, psc.getParameterCount());
            assertEquals("SELECT foo FROM bar WHERE xyz = ? AND abc = ? AND xyz2 = ?", psc.getSql());
            assertEquals(position13, psc.getParameterPositions("xyz"));
            assertEquals(position2, psc.getParameterPositions("abc"));
            assertEquals(2, psc.getDistinctParameterCount());
            assertEquals(3, psc.getParameterCount());
       }
        catch (CharmException e)
        {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
               
        
    }
}