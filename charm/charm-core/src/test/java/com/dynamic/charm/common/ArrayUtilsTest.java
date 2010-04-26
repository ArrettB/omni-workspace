/*
 *               Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.

 * Copyright 2005, Dynamic Information Systems, LLC
 * $Id: ArrayUtilsTest.java 33 2005-11-04 15:56:55Z gcase $

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
package com.dynamic.charm.common;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import junit.framework.TestCase;



/**
 * @author gcase
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class ArrayUtilsTest extends TestCase
{
    private Object[] emptyArray;
    private Object[] length1A;
    private Object[] length1B;
    private Object[] length2A;
    private Object[] length2B;
    private Object[] nullArray1;
    private Object[] nullArray2;

    private List nullList;
  	private List emptyList;
  	private String[] colorArray;
  	private List colorList;
    
    protected void setUp() throws Exception
    {
        emptyArray = new Object[0];
        length1A = new Object[1];
        length1B = new Object[1];
        length2A = new Object[2];
        length2B = new Object[2];

        nullArray1 = null;
        nullArray2 = null;
 
        emptyList = new ArrayList();
        
        colorArray = new String[3];
        colorArray[0] = "Red";
        colorArray[1] = "Green";
        colorArray[2] = "Blue";
           	
        colorList = new ArrayList();
       	colorList.add("Red");
       	colorList.add("Green");
       	colorList.add("Blue");    
    }

    public void testIsCompatible()
    {
        //nulls arrays are compatible
        assertTrue(ArrayUtils.isCompatible(nullArray1, nullArray2));
        assertTrue(ArrayUtils.isCompatible(nullArray2, nullArray1));
        
        // a null array is not compatible with an empty array
        assertFalse(ArrayUtils.isCompatible(emptyArray, nullArray1));
        assertFalse(ArrayUtils.isCompatible(nullArray1, emptyArray));
      
        // a null array is not compatible with an non-empty array
        assertFalse(ArrayUtils.isCompatible(emptyArray, length1A));
        assertFalse(ArrayUtils.isCompatible(length1A, emptyArray));
          
        //arrays of equal size are compatible
        assertTrue(ArrayUtils.isCompatible(length1A, length1B));
        assertTrue(ArrayUtils.isCompatible(length1B, length1A));
    
        //arrays of un equal size are not compatible
        assertFalse(ArrayUtils.isCompatible(length1A, length2A));
        assertFalse(ArrayUtils.isCompatible(length2A, length1A));
   
    }
    
    public void testCopyToList()
    {
    	assertNull(ArrayUtils.copyToList(null));
       	assertNull(ArrayUtils.copyToList(nullArray1));
       	
     	assertEquals(ArrayUtils.copyToList(emptyArray), emptyList);
     	assertEquals(ArrayUtils.copyToList(colorArray), colorList);
           	
    }
    
    public void testToArray()
    {
       	assertNull(ArrayUtils.toArray(null, Object.class));
       	assertNull(ArrayUtils.toArray(nullList, Object.class));
    	
       	assertTrue(Arrays.equals(ArrayUtils.toArray(colorList, String.class), colorArray));
    	
    }
    
    public void testToString()
    {
    	assertEquals(ArrayUtils.toString(null, "foo"), "foo[] is null");
    	assertEquals(ArrayUtils.toString(nullArray1, "foo"), "foo[] is null");
    	assertEquals(ArrayUtils.toString(emptyArray, "foo"), "foo[] is empty");
    }
    
}