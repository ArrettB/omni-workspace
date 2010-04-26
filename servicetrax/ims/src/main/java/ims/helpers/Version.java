package ims.helpers;


import java.io.File;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.util.diagnostics.Diagnostics;

public class Version
{

	public static void addVersion(InvocationContext ic, ConnectionWrapper conn, String projectID, String documentID, String userID, String versionCode, String versionComments, String filename, String extension) throws Exception
	{
		Diagnostics.debug("Version.addVersion()");
		Diagnostics.debug("projectID=" + projectID);

		String docDirPath = (String)ic.getRequiredAppGlobalDatum("documentDir");
		String tempDirPath = (String)ic.getRequiredAppGlobalDatum("tempDir");

		//make sure our root level directory exists
		File documentDir = new File(docDirPath);
		Diagnostics.debug("Verifying " + documentDir);
		if (!documentDir.exists())
		{
			documentDir.mkdir();
		}

		//make sure our project directory exists
		File projectDir = new File(documentDir, projectID);
		Diagnostics.debug("Verifying " + projectDir);
		if (!projectDir.exists())
		{
			projectDir.mkdir();
		}

		//get reference to our temp file
		File tempDir = new File(tempDirPath);
		File tempFile = new File(tempDir, filename);
		Diagnostics.debug("Verifying " + tempFile);
		if (!tempFile.exists())
		{
			Diagnostics.error("Error - " + tempDir + filename + " does not exist");
		}

		//determine new file name, and delete if it exists for some reason
		String newFileName = documentID + "_" + versionCode + extension;
		File newFile = new File(projectDir, newFileName);
		if (newFile.exists())
		{
			newFile.delete();
		}

		//rename/move the the tempfile
		Diagnostics.debug(tempFile + " will be renamed to " + newFile);
		tempFile.renameTo(newFile);

		//Insert a row into versions
		StringBuffer insert = new StringBuffer();
		insert.append("INSERT INTO versions (document_id, code, comments, num_downloads, created_by, date_created)");
		insert.append(" VALUES (").append(documentID);
		insert.append(", ").append(conn.toSQLString(versionCode));
		insert.append(", ").append(conn.toSQLString(versionComments));
		insert.append(", 0");
		insert.append(", ").append(userID);
		insert.append(", getDate()");
		insert.append(")");

		conn.updateExactlyEx(insert, 1);


	}
}