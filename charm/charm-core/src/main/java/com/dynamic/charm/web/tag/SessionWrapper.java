/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: SessionWrapper.java 199 2006-11-14 23:38:41Z gcase $

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


package com.dynamic.charm.web.tag;

import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.apache.commons.collections.IteratorUtils;


public class SessionWrapper
{
    private HttpSession _session;

    public SessionWrapper(HttpSession session)
    {
        this._session = session;
    }

    public long getCreationTime()
    {
        return _session.getCreationTime();
    }

    public String getId()
    {
        return _session.getId();
    }

    public long getLastAccessedTime()
    {
        return _session.getLastAccessedTime();
    }

    public int getMaxInactiveInterval()
    {
        return _session.getMaxInactiveInterval();
    }

    public Date getCreationDate()
    {
        return new Date(getCreationTime());
    }

    public Date getLastAccessedDate()
    {
        return new Date(getLastAccessedTime());
    }

    public Map getAttributeMap()
    {
        HashMap result = new HashMap();
        Iterator iter = IteratorUtils.asIterator(_session.getAttributeNames());
        while (iter.hasNext())
        {
            String attribute = (String) iter.next();
            result.put(attribute, _session.getAttribute(attribute));
        }
        return result;
    }
}
