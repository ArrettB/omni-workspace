package com.dynamic.charm.web.context;

import org.springframework.util.Assert;

public class CharmContextHolder
{
	private static ThreadLocal contextHolder = new ThreadLocal();

	/**
	 * Associates a new <code>CharmContext</code> with the current thread of
	 * execution.
	 *
	 * @param context the new <code>SecurityContext</code> (may not be
	 *        <code>null</code>)
	 */
	public static void setContext(CharmContext context)
	{
		Assert.notNull(context, "Only non-null CharmContext instances are permitted");
		contextHolder.set(context);
	}

	/**
	 * Obtains the <code>CharmContext</code> associated with the current
	 * thread of execution. If no <code>CharmContext</code> has been
	 * associated with the current thread of execution, a new instance of
	 * {@link CharmContextImpl} is associated with the current thread and
	 * then returned.
	 *
	 * @return the current <code>CharmContext</code> (guaranteed to never be
	 *         <code>null</code>)
	 */
	public static CharmContext getContext()
	{
		if (contextHolder.get() == null)
		{
			contextHolder.set(new CharmContextImpl());
		}

		return (CharmContext) contextHolder.get();
	}

	/**
	 * Explicitly clears the context value from thread local storage.
	 * Typically used on completion of a request to prevent potential
	 * misuse of the associated context information if the thread is
	 * reused. 
	 */
	public static void clearContext()
	{
		// Internally set the context value to null. This is never visible
		// outside the class.
		contextHolder.set(null);
	}
}
