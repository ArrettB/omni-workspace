/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: JDBCFormService.java 199 2006-11-14 23:38:41Z gcase $

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


package com.dynamic.charm.web.form;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import org.apache.log4j.Logger;

import com.dynamic.charm.common.ArrayUtils;
import com.dynamic.charm.common.LogUtil;
import com.dynamic.charm.query.jdbc.JDBCService;
import com.dynamic.charm.query.jdbc.JDBCUtils;


/**
 * TODO cache the results for each table, be sure it is thread-safe!
 * @author gcase
 *
 */
public class JDBCFormService implements FormService
{
    private final static Logger logger = Logger.getLogger(JDBCFormService.class);
    private JDBCService jdbcService;
    private String catalog;
    private String schema;

    public String[] getRequiredFields(String tableOrClass)
    {
        DataSource ds = jdbcService.getJDBCTemplate().getDataSource();
        List mandatoryColumns = new ArrayList();
        Connection conn = null;
        ResultSet rs = null;
        try
        {
            conn = ds.getConnection();

            DatabaseMetaData meta = conn.getMetaData();
            rs = meta.getColumns(catalog, schema, tableOrClass, null);

            int required = rs.getInt("IS_NULLABLE");
            if (required == DatabaseMetaData.columnNoNulls)
            {
                mandatoryColumns.add(rs.getString("COLUMN_NAME"));
            }
        }
        catch (SQLException e)
        {
        }
        finally
        {
            JDBCUtils.closeQuietly(conn, rs);
        }

        String[] result = (String[]) ArrayUtils.toArray(mandatoryColumns, String.class);
        logger.debug("Mandatory columns for " + tableOrClass + ":");
        LogUtil.debugArray(logger, result, "mandatory");
        return result;
    }

    public String getCatalog()
    {
        return catalog;
    }

    public void setCatalog(String catalog)
    {
        this.catalog = catalog;
    }

    public JDBCService getJdbcService()
    {
        return jdbcService;
    }

    public void setJdbcService(JDBCService jdbcService)
    {
        this.jdbcService = jdbcService;
    }

    public String getSchema()
    {
        return schema;
    }

    public void setSchema(String schema)
    {
        this.schema = schema;
    }
}
