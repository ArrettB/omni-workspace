/*
 *               Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.

 * Copyright 2005, Dynamic Information Systems, LLC
 * $Id: NamedParameter.java 206 2006-12-07 00:43:17Z gcase $

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

import java.util.Collections;
import java.util.LinkedList;
import java.util.List;

import org.springframework.jdbc.core.SqlTypeValue;


/**
 * @author gcase
 *
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class NamedParameter
{
    private String name;
    private int sqlType;
    private Object value;
    private List positions;

    public NamedParameter(String name)
    {
        this(name, SqlTypeValue.TYPE_UNKNOWN, null);
    }

    public NamedParameter(String name, int sqlType)
    {
        this(name, sqlType, null);
    }

    public NamedParameter(String name, Object value)
    {
        this(name, SqlTypeValue.TYPE_UNKNOWN, value);
    }

    public NamedParameter(String name, int sqlType, Object value)
    {
        this.name = name;
        this.sqlType = sqlType;
        this.value = value;
        positions = new LinkedList();
    }

    public Object getValue()
    {
        return value;
    }

    public void setValue(Object value)
    {
        this.value = value;
    }

    public void addPosition(int i)
    {
        positions.add(new Integer(i));
    }

    public List getParameterPositions()
    {
        return Collections.unmodifiableList(positions);
    }

    public String getName()
    {
        return name;
    }

    public int getSqlType()
    {
        return sqlType;
    }

    public String getTypeName()
    {
        return JDBCUtils.getJdbcTypeName(sqlType);
    }
    
    public String toString()
    {
    	return "NamedParameter [name=" + getName() + ", value=" + getValue() + ", type = " + getTypeName();
    }
}
