package dynamic.intraframe.engine;

import dynamic.Version;
import dynamic.dbtk.MetaData;
import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.intraframe.filter.QueryFilterManager;
import dynamic.intraframe.handlers.Dispatcher;
import dynamic.intraframe.session.SessionData;
import dynamic.intraframe.session.SessionManager;
import dynamic.intraframe.templates.Template;
import dynamic.intraframe.templates.TemplateManager;
import dynamic.util.date.StdDate;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.diagnostics.DiagnosticsMessage;
import dynamic.util.resources.DynamicResource;
import dynamic.util.resources.ResourceManager;
import dynamic.util.sorting.Sort;
import dynamic.util.string.PhoneNumberFormat;
import dynamic.util.string.StringUtil;
import dynamic.util.xml.XMLUtils;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayOutputStream;
import java.io.FileNotFoundException;
import java.io.OutputStream;
import java.lang.reflect.Constructor;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * The application context provides a convenient bridge for multiple servlets to share in
 * an application. This allows support for multiple servlets to make up an app set. For
 * instance, the BaseServlet, FileUploadServlet and FileDownloadServlet.
 *
 * @version $Header: BaseApplicationContext.java, 5, 10/2/2006 10:00:45 AM, Greg Case$
 */
public class BaseApplicationContext implements ApplicationContext
{
	private BaseServlet servlet = null;
	private Configuration config = null;
	private ResourceManager resourceManager = null;
	private SessionManager sessionManager = null;
	private Dispatcher dispatcher = null;
	private TemplateManager templateManager = null;
	private QueryFilterManager queryFilterManager = null;
	private ClassLoader loader = null;
	private String actionParam = null;
	private Class invocationContextClass = null;
	private Vector listeners = null;
	private Hashtable providerHash = null;
	private Hashtable appGlobalData = null;
	private Hashtable formats = null;
	private Hashtable daemons = null;
	private String defaultProvider = null;

	private static String EOL;
	static
	{
		EOL = System.getProperty("line.separator");
		if (EOL == null || EOL.length() == 0) EOL = "\n";
	}

	/**
	 */
	public void initialize(BaseServlet servlet, Configuration config, ClassLoader loader) throws Exception
	{
		this.servlet = servlet;
		this.config = config;
		this.loader = loader;

		//get configuration information
		Document xmlDoc = getConfigDocument();
		Element applicationContextElement = XMLUtils.getSingleElement(xmlDoc, Configuration.AC);
		if (applicationContextElement == null)
			throw new ConfigurationException("Could not find element " + Configuration.AC);

		initSystemProperties();
		initAppGlobals(applicationContextElement.getAttribute("version"));
		initFormatManager();
		initListeners();
		initInvocationContext();
		initResourceManager();
		initTemplateManager();
		initSessionManager();
		initDispatcher();
		initQueryFilterManager();
		initProviders();
		initCodeTables();
		initDaemons();
		fireAfterContextCreated();
		startDaemons();

		Diagnostics.trace("ApplicationContext.initialize() complete");
	}

	public void destroy()
	{
		fireBeforeContextDestroyed();
		stopDaemons();
		if (daemons != null) daemons.clear();
		daemons = null;
		if (providerHash != null) providerHash.clear();
		providerHash = null;
		if (queryFilterManager != null) queryFilterManager.destroy();
		queryFilterManager = null;
		if (dispatcher != null) dispatcher.destroy();
		dispatcher = null;
		if (sessionManager != null) sessionManager.destroy();
		sessionManager = null;
		if (templateManager != null) templateManager.destroy();
		templateManager = null;
		if (resourceManager != null) resourceManager.destroy();
		resourceManager = null;
		invocationContextClass = null;
		actionParam = null;
		if (listeners != null) listeners.removeAllElements();
		listeners = null;
		if (formats != null) formats.clear();
		formats = null;
		if (appGlobalData != null) appGlobalData.clear();
		appGlobalData = null;
		config = null;
		loader = null;
	}

	public void initListeners() throws Exception
	{
		listeners = new Vector();
		Document xmlDoc = getConfigDocument();
		Element acElement = XMLUtils.getSingleElement(xmlDoc, Configuration.AC);
		NodeList nodes = acElement.getElementsByTagName(Configuration.AC_LISTENER);
		for (int i = 0; i < nodes.getLength(); i++)
		{
			Element listenerElement = (Element)nodes.item(i);
			String listenerClass = listenerElement.getAttribute("class");
			ApplicationContextListener temp = (ApplicationContextListener)loader.loadClass(listenerClass).newInstance();
			if (temp != null)
			{
				temp.initialize(config);
				listeners.addElement(temp);
			}
		}
	}

	private void initInvocationContext() throws Exception
	{
		Diagnostics.trace("ApplicationContext.initInvocationContext()");
		Document xmlDoc = getConfigDocument();
		Element icElement = XMLUtils.getSingleElement(xmlDoc, Configuration.IC);
		String className = icElement.getAttribute("class");
		invocationContextClass = loader.loadClass(className);

		//now load the action parameter (ecommerce_action)
		Element actionElement = XMLUtils.getSingleElement(xmlDoc, Configuration.ACTION_PARAM);
		if (actionElement != null)
		{
			Diagnostics.warning("The " + Configuration.ACTION_PARAM + " configuration element has been deprecated");
			actionParam = actionElement.getAttribute("name");
		}
	}

	private void initDaemons() throws Exception
	{
		daemons = new Hashtable();
		Document xmlDoc = getConfigDocument();
		NodeList daemonList = xmlDoc.getElementsByTagName(Configuration.DAEMON);
		for (int i = 0; i < daemonList.getLength(); i++)
		{
			Element daemonElement = (Element)daemonList.item(i);
			String daemonName = daemonElement.getAttribute("name");
			String daemonClass = daemonElement.getAttribute("class");
			Daemon daemon = (Daemon)loader.loadClass(daemonClass).newInstance();
			if (daemon != null)
			{
				Diagnostics.trace("ApplicationContext.initDaemons(): initializing daemon " + daemonName + " with class " + daemonClass);
				daemon.initialize(this, daemonName);
				daemons.put(daemonName, daemon);
			}
		}
	}

	private void startDaemons()
	{
		if (daemons == null) return;

		Enumeration keys = daemons.keys();
		while (keys.hasMoreElements())
		{
			String key = (String)keys.nextElement();
			Daemon d = (Daemon)daemons.get(key);
			Diagnostics.trace("BaseApplicationContext.startDaemons(): starting daemon " + key);
			d.start();
		}
	}

	private void stopDaemons()
	{
		if (daemons == null) return;

		Enumeration keys = daemons.keys();
		while (keys.hasMoreElements())
		{
			String key = (String)keys.nextElement();
			Daemon d = (Daemon)daemons.get(key);
			d.stop();
			d.destroy();
		}
	}

	private void initSystemProperties() throws Exception
	{
		Diagnostics.trace("ApplicationContext.initSystemProperties()");
		Document xmlDoc = getConfigDocument();
		NodeList list = xmlDoc.getElementsByTagName(Configuration.PROPERTY);
		Properties p = System.getProperties();
		for (int i = 0; list != null && i < list.getLength(); i++)
		{
			Element datum = (Element)list.item(i);
			String name = datum.getAttribute("name").toLowerCase();
			String value = XMLUtils.getEnclosedText(datum);
			p.put(name,value);
		}
		System.setProperties(p);
	}

	private void initAppGlobals(String appversion) throws Exception
	{
		Diagnostics.trace("ApplicationContext.initAppGlobals()");
		appGlobalData = new Hashtable();
		appGlobalData.put("version", new Version());
		if (appversion != null)
		{
			try { appGlobalData.put("appversion", loader.loadClass(appversion).newInstance()); } catch (Exception e) {} // throw away
		}
		
		Document xmlDoc = getConfigDocument();
		NodeList list = xmlDoc.getElementsByTagName(Configuration.AG_DATUM);
		for (int i = 0; i < list.getLength(); i++)
		{
			Element datum = (Element)list.item(i);
			String name = datum.getAttribute("name");
			String className = datum.getAttribute("class");
			String value = XMLUtils.getEnclosedText(datum);
			if (className != null && !className.equals(""))
			{
				try
				{

					Class theClass = loader.loadClass(className);
					Constructor construct = theClass.getConstructor(new Class[] {value.getClass()});
					setAppGlobalDatum(name, construct.newInstance(new Object[] {value}));
				}
				catch (ClassNotFoundException e)
				{
					Diagnostics.error("No class found for " + className);
					throw e;
				}
				catch (NoSuchMethodException e)
				{
					Diagnostics.error("No default constructor found for " + className);
					throw e;
				}
			}
			else
			{
				setAppGlobalDatum(name, value);
			}
		}
	}

	/**
	 * Load the code values and meta data for tables.
	 * The code values will be stored in AppGlobals in the format
	 *   table:code (in whatever case it is in the config file)
     *
	 * The meta data will be stored in AppGlobals in the format
	 *   table:column (in whatever case it is in the config file)
	 *
	 * @see dynamic.dbtk.MetaData
	 * @see dynamic.dbtk.MetaDataColumn
	 */
	private void initCodeTables() throws Exception
	{
		ConnectionWrapper conn = null;
		QueryResults rs = null;

		try
		{
			Diagnostics.debug("ApplicationContext.initCodeTables()");

	 		conn = (ConnectionWrapper)getResource();

			Document xmlDoc = getConfigDocument();
			NodeList appGlobals = xmlDoc.getElementsByTagName("appGlobals");

			NodeList list = XMLUtils.getElementsByTagName(appGlobals.item(0), "codetable");
			for (int x = 0; x < list.getLength(); x++)
			{
				Element element = (Element)list.item(x);
				if (element != null)
				{
					String table = element.getAttribute("table");
					String id = element.getAttribute("id");
					String code = element.getAttribute("code");
					String query = element.getAttribute("query");
					String name = element.getAttribute("name");
	
	
				 	if (query != null && query.length() > 0)
				 	{
						if (name == null || name.length() == 0)
						{
							throw new ConfigurationException("Name not specified, required when query is specified when initializing code tables.");
						}
				 	}
				 	else if (table == null || table.length() == 0 || id == null || id.length() == 0 || code == null || code.length() == 0)
					{
						throw new ConfigurationException("Bad codetable in appGlobals");
					}
					else
					{
						query = "SELECT " + id + ", " + code + " FROM " + table + " WHERE " + code + " IS NOT NULL";
						if (name == null || name.length() == 0)
						{
							name = table;
						}
					}
	
				 	Diagnostics.debug("ApplicationContext.initCodeTables() loading codes, query =  " + query);
					rs = conn.resultsQueryEx(query);
					while (rs.next())
						setAppGlobalDatum(name+":" + StringUtil.replaceString(rs.getString(2), ".", ""), rs.getString(1));
					rs.close();
					rs = null;
				}
			}

			list = XMLUtils.getElementsByTagName(appGlobals.item(0), "codetable2");
			for (int x = 0; x < list.getLength(); x++)
			{
				Element element = (Element)list.item(x);
				if (element != null)
				{
					String table = element.getAttribute("table");
					String id = element.getAttribute("id");
					String code = element.getAttribute("code");
					String query = element.getAttribute("query");
					String name = element.getAttribute("name");


				 	if (query != null && query.length() > 0)
				 	{
						if (name == null || name.length() == 0)
						{
							throw new ConfigurationException("Name not specified, required when query is specified when initializing code tables.");
						}
				 	}
				 	else if (table == null || table.length() == 0 || id == null || id.length() == 0 || code == null || code.length() == 0)
					{
						throw new ConfigurationException("Bad codetable in appGlobals");
					}
					else
					{
						query = "SELECT " + id + ", " + code + " FROM " + table + " WHERE " + code + " IS NOT NULL";
						if (name == null || name.length() == 0)
						{
							name = table;
						}
					}
	
				 	Diagnostics.debug("ApplicationContext.initCodeTables() loading codes, query =  " + query);
					rs = conn.resultsQueryEx(query);
					Hashtable codeTable = new Hashtable();
					while (rs.next())
						codeTable.put(StringUtil.replaceString(rs.getString(2), ".", ""), rs.getString(1));
					rs.close();
					rs = null;
					setAppGlobalDatum(name, codeTable);
				}
			}

			list = XMLUtils.getElementsByTagName(appGlobals.item(0), "metadata");
			for (int x = 0; x < list.getLength(); x++)
			{
				Element element = (Element)list.item(x);
				if (element != null)
				{
					String table = element.getAttribute("table");
					String columns = element.getAttribute("columns");
					if (columns == null || columns.length() == 0) columns = "*";
	
					if (table == null || table.length() == 0)
						throw new ConfigurationException("Bad metadata in appGlobals");
	
					Diagnostics.debug("ApplicationContext.initCodeTables() loading metadata from " + table + " for " + columns);
					rs = conn.resultsQueryEx("SELECT " + columns + " FROM " + table + " WHERE NULL=NULL");
					MetaData meta = new MetaData(rs.getMetaData());
					rs.close();
					rs = null;
					for (int i = 1; i <= meta.getColumnCount(); i++)
						setAppGlobalDatum(table + ":" + meta.getColumnName(i), meta.findMetaDataColumn(i));
				}
			}

			list = XMLUtils.getElementsByTagName(appGlobals.item(0), "metadata2");
			for (int x = 0; x < list.getLength(); x++)
			{
				Hashtable meta_data = new Hashtable();
				Element element = (Element)list.item(x);
				if (element != null)
				{
					String table = element.getAttribute("table");
					String columns = element.getAttribute("columns");
					if (columns == null || columns.length() == 0) columns = "*";
	
					if (table == null || table.length() == 0)
						throw new ConfigurationException("Bad metadata in appGlobals");
	
					Diagnostics.debug("ApplicationContext.initCodeTables() loading metadata from " + table + " for " + columns);
					rs = conn.resultsQueryEx("SELECT " + columns + " FROM " + table + " WHERE NULL=NULL");
					MetaData meta = new MetaData(rs.getMetaData());
					rs.close();
					rs = null;
					for (int i = 1; i <= meta.getColumnCount(); i++)
						meta_data.put(meta.getColumnName(i), meta.findMetaDataColumn(i));
					setAppGlobalDatum(table, meta_data);
				}
			}
		}
		finally
		{
			if (rs != null) try { rs.close(); } catch (Exception e) {} // throw away
			if (conn != null) conn.release();
		}
	}

	private void initFormatManager() throws Exception
	{
		Diagnostics.trace("ApplicationContext.initFormatManager()");
		formats = new Hashtable();
		formats.put("date",System.getProperty("dynamic.format.date",StdDate.DATE_FORMAT));
		formats.put("time",System.getProperty("dynamic.format.time",StdDate.TIME_FORMAT));
		formats.put("datetime",System.getProperty("dynamic.format.datetime",StdDate.DATE_TIME_FORMAT));
		formats.put("money",System.getProperty("dynamic.format.money","default"));
		formats.put("phone",System.getProperty("dynamic.format.phone",PhoneNumberFormat.DEFAULT_FORMAT));
		
		Document xmlDoc = getConfigDocument();
		NodeList list = xmlDoc.getElementsByTagName(Configuration.FORMAT);
		for (int i = 0; list != null && i < list.getLength(); i++)
		{
			Element datum = (Element)list.item(i);
			String name = datum.getAttribute("name").toLowerCase();
			String value = XMLUtils.getEnclosedText(datum);
			formats.put(name,value);
		}
	
		// if the System properties for date/time formatting aren't set yet and new values are different than the defaults then set them
		Properties p = System.getProperties();
		String dateFormat = (String)formats.get("date");
		//if (!p.contains("dymamic.format.date") && !dateFormat.equals(StdDate.DATE_FORMAT))
		p.put("dynamic.format.date",dateFormat);
		String timeFormat = (String)formats.get("time");
		//if (!p.contains("dymamic.format.time") && !timeFormat.equals(StdDate.TIME_FORMAT))
		p.put("dynamic.format.time",timeFormat);
		String dateTimeFormat = (String)formats.get("datetime");
		//if (!p.contains("dymamic.format.datetime") && !dateTimeFormat.equals(StdDate.DATE_TIME_FORMAT))
		p.put("dynamic.format.datetime",dateTimeFormat);
		String moneyFormat = (String)formats.get("money");
		//if (!p.contains("dymamic.format.money") && !moneyFormat.equals("default"))
		p.put("dynamic.format.money",moneyFormat);
		String phoneFormat = (String)formats.get("phone");
		//if (!p.contains("dymamic.format.phone") && !phoneFormat.equals(PhoneNumberFormat.DEFAULT_FORMAT))
		p.put("dynamic.format.phone",phoneFormat);
		System.setProperties(p);
	}

	private void initTemplateManager() throws Exception
	{
		Diagnostics.trace("ApplicationContext.initTemplateManager()");
		Element templateManagerElement = XMLUtils.getSingleElement(getConfigDocument(), Configuration.TEMPLATE_MANAGER);
		String templateManagerClass = templateManagerElement.getAttribute("class");
		templateManager = (TemplateManager)loader.loadClass(templateManagerClass).newInstance();
		templateManager.initialize(this);
	}

	private void initDispatcher() throws Exception
	{
		Diagnostics.trace("ApplicationContext.initDispatcher()");
		Element dispatcherElement = XMLUtils.getSingleElement(getConfigDocument(), Configuration.DISPATCHER);
		String dispatcherClass = dispatcherElement.getAttribute("class");
		dispatcher = (Dispatcher)loader.loadClass(dispatcherClass).newInstance();
		dispatcher.initialize(this);
	}

	private void initResourceManager() throws Exception
	{
		Diagnostics.trace("ApplicationContext.initResourceManager()");
		Element resourceManagerElement = XMLUtils.getSingleElement(getConfigDocument(), Configuration.RESOURCE_MANAGER);
		String resourceManagerClass = resourceManagerElement.getAttribute("class");
		resourceManager = (ResourceManager)loader.loadClass(resourceManagerClass).newInstance();
		resourceManager.initialize(resourceManagerElement,loader);
	}

	private void initSessionManager() throws Exception
	{
		Diagnostics.trace("ApplicationContext.initSessionManager()");
		Element sessionManagerElement = XMLUtils.getSingleElement(getConfigDocument(), Configuration.SESSION_MANAGER);
		String sessionManagerClass = sessionManagerElement.getAttribute("class");
		sessionManager = (SessionManager)loader.loadClass(sessionManagerClass).newInstance();
		sessionManager.initialize(this);
	}

	private void initQueryFilterManager() throws Exception
	{
		Diagnostics.trace("ApplicationContext.initQueryFilterManager()");
		Element queryFilterManagerElement = XMLUtils.getSingleElement(getConfigDocument(), Configuration.QUERY_FILTER_MANAGER);
		if (queryFilterManagerElement == null) return;
		String queryFilterManagerClass = queryFilterManagerElement.getAttribute("class");
		queryFilterManager = (QueryFilterManager)loader.loadClass(queryFilterManagerClass).newInstance();
		queryFilterManager.initialize(this);
	}

	private void initProviders() throws Exception
	{
		Diagnostics.trace("ApplicationContext.initProviders()");
		providerHash = new Hashtable();

		Element providers = XMLUtils.getSingleElement(getConfigDocument(), Configuration.PROVIDERS);
		String tmp = providers.getAttribute("default");
		if (tmp != null && tmp.length() > 0) defaultProvider = tmp;

		NodeList elementList = XMLUtils.getElementsByTagName(providers, Configuration.PROVIDER);
		if (elementList != null)
		{
			for (int i = 0; i < elementList.getLength(); i++)
			{
				Element element = (Element)elementList.item(i);
				String name = element.getAttribute("name");
				String id = element.getAttribute("id");
				String type = element.getAttribute("type");

				if (name != null && name.length() > 0
						&& id != null && id.length() > 0
						&& type != null && type.length() > 0)
				{
					providerHash.put(name, new Provider(name, id, type));
				}
			}
		}
	}

	public Document getConfigDocument()
	{
		return config.getConfigDocument();
	}

	public Configuration getConfig()
	{
		return config;
	}

	public Object getAppGlobalDatum(String key)
	{
		return appGlobalData.get(key);
	}

	public Object getRequiredAppGlobalDatum(String key) throws Exception
	{
		Object result = getAppGlobalDatum(key);
		if (result == null)
			throw new Exception("Missing required app global datum \"" + key + "\"");
		return result;
	}

	public void setAppGlobalDatum(String key, Object value)
	{
		if (value == null)
		{
			Diagnostics.warning("Setting AppGlobalDatum to null for: "+key);
			appGlobalData.remove(key);
		}
		else
		{
			appGlobalData.put(key, value);
		}
	}

	public void removeAppGlobalDatum(String key)
	{
		appGlobalData.remove(key);
	}

	public void clearAppGlobalData()
	{
		appGlobalData.clear();
	}

	public Enumeration getAppGlobalKeys()
	{
		return Sort.keys(appGlobalData);
	}

	public boolean containsAppGlobalDatum(String key)
	{
		return appGlobalData.containsKey(key);
	}

	public DynamicResource getResource() throws Exception
	{
		return resourceManager.getResource();
	}

	public DynamicResource getResource(String resourceName) throws Exception
	{
		return resourceManager.getResource(resourceName);
	}

	public Template getTemplate(String templateName) throws Exception
	{
		return templateManager.getTemplate(templateName);
	}

	public Provider getProvider(String key)
	{
		Provider result = (Provider)providerHash.get(key);
		if (result != null) return result;
		if (defaultProvider == null) return null;
	 	result = (Provider)providerHash.get(defaultProvider);
		return result;
	}

	public void handle(HttpServletRequest req, HttpServletResponse res) throws Exception
	{
		InvocationContext ic = null;
		Throwable error = null;
		StringBuffer sb = new StringBuffer();

		try
		{
			SessionData session = sessionManager.getSessionData(req, loader);
			ic = (InvocationContext)invocationContextClass.newInstance();
			ic.initialize(this, req, res, session);
			sessionManager.bindSessionKey(ic);

			if (ic == null) throw new NullPointerException("InvocationContext is null");

			// **** handlers ****
			String postSuccessAction = null;
			//	Remember the "nextActionIf" clause will be blown away by getPendingSuccessAction
			String hackAction = (String) ic.getSessionDatum("_nextActionIf");
			ApplicationServerAction postSuccessActionObj = ic.getPendingSuccessAction(ic.getAction());
			if (postSuccessActionObj != null) postSuccessAction = postSuccessActionObj.actionName;
			boolean dispatchSuccess = true;
			while (ic.getAction() != null)
			{
				dispatchSuccess = ic.dispatchAction(ic.getAction());

				if (ic.getImmediateAction() != null)
				{
					ic.setAction(ic.getImmediateAction().actionName);
					ic.setImmediateAction(null);
				}
				else
				{
					ic.setAction(null);
					if (postSuccessAction != null)
					{
						if (dispatchSuccess)
						{
							ic.setAction(postSuccessAction);
							postSuccessAction = null;
						}
						else
						{
							ic.setPendingSuccessAction(new ApplicationServerAction(postSuccessAction,null),hackAction);
						}
					}
				}
			}

			// if someone set a redirect bail out now because there's no place to display the template
			if (ic.isRedirected()) return;

			// if nobody set a template to be displayed bail out now because there is nothing more to send
			String templateName = ic.getHTMLTemplateName();
			if (templateName == null) return;

			// **** templates ****
			Template tmpl = ic.getTemplate(templateName);
			while (!tmpl.requirementsMet(ic))
			{
				String providerFor = tmpl.getRequiredData();
				Provider provider = getProvider(providerFor);

				if (provider == null)
					throw new Exception("The provider for " + providerFor + " was not found in the configuration");

				if (provider.getType().equals("template"))
				{
					ic.setHTMLTemplateName(provider.getId());
					ic.setTransientDatum("errTitle","Security Problem");
					ic.setTransientDatum("errMessage","You do not have access to this page");
				}
				else if (provider.getType().equals("handler"))
				{
					if (!ic.dispatchHandler(provider.getId()))
						throw new Exception("The handler " + provider.getId() + " could not be dispatched");
				}

				templateName = ic.getHTMLTemplateName();
				if (templateName == null)	throw new Exception("No template was specified");
				tmpl = ic.getTemplate(templateName);
			}

			sb.append(tmpl.include(ic));
		}
		catch (FileNotFoundException fnfe)
		{
			try
			{
				Diagnostics.warning("Template not found: \"" + fnfe.getMessage() + "\"");
				ic.getHttpServletResponse().sendError(HttpServletResponse.SC_NOT_FOUND, fnfe.getMessage());
			}
			catch (Throwable t)
			{
				error = t;
				Diagnostics.error("Problem with service", t);
			}
		}
		catch (Throwable t)
		{
			error = t;
			Diagnostics.error("Problem with service", error);
		}
		finally
		{
			if (ic != null) ic.destroy();
		}

		//write the result to the OutputStream
		try
		{
			ByteArrayOutputStream tempStorage = new ByteArrayOutputStream();

			if (sb != null)
			{
				tempStorage.write(sb.toString().getBytes("utf-8"));
			}
			if (error != null)
			{
				DiagnosticsMessage m = new DiagnosticsMessage(Diagnostics.ERROR, "Problem with service", error, null);
				tempStorage.write(m.toHTML().getBytes("utf-8"));
			}
	
			OutputStream os;
			if (res != null)
			{
				os = res.getOutputStream();
				if (!StringUtil.hasAValue(res.getContentType())) {
					res.setContentType("text/html; charset=utf-8");
				}
			
				res.setContentLength(tempStorage.size());
				res.setHeader("Pragma", "no-cache");
				res.setHeader("Cache-Control", "no-cache");
				res.setDateHeader("Expires", 0);
			}
			else
			{
				os = System.out;
			}

			tempStorage.writeTo(os);
			os.flush();

			tempStorage.close();	
			os.close();
			
		}
		catch (Exception e) {}
	}

	public Class loadClass(String name) throws Exception
	{
		return loader.loadClass(name);
	}

	public String format(Object o, String pattern) throws Exception
	{
		if (o == null) return "";
		if (pattern == null) return o.toString();
		String template = (String)formats.get(pattern.toLowerCase());
		if (template == null) template = pattern;
		
		String result = "";

		if (o instanceof Date)
		{
			result = new SimpleDateFormat(template).format((Date)o);
		}
		else if (o instanceof Number)
		{
			if (pattern.equals("money") && template.equalsIgnoreCase("default"))
			{
				result = NumberFormat.getCurrencyInstance().format((Number)o);
			}
			else
			{
				result = new DecimalFormat(template).format((Number)o);
			}
		}
		else if (o instanceof String)
		{
			String s = (String)o;
			if (s.length() > 0)
				result = new PhoneNumberFormat(template).format(s);
		}
		else
		{
			throw new IllegalArgumentException("Bad argument to format: " + o.getClass().getName());
		}
		
		return result;
	}

	/**
	 * @deprecated shorter version of URL without actionParam should be used.
	 */
	public String getActionParam()
	{
		return actionParam;
	}

	// end of Interface ApplicationContext

	private void fireAfterContextCreated()
	{
		if (listeners != null)
		{
			for (int i = 0; i < listeners.size(); i++)
				((ApplicationContextListener)listeners.elementAt(i)).afterContextCreated(this);
		}
	}

	private void fireBeforeContextDestroyed()
	{
		if (listeners != null)
		{
			for (int i = 0; i < listeners.size(); i++)
				((ApplicationContextListener)listeners.elementAt(i)).beforeContextDestroyed(this);
		}
	}

	public SessionManager getSessionManager()
	{
		return sessionManager;
	}

	public Dispatcher getDispatcher()
	{
		return dispatcher;
	}

	public ResourceManager getResourceManager()
	{
		return resourceManager;
	}

	public TemplateManager getTemplateManager()
	{
		return templateManager;
	}

	public QueryFilterManager getQueryFilterManager()
	{
		return queryFilterManager;
	}

	public Hashtable getDaemons()
	{
		return daemons;
	}

	public BaseServlet getServlet()
	{
		return servlet;
	}
}
