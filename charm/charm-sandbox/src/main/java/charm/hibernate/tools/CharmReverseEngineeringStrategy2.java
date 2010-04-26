package charm.hibernate.tools;

import java.beans.Introspector;
import java.util.List;

import org.apache.log4j.Logger;
import org.hibernate.cfg.reveng.DelegatingReverseEngineeringStrategy;
import org.hibernate.cfg.reveng.JDBCToHibernateTypeHelper;
import org.hibernate.cfg.reveng.ReverseEngineeringStrategy;
import org.hibernate.cfg.reveng.TableIdentifier;
import org.hibernate.mapping.Column;
import org.hibernate.util.StringHelper;

public class CharmReverseEngineeringStrategy2 extends DelegatingReverseEngineeringStrategy
{
	private final static Logger logger = Logger.getLogger(CharmReverseEngineeringStrategy2.class);

	public CharmReverseEngineeringStrategy2(ReverseEngineeringStrategy delegate)
	{
		super(delegate);
		System.out.println("delegate = " + delegate);
	}


	public String tableToClassName(TableIdentifier table)
	{
//		System.out.println("tableToClassName");
		String result = super.tableToClassName(table);
		// if (result.toLowerCase().startsWith("bbp"))
		// {
		// System.out.println("removing bbp");
		// result = result.substring(3);
		// result = Character.toUpperCase(result.charAt(0)) +
		// result.substring(1);
		// }
		return singularise(result);

		// return singularise(super.tableToClassName(table));
	}



	public String foreignKeyToCollectionName(String keyname, TableIdentifier fromTable, List fromColumns, TableIdentifier referencedTable, List referencedColumns, boolean uniqueReference)
	{
		System.out.println("foreignKeyToCollectionName");

		String propertyName = Introspector.decapitalize(StringHelper.unqualify(tableToClassName(fromTable)));

		if (!seemsPluralised(propertyName))
		{
			propertyName = pluralise(propertyName);
		}

		if (!uniqueReference)
		{
			if (fromColumns != null && fromColumns.size() == 1)
			{
				String columnName = ((Column) fromColumns.get(0)).getName();
				propertyName = propertyName + "For" + toUpperCamelCase(columnName);
			}
			else
			{ // composite key or no columns at all safeguard
				propertyName = propertyName + "For" + toUpperCamelCase(keyname);
			}
		}
		return propertyName;
	}

	public String foreignKeyToEntityName(String keyname, TableIdentifier fromTable, List fromColumnNames, TableIdentifier referencedTable, List referencedColumnNames, boolean uniqueReference)
	{
		System.out.println("foreignKeyToEntityName");
		String singular = singularise(StringHelper.unqualify(tableToClassName(referencedTable)));
		String simpleName = Introspector.decapitalize(singular);
		String propertyName = simpleName;

		if (fromColumnNames != null && fromColumnNames.size() == 1)
		{
			String columnName = ((Column) fromColumnNames.get(0)).getName();
			propertyName = propertyName + "By" + toUpperCamelCase(columnName);
		}
		else
		{ // composite key or no columns at all safeguard
			propertyName = propertyName + "By" + toUpperCamelCase(keyname);
		}

		// Make the generated name reflect the column name for the foreign key,
		// and use the simple name only if the relationship is unique
		// and the simple name is part of the FK column name.
		if (uniqueReference && propertyName.toLowerCase().lastIndexOf(simpleName.toLowerCase()) > 0)
			propertyName = simpleName;

		return propertyName;
	}

	public static String singularise(String name)
	{
		if (name.toLowerCase().endsWith("audit"))
		{
			String normal = name.substring(0, name.length() - "audit".length());
			String result = singularise(normal) + "Audit";
			System.out.println("auditname:" + result);
			return result;
		}
		else
		{
			String result = name;
			if (seemsPluralised(name))
			{
				String lower = name.toLowerCase();
				if (lower.endsWith("ies"))
				{
					// cities --> city
					result = name.substring(0, name.length() - 3) + "y";
				}
				else if (lower.endsWith("ches"))
				{
					// switches --> switch
					result = name.substring(0, name.length() - 2);
				}
				else if (lower.endsWith("s"))
				{
					// customers --> customer
					result = name.substring(0, name.length() - 1);
				}
			}
			logger.debug("singularised " + name + " to " + result);
			return result;
		}
	}

	public static String pluralise(String name)
	{
		logger.debug("pluralise:" + name);
		String result = name;
		if (name.length() == 1)
		{
			// just append 's'
			result += 's';
		}
		else
		{
			if (!seemsPluralised(name))
			{
				String lower = name.toLowerCase();
				char last = name.charAt(name.length() - 1);
				char secondLast = lower.charAt(name.length() - 2);
				if (last == 'x')
					result = name + "es";
				else if (last == 's')
					result = name + "es";
				else if (last == 'y' && !isVowel(secondLast))
				{
					// city, body etc --> cities, bodies
					result = name.substring(0, name.length() - 1) + "ies";
				}
				else if (lower.endsWith("ch"))
				{
					// switch --> switches
					result = name + "es";
				}
				else
				{
					result = name + "s";
				}

			}
		}
		logger.debug("pluralised " + name + " to " + result);
		return result;
	}

	public static boolean isVowel(char c)
	{
		boolean vowel = false;
		vowel |= c == 'a';
		vowel |= c == 'e';
		vowel |= c == 'i';
		vowel |= c == 'o';
		vowel |= c == 'u';
		vowel |= c == 'y'; // sometimes
		return vowel;
	}

	private static boolean seemsPluralised(String name)
	{
		name = name.toLowerCase();
		boolean pluralised = false;
		pluralised |= name.endsWith("es");
		pluralised |= name.endsWith("s");
		pluralised &= !name.endsWith("ss") || !name.endsWith("us");
		System.out.println(name + " is " + (pluralised ? "plural." : "not plural."));
		return pluralised;
	}

	protected String toUpperCamelCase(String s)
	{
		if ("".equals(s))
		{
			return s;
		}
		StringBuffer result = new StringBuffer();

		boolean capitalize = true;
		boolean lastCapital = false;
		boolean lastDecapitalized = false;
		String p = null;
		for (int i = 0; i < s.length(); i++)
		{
			String c = s.substring(i, i + 1);
			if ("_".equals(c) || " ".equals(c) || "-".equals(c))
			{
				capitalize = true;
				continue;
			}

			if (c.toUpperCase().equals(c))
			{
				if (lastDecapitalized && !lastCapital)
				{
					capitalize = true;
				}
				lastCapital = true;
			}
			else
			{
				lastCapital = false;
			}

			// if(forceFirstLetter && result.length()==0) capitalize = false;

			if (capitalize)
			{
				if (p == null || !p.equals("_"))
				{
					result.append(c.toUpperCase());
					capitalize = false;
					p = c;
				}
				else
				{
					result.append(c.toLowerCase());
					capitalize = false;
					p = c;
				}
			}
			else
			{
				result.append(c.toLowerCase());
				lastDecapitalized = true;
				p = c;
			}

		}
		String r = result.toString();
		return r;
	}


}
