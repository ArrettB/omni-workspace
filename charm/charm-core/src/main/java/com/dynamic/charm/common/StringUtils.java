/*
 * Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written consent of Dynamic
 * Information Systems. All rights reserved.
 *
 * Copyright 2005, Dynamic Information Systems, LLC $Id: StringUtils.java 199 2006-11-14 23:38:41Z gcase $
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

public class StringUtils
{
    /**
     * <p>
     * Checks if a String is empty ("") or null.
     * </p>
     *
     * <pre>
     *  StringUtils.isEmpty(null)      = true
     *  StringUtils.isEmpty(&quot;&quot;)        = true
     *  StringUtils.isEmpty(&quot; &quot;)       = false
     *  StringUtils.isEmpty(&quot;bob&quot;)     = false
     *  StringUtils.isEmpty(&quot;  bob  &quot;) = false
     * </pre>
     *
     * <p>
     * NOTE: This method changed in Lang version 2.0. It no longer trims the
     * String. That functionality is available in isBlank().
     * </p>
     *
     * @param str
     *            the String to check, may be null
     * @return <code>true</code> if the String is empty or null
     */
    public static boolean isEmpty(String str)
    {
        return org.apache.commons.lang.StringUtils.isEmpty(str);
    }

    /**
     * <p>
     * Checks if a String is not empty ("") and not null.
     * </p>
     *
     * <pre>
     *  StringUtils.isNotEmpty(null)      = false
     *  StringUtils.isNotEmpty(&quot;&quot;)        = false
     *  StringUtils.isNotEmpty(&quot; &quot;)       = true
     *  StringUtils.isNotEmpty(&quot;bob&quot;)     = true
     *  StringUtils.isNotEmpty(&quot;  bob  &quot;) = true
     * </pre>
     *
     * @param str
     *            the String to check, may be null
     * @return <code>true</code> if the String is not empty and not null
     */
    public static boolean isNotEmpty(String str)
    {
        return org.apache.commons.lang.StringUtils.isNotEmpty(str);
    }

    /**
     * <p>
     * Checks if a String is whitespace, empty ("") or null.
     * </p>
     *
     * <pre>
     *  StringUtils.isBlank(null)      = true
     *  StringUtils.isBlank(&quot;&quot;)        = true
     *  StringUtils.isBlank(&quot; &quot;)       = true
     *  StringUtils.isBlank(&quot;bob&quot;)     = false
     *  StringUtils.isBlank(&quot;  bob  &quot;) = false
     * </pre>
     *
     * @param str
     *            the String to check, may be null
     * @return <code>true</code> if the String is null, empty or whitespace
     */
    public static boolean isBlank(String str)
    {
        return org.apache.commons.lang.StringUtils.isBlank(str);
    }

    /**
     * <p>
     * Checks if a String is not empty (""), not null and not whitespace only.
     * </p>
     *
     * <pre>
     *  StringUtils.isNotBlank(null)      = false
     *  StringUtils.isNotBlank(&quot;&quot;)        = false
     *  StringUtils.isNotBlank(&quot; &quot;)       = false
     *  StringUtils.isNotBlank(&quot;bob&quot;)     = true
     *  StringUtils.isNotBlank(&quot;  bob  &quot;) = true
     * </pre>
     *
     * @param str
     *            the String to check, may be null
     * @return <code>true</code> if the String is not empty and not null and
     *         not whitespace
     */
    public static boolean isNotBlank(String str)
    {
        return org.apache.commons.lang.StringUtils.isNotBlank(str);
    }

    public static boolean isLowerCase(String str)
    {
    	if (str == null)
    		return false;
    	char[] letters = str.toCharArray();
        for (int i = 0; i < letters.length; i++)
        {
            if (!Character.isLowerCase(letters[i]))
            {
                return false;
            }
        }
        return true;
    }

    public static boolean isUpperCase(String str)
    {
    	if (str == null)
    		return false;
    	char[] letters = str.toCharArray();
        for (int i = 0; i < letters.length; i++)
        {
            if (!Character.isUpperCase(letters[i]))
            {
                return false;
            }
        }
        return true;
    }

    public static boolean isLowerCaseOrSpace(String str)
    {
    	if (str == null)
    		return false;	
        char[] letters = str.toCharArray();
        for (int i = 0; i < letters.length; i++)
        {
            if (!Character.isLowerCase(letters[i]) && !Character.isWhitespace(letters[i]))
            {
                return false;
            }
        }
        return true;
    }

    public static boolean isUpperCaseOrSpace(String str)
    {
    	if (str == null)
    		return false;
        char[] letters = str.toCharArray();
        for (int i = 0; i < letters.length; i++)
        {
            if (!Character.isUpperCase(letters[i]) && !Character.isWhitespace(letters[i]))
            {
                return false;
            }
        }
        return true;
    }   
    
    
    public static String capitalize(String str)
    {
        return org.apache.commons.lang.StringUtils.capitalize(str);
    }
    
    /**
	*  Returns the string representation of an object.  Returns null if the object is null.
	*/
    public static String toStringNullsAsNull(Object o)
    {
    	return o != null ? o.toString() : null;
    }
    
     /**
	*  Returns the string representation of an object.  Returns an empty string if the object is null.
	*/
    public static String toStringNullsAsEmpty(Object o)
    {
    	return o != null ? o.toString() : "";
    }
    
}
