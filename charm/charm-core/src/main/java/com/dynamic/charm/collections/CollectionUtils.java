package com.dynamic.charm.collections;

import java.util.Collection;
import java.util.Iterator;
import java.util.NoSuchElementException;

public class CollectionUtils
{
	private static Iterator EMPTY_ITERATOR = new EmptyIterator();

	/**
	 * Returns an iterator for the collection. If the collection returns null, this will return an iterator that returns false for hasNext()
	 * @return an iterator for the collection.
	 * @see java.util.Iterator
	 */
	public static Iterator nullSafeIterator(Collection c)
	{
		return c != null ? c.iterator() : EMPTY_ITERATOR;
	}

	/**
	 * Returns the size of the collection.  If the collection is null, returns 0
	 * @param c
	 * @return the size of the collection
	 */
	public static int nullSafeSize(Collection c)
	{
		return c != null ? c.size() : 0;
	}

}

final class EmptyIterator implements Iterator
{
	public void remove()
	{
		throw new UnsupportedOperationException();
	}

	public boolean hasNext()
	{
		return false;
	}

	public Object next()
	{
		return new NoSuchElementException();
	}
}