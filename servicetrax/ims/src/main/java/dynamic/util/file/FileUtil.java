/*
 *               Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.
 *
 * Copyright 2002, Dynamic Information Systems, LLC
 *
 * @header $Revision: 119 $Date: 5/17/2005 8:12:51 AM$
 */

package dynamic.util.file;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.security.MessageDigest;

import dynamic.util.diagnostics.Diagnostics;

/**
 * This class provides a bunch of utilties for file manipulation.
 * 
 * @author Greg Case
 */
public class FileUtil
{

	//~ Static variables/initializers ----------------------------------------------------------------------------------

	/** The block size to read in one shot. */
	private static int BLOCK_SIZE = 4096;

	//~ Methods --------------------------------------------------------------------------------------------------------

	/**
	 * Returns the extension of the given file object
	 * 
	 * @param f
	 * 
	 * @return the result
	 */
	public static String getExtension(File f)
	{
		String name = f.getName();
		int    pos = name.lastIndexOf(".");

		if (pos >= 0)
		{
			return name.substring(pos + 1);
		}

		return "";
	}


	/**
	 * Moves a file.
	 * 
	 * @param srcFileName
	 * @param destFileName
	 * 
	 * @throws IOException DOCUMENT ME!
	 */
	public static void moveFile(String srcFileName, String destFileName)
						 throws IOException
	{
		moveFile(new File(srcFileName), new File(destFileName));	
	}

	/**
	 * Moves a file
	 * 
	 * @param src
	 * @param dest
	 * 
	 * @throws IOException DOCUMENT ME!
	 */
	public static void moveFile(File src, File dest) throws IOException
	{
		Diagnostics.trace("Moving " + src.getAbsolutePath() + " to " + dest.getAbsolutePath());
		copyStream(new FileInputStream(src), new FileOutputStream(dest));
		if (!src.delete())
			Diagnostics.debug("Could not delete " + src.getName() + " during move operation.");
	}

	/**
	 * Copies a file.
	 * 
	 * @param srcFileName
	 * @param destFileName
	 * 
	 * @throws IOException DOCUMENT ME!
	 */
	public static void copyFile(String srcFileName, String destFileName)
						 throws IOException
	{
		copyStream(new FileInputStream(srcFileName), new FileOutputStream(destFileName));
	}

	/**
	 * Copies a file
	 * 
	 * @param src
	 * @param dest
	 * 
	 * @throws IOException DOCUMENT ME!
	 */
	public static void copyFile(File src, File dest) throws IOException
	{
		copyStream(new FileInputStream(src), new FileOutputStream(dest));
	}

	/**
	 * Copies a stream from source to destination.
	 * 
	 * @param src : The source stream.
	 * @param dest The destination.
	 * 
	 * @exception IOException
	 */
	public static void copyStream(InputStream src, OutputStream dest)
						   throws IOException
	{
		InputStream  in  = null;
		OutputStream out = null;

		try
		{
			// Initialize the streams
			// Use buffered streams for better performance
			if (src instanceof BufferedInputStream)
				in = src;
			else
				in  = new BufferedInputStream(src, BLOCK_SIZE);
			
			if (dest instanceof BufferedOutputStream)
				out = dest;
			else
				out = new BufferedOutputStream(dest, BLOCK_SIZE);
				
			// The number of bytes read
			int numRead = 0;

			// The buffer to hold the read in data
			byte[] buf = new byte[BLOCK_SIZE];

			// Read from source and write to the destination
			while ((numRead = in.read(buf, 0, buf.length)) != -1)
			{
				// Write to the destination
				out.write(buf, 0, numRead);
			}
		}

		finally
		{
			// Close
			try
			{
				if (in != null)
				{
					in.close();
				}

				if (out != null)
				{
					out.close();
				}
			}
			catch (IOException ex)
			{
			}
		}
	}

	/**
	 * Only copies the source to the destination if the files are different.
	 * 
	 * @param sourceFile
	 * @param destFile
	 */
	public void copyFileAsNeeded(String sourceFile, String destFile)
	{
		FileInputStream  fis = null;
		FileOutputStream fos = null;

		try
		{
			File    source       = new File(sourceFile);
			File    target       = new File(sourceFile);
			boolean needToDeploy;

			fis = new FileInputStream(source);
			byte[] sourceContents = new byte[fis.available()];
			fis.read(sourceContents);
			fis.close();
			fis = null;
			String sourceChecksum = md5(sourceContents);

			if (target.exists())
			{
				fis = new FileInputStream(target);
				byte[] targetContents = new byte[fis.available()];
				fis.read(targetContents);
				fis.close();
				fis = null;
				String targetChecksum = md5(sourceContents);
				needToDeploy = !sourceChecksum.equals(targetChecksum);
			}
			else
			{
				needToDeploy = true;
			}

			if (needToDeploy)
			{
				fos = new FileOutputStream(target);
				fos.write(sourceContents);
				fos.close();
				fos = null;
				target.setLastModified(source.lastModified());
			}
		}
		catch (Exception e)
		{
			System.err.println("copyFileAsNeeded() could not deploy file: " + e.toString());
		}
		finally
		{
			try
			{
				if (fis != null)
					fis.close();
				if (fos != null)
					fos.close();
			}
			catch (IOException e)
			{
			}
		}
	}

	/**
	 * Returns whether or not a given directory exists
	 * 
	 * @param dirName
	 * 
	 * @return the result
	 */
	public static boolean directoryExists(String dirName)
	{
		return directoryExists(dirName, false);
	}

	/**
	 * Returns whether or not a directory exists.  If attemptToCreate is true, it will create the directory if it does
	 * not exist and return whether or not it was sucessfull
	 * 
	 * @param dirName
	 * @param attempToCreate
	 * 
	 * @return the result
	 */
	public static boolean directoryExists(String dirName, boolean attempToCreate)
	{
		Diagnostics.debug("FileUtils.directoryExists(" + dirName + "," + attempToCreate + " )");

		boolean result = false;

		try
		{
			File testDir = new File(dirName);

			if (testDir.exists())
			{
				if (testDir.isDirectory())
				{
					result = true;
				}
				else
				{
					Diagnostics.debug("directoryExists returning false because the directory is actually a file");
				}
			}
			else if (attempToCreate)
			{
				Diagnostics.debug("Attempting to create " + dirName);
				testDir.mkdirs();
				result = directoryExists(dirName, false);
			}
		}
		catch (Exception e)
		{
			Diagnostics.error("Exception in directoryExists()", e);
		}

		return result;
	}

	/**
	 * Test for the existance of a file given a directory name and a file name
	 * 
	 * @param dirName
	 * @param fileName
	 * 
	 * @return the result
	 */
	public static boolean fileExists(String dirName, String fileName)
	{
		Diagnostics.debug("FileUtils.fileExists(" + dirName + ", " + fileName + ")");

		boolean result = false;

		try
		{
			File testFile = new File(dirName, fileName);

			if (testFile.exists() && testFile.isFile())
			{
				result = true;
			}
		}
		catch (Exception e)
		{
			Diagnostics.error("Exception in fileExists()", e);
		}

		return result;
	}

	/**
	 * Tests for the existance of a file given its full path
	 * 
	 * @param filePath
	 * 
	 * @return the result
	 */
	public static boolean fileExists(String filePath)
	{
		Diagnostics.debug("FileUtils.fileExists(" + filePath + ")");

		boolean result = false;

		try
		{
			File testFile = new File(filePath);

			if (testFile.exists() && testFile.isFile())
			{
				result = true;
			}
		}
		catch (Exception e)
		{
			Diagnostics.error("Exception in fileExists()", e);
		}

		return result;
	}

	/**
	 * Generates a MD5 checksum for the file provided. This is useful to compare two files to see if they are equal.
	 * 
	 * @param fileToCheck
	 * 
	 * @return the result
	 */
	public String md5(File fileToCheck)
	{
		FileInputStream fis    = null;
		String          result = null;
		try
		{
			fis = new FileInputStream(fileToCheck);
			byte[] fileContents = new byte[fis.available()];
			result = md5(fileContents);

		}
		catch (Exception e)
		{
			Diagnostics.error("Failed to create MD5 checksum", e);
		}
		finally
		{
			if (fis != null)
			{
				try
				{
					fis.close();
				}
				catch (IOException e)
				{
				}
			}
		}
		return result;
	}

	/**
	 * Generates a MD5 checksum for the byte array provided. This is useful to compare two files to see if they are
	 * equal.
	 * 
	 * @param content the bytes to be checked
	 * 
	 * @return the MD5 checksum
	 * 
	 * @throws Exception
	 */
	public String md5(byte[] content) throws Exception
	{
		MessageDigest md5 = MessageDigest.getInstance("MD5");
		md5.update(content);
		byte[]       digest = md5.digest();
		StringBuffer sb = new StringBuffer();
		for (int i = 0; i < digest.length; i++)
		{
			sb.append(Integer.toHexString((digest[i] >> 4) & 0xF));
			sb.append(Integer.toHexString(digest[i] & 0xF));
		}
		String checksum = sb.toString();

		return checksum;
	}
	
	public static File getWorkingDirectory()
	{
		return new File(System.getProperty("user.dir"));
	}
}
