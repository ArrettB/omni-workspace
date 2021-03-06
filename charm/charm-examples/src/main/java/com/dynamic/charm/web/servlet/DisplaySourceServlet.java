package com.dynamic.charm.web.servlet;

import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet used to display jsp source for example pages.
 * 
 * @author Fabrizio Giustina
 * @version $Revision: 1.1 $ ($Author: fgiust $)
 */
public class DisplaySourceServlet extends HttpServlet
{

	/**
	 * D1597A17A6.
	 */
	private static final long serialVersionUID = 899149338534L;

	/**
	 * @see javax.servlet.http.HttpServlet#doGet(HttpServletRequest,
	 *      HttpServletResponse)
	 */
	protected final void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{

		String jspRoot = getServletConfig().getInitParameter("jspRoot");
		if (jspRoot.charAt(jspRoot.length()-1) != '/')
		{
			jspRoot = jspRoot + "/";
		}

		String jspFile = request.getRequestURI();

		//remove the context
		jspFile = jspFile.substring(request.getContextPath().length() + 1);
		
		// lastIndexOf(".") can't be null, since the servlet is mapped to
		// ".source"
		jspFile = jspFile.substring(0, jspFile.lastIndexOf("."));

		

		// only want to show sample pages, don't play with url!
		if (!jspFile.startsWith("examples"))
		{
			throw new ServletException("Invalid file selected: " + jspFile);
		}

		String fullName = jspRoot + jspFile;

		InputStream inputStream = getServletContext().getResourceAsStream(fullName);

		if (inputStream == null)
		{
			throw new ServletException("Unable to find JSP file: " + jspFile);
		}

		response.setContentType("text/html");

		PrintWriter out = response.getWriter();

		out.println("<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" " + "\"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">");
		out.println("<html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"en\" lang=\"en\">");
		out.println("<head>");
		out.println("<title>");
		out.println("source for " + jspFile);
		out.println("</title>");
		out.println("<meta http-equiv=\"content-type\" content=\"text/html; charset=ISO-8859-1\" />");
		out.println("</head>");
		out.println("<body>");
		out.println("<pre>");
		for (int currentChar = inputStream.read(); currentChar != -1; currentChar = inputStream.read())
		{
			switch (currentChar)
			{
			case '<':
				out.print("&lt;");
				break;
			case '>':
				out.print("&gt;");
				break;
			case '"':
				out.print("&quot;");
				break;
			case '&':
				out.print("&amp;");
				break;

			default:
				out.print((char) currentChar);
			}

		}
		out.println("</pre>");
		out.println("</body>");
		out.println("</html>");
	}

}
