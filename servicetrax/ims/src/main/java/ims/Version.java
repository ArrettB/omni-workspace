package ims;

/**
 * ServiceTRAX version info file. Must be updated manually.
 *
 * @version $Id: Version.java 1685 2009-09-11 19:56:21Z bvonhaden $
 */
public class Version
{

	private static final String author = "$Author: kettleriver $";

	private static final String date = "$Date: 2010-08-09 10:52:00 -0500 (Mon, 9 Aug 2010) $";

	private static final String project = "$Project: ServiceTrax$";

	private static final String revision = "$Revision: 122 $";

	private static final String version = "1.41";

	public static String getAuthor()
	{
		return author.substring(9, author.length() - 1);
	}

	public static String getDate()
	{
		String result = getDateTime();
		int i = result.indexOf(" ");
		if (i != -1)
			result = result.substring(0, i);
		return result;
	}

	public static String getDateTime()
	{
		return date.substring("$Date: ".length(), date.length() - 1);
	}

	public static String getTime()
	{
		String result = getDateTime();
		int i = result.indexOf(" ");
		if (i != -1)
			result = result.substring(i + 1, result.length());
		return result;
	}

	public static String getProject()
	{
		return project.substring("$Project: ".length() - 1, project.length() - 1);
	}

	public static String getRevision()
	{
		String result = revision.substring("$Revision: ".length(), revision.length() - 2);
		if (result.length() == 1)
			result = "00" + result;
		if (result.length() == 2)
			result = "0" + result;
		return result;
	}

	public static String getVersion()
	{
		return version + "." + getRevision();
	}

	public static String getFullVersion()
	{
		return getProject() + " " + getVersion() + " (" + getDate() + ")";
	}

	public String toString()
	{
		return getFullVersion();
	}

	public static void main(String argv[])
	{
		System.out.println(getFullVersion());
	}
}
