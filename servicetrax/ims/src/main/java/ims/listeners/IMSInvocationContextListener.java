package ims.listeners;

import dynamic.intraframe.engine.Configuration;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.engine.InvocationContextListener;
import dynamic.util.diagnostics.Diagnostics;


public class IMSInvocationContextListener implements InvocationContextListener
{
	public void initialize(Configuration config)
	{
		Diagnostics.trace("IMSInvocationContextListener.initialize()");
	}
	public void afterContextCreated(InvocationContext ic)
	{
		Diagnostics.trace("IMSInvocationContextListener.afterContextCreated()");
	}
	public void beforeContextDestroyed(InvocationContext ic)
	{
		Diagnostics.trace("IMSInvocationContextListener.beforeContextDestroyed()");
	}
	public void destroy()
	{
		Diagnostics.trace("IMSInvocationContextListener.destory()");
	}
}