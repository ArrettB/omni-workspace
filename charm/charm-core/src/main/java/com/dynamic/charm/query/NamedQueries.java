/*
 *               Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.

 * Copyright 2005, Dynamic Information Systems, LLC
 * $Id: NamedQueries.java 199 2006-11-14 23:38:41Z gcase $

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

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.apache.log4j.Logger;


/**
 * @author gcase
 *
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class NamedQueries
{
    private final static Logger logger = Logger.getLogger(NamedQueries.class);

    Map queryMap = new HashMap();

    public void addNamedQuery(NamedQuery namedQuery)
    {
        queryMap.put(namedQuery.getId(), namedQuery);
    }

    public NamedQuery findNamedQuery(String identifier)
    {
        NamedQuery result = (NamedQuery) queryMap.get(identifier);

        if (result == null)
        {
            //          throw new Exception();
        }

        return result;
    }

    public Iterator getNamedQueries()
    {
        return queryMap.values().iterator();
    }

    public void clear()
    {
        queryMap.clear();
    }

    public void merge(NamedQueries mergeWith)
    {
        for (Iterator iter = mergeWith.getNamedQueries(); iter.hasNext();)
        {
            NamedQuery nq = (NamedQuery) iter.next();
            if (queryMap.containsKey(nq.getId()))
            {
                logger.info("Duplicate identifiers found in merge, previous NamedQuery will be replaced, identifier = " + nq.getId());
            }
            addNamedQuery(nq);
        }
    }
}
