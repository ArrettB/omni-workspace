/*
 *               Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.

 * Copyright 2005, Dynamic Information Systems, LLC
 * $Id: NamedQueryLoader.java 243 2007-04-09 16:41:49Z nwest $

 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED.  IN NO EVENT SHALL DYNAMIC INFORMATIONS SYTEMS, LLC
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
 * USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
 * OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 * ====================================================================
 */


package com.dynamic.charm.query;

import java.io.IOException;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.context.ResourceLoaderAware;
import org.springframework.core.io.DefaultResourceLoader;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.xml.sax.SAXException;

import com.dynamic.charm.exception.CharmException;
import com.dynamic.charm.exception.CheckedCharmException;
import com.dynamic.charm.io.ReloadableFile;
import com.dynamic.charm.web.CharmWebObjectSupport;


/**
 * @author gcase
 *
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class NamedQueryLoader extends CharmWebObjectSupport implements ResourceLoaderAware, InitializingBean
{
    private static final Logger logger = Logger.getLogger(NamedQueryLoader.class);

    protected ResourceLoader resourceLoader = new DefaultResourceLoader();

    protected NamedQueries queryStorage = new NamedQueries();

    protected String[] namedQueries;

    protected ReloadableFile[] namedQueryFiles;

    public void registerRequiredProperties()
	{
		registerRequiredProperty("resourceLoader");
		registerRequiredProperty("namedQueries");
	}
    
    /*
	 * (non-Javadoc)
	 * 
	 * @see org.springframework.beans.factory.InitializingBean#afterPropertiesSet()
	 */
    public void afterPropertiesSetInternal() 
    {
        namedQueryFiles = new ReloadableFile[namedQueries.length];

        try
		{
			for (int i = 0; i < namedQueries.length; i++)
			{
			    Resource res = resourceLoader.getResource(namedQueries[i]);
			    namedQueryFiles[i] = new ReloadableFile(res.getFile());
			}

			reload();
		}
		catch (CheckedCharmException e)
		{
			throw new CharmException("Exception reading named queries", e);
		}
		catch (IOException e)
		{
			throw new CharmException("Exception reading named queries", e);
		}
    }

    public NamedQuery findNamedQuery(String identifier) throws Exception
    {
        refresh();
        return queryStorage.findNamedQuery(identifier);
    }

    protected void reload() throws CheckedCharmException
    {
        try
        {
            NamedQueryDigester digester = new NamedQueryDigester();
            queryStorage.clear();
            for (int i = 0; i < namedQueryFiles.length; i++)
            {
            	namedQueryFiles[i].updateLastModified();
                NamedQueries parsed = digester.parse(namedQueryFiles[i].getFile());
                queryStorage.merge(parsed);
            }
            
            Object[] aware =  getBeansOfType(NamedQueryLoaderAware.class);                   
            for (int i = 0; i < aware.length; i++)
			{
            	((NamedQueryLoaderAware)aware[i]).afterLoad();
			}
                     
        }
        catch (IOException e)
        {
            throw new CheckedCharmException("IOException loading NamedQueryDefinitions", e);
        }
        catch (SAXException e)
        {
            throw new CheckedCharmException("SAXException loading NamedQueryDefinitions", e);
        }
    }

    protected void refresh() throws CheckedCharmException
    {
        boolean stale = false;

        for (int i = 0; i < namedQueryFiles.length; i++)
        {
            if (namedQueryFiles[i].hasChanged())
            {
                logger.info(namedQueryFiles[i].getFile().getAbsolutePath() + " has been modified, reloading namedQueries");
                stale = true;
                break;
            }
        }

        if (stale)
        {
            reload();
        }
    }

	public String[] getNamedQueries()
	{
		return namedQueries;
	}

	public void setNamedQueries(String[] namedQueries)
	{
		this.namedQueries = namedQueries;
	}

	public ResourceLoader getResourceLoader()
	{
		return resourceLoader;
	}

	public void setResourceLoader(ResourceLoader resourceLoader)
	{
		this.resourceLoader = resourceLoader;
	}


	
}
