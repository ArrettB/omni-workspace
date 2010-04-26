/*
 * Dynamic Information Systems, LLC
 * 
 * This software can only be used with the expressed written consent of Dynamic
 * Information Systems. All rights reserved.
 * 
 * Copyright 2005, Dynamic Information Systems, LLC $Id: ArrayUtils.java 160
 * 2005-07-26 13:53:17Z $
 * 
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
 * FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL DYNAMIC
 * INFORMATIONS SYTEMS, LLC BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * ====================================================================
 */

package com.dynamic.charm.common;

import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.List;

/**
 * @author gcase
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class ArrayUtils
{
	/**
	 * Determines if a set of arrays are "compatible"  Compatible meaning 
	 * that the arrays are either both null or have the same length.
	 * @param array1 the first array
	 * @param array2 the second array
	 * @return true if the arrays are compatible
	 */
	public static boolean isCompatible(Object[] array1, Object[] array2)
	{
		if (((array1 != null) && (array2 == null)) || ((array1 == null) && (array2 != null)) || ((array1 != null) && (array1.length != array2.length)))
		{
			return false;
		}
		return true;
	}

	/**
	 * Determines if a set of arrays are "compatible"  Compatible meaning 
	 * that the arrays are either both null or have the same length.
	 * @param array1 the first array
	 * @param array2 the second array
	 * @return true if the arrays are compatible
	 */
	public static boolean isCompatible(Object[] array1, int[] array2)
	{
		if (((array1 != null) && (array2 == null)) || ((array1 == null) && (array2 != null)) || ((array1 != null) && (array1.length != array2.length)))
		{
			return false;
		}
		return true;
	}
	
	/**
	 * Returns a human-readable string representation of the array.   Useful for debugging.
	 * 
	 * @param array
	 * @param arrayName
	 * @return
	 */
	public static String toString(Object[] array, String arrayName)
	{
		StringBuffer result = new StringBuffer();
		if (array == null)
		{
			return arrayName + "[] is null";
		}
		else if (array.length == 0)
		{
			return arrayName + "[] is empty";
		}
		else
		{
			for (int i = 0; i < array.length; i++)
			{
				result.append(arrayName + "[" + i + "] = " + array[i]);
				result.append(Constants.LINE_SEP);
			}
			return result.toString();
		}

	}
	
	/**
	 * Convenience method to convert a collection to an array of the given type and the correct length.
	 * 
	 * @param aCollection, may be null
	 * @param desired type
	 * @return the created array
	 */
	public static Object[] toArray(Collection aCollection, Class desiredType)
	{
		if (aCollection == null)
		{
			return null;
		}
		Object[] result = (Object[]) Array.newInstance(desiredType, aCollection.size());
		result = aCollection.toArray(result);
		return result;
	}
	
	/**
	 * This method performs a shallow copy of the array into a list.  The reason why
	 * one would use this method rather than java.util.Arrays.asList() is that the asList() 
	 * method returns a list that does not support remove or add operations. 
	 * The actual list returned is a java.util.ArrayList
	 * 
	 * @param array The array to copy to a list.  May be null
	 * @return the List, null of the array was null
	 * @see java.util.Arrays#asList
	 * @see java.util.ArrayList
	 */
	public static List copyToList(Object[] array)
	{
		if (array == null)
			return null;
		List result = new ArrayList(array.length);
		for (int i = 0; i < array.length; i++)
		{
			result.add(array[i]);
		}
		return result;
	}
	
	public static Object[] getSortedDistinctValues(Object[] array)
	{
		List distinctList = new ArrayList();
		for (int i = 0; i < array.length; i++)
		{
            if (array[i] != null)
            {
                int index = Collections.binarySearch(distinctList, array[i]);
                if (index < 0)
                {
                    distinctList.add(-index - 1, array[i]);
                }                
            }
		}
		Object[] result = (Object[]) Array.newInstance(Object.class, distinctList.size());
		result = distinctList.toArray(result);
		
		return result;
	}		
	
}
