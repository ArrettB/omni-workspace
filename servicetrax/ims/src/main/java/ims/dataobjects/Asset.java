/*
 *               Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.
 *
 * Copyright 2001,2003,2006, Dynamic Information Systems, LLC
 * $Header: Asset.java, 4, 1/26/2006 5:44:43 PM, Blake Von Haden$
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO
 * EVENT SHALL DYNAMIC INFORMATIONS SYTEMS, LLC BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * ====================================================================
 */
package ims.dataobjects;

import java.io.Serializable;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;
import java.util.Hashtable;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;

/**
 * Asset: something (page, form, etc) the user might access
 * 
 * @version $Header: Asset.java, 4, 1/26/2006 5:44:43 PM, Blake Von Haden$
 */
public class Asset implements Serializable
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 8820347826686139575L;
	public String id = ""; // default to blank to make compare easier (no null test)
	public String code = null;
	public String name = null;
	public String description = null;
	public String created_by = null;
	public Date date_created = null;
	public String modified_by = null;
	public Date date_modified = null;
	public boolean view = false;
	public boolean insert = false;
	public boolean update = false;
	public boolean delete = false;

	public Asset()
	{
	}

	public Asset(ResultSet rs) throws SQLException
	{
		id = rs.getString("id");
		code = rs.getString("code");
		name = rs.getString("name");
		description = rs.getString("description");
		created_by = rs.getString("created_by");
		date_created = rs.getTimestamp("date_created");
		modified_by = rs.getString("modified_by");
		date_modified = rs.getTimestamp("date_modified");
	}

	public String toString()
	{
		StringBuffer sb = new StringBuffer();
		sb.append(super.toString() + ": ");
		if (view)
			sb.append(" view");
		if (insert)
			sb.append(" insert");
		if (update)
			sb.append(" update");
		if (delete)
			sb.append(" delete");
		return sb.toString();
	}

	// class is a factory
	public static Asset fetch(ConnectionWrapper conn, String asset_id) throws SQLException
	{
		return fetch(conn, asset_id, null);
	}

	public static Asset fetch(ConnectionWrapper conn, String asset_id, String role_id) throws SQLException
	{
		Asset result = null;

		String query;
		query = "select asset_id id, code, name, description, created_by, date_created, modified_by, date_modified"
				+ " from assets" + " where asset_id=" + conn.toSQLString(asset_id);
		QueryResults rs = conn.resultsQueryEx(query);
		if (rs.next())
		{
			result = new Asset(rs.getResultSet());
		}
		else
		{
			SQLException sex = new SQLException("Could not fetch asset with id=" + asset_id);
			sex.setNextException(new SQLException(query));
			throw sex;
		}
		rs.close();

		if (result != null && role_id != null)
		{
			query = "select rt.code from rights r, right_types rt" + " where r.right_type_id=rt.right_type_id"
					+ "   and r.asset_id=" + conn.toSQLString(asset_id) + "   and r.role_id=" + conn.toSQLString(role_id);
			QueryResults rs2 = conn.resultsQueryEx(query);
			while (rs2.next())
			{
				String code = rs2.getString("code");
				setCode(code, asset_id, result);
			}
			rs2.close();
		}

		return result;
	}

	private static void setCode(String code, String asset_id, Asset res) throws SQLException
	{
		if (code == null)
		{
			// throw new SQLException("Asset.fetch("+asset_id+") Null right type");
		}
		else if (code.equals("view"))
		{
			res.view = true;
		}
		else if (code.equals("insert"))
		{
			res.insert = true;
		}
		else if (code.equals("update"))
		{
			res.update = true;
		}
		else if (code.equals("delete"))
		{
			res.delete = true;
		}
		else
		{
			throw new SQLException("Asset.fetch(" + asset_id + ") Unknown right type " + code);
		}
	}

	public static Hashtable fetchAll(ConnectionWrapper conn) throws SQLException
	{
		return fetchAll(conn, null);
	}

	/**
	 * Get all the asset, even if they do not have rights.
	 */
	public static Hashtable fetchAll(ConnectionWrapper conn, String role_id) throws SQLException
	{
		Hashtable result = new Hashtable();

		String query = "SELECT a.asset_id id, a.code, a.name, a.description"
				+ ", a.created_by, a.date_created, a.modified_by, a.date_modified, rt.code right_code"
				+ "  FROM assets a, rights r, right_types rt" + " WHERE r.right_type_id=rt.right_type_id"
				+ "   AND a.asset_id=r.asset_id" + "   AND r.role_id=" + conn.toSQLString(role_id) + " UNION"
				+ " SELECT a.asset_id id, a.code, a.name, a.description"
				+ ", a.created_by, a.date_created, a.modified_by, a.date_modified, null right_code" + "  FROM assets a"
				+ " WHERE a.asset_id NOT IN (SELECT asset_id FROM rights where role_id = " + conn.toSQLString(role_id) + ")"
				+ " ORDER BY a.code";
		QueryResults rs = conn.resultsQueryEx(query);
		while (rs.next())
		{
			Asset res = new Asset(rs.getResultSet());

			Asset existingAsset = (Asset) result.get(res.code);
			if (existingAsset == null)
			{
				result.put(res.code, res);
			}
			else
			{
				res = existingAsset;
			}

			setCode(rs.getString("right_code"), res.code, res);

		}
		rs.close();

		return result;
	}
}
