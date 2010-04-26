/*
 *               Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.

 * Copyright 2005, Dynamic Information Systems, LLC
 * $Id: QueryParser.java 199 2006-11-14 23:38:41Z gcase $

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


package com.dynamic.charm.query.jdbc;

import java.util.List;

import org.springframework.jdbc.core.SqlProvider;

import com.dynamic.charm.exception.CharmException;
import com.dynamic.charm.query.core.ParameterBundle;


/**
 * @author gcase
 *
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class QueryParser implements SqlProvider
{
    private final static String DELIMS = "\"'";
    private final static char PARAM_START = ':';
    private final static char PLACEHOLDER = '?';

    protected String originalSQL;
    protected String parsedSQL;
    protected ParameterBundle parameterBundle;

    public QueryParser(String sql) throws CharmException
    {
        this(sql, new ParameterBundle());
    }

    public QueryParser(String sql, ParameterBundle parameterBundle)
    {
        this.originalSQL = sql;
        this.parameterBundle = parameterBundle;
        parse();
    }

    protected void addNamedParameter(String parameterName)
    {
        NamedParameter np = parameterBundle.getNamedParameter(parameterName);
        if (np == null)
        {
            np = parameterBundle.addParameter(parameterName);
        }
        parameterBundle.addPosition(parameterName);
    }

    public int getDistinctParameterCount()
    {
        return parameterBundle.getDistinctParameterCount();
    }

    public int getParameterCount()
    {
        return parameterBundle.getParameterCount();
    }

    public List getParameterPositions(String parameterName)
    {
        NamedParameter np = parameterBundle.getNamedParameter(parameterName);
        return (np != null) ? np.getParameterPositions() : null;
    }

    protected void parse() throws CharmException
    {
        StringBuffer parsed = new StringBuffer();
        boolean insideLiteral = false;
        boolean insideParameter = false;
        StringBuffer paramName = null;
        int activeLiteral = -1;

        for (int i = 0; (originalSQL != null) && (i < originalSQL.length()); i++)
        {
            char c = originalSQL.charAt(i);

            if (insideParameter)
            {
                if (Character.isLetterOrDigit(c) || (c == '_'))
                {
                    paramName.append(c);
                }
                else
                {
                    insideParameter = false;
                    addNamedParameter(paramName.toString());
                    parsed.append(c);
                }
            }
            else if (c == PARAM_START)
            {
                if (!insideLiteral)
                {
                    parsed.append(PLACEHOLDER);
                    insideParameter = true;
                    paramName = new StringBuffer();
                }
                else
                {
                    parsed.append(c);
                }
            }
            else if (DELIMS.indexOf(c) > -1)
            {
                if (!insideLiteral)
                {
                    insideLiteral = true;
                    activeLiteral = DELIMS.indexOf(c);
                }
                else
                {
                    if (activeLiteral == DELIMS.indexOf(c))
                    {
                        insideLiteral = false;
                        activeLiteral = -1;
                    }
                }

                parsed.append(c);
            }
            else
            {
                parsed.append(c);
            }
        }

        if (insideParameter)
        {
            addNamedParameter(paramName.toString());
        }

        parsedSQL = parsed.toString();
    }

    public String getSql()
    {
        return parsedSQL;
    }

    public ParameterBundle getParameterBundle()
    {
        return parameterBundle;
    }
}
