package com.dynamic.servicetrax.util;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;

public class DistinctList extends ArrayList
{
	public DistinctList()
	{
		super();
	}

	public DistinctList(Collection c)
	{
		super(c);
	}

	@Override
	public void add(int index, Object element)
	{
		if (this.contains(element))
			super.add(index, element);
	}

	@Override
	public boolean add(Object o)
	{
		if (this.contains(o))
			return false;
		else
			return super.add(o);
	}

	@Override
	public boolean addAll(Collection c)
	{
		Iterator iter = c.iterator();
		boolean result = false;
		while (iter.hasNext())
		{
			Object o = iter.next();
			if (!contains(o))
			{
				super.add(o);
				result = true;
			}
		}
		return result;

	}

	@Override
	public boolean addAll(int index, Collection c)
	{
		Iterator iter = c.iterator();
		boolean result = false;
		while (iter.hasNext())
		{
			Object o = iter.next();
			if (!contains(o))
			{
				super.add(index, o);
				result = true;
			}
		}
		return result;
	}

}
