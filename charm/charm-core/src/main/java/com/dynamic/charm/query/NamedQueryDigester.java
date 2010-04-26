/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: NamedQueryDigester.java 412 2009-05-28 21:51:04Z bvonhaden $

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

import java.io.File;
import java.io.IOException;
import java.io.Reader;

import org.apache.commons.digester.Digester;
import org.xml.sax.SAXException;


/**
 * @author gcase
 *
 * @version $Id: NamedQueryDigester.java 412 2009-05-28 21:51:04Z bvonhaden $
 */
public class NamedQueryDigester
{
    public NamedQueryDigester()
    {
    }

    public NamedQueries parse(File file) throws IOException, SAXException
    {
        NamedQueries result = (NamedQueries) getDigester().parse(file);

        return result;
    }
    
    public NamedQueries parse(Reader reader) throws IOException, SAXException
    {
        NamedQueries result = (NamedQueries) getDigester().parse(reader);

        return result;
    }
    
    
    private Digester getDigester()
    {
        Digester digester = new Digester();

        //        QueryDtdResolver resolver = new QueryDtdResolver();
        //              digester.setEntityResolver(resolver);
        digester.setValidating(false);
        digester.addObjectCreate("namedQueries", "com.dynamic.charm.query.NamedQueries");
        digester.addObjectCreate("namedQueries/namedQuery", "com.dynamic.charm.query.NamedQuery");
        digester.addCallMethod("namedQueries/namedQuery/id", "setId", 0);
        digester.addCallMethod("namedQueries/namedQuery/query", "setQuery", 0);
        digester.addCallMethod("namedQueries/namedQuery/service", "setService", 0);
        digester.addCallMethod("namedQueries/namedQuery/entityType", "setEntityType", 0);
        digester.addObjectCreate("namedQueries/namedQuery/parameter",
            "com.dynamic.charm.query.QueryParameter");
        digester.addSetProperties("namedQueries/namedQuery/parameter", "name", "name");
        digester.addSetProperties("namedQueries/namedQuery/parameter", "type", "typeName");
        digester.addSetNext("namedQueries/namedQuery/parameter", "addQueryParameter",
            "com.dynamic.charm.query.QueryParameter");
        digester.addSetNext("namedQueries/namedQuery", "addNamedQuery",
            "com.dynamic.charm.query.NamedQuery");
        return digester;
    }
    
}
