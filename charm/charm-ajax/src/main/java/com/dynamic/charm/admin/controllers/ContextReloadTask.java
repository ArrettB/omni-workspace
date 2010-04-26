package com.dynamic.charm.admin.controllers;

import java.util.TimerTask;

import org.apache.log4j.Logger;
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.context.ResourceLoaderAware;
import org.springframework.core.io.DefaultResourceLoader;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.web.context.support.AbstractRefreshableWebApplicationContext;

import com.dynamic.charm.io.ReloadableFile;

public class ContextReloadTask extends TimerTask implements ApplicationContextAware, InitializingBean, ResourceLoaderAware
{

	private String[] fileNames;
	private ReloadableFile[] watchedFiles;
	private AbstractRefreshableWebApplicationContext applicationContext;
	private ResourceLoader resourceLoader;
	private final static Logger logger = Logger.getLogger(ContextReloadTask.class);
	
	public void setFileNames(String[] fileNames)
	{
		this.fileNames = fileNames;
	}

	public void run()
	{
		logger.info("ContextReloadTask is running");
		for (int i = 0; i < watchedFiles.length; i++)
		{
			if (watchedFiles[i].hasChanged())
			{
				logger.debug(watchedFiles[i].getFile().getName() + " has been modified, reloading the applicationContext");
				applicationContext.refresh();
			}
		}
	}

	public void setApplicationContext(ApplicationContext ac) throws BeansException
	{
		this.applicationContext = (AbstractRefreshableWebApplicationContext) ac;
	}

	public void setResourceLoader(ResourceLoader resourceLoader)
	{
		this.resourceLoader = (resourceLoader != null ? resourceLoader : new DefaultResourceLoader());
	}	
	
	public void afterPropertiesSet() throws Exception
	{
		watchedFiles = new ReloadableFile[fileNames.length];
        for (int i = 0; i < watchedFiles.length; i++)
        {
            Resource res = resourceLoader.getResource(fileNames[i]);
            watchedFiles[i] = new ReloadableFile(res.getFile());
        }
	}

}


