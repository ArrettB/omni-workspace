// Decompiled by Jad v1.5.8f. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.kpdus.com/jad.html
// Decompiler options: packimports(3) 
// Source File Name:   StringUtil.java

package dynamic.util.string;

import dynamic.dbtk.FieldValidator;
import dynamic.util.date.StdDate;
import dynamic.util.diagnostics.Diagnostics;

import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.text.ParseException;
import java.util.Enumeration;
import java.util.StringTokenizer;
import java.util.Vector;

public class StringUtil
{
    public static final String PSTMT_TAG_START = "'<#?";
   	public static final String PSTMT_TAG_END = "?#>'";
   	public static final int PSTMT_TAG_SIZE = 4;
    public static final String PSTMT_TYPE_INT = "I";
   	public static final String PSTMT_TYPE_STRING = "S";
   	public static final String PSTMT_TYPE_FORCE_STRING = "F";
   	public static final int PSTMT_TYPE_SIZE = 1;

    private StringUtil()
    {
    }

    public static String append(String s, String s2)
    {
        if(s == null)
            return s2;
        if(s2 == null)
            return s;
        else
            return s + s2;
    }

    public static String prepend(String s, String s2)
    {
        if(s == null)
            return s2;
        if(s2 == null)
            return s;
        else
            return s2 + s;
    }

    public static String surround(String s, String s2)
    {
        if(s == null)
            return s2;
        if(s2 == null)
            return s;
        else
            return s2 + s + s2;
    }

    public static int length(String s)
    {
        return s != null ? s.length() : 0;
    }

    public static int length(String s, int max_length)
    {
        int result = length(s);
        return result <= max_length ? result : max_length;
    }

    public static int length(String s, int min_length, int max_length)
    {
        int result = length(s, max_length);
        return result >= min_length ? result : min_length;
    }

    public static String truncate(String s, int length)
    {
        if(s == null)
            return null;
        if(s.length() <= length)
            return s;
        else
            return s.substring(0, length);
    }

    public static String rightPad(String s, int length)
    {
        return rightPad(s, length, ' ');
    }

    public static String leftPad(String s, int length)
    {
        return leftPad(s, length, ' ');
    }

    public static String rightPad(String s, int length, char c)
    {
        s = truncate(s, length);
        StringBuffer result = new StringBuffer(length);
        result.append(s);
        for(int i = 0; i < length - s.length(); i++)
            result.append(c);

        return result.toString();
    }

    public static String leftPad(String s, int length, char c)
    {
        s = truncate(s, length);
        StringBuffer result = new StringBuffer(length);
        for(int i = 0; i < length - s.length(); i++)
            result.append(c);

        result.append(s);
        return result.toString();
    }

    public static Vector stringToVector(String input)
    {
        if(input == null)
            return null;
        char delim;
        if(input.indexOf(";") != -1)
            delim = ';';
        else
        if(input.indexOf(",") != -1)
            delim = ',';
        else
            delim = ';';
        return stringToVector(input, delim);
    }

    public static Vector stringToVector(String input, char delim)
    {
        if(input == null)
            return null;
        Vector v = new Vector();
        int lastIdx = 0;
        for(int nextIdx = 0; (nextIdx = input.indexOf(delim, lastIdx)) != -1;)
        {
            v.addElement(input.substring(lastIdx, nextIdx));
            lastIdx = nextIdx + 1;
        }

        if(v.size() == 0 || lastIdx < input.length())
            v.addElement(input.substring(lastIdx));
        return v;
    }

    public static Enumeration stringToEnum(String input, char delim)
    {
        Vector tmp = stringToVector(input, delim);
        return tmp != null ? tmp.elements() : null;
    }

    public static Enumeration stringToEnum(String input)
    {
        Vector tmp = stringToVector(input);
        return tmp != null ? tmp.elements() : null;
    }

    public static String vectorToString(Vector input, char delim)
    {
        StringBuffer sb = new StringBuffer();
        for(int i = 0; i < input.size(); i++)
        {
            if(i > 0)
                sb.append(delim);
            sb.append(input.elementAt(i));
        }

        return sb.toString();
    }

    public static String[] stringToArray(String input, char delim)
    {
        if(input == null)
        {
            return null;
        } else
        {
            Vector v = stringToVector(input, delim);
            String result[] = new String[v.size()];
            v.copyInto(result);
            return result;
        }
    }

    public static String arrayToString(Object input[], char delim)
    {
        StringBuffer sb = new StringBuffer();
        for(int i = 0; i < input.length; i++)
        {
            if(i > 0)
                sb.append(delim);
            sb.append("" + input[i]);
        }

        return sb.toString();
    }

    public static String replaceString(String original, String strToReplace, String strReplaceWith)
    {
        if(original == null)
            return null;
        int replaceCt = 0;
        int searchStrLength = strToReplace.length();
        StringBuffer outBuffer = new StringBuffer();
        int lastIdx = 0;
        for(int nextIdx = 0; (nextIdx = original.indexOf(strToReplace, lastIdx)) != -1;)
        {
            outBuffer.append(original.substring(lastIdx, nextIdx));
            outBuffer.append(strReplaceWith);
            lastIdx = nextIdx + searchStrLength;
            replaceCt++;
        }

        outBuffer.append(original.substring(lastIdx));
        return outBuffer.toString();
    }

    public static String toInitialCaps(String s)
    {
        if(s == null)
            return null;
        StringTokenizer st = new StringTokenizer(s);
        StringBuffer result = new StringBuffer();
        String a_substring;
        for(; st.hasMoreTokens(); result.append(a_substring.substring(0, 1).toUpperCase() + a_substring.substring(1) + " "))
            a_substring = st.nextToken();

        if(result.length() > 0)
            result.deleteCharAt(result.length() - 1);
        return result.toString();
    }

    public static String toMixedCase(String s)
    {
        if(s == null)
            return null;
        s = s.toLowerCase();
        StringTokenizer st = new StringTokenizer(s);
        StringBuffer result = new StringBuffer();
        String a_substring;
        for(; st.hasMoreTokens(); result.append(a_substring.substring(0, 1).toUpperCase() + a_substring.substring(1) + " "))
            a_substring = st.nextToken();

        if(result.length() > 0)
            result.deleteCharAt(result.length() - 1);
        return result.toString();
    }
    
    /**
     * Force the string to uppercase.
     * Is null safe.
     * @param s
     * @return
     */
    public static String toUpperCase(String s)
    {
    	if (s == null)
    		return s;
    	return s.toUpperCase();
    }
    
	public static String toPStmtForceString(String s)
	{
		return PSTMT_TAG_START + PSTMT_TYPE_FORCE_STRING + s + PSTMT_TAG_END;
	}

	public static String toPStmtString(String s)
	{
		return PSTMT_TAG_START + PSTMT_TYPE_STRING + s + PSTMT_TAG_END;
	}
	
	public static String toPStmtInt(String s)
	{
		return PSTMT_TAG_START + PSTMT_TYPE_INT + s + PSTMT_TAG_END;
	}
	
	public static String toPStmtInt(int i)
	{
		return PSTMT_TAG_START + PSTMT_TYPE_INT + i + PSTMT_TAG_END;
	}

	
    public static String escapeString(String s, String delimeter, String escaped_delimeter, String null_value)
    {
        if(s == null || s.length() == 0)
            return null_value;
        else
            return delimeter + replaceString(s, delimeter, escaped_delimeter) + delimeter;
    }

    public static String toSqlString(String s)
    {
        return toSQLString(s);
    }

    public static String toSQLString(String s)
    {
        return escapeString(s, "'", "''", "NULL");
    }

    public static String toJavaScriptString(String s)
    {
        String result = s;
        result = replaceString(result, "\\", "\\\\");
        return escapeString(result, "'", "\\'", "''");
    }

    public static String toJavaScriptString2(String s)
    {
        String result = toJavaScriptString(s);
        result = replaceString(result, "\\", "\\\\");
        result = replaceString(result, "\"", "\\\"");
        return result;
    }

    public static String toHTMLString(String s)
    {
        if(s == null)
            s = "";
        return "\"" + toHTML(s) + "\"";
    }

    public static String toHTML(String s)
    {
        String result = s;
        result = replaceString(result, "&#", "<~-~-~>");
        result = replaceString(result, "&", "&amp;");
        result = replaceString(result, "<~-~-~>", "&#");
        result = replaceString(result, "<", "&lt;");
        result = replaceString(result, ">", "&gt;");
        result = replaceString(result, "\"", "&quot;");
        result = replaceString(result, "\r\n", "&#13;");
        result = replaceString(result, "\n", "&#13;");
        return result;
    }

    public static String toHTML2(String s)
    {
        String result = s;
        result = replaceString(result, "&#", "<~-~-~>");
        result = replaceString(result, "&", "&amp;");
        result = replaceString(result, "<~-~-~>", "&#");
        result = replaceString(result, "<", "&lt;");
        result = replaceString(result, ">", "&gt;");
        result = replaceString(result, "\"", "&quot;");
        result = replaceString(result, "\r\n", "<BR>");
        result = replaceString(result, "\n", "<BR>");
        return result;
    }

    public static String toURL(String s)
    {
    	String result = null;
        if(s != null)
        {
            try
			{
				result = URLEncoder.encode(s, "UTF-8");
			}
			catch (UnsupportedEncodingException ignore){}
        }
        return result;
    }

    public static boolean toBoolean(String s)
    {
        if(s == null)
            return false;
        return s.equalsIgnoreCase("on") || s.equalsIgnoreCase("yes") || s.equalsIgnoreCase("true") || s.equalsIgnoreCase("T") || s.equalsIgnoreCase("Y");
    }

    public static String appendUnique(String s1, String s2, char delim)
    {
        if(s1 == null || s1.length() == 0)
            return s2;
        if(s2 == null || s2.length() == 0)
        {
            return s1;
        } else
        {
            Vector v1 = stringToVector(s1, delim);
            Vector v2 = stringToVector(s2, delim);
            return vectorToString(appendUnique(v1, v2), delim);
        }
    }

    public static Vector appendUnique(Vector v1, Vector v2)
    {
        for(int i = 0; i < v2.size(); i++)
        {
            String s = (String)v2.elementAt(i);
            if(!v1.contains(s))
                v1.addElement(s);
        }

        return v1;
    }

    public static String formatDate(String s)
        throws ParseException
    {
        if(s == null || s.length() == 0)
            return "";
        else
            return (new StdDate(s)).toString();
    }

    public static String formatDate(String s, String format)
        throws ParseException
    {
        if(s == null || s.length() == 0)
            return "";
        else
            return (new StdDate(s)).toString(format);
    }

    public static String toFileName(String name)
    {
        name = replaceString(name, "\"", "_");
        name = replaceString(name, "/", "_");
        name = replaceString(name, ":", "_");
        name = replaceString(name, "?", "_");
        name = replaceString(name, "\"", "_");
        name = replaceString(name, "<", "_");
        name = replaceString(name, ">", "_");
        name = replaceString(name, "/", "_");
        name = replaceString(name, " ", "_");
        return name;
    }

    public static String getDigits(String s, boolean isNumber)
    {
        if(s != null)
            s = s.trim();
        if(s == null || s.length() == 0)
            return "";
        String result = "";
        for(int i = 0; i < s.length(); i++)
        {
            char c = s.charAt(i);
            if(c >= '0' && c <= '9' || isNumber && (c == '.' || c == '-'))
                result = result + c;
        }

        return result;
    }

    public static String getDBPercent(String s, String numDecimals, boolean divide)
    {
        if(s != null)
            s = s.trim();
        if(s == null || s.length() == 0)
            return "";
        int start_index = 0;
        int end_index = s.length();
        boolean is_negative = false;
        if(s.indexOf("(") >= 0)
        {
            start_index = s.indexOf("(") + 1;
            is_negative = true;
        }
        if(s.indexOf(")") > 0)
            end_index = s.indexOf(")");
        if(s.indexOf("%") > 0)
            end_index = s.indexOf("%");
        String result = s.substring(start_index, end_index);
        if(FieldValidator.validateNumber(result))
        {
            BigDecimal value = new BigDecimal(result);
            if(divide)
                value = value.movePointLeft(2);
            if(numDecimals != null && FieldValidator.validateNumber(numDecimals))
            {
                int new_numDecimals = (new Integer(numDecimals)).intValue();
                if(new_numDecimals < 0)
                {
                    Diagnostics.error("Cannot set number of decimals to less then 0.");
                    new_numDecimals = 0;
                }
                if(!divide)
                    new_numDecimals += 2;
                value = value.setScale(new_numDecimals, 6);
            }
            if(is_negative)
                value = value.negate();
            return value.toString();
        } else
        {
            return null;
        }
    }

    public static boolean hasAValue(String s)
    {
        return s != null && s.trim().length() > 0 && !s.trim().equalsIgnoreCase("NULL");
    }

    public static String isNull(String original, String replacement)
    {
        return hasAValue(original) ? original : replacement;
    }

    public static String isNotNull(String original, String replacement)
    {
        StringBuffer result = new StringBuffer();
        if(hasAValue(original))
            if(replacement != null && replacement.indexOf("$x$") != -1)
            {
                for(StringTokenizer phrase_parts = new StringTokenizer(replacement, "$x$"); phrase_parts.hasMoreTokens(); result.append(phrase_parts.nextToken() + original));
            } else
            {
                result.append(replacement + original);
            }
        return result.toString();
    }

    public static String isNullAnd(String original, String replacement, String extra_clause)
    {
        return hasAValue(original) ? original : replacement + " " + extra_clause;
    }

    public static String isNullLike(String original, String replacement)
    {
        return isNullLikeAnd(original, replacement, null);
    }

    public static String isNullLikeAnd(String original, String replacement, String extra_clause)
    {
        String clause = null;
        if(hasAValue(original))
        {
            clause = " = " + original;
        } 
        else
        {
            if(hasAValue(replacement))
            {
                if(replacement.equals("%"))
                    replacement = toSQLString(replacement);
                clause = " LIKE " + replacement;
            } 
            else
            {
                clause = " IS NULL";
            }
            if(hasAValue(extra_clause))
                clause = clause + " " + extra_clause;
        }
        return clause;
    }

    public static String isNullSQLString(String original, String replacement)
    {
        return hasAValue(original) ? toSQLString(original) : replacement.equalsIgnoreCase("null") ? replacement : toSQLString(replacement);
    }

    public static String isNotNullSQLString(String original, String replacement)
    {
        return isNotNull(toSQLString(original), replacement);
    }

    public static String isNullSQLStringAnd(String original, String replacement, String extra_clause)
    {
        return hasAValue(original) ? toSQLString(original) : replacement.equalsIgnoreCase("null") ? replacement + " " + extra_clause : toSQLString(replacement) + " " + extra_clause;
    }

    public static String isNullSQLStringLike(String original, String replacement)
    {
        return isNullSQLStringLikeAnd(original, replacement, null);
    }

    public static String isNullSQLStringLikeAnd(String original, String replacement, String extra_clause)
    {
        String clause = null;
        if(hasAValue(original))
        {
            clause = " = " + toSQLString(original);
        } else
        {
            if(hasAValue(replacement) && !replacement.equalsIgnoreCase("null"))
            {
                replacement = toSQLString(replacement);
                clause = " LIKE " + replacement;
            } else
            {
                clause = " IS NULL";
            }
            if(hasAValue(extra_clause))
                clause = clause + " " + extra_clause;
        }
        return clause;
    }

    public static String ifThen(String original, String compare_string, String then_string)
    {
        String result = original;
        if(hasAValue(original))
        {
            if(original.equalsIgnoreCase(compare_string))
                result = then_string;
        } else
        if(!hasAValue(compare_string))
            result = then_string;
        return result;
    }

    public static String ifThenSQLString(String original, String compare_string, String then_string)
    {
        return toSQLString(ifThen(original, compare_string, then_string));
    }

    public static String ifThen(String original, int compare, String then_string)
    {
        String result = original;
        Diagnostics.error("orginal='" + original + "', then_string='" + then_string + "'");
        if(hasAValue(original) && (new Float(original)).floatValue() == (float)compare)
            result = then_string;
        return result;
    }

    public static String ifThen(String original, String compare_string, String then_string, String else_string)
    {
        String result = else_string;
        if(hasAValue(original))
        {
            if(original.equalsIgnoreCase(compare_string))
                result = then_string;
        } else
        if(!hasAValue(compare_string))
            result = then_string;
        return result;
    }

    public static String ifThenSQLString(String original, String compare_string, String then_string, String else_string)
    {
        return toSQLString(ifThen(original, compare_string, then_string, else_string));
    }

    public static String toHex(String s)
    {
        StringBuffer result = new StringBuffer();
        byte b[] = s.getBytes();
        for(int i = 0; i < b.length; i++)
        {
            result.append(Integer.toHexString(b[i] >> 4 & 0xf));
            result.append(Integer.toHexString(b[i] & 0xf));
        }

        return result.toString();
    }

    /**
     * Tests a char object to see if it is whitespace.  A shortcut for Character.isWhitespace()
     *
     * @param c the char to test
     *
     * @return true if the character is whitespace
     *
     * @see java.lang.Character#isWhitespace(char)
     */
    public static boolean isWhitespace(char c)
    {
        return Character.isWhitespace(c);
    }

    public static final void main(String args[])
    {
        try
        {
            String foo = "Bill said 'Hello World'";
            foo = replaceString(foo, "'", "''");
            foo = replaceString(foo, "Hello", "Goodbye");
            foo = replaceString(foo, "World", "Cruel World");
            foo = replaceString(foo, "Bill", "Fred");
            Diagnostics.debug(foo);
            String foo3 = "This's a test of \"escaping\" strings.";
            Diagnostics.debug(foo3);
            Diagnostics.debug(toSQLString(foo3));
            Diagnostics.debug(toURL(foo3));
            Diagnostics.debug(toJavaScriptString(foo3));
            Diagnostics.debug(toHTMLString(foo3));
            Diagnostics.debug(vectorToString(stringToVector("a,b,c"), '|'));
            Diagnostics.debug(vectorToString(stringToVector("a,b;c,d;e,f,g"), '|'));
            Diagnostics.debug(vectorToString(stringToVector("a;"), '|'));
            Diagnostics.debug(appendUnique(null, "b;d;c", ';'));
            Diagnostics.debug(appendUnique("a;b;c", null, ';'));
            Diagnostics.debug(appendUnique("a;b;c", "b;c;d", ';'));
        }
        catch(Throwable t)
        {
            Diagnostics.error("Problem", t);
        }
        System.exit(0);
    }
}
