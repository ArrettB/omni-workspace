package charm.hibernate.tools;

import java.lang.reflect.Field;
import java.lang.reflect.Modifier;
import java.sql.SQLException;
import java.sql.Types;
import java.util.HashMap;
import java.util.Map;

import org.hibernate.MappingException;

/**
 * @version $Id: JDBCToHibernateTypeHelper.java 334 2008-07-25 20:06:33Z john.cicchese $
 */
public final class JDBCToHibernateTypeHelper
{

	private JDBCToHibernateTypeHelper()
	{

	}

	/** The Map containing the preferred conversion type values. */
	private static final Map PREFERRED_HIBERNATETYPE_FOR_SQLTYPE = new HashMap();

	static
	{
		PREFERRED_HIBERNATETYPE_FOR_SQLTYPE.put(new Integer(Types.TINYINT), "byte");
		PREFERRED_HIBERNATETYPE_FOR_SQLTYPE.put(new Integer(Types.SMALLINT), "short");
		PREFERRED_HIBERNATETYPE_FOR_SQLTYPE.put(new Integer(Types.INTEGER), "integer");
		PREFERRED_HIBERNATETYPE_FOR_SQLTYPE.put(new Integer(Types.BIGINT), "long");
		PREFERRED_HIBERNATETYPE_FOR_SQLTYPE.put(new Integer(Types.REAL), "float");
		PREFERRED_HIBERNATETYPE_FOR_SQLTYPE.put(new Integer(Types.FLOAT), "double");
		PREFERRED_HIBERNATETYPE_FOR_SQLTYPE.put(new Integer(Types.DOUBLE), "double");
		PREFERRED_HIBERNATETYPE_FOR_SQLTYPE.put(new Integer(Types.DECIMAL), "big_decimal");
		PREFERRED_HIBERNATETYPE_FOR_SQLTYPE.put(new Integer(Types.NUMERIC), "big_decimal");
		PREFERRED_HIBERNATETYPE_FOR_SQLTYPE.put(new Integer(Types.BIT), "boolean");
		PREFERRED_HIBERNATETYPE_FOR_SQLTYPE.put(new Integer(Types.BOOLEAN), "boolean");
		PREFERRED_HIBERNATETYPE_FOR_SQLTYPE.put(new Integer(Types.CHAR), "character");
		PREFERRED_HIBERNATETYPE_FOR_SQLTYPE.put(new Integer(Types.VARCHAR), "string");
		PREFERRED_HIBERNATETYPE_FOR_SQLTYPE.put(new Integer(Types.LONGVARCHAR), "string");
		PREFERRED_HIBERNATETYPE_FOR_SQLTYPE.put(new Integer(Types.BINARY), "binary");
		PREFERRED_HIBERNATETYPE_FOR_SQLTYPE.put(new Integer(Types.VARBINARY), "binary");
		PREFERRED_HIBERNATETYPE_FOR_SQLTYPE.put(new Integer(Types.LONGVARBINARY), "binary");
		PREFERRED_HIBERNATETYPE_FOR_SQLTYPE.put(new Integer(Types.DATE), "date");
		PREFERRED_HIBERNATETYPE_FOR_SQLTYPE.put(new Integer(Types.TIME), "time");
		PREFERRED_HIBERNATETYPE_FOR_SQLTYPE.put(new Integer(Types.TIMESTAMP), "timestamp");
		PREFERRED_HIBERNATETYPE_FOR_SQLTYPE.put(new Integer(Types.CLOB), "clob");
		PREFERRED_HIBERNATETYPE_FOR_SQLTYPE.put(new Integer(Types.BLOB), "blob");

		//Hibernate does not have any built-in Type for these:
		//preferredJavaTypeForSqlType.put(new Integer(Types.ARRAY), "java.sql.Array");
		//preferredJavaTypeForSqlType.put(new Integer(Types.REF), "java.sql.Ref");
		//preferredJavaTypeForSqlType.put(new Integer(Types.STRUCT), "java.lang.Object");
		//preferredJavaTypeForSqlType.put(new Integer(Types.JAVA_OBJECT), "java.lang.Object");
	}

	/* (non-Javadoc)
	 * @see org.hibernate.cfg.JDBCTypeToHibernateTypesStrategy#getPreferredHibernateType(int, int, int, int)
	 */
	public static String getPreferredHibernateType(int sqlType, int size, int precision, int scale)
	{
		if ((sqlType == Types.DECIMAL || sqlType == Types.NUMERIC) && scale <= 0)
		{ // <= 
			if (precision == 1)
			{
				// NUMERIC(1) is a often used idiom for storing boolean thus providing it out of the box.
				return "boolean";
			}
			else if (precision < 3)
			{
				return "byte";
			}
			else if (precision < 5)
			{
				return "short";
			}
			else if (precision < 10)
			{
				return "integer";
			}
			else if (precision < 19)
			{
				return "long";
			}
			else
			{
				return "big_decimal";
			}
		}

		if (sqlType == Types.CHAR && size > 1)
		{
			return "string";
		}
		String result = (String) PREFERRED_HIBERNATETYPE_FOR_SQLTYPE.get(new Integer(sqlType));

		return result;
	}

	static Map jdbcTypes; // Name to value
	static Map jdbcTypeValues; // value to Name

	public static String[] getJDBCTypes()
	{
		checkTypes();

		return (String[]) jdbcTypes.keySet().toArray(new String[jdbcTypes.size()]);
	}

	public static int getJDBCType(String value)
	{
		checkTypes();

		Integer number = (Integer) jdbcTypes.get(value);

		if (number == null)
		{
			try
			{
				return Integer.parseInt(value);
			}
			catch (NumberFormatException nfe)
			{
				throw new MappingException("jdbc-type: " + value + " is not a known JDBC Type nor a valid number");
			}
		}
		else
		{
			return number.intValue();
		}
	}

	private static void checkTypes()
	{
		if (jdbcTypes == null)
		{
			jdbcTypes = new HashMap();
			Field[] fields = Types.class.getFields();
			for (int i = 0; i < fields.length; i++)
			{
				Field field = fields[i];
				if (Modifier.isStatic(field.getModifiers()))
				{
					try
					{
						jdbcTypes.put(field.getName(), field.get(Types.class));
					}
					catch (IllegalArgumentException e)
					{
						// ignore						
					}
					catch (IllegalAccessException e)
					{
						// ignore					
					}
				}
			}
		}
	}

	public static String getJDBCTypeName(int value)
	{
		if (jdbcTypeValues == null)
		{
			jdbcTypeValues = new HashMap();
			Field[] fields = Types.class.getFields();
			for (int i = 0; i < fields.length; i++)
			{
				Field field = fields[i];
				if (Modifier.isStatic(field.getModifiers()))
				{
					try
					{
						jdbcTypeValues.put(field.get(Types.class), field.getName());
					}
					catch (IllegalArgumentException e)
					{
						// ignore						
					}
					catch (IllegalAccessException e)
					{
						// ignore					
					}
				}
			}
		}

		String name = (String) jdbcTypeValues.get(new Integer(value));

		if (name != null)
		{
			return name;
		}
		else
		{
			return "" + value;
		}
	}

	/**
	 * @param table
	 * @param schema
	 * @param catalog
	 * @throws SQLException
	 */

	//		 scale and precision have numeric column
	public static boolean typeHasScaleAndPrecision(int sqlType)
	{
		return (sqlType == Types.DECIMAL || sqlType == Types.NUMERIC || sqlType == Types.REAL || sqlType == Types.FLOAT || sqlType == Types.DOUBLE);
	}

	// length is for string column
	public static boolean typeHasLength(int sqlType)
	{
		return (sqlType == Types.CHAR || sqlType == Types.DATE || sqlType == Types.LONGVARCHAR || sqlType == Types.TIME
				|| sqlType == Types.TIMESTAMP || sqlType == Types.VARCHAR);
	}
}